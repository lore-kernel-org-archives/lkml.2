Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801Ab1CBFRm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 00:17:42 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33914 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab1CBFRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 00:17:41 -0500
Date: Tue, 1 Mar 2011 23:17:34 -0600
From: Shaun Ruffell <sruffell@sruffell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Russ Meyerriecks <rmeyerriecks@digium.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] mm/dmapool.c: Do not create/destroy sysfs file while
	holding pools_lock
Message-ID: <20110302051734.GA7463@kilby.digium.internal>
References: <20110228224124.GA31769@blackmagic.digium.internal> <20110301170117.258e06e2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110301170117.258e06e2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01, 2011 at 05:01:17PM -0800, Andrew Morton wrote:
> On Mon, 28 Feb 2011 16:41:24 -0600
> Russ Meyerriecks <rmeyerriecks@digium.com> wrote:
> 
> > From: Shaun Ruffell <sruffell@digium.com>
> > 
> > Eliminates a circular lock dependency reported by lockdep. When reading the
> > "pools" file from a PCI device via sysfs, the s_active lock is acquired before
> > the pools_lock. When unloading the driver and destroying the pool, pools_lock
> > is acquired before the s_active lock.
> > 
> >  cat/12016 is trying to acquire lock:
> >   (pools_lock){+.+.+.}, at: [<c04ef113>] show_pools+0x43/0x140
> > 
> >  but task is already holding lock:
> >   (s_active#82){++++.+}, at: [<c0554e1b>] sysfs_read_file+0xab/0x160
> > 
> >  which lock already depends on the new lock.
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
> 
> > --- a/mm/dmapool.c
> > +++ b/mm/dmapool.c
> > @@ -174,21 +174,28 @@ struct dma_pool *dma_pool_create(const char *name, struct device *dev,
> >  	init_waitqueue_head(&retval->waitq);
> >  
> >  	if (dev) {
> > -		int ret;
> > +		int first_pool;
> >  
> >  		mutex_lock(&pools_lock);
> >  		if (list_empty(&dev->dma_pools))
> > -			ret = device_create_file(dev, &dev_attr_pools);
> > +			first_pool = 1;
> >  		else
> > -			ret = 0;
> > +			first_pool = 0;
> >  		/* note:  not currently insisting "name" be unique */
> > -		if (!ret)
> > -			list_add(&retval->pools, &dev->dma_pools);
> > -		else {
> > -			kfree(retval);
> > -			retval = NULL;
> > -		}
> > +		list_add(&retval->pools, &dev->dma_pools);
> >  		mutex_unlock(&pools_lock);
> > +
> > +		if (first_pool) {
> > +			int ret;
> > +			ret = device_create_file(dev, &dev_attr_pools);
> > +			if (ret) {
> > +				mutex_lock(&pools_lock);
> > +				list_del(&retval->pools);
> > +				mutex_unlock(&pools_lock);
> > +				kfree(retval);
> > +				retval = NULL;
> > +			}
> > +		}
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

If I am following, I do not believe using a static pools_sysfs_done flag
will not work since there is one pools file created in sysfs for each
device that creates one or more dma pools. A static flag like that will
fail for any aditional devices.

Assuming that lockdep has uncovered a real bug (I'm not 100% clear on
all the reasons that sysfs PseudoVirtualLocks are needed as opposed
to regular locks) what do you think about something like:

mm/dmapool.c: Do not create/destroy sysfs file while holding pools_lock

Eliminates a circular lock dependency reported by lockdep. When reading the
"pools" file from a PCI device via sysfs, the s_active lock is acquired before
the pools_lock. When unloading the driver and destroying the pool, pools_lock
is acquired before the s_active lock.

 cat/12016 is trying to acquire lock:
  (pools_lock){+.+.+.}, at: [<c04ef113>] show_pools+0x43/0x140

 but task is already holding lock:
  (s_active#82){++++.+}, at: [<c0554e1b>] sysfs_read_file+0xab/0x160

 which lock already depends on the new lock.

This introduces a new pools_sysfs_lock that is used to synchronize
'pools' attribute creation / destruction without requiring 'pools_lock'
to be held.

Signed-off-by: Shaun Ruffell <sruffell@digium.com>
Signed-off-by: Russ Meyerriecks <rmeyerriecks@digium.com>
---
 mm/dmapool.c |   37 +++++++++++++++++++++++++++----------
 1 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/mm/dmapool.c b/mm/dmapool.c
index 03bf3bb..b0dd40c 100644
--- a/mm/dmapool.c
+++ b/mm/dmapool.c
@@ -64,6 +64,7 @@ struct dma_page {		/* cacheable header for 'allocation' bytes */
 #define	POOL_TIMEOUT_JIFFIES	((100 /* msec */ * HZ) / 1000)
 
 static DEFINE_MUTEX(pools_lock);
+static DEFINE_MUTEX(pools_sysfs_lock);
 
 static ssize_t
 show_pools(struct device *dev, struct device_attribute *attr, char *buf)
@@ -174,21 +175,28 @@ struct dma_pool *dma_pool_create(const char *name, struct device *dev,
 	init_waitqueue_head(&retval->waitq);
 
 	if (dev) {
-		int ret;
+		int first_pool;
 
+		mutex_lock(&pools_sysfs_lock);
 		mutex_lock(&pools_lock);
 		if (list_empty(&dev->dma_pools))
-			ret = device_create_file(dev, &dev_attr_pools);
+			first_pool = 1;
 		else
-			ret = 0;
+			first_pool = 0;
 		/* note:  not currently insisting "name" be unique */
-		if (!ret)
-			list_add(&retval->pools, &dev->dma_pools);
-		else {
-			kfree(retval);
-			retval = NULL;
-		}
+		list_add(&retval->pools, &dev->dma_pools);
 		mutex_unlock(&pools_lock);
+
+		if (first_pool) {
+			if (device_create_file(dev, &dev_attr_pools)) {
+				mutex_lock(&pools_lock);
+				list_del(&retval->pools);
+				mutex_unlock(&pools_lock);
+				kfree(retval);
+				retval = NULL;
+			}
+		}
+		mutex_unlock(&pools_sysfs_lock);
 	} else
 		INIT_LIST_HEAD(&retval->pools);
 
@@ -263,12 +271,21 @@ static void pool_free_page(struct dma_pool *pool, struct dma_page *page)
  */
 void dma_pool_destroy(struct dma_pool *pool)
 {
+	int last_pool;
+
+	mutex_lock(&pools_sysfs_lock);
 	mutex_lock(&pools_lock);
 	list_del(&pool->pools);
 	if (pool->dev && list_empty(&pool->dev->dma_pools))
-		device_remove_file(pool->dev, &dev_attr_pools);
+		last_pool = 1;
+	else
+		last_pool = 0;
 	mutex_unlock(&pools_lock);
 
+	if (last_pool)
+		device_remove_file(pool->dev, &dev_attr_pools);
+	mutex_unlock(&pools_sysfs_lock);
+
 	while (!list_empty(&pool->page_list)) {
 		struct dma_page *page;
 		page = list_entry(pool->page_list.next,
-- 
1.7.4

