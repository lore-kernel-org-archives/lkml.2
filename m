Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873Ab0JRXMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 19:12:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40725 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755983Ab0JRXMD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 19:12:03 -0400
Date: Tue, 19 Oct 2010 10:11:51 +1100
From: Neil Brown <neilb@suse.de>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Li Shaohua <shaohua.li@intel.com>
Subject: Re: Deadlock possibly caused by too_many_isolated.
Message-ID: <20101019101151.57c6dd56@notabene>
In-Reply-To: <AANLkTimv_zXHdFDGa9ecgXyWmQynOKTDRPC59PZA9mvL@mail.gmail.com>
References: <20100915091118.3dbdc961@notabene>
	<4C90139A.1080809@redhat.com>
	<20100915122334.3fa7b35f@notabene>
	<20100915082843.GA17252@localhost>
	<20100915184434.18e2d933@notabene>
	<20101018151459.2b443221@notabene>
	<AANLkTimv_zXHdFDGa9ecgXyWmQynOKTDRPC59PZA9mvL@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010 12:58:17 +0200
Torsten Kaiser <just.for.lkml@googlemail.com> wrote:

> On Mon, Oct 18, 2010 at 6:14 AM, Neil Brown <neilb@suse.de> wrote:
> > Testing shows that this patch seems to work.
> > The test load (essentially kernbench) doesn't deadlock any more, though it
> > does get bogged down thrashing in swap so it doesn't make a lot more
> > progress :-)  I guess that is to be expected.
> 
> I just noticed this thread, as your mail from today pushed it up.
> 
> In your original mail you wrote: " I recently had a customer (running
> 2.6.32) report a deadlock during very intensive IO with lots of
> processes. " and " Some threads that are blocked there, hold some IO
> lock (probably in the filesystem) and are trying to allocate memory
> inside the block device (md/raid1 to be precise) which is allocating
> with GFP_NOIO and has a mempool to fall back on."
> 
> I recently had the same problem (intense IO due to swapstorm created
> by 20 gcc processes hung my system) and after initially blaming the
> workqueue changes in 2.6.36 Tejun Heo determined that my problem was
> not the workqueues getting locked up, but that it was cause by an
> exhausted mempool:
> http://marc.info/?l=linux-kernel&m=128655737012549&w=2
> 
> Instrumenting mm/mempool.c and retrying my workload showed that
> fs_bio_set from fs/bio.c looked like the mempool to blame and the code
> in drivers/md/raid1.c to be the misuser:
> http://marc.info/?l=linux-kernel&m=128671179817823&w=2
> 
> I was even able to reproduce this hang with only using a normal RAID1
> md device as swapspace and then using dd to fill a tmpfs until
> swapping was needed:
> http://marc.info/?l=linux-raid&m=128699402805191&w=2
> 
> Looking back in the history of raid1.c and bio.c I found the following
> interesting parts:
> 
>  * the change to allocate more then one bio via bio_clone() is from
> 2005, but it looks like it was OK back then, because at that point the
> fs_bio_set was allocation 256 entries
>  * in 2007 the size of the mempool was changed from 256 to only 2
> entries (5972511b77809cb7c9ccdb79b825c54921c5c546 "A single unit is
> enough, lets scale it down to 2 just to be on the safe side.")
>  * only in 2009 the comment "To make this work, callers must never
> allocate more than 1 bio at the time from this pool. Callers that need
> to allocate more than 1 bio must always submit the previously allocate
> bio for IO before attempting to allocate a new one. Failure to do so
> can cause livelocks under memory pressure." was added to bio_alloc()
> that is the base from my reasoning that raid1.c is broken. (And such a
> comment was not added to bio_clone() although both calls use the same
> mempool)
> 
> So could please look someone into raid1.c to confirm or deny that
> using multiple bio_clone() (one per drive) before submitting them
> together could also cause such deadlocks?
> 
> Thank for looking
> 
> Torsten

Yes, thanks for the report.
This is a real bug exactly as you describe.

This is how I think I will fix it, though it needs a bit of review and
testing before I can be certain.
Also I need to check raid10 etc to see if they can suffer too.

If you can test it I would really appreciate it.

Thanks,
NeilBrown



diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index d44a50f..8122dde 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -784,7 +784,6 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 	int i, targets = 0, disks;
 	struct bitmap *bitmap;
 	unsigned long flags;
-	struct bio_list bl;
 	struct page **behind_pages = NULL;
 	const int rw = bio_data_dir(bio);
 	const unsigned long do_sync = (bio->bi_rw & REQ_SYNC);
@@ -892,13 +891,6 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 	 * bios[x] to bio
 	 */
 	disks = conf->raid_disks;
-#if 0
-	{ static int first=1;
-	if (first) printk("First Write sector %llu disks %d\n",
-			  (unsigned long long)r1_bio->sector, disks);
-	first = 0;
-	}
-#endif
  retry_write:
 	blocked_rdev = NULL;
 	rcu_read_lock();
@@ -956,14 +948,15 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 	    (behind_pages = alloc_behind_pages(bio)) != NULL)
 		set_bit(R1BIO_BehindIO, &r1_bio->state);
 
-	atomic_set(&r1_bio->remaining, 0);
+	atomic_set(&r1_bio->remaining, targets);
 	atomic_set(&r1_bio->behind_remaining, 0);
 
 	do_barriers = bio->bi_rw & REQ_HARDBARRIER;
 	if (do_barriers)
 		set_bit(R1BIO_Barrier, &r1_bio->state);
 
-	bio_list_init(&bl);
+	bitmap_startwrite(bitmap, bio->bi_sector, r1_bio->sectors,
+				test_bit(R1BIO_BehindIO, &r1_bio->state));
 	for (i = 0; i < disks; i++) {
 		struct bio *mbio;
 		if (!r1_bio->bios[i])
@@ -995,30 +988,18 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 				atomic_inc(&r1_bio->behind_remaining);
 		}
 
-		atomic_inc(&r1_bio->remaining);
-
-		bio_list_add(&bl, mbio);
+		spin_lock_irqsave(&conf->device_lock, flags);
+		bio_list_add(&conf->pending_bio_list, mbio);
+		blk_plug_device(mddev->queue);
+		spin_unlock_irqrestore(&conf->device_lock, flags);
 	}
 	kfree(behind_pages); /* the behind pages are attached to the bios now */
 
-	bitmap_startwrite(bitmap, bio->bi_sector, r1_bio->sectors,
-				test_bit(R1BIO_BehindIO, &r1_bio->state));
-	spin_lock_irqsave(&conf->device_lock, flags);
-	bio_list_merge(&conf->pending_bio_list, &bl);
-	bio_list_init(&bl);
-
-	blk_plug_device(mddev->queue);
-	spin_unlock_irqrestore(&conf->device_lock, flags);
-
 	/* In case raid1d snuck into freeze_array */
 	wake_up(&conf->wait_barrier);
 
 	if (do_sync)
 		md_wakeup_thread(mddev->thread);
-#if 0
-	while ((bio = bio_list_pop(&bl)) != NULL)
-		generic_make_request(bio);
-#endif
 
 	return 0;
 }
