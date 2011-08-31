Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818Ab1HaNbw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 09:31:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755567Ab1HaNbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 09:31:49 -0400
Date: Wed, 31 Aug 2011 09:31:29 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Dave Chinner <david@fromorbit.com>
cc: Dave Chinner <dchinner@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] shrinker: fix a bug when callback returns -1
In-Reply-To: <20110830223711.GU3162@dastard>
Message-ID: <Pine.LNX.4.64.1108310923320.22628@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1108291534140.19003@hs20-bc2-1.build.redhat.com>
 <20110830021333.GL3162@dastard> <Pine.LNX.4.64.1108301511110.9551@hs20-bc2-1.build.redhat.com>
 <20110830223711.GU3162@dastard>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 31 Aug 2011, Dave Chinner wrote:

> On Tue, Aug 30, 2011 at 03:52:02PM -0400, Mikulas Patocka wrote:
> > On Tue, 30 Aug 2011, Dave Chinner wrote:
> > 
> > > On Mon, Aug 29, 2011 at 03:36:48PM -0400, Mikulas Patocka wrote:
> > > > Hi
> > > > 
> > > > This patch fixes a lockup when shrinker callback returns -1.
> > > 
> > > What lockup is that? I haven't seen any bug reports, and this code
> > > has been like this for several years, so I'm kind of wondering why
> > > this is suddenly an issue....
> > 
> > I got the lockups when modifying my own dm-bufio code to use the shrinker. 
> > The reason for lockups was that the variable total_scan contained 
> > extremely high values.
> 
> Your new shrinker was returning -1 when nr_to_scan == 0? That's not
> correct - you should be returning the count of objects (regardless
> of the specified gfp_mask) or 0 if you can't get one for whatever
> reason....
> 
> > The only possible way how such extreme values could be stored in 
> > total_scan was this:
> > 
> > max_pass = do_shrinker_shrink(shrinker, shrink, 0);
> > delta = (4 * nr_pages_scanned) / shrinker->seeks;
> > delta *= max_pass;
> > do_div(delta, lru_pages + 1);
> > total_scan += delta;
> > 
> > --- you don't test if do_shinker_shrink retuned -1 here. The variables are 
> > unsigned long, so you end up adding extreme value (approximately 
> > 2^64/(lru_pages+1) to total_scan.
> 
> That's not the only way to get large values in total scan. If
> you do any amount of GFP_NOFS/GFP_NOIO allocation and the shrinker
> aborts when it sees this, the shrinker->nr total will aggregate
> until it becomes large. total_scan contains that aggregation because
> it starts from the current value of shrinker->nr.
> 
> > Note that some existing shrinkers contain workaround for this (something 
> > like "return nr_to_scan ? -1 : 0",
> 
> That's not a workaround - that is exactly how the current API
> expects them to operate. That is, when counting objects, you return
> the count of objects. If you can't get the count, you return 0.

So apply this patch, that mentions this requirement in the specification 
and fixes the bug in fs/super.c.

> Did I mention I was rewriting the API to make it more sane, obvious
> and simple to implement correctly?
> 
> > while some can still return -1 when 
> > nr_to_scan is 0 and trigger this bug (prune_super).
> 
> prune_super() will only return -1 if grab_super_passive() fails,
> which indicates that something serious is happening on the
> superblock (like unmount, remount or freeze) in which case the
> caches are about to or already undergoing significant change anyway.
>
> It could be seen as a bug, but it's really a "don't care" case - it
> doesn't matter what the calculated value is because it doesn't
> matter what the shrinker does after such a failure - the next call
> is going to fail to grab the superblock, too.

It is a bug, because the shrinker will loop for 
2^64/(lru_pages+1)/batch_size times if that "-1" is returned at certain 
place --- in "max_pass = do_shrinker_shrink(shrinker, shrink, 0)".

Mikulas

> And FWIW, that wart also goes away with the shrinker API rework.
> 
> Cheers,
> 
> Dave.

---

Fix shrinker callback bug in fs/super.c

The callback must not return -1 when nr_to_scan is zero. Fix the bug in
fs/super.c and add this requirement to the callback specification.

CC: stable@kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 fs/super.c               |    2 +-
 include/linux/shrinker.h |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

Index: linux-3.1-rc3-fast/fs/super.c
===================================================================
--- linux-3.1-rc3-fast.orig/fs/super.c	2011-08-31 15:21:01.000000000 +0200
+++ linux-3.1-rc3-fast/fs/super.c	2011-08-31 15:21:21.000000000 +0200
@@ -61,7 +61,7 @@ static int prune_super(struct shrinker *
 		return -1;
 
 	if (!grab_super_passive(sb))
-		return -1;
+		return !sc->nr_to_scan ? 0 : -1;
 
 	if (sb->s_op && sb->s_op->nr_cached_objects)
 		fs_objects = sb->s_op->nr_cached_objects(sb);
Index: linux-3.1-rc3-fast/include/linux/shrinker.h
===================================================================
--- linux-3.1-rc3-fast.orig/include/linux/shrinker.h	2011-08-31 15:21:28.000000000 +0200
+++ linux-3.1-rc3-fast/include/linux/shrinker.h	2011-08-31 15:21:58.000000000 +0200
@@ -20,6 +20,7 @@ struct shrink_control {
  * 'nr_to_scan' entries and attempt to free them up.  It should return
  * the number of objects which remain in the cache.  If it returns -1, it means
  * it cannot do any scanning at this time (eg. there is a risk of deadlock).
+ * The callback must not return -1 if nr_to_scan is zero.
  *
  * The 'gfpmask' refers to the allocation we are currently trying to
  * fulfil.
