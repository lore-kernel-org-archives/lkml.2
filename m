Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966Ab1CBEgF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 23:36:05 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:34065 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757565Ab1CBEgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 23:36:03 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Russ Meyerriecks <rmeyerriecks@digium.com>, sruffell@digium.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>
References: <20110228224124.GA31769@blackmagic.digium.internal>
	<20110301170117.258e06e2.akpm@linux-foundation.org>
Date: Tue, 01 Mar 2011 20:35:53 -0800
In-Reply-To: <20110301170117.258e06e2.akpm@linux-foundation.org> (Andrew
	Morton's message of "Tue, 1 Mar 2011 17:01:17 -0800")
Message-ID: <m1wrki3zrq.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1++ZhWi0cyaK5iQ5WIx1BLsIsCsVW+xUgA=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: linux-foundation.org]
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] mm/dmapool.c: Do not create/destroy sysfs file while holding pools_lock
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Mon, 28 Feb 2011 16:41:24 -0600
> Russ Meyerriecks <rmeyerriecks@digium.com> wrote:
>
>> From: Shaun Ruffell <sruffell@digium.com>
>> 
>> Eliminates a circular lock dependency reported by lockdep. When reading the
>> "pools" file from a PCI device via sysfs, the s_active lock is acquired before
>> the pools_lock. When unloading the driver and destroying the pool, pools_lock
>> is acquired before the s_active lock.
>> 
>>  cat/12016 is trying to acquire lock:
>>   (pools_lock){+.+.+.}, at: [<c04ef113>] show_pools+0x43/0x140
>> 
>>  but task is already holding lock:
>>   (s_active#82){++++.+}, at: [<c0554e1b>] sysfs_read_file+0xab/0x160
>> 
>>  which lock already depends on the new lock.
>
> sysfs_dirent_init_lockdep() and the 6992f53349 ("sysfs: Use one lockdep
> class per sysfs attribute") which added it are rather scary.
>
> The alleged bug appears to be due to taking pools_lock outside
> device_create_file() (which takes magical sysfs PseudoVirtualLocks)
> versus show_pools(), which takes pools_lock but is called from inside
> magical sysfs PseudoVirtualLocks.
>
> I don't know if this is actually a real bug or not.  Probably not, as
> this device_create_file() does not match the reasons for 6992f53349:
> "There is a sysfs idiom where writing to one sysfs file causes the
> addition or removal of other sysfs files".  But that's a guess.

device_create_file is arguable But this also happens with
device_remove_file, and that is exactly the deadlock scenario I added
the lockdep annotation to catch.  So the patch clearly does not fix the
issue.

Eric


>> --- a/mm/dmapool.c
>> +++ b/mm/dmapool.c
>> @@ -174,21 +174,28 @@ struct dma_pool *dma_pool_create(const char *name, struct device *dev,
>>  	init_waitqueue_head(&retval->waitq);
>>  
>>  	if (dev) {
>> -		int ret;
>> +		int first_pool;
>>  
>>  		mutex_lock(&pools_lock);
>>  		if (list_empty(&dev->dma_pools))
>> -			ret = device_create_file(dev, &dev_attr_pools);
>> +			first_pool = 1;
>>  		else
>> -			ret = 0;
>> +			first_pool = 0;
>>  		/* note:  not currently insisting "name" be unique */
>> -		if (!ret)
>> -			list_add(&retval->pools, &dev->dma_pools);
>> -		else {
>> -			kfree(retval);
>> -			retval = NULL;
>> -		}
>> +		list_add(&retval->pools, &dev->dma_pools);
>>  		mutex_unlock(&pools_lock);
>> +
>> +		if (first_pool) {
>> +			int ret;
>> +			ret = device_create_file(dev, &dev_attr_pools);
>> +			if (ret) {
>> +				mutex_lock(&pools_lock);
>> +				list_del(&retval->pools);
>> +				mutex_unlock(&pools_lock);
>> +				kfree(retval);
>> +				retval = NULL;
>> +			}
>> +		}
>
> Not a good fix, IMO.  The problem is that if two CPUs concurrently call
> dma_pool_create(), the first CPU will spend time creating the sysfs
> file.  Meanwhile, the second CPU will whizz straight back to its
> caller.  The caller now thinks that the sysfs file has been created and
> returns to userspace, which immediately tries to read the sysfs file. 
> But the first CPU hasn't finished creating it yet.  Userspace fails.
>
> One way of fixing this would be to create another singleton lock:
>
>
> 	{
> 		static DEFINE_MUTEX(pools_sysfs_lock);
> 		static bool pools_sysfs_done;
>
> 		mutex_lock(&pools_sysfs_lock);
> 		if (pools_sysfs_done == false) {
> 			create_sysfs_stuff();
> 			pools_sysfs_done = true;
> 		}
> 		mutex_unlock(&pools_sysfs_lock);
> 	}
>
> That's not terribly pretty.

Or possibly use module_init style magic.  Where use module
initialization and remove to trigger creation and deletion of the sysfs.

Eric
