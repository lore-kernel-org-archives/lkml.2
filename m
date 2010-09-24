Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143Ab0IXRLR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 13:11:17 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:41695 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151Ab0IXRLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 13:11:15 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
References: <m1y6b48973.fsf@fess.ebiederm.org> <20100917205946.GF2522@local>
	<m139t451b4.fsf_-_@fess.ebiederm.org>
	<m1eico3mjg.fsf_-_@fess.ebiederm.org>
	<20100924105555.GD1819@silverbox.local>
Date: Fri, 24 Sep 2010 10:11:09 -0700
In-Reply-To: <20100924105555.GD1819@silverbox.local> (Hans J. Koch's message
	of "Fri, 24 Sep 2010 12:55:56 +0200")
Message-ID: <m1wrqbcbiq.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Hans J. Koch" <hjk@linutronix.de>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 5/5] uio: Implement hotunplug support, using libunload
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Hans J. Koch" <hjk@linutronix.de> writes:

> On Mon, Sep 20, 2010 at 12:24:19AM -0700, Eric W. Biederman wrote:
>> 
>>  }
>>  
>>  static ssize_t uio_read(struct file *filep, char __user *buf,
>>  			size_t count, loff_t *ppos)
>>  {
>>  	struct uio_listener *listener = filep->private_data;
>> -	struct uio_device *idev = listener->dev;
>> +	struct uio_device *idev = listener_idev(listener);
>>  	DECLARE_WAITQUEUE(wait, current);
>>  	ssize_t retval;
>>  	s32 event_count;
>>  
>> -	if (!idev->info->irq)
>> +	if (!unload_trylock(&idev->unload))
>>  		return -EIO;
>>  
>> +	retval = -EIO;
>> +	if (!idev->info->irq)
>> +		goto out;
>> +
>> +	retval = -EIO;
>>  	if (count != sizeof(s32))
>> -		return -EINVAL;
>> +		goto out;
>
> No. uio_read() should return -EINVAL if count != sizeof(s32). This is
> simply wrong userspace code that passes in an illegal value, so it's
> not an IO error but an invalid parameter.
> BTW, you use -EINVAL in the same situation in uio_write()...

Apologies.  That was a typo.  It was my intention to preserve the
existing return codes.

Eric
