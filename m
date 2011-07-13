Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab1GMNRL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 09:17:11 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:34572 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989Ab1GMNRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 09:17:09 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E1D9AD4.5000002@cam.ac.uk>
Date: Wed, 13 Jul 2011 14:17:08 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110509 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: RFC: Boiler plate functions for ida / idr allocation?
References: <4E1D6900.6040500@cam.ac.uk> <20110713151410.59a3a193@stein>
In-Reply-To: <20110713151410.59a3a193@stein>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/11 14:14, Stefan Richter wrote:
> On Jul 13 Jonathan Cameron wrote:
>> Taking ida's first, how about the following patch?  I'm not at
>> all attached to the form it takes, merely to cutting out on the
>> cut and paste.
> 
> Not a big-picture opinion here whether this is a good thing; only some
> small comments on side issues:
> 
> [...]
>> The other thing this highlights is that I suspect quite a few are protected by
>> spin locks when a mutex would be fine. Hence that might be worth tidying up first.
> 
> It seems to be the other way around in this case:  Why use a mutex if a
> spinlock is fine?
> 
> [...]
>> --- a/drivers/misc/cb710/core.c
>> +++ b/drivers/misc/cb710/core.c
>> @@ -254,18 +254,9 @@ static int __devinit cb710_probe(struct pci_dev *pdev,
>>  	if (err)
>>  		return err;
>>  
>> -	do {
>> -		if (!ida_pre_get(&cb710_ida, GFP_KERNEL))
>> -			return -ENOMEM;
>> -
>> -		spin_lock_irqsave(&cb710_ida_lock, flags);
>> -		err = ida_get_new(&cb710_ida, &chip->platform_id);
>> -		spin_unlock_irqrestore(&cb710_ida_lock, flags);
>> -
>> -		if (err && err != -EAGAIN)
>> -			return err;
>> -	} while (err);
>> -
>> +	err = ida_get_id(&cb710_ida_lock, &cb710_ida, &chip->platform_id);
>> +	if (err)
>> +		return err;
>>  
>>  	dev_info(&pdev->dev, "id %d, IO 0x%p, IRQ %d\n",
>>  		chip->platform_id, chip->iobase, pdev->irq);
> 
> To balance this change to cb710_probe, also switch from spin_lock_irqsave/
> spin_unlock_irqrestore to spin_lock/spin_unlock in cb710_remove_one for
> clarity.
Good point. I'd actually suggest adding a paired release_id function with similar
semantics to the get function just to keep things consistent.
> 
> [...]
>> --- a/lib/idr.c
>> +++ b/lib/idr.c
>> @@ -939,3 +939,23 @@ void ida_init(struct ida *ida)
>>  
>>  }
>>  EXPORT_SYMBOL(ida_init);
>> +
>> +int ida_get_id(spinlock_t *lock, struct ida *ida, int *val)
>> +{
>> +	int ret = 0;
>> +ida_again:
>> +	if (unlikely(ida_pre_get(ida, GFP_KERNEL) == 0))
>> +		return -ENOMEM;
>> +
>> +	spin_lock(lock);
>> +	ret = ida_get_new(ida, val);
>> +	spin_unlock(lock);
>> +
>> +	if (unlikely (ret == -EAGAIN))
>> +		goto ida_again;
>> +	else if (likely(!ret))
>> +		*val = *val & MAX_ID_MASK;
>> +
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL(ida_get_id);
> 
> A new exported function (in lib/ even) should come with a kerneldoc comment
> of course.  Here it is among else noteworthy that the caller must provide
> GFP_KERNEL allocations capable context and that @lock cannot be shared
> with users in IRQ or softIRQ contexts.
Of course, I was just being lazy for an RFC ;)  Is suspect any formal submission
will need a few iterations before everyone is happy.
