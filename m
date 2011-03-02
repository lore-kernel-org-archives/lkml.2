Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab1CBHYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 02:24:40 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:56809 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab1CBHYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 02:24:39 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Shaun Ruffell <sruffell@sruffell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Russ Meyerriecks <rmeyerriecks@digium.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
References: <20110228224124.GA31769@blackmagic.digium.internal>
	<20110301170117.258e06e2.akpm@linux-foundation.org>
	<20110302051734.GA7463@kilby.digium.internal>
Date: Tue, 01 Mar 2011 23:24:27 -0800
In-Reply-To: <20110302051734.GA7463@kilby.digium.internal> (Shaun Ruffell's
	message of "Tue, 1 Mar 2011 23:17:34 -0600")
Message-ID: <m1lj0y3rys.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/EDnpgZNyUfkvy8sPgShgXSuDZzvWdZDI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Shaun Ruffell <sruffell@sruffell.net>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] mm/dmapool.c: Do not create/destroy sysfs file while holding pools_lock
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shaun Ruffell <sruffell@sruffell.net> writes:

> On Tue, Mar 01, 2011 at 05:01:17PM -0800, Andrew Morton wrote:
>> On Mon, 28 Feb 2011 16:41:24 -0600
>> Russ Meyerriecks <rmeyerriecks@digium.com> wrote:
>> 
>> > From: Shaun Ruffell <sruffell@digium.com>
>> > 
>> > Eliminates a circular lock dependency reported by lockdep. When reading the
>> > "pools" file from a PCI device via sysfs, the s_active lock is acquired before
>> > the pools_lock. When unloading the driver and destroying the pool, pools_lock
>> > is acquired before the s_active lock.
>> > 
>> >  cat/12016 is trying to acquire lock:
>> >   (pools_lock){+.+.+.}, at: [<c04ef113>] show_pools+0x43/0x140
>> > 
>> >  but task is already holding lock:
>> >   (s_active#82){++++.+}, at: [<c0554e1b>] sysfs_read_file+0xab/0x160
>> > 
>> >  which lock already depends on the new lock.
>> 
>> sysfs_dirent_init_lockdep() and the 6992f53349 ("sysfs: Use one lockdep
>> class per sysfs attribute") which added it are rather scary.
>> 
>> The alleged bug appears to be due to taking pools_lock outside
>> device_create_file() (which takes magical sysfs PseudoVirtualLocks)
>> versus show_pools(), which takes pools_lock but is called from inside
>> magical sysfs PseudoVirtualLocks.
>> 
>> I don't know if this is actually a real bug or not.  Probably not, as
>> this device_create_file() does not match the reasons for 6992f53349:
>> "There is a sysfs idiom where writing to one sysfs file causes the
>> addition or removal of other sysfs files".  But that's a guess.
>> 
>> > --- a/mm/dmapool.c
>> > +++ b/mm/dmapool.c
>> > @@ -174,21 +174,28 @@ struct dma_pool *dma_pool_create(const char *name, struct device *dev,
>> >  	init_waitqueue_head(&retval->waitq);
>> >  
>> >  	if (dev) {
>> > -		int ret;
>> > +		int first_pool;
>> >  
>> >  		mutex_lock(&pools_lock);
>> >  		if (list_empty(&dev->dma_pools))
>> > -			ret = device_create_file(dev, &dev_attr_pools);
>> > +			first_pool = 1;
>> >  		else
>> > -			ret = 0;
>> > +			first_pool = 0;
>> >  		/* note:  not currently insisting "name" be unique */
>> > -		if (!ret)
>> > -			list_add(&retval->pools, &dev->dma_pools);
>> > -		else {
>> > -			kfree(retval);
>> > -			retval = NULL;
>> > -		}
>> > +		list_add(&retval->pools, &dev->dma_pools);
>> >  		mutex_unlock(&pools_lock);
>> > +
>> > +		if (first_pool) {
>> > +			int ret;
>> > +			ret = device_create_file(dev, &dev_attr_pools);
>> > +			if (ret) {
>> > +				mutex_lock(&pools_lock);
>> > +				list_del(&retval->pools);
>> > +				mutex_unlock(&pools_lock);
>> > +				kfree(retval);
>> > +				retval = NULL;
>> > +			}
>> > +		}
>> 
>> Not a good fix, IMO.  The problem is that if two CPUs concurrently call
>> dma_pool_create(), the first CPU will spend time creating the sysfs
>> file.  Meanwhile, the second CPU will whizz straight back to its
>> caller.  The caller now thinks that the sysfs file has been created and
>> returns to userspace, which immediately tries to read the sysfs file. 
>> But the first CPU hasn't finished creating it yet.  Userspace fails.
>> 
>> One way of fixing this would be to create another singleton lock:
>> 
>> 
>> 	{
>> 		static DEFINE_MUTEX(pools_sysfs_lock);
>> 		static bool pools_sysfs_done;
>> 
>> 		mutex_lock(&pools_sysfs_lock);
>> 		if (pools_sysfs_done == false) {
>> 			create_sysfs_stuff();
>> 			pools_sysfs_done = true;
>> 		}
>> 		mutex_unlock(&pools_sysfs_lock);
>> 	}
>> 
>
> If I am following, I do not believe using a static pools_sysfs_done flag
> will not work since there is one pools file created in sysfs for each
> device that creates one or more dma pools. A static flag like that will
> fail for any aditional devices.
>
> Assuming that lockdep has uncovered a real bug (I'm not 100% clear on
> all the reasons that sysfs PseudoVirtualLocks are needed as opposed
> to regular locks) what do you think about something like:
>
> mm/dmapool.c: Do not create/destroy sysfs file while holding pools_lock
>
> Eliminates a circular lock dependency reported by lockdep. When reading the
> "pools" file from a PCI device via sysfs, the s_active lock is acquired before
> the pools_lock. When unloading the driver and destroying the pool, pools_lock
> is acquired before the s_active lock.
>
>  cat/12016 is trying to acquire lock:
>   (pools_lock){+.+.+.}, at: [<c04ef113>] show_pools+0x43/0x140
>
>  but task is already holding lock:
>   (s_active#82){++++.+}, at: [<c0554e1b>] sysfs_read_file+0xab/0x160
>
>  which lock already depends on the new lock.
>
> This introduces a new pools_sysfs_lock that is used to synchronize
> 'pools' attribute creation / destruction without requiring 'pools_lock'
> to be held.


The deadlock scenario looks like this.
Process A:					Process B:
mutex_lock(&pools_lock)				s_active_down();
	device_remove_pool_file();		show_pools();	
		s_active_down();
							mutex_lock(&pools_lock);

What sysfs uses isn't strictly a lock implementation wise, but from a
deadlock perspective it is.   And you very much have an AB BA deadlock
here.

If you read the sysfs file while trying to remove dma pool you will deadlock.

The patch below looks like it might work.  The immediate symptom is
fixed.  But it is doing strange locking things and I am too tired to
read through the rest of the code.

>  mm/dmapool.c |   37 +++++++++++++++++++++++++++----------
>  1 files changed, 27 insertions(+), 10 deletions(-)
>
> diff --git a/mm/dmapool.c b/mm/dmapool.c
> index 03bf3bb..b0dd40c 100644
> --- a/mm/dmapool.c
> +++ b/mm/dmapool.c
> @@ -64,6 +64,7 @@ struct dma_page {		/* cacheable header for 'allocation' bytes */
>  #define	POOL_TIMEOUT_JIFFIES	((100 /* msec */ * HZ) / 1000)
>  
>  static DEFINE_MUTEX(pools_lock);
> +static DEFINE_MUTEX(pools_sysfs_lock);
>  
>  static ssize_t
>  show_pools(struct device *dev, struct device_attribute *attr, char *buf)
> @@ -174,21 +175,28 @@ struct dma_pool *dma_pool_create(const char *name, struct device *dev,
>  	init_waitqueue_head(&retval->waitq);
>  
>  	if (dev) {
> -		int ret;
> +		int first_pool;
>  
> +		mutex_lock(&pools_sysfs_lock);
>  		mutex_lock(&pools_lock);
>  		if (list_empty(&dev->dma_pools))
> -			ret = device_create_file(dev, &dev_attr_pools);
> +			first_pool = 1;
>  		else
> -			ret = 0;
> +			first_pool = 0;
>  		/* note:  not currently insisting "name" be unique */
> -		if (!ret)
> -			list_add(&retval->pools, &dev->dma_pools);
> -		else {
> -			kfree(retval);
> -			retval = NULL;
> -		}
> +		list_add(&retval->pools, &dev->dma_pools);
>  		mutex_unlock(&pools_lock);
> +
> +		if (first_pool) {
> +			if (device_create_file(dev, &dev_attr_pools)) {
> +				mutex_lock(&pools_lock);
> +				list_del(&retval->pools);
> +				mutex_unlock(&pools_lock);
> +				kfree(retval);
> +				retval = NULL;
> +			}
> +		}
> +		mutex_unlock(&pools_sysfs_lock);
>  	} else
>  		INIT_LIST_HEAD(&retval->pools);
>  
> @@ -263,12 +271,21 @@ static void pool_free_page(struct dma_pool *pool, struct dma_page *page)
>   */
>  void dma_pool_destroy(struct dma_pool *pool)
>  {
> +	int last_pool;
> +
> +	mutex_lock(&pools_sysfs_lock);
>  	mutex_lock(&pools_lock);
>  	list_del(&pool->pools);
>  	if (pool->dev && list_empty(&pool->dev->dma_pools))
> -		device_remove_file(pool->dev, &dev_attr_pools);
> +		last_pool = 1;
> +	else
> +		last_pool = 0;
>  	mutex_unlock(&pools_lock);
>  
> +	if (last_pool)
> +		device_remove_file(pool->dev, &dev_attr_pools);
> +	mutex_unlock(&pools_sysfs_lock);
> +
>  	while (!list_empty(&pool->page_list)) {
>  		struct dma_page *page;
>  		page = list_entry(pool->page_list.next,
