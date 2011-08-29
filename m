Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab1H2LmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 07:42:20 -0400
Received: from zimbra.linbit.com ([212.69.161.123]:58574 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab1H2LmP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 07:42:15 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: Pawel Jakub Dawidek <pjd@freebsd.org>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: [Drbd-dev] [PATCH 016/118] drbd: Add read_requests tree
Date: Mon, 29 Aug 2011 13:42:04 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38-8-generic; KDE/4.6.2; i686; ; )
Cc: drbd-dev@lists.linbit.com
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com> <1314284934-17999-17-git-send-email-philipp.reisner@linbit.com> <20110825180244.GA1697@garage.freebsd.pl>
In-Reply-To: <20110825180244.GA1697@garage.freebsd.pl>
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201108291342.05003.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 25. August 2011, 20:02:44 schrieb Pawel Jakub Dawidek:
> On Thu, Aug 25, 2011 at 05:07:12PM +0200, Philipp Reisner wrote:
> > From: Andreas Gruenbacher <agruen@linbit.com>
> > 
> > We do not do collision detection for read requests, but we still need to
> > look up the request objects when we receive a package over the network.
> > Using the same data structure for read and write requests results in
> > simpler code once the tl_hash and app_reads_hash tables are removed.
> > 
> > Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
> > Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
> > ---
> > 
> >  drivers/block/drbd/drbd_int.h  |    1 +
> >  drivers/block/drbd/drbd_main.c |    1 +
> >  drivers/block/drbd/drbd_req.c  |   13 ++++++++++---
> >  3 files changed, 12 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/block/drbd/drbd_int.h
> > b/drivers/block/drbd/drbd_int.h index 0583713..fe15319 100644
> > --- a/drivers/block/drbd/drbd_int.h
> > +++ b/drivers/block/drbd/drbd_int.h
> > @@ -1020,6 +1020,7 @@ struct drbd_conf {
> > 
> >  	unsigned int tl_hash_s;
> >  	
> >  	/* Interval tree of pending local write requests */
> > 
> > +	struct rb_root read_requests;
> > 
> >  	struct rb_root write_requests;
> 
> Looks like the comment needs updating.

Ok, new edition of the patch:

>From dac1389ccc273b5486f2931c64c8e1672f233727 Mon Sep 17 00:00:00 2001
From: Andreas Gruenbacher <agruen@linbit.com>
Date: Fri, 21 Jan 2011 17:18:39 +0100
Subject: [PATCH 016/118] drbd: Add read_requests tree

We do not do collision detection for read requests, but we still need to
look up the request objects when we receive a package over the network.
Using the same data structure for read and write requests results in
simpler code once the tl_hash and app_reads_hash tables are removed.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h  |    3 ++-
 drivers/block/drbd/drbd_main.c |    1 +
 drivers/block/drbd/drbd_req.c  |   13 ++++++++++---
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 0583713..46a4332 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1019,7 +1019,8 @@ struct drbd_conf {
        struct hlist_head *tl_hash;
        unsigned int tl_hash_s;
 
-       /* Interval tree of pending local write requests */
+       /* Interval tree of pending local requests */
+       struct rb_root read_requests;
        struct rb_root write_requests;
 
        /* blocks to resync in this run [unit BM_BLOCK_SIZE] */
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 4d85838..c0ea5ba 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -3473,6 +3473,7 @@ struct drbd_conf *drbd_new_device(unsigned int minor)
        /* no need to lock access, we are still initializing this minor device. */
        if (!tl_init(mdev))
                goto out_no_tl;
+       mdev->read_requests = RB_ROOT;
        mdev->write_requests = RB_ROOT;
 
        mdev->app_reads_hash = kzalloc(APP_R_HSIZE*sizeof(void *), GFP_KERNEL);
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 593576f..d2a78c4 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -260,10 +260,15 @@ void _req_may_be_done(struct drbd_request *req, struct bio_and_error *m)
 
                /* remove the request from the conflict detection
                 * respective block_id verification hash */
-               if (!hlist_unhashed(&req->collision)) {
+               if (!drbd_interval_empty(&req->i)) {
+                       struct rb_root *root;
+
                        hlist_del(&req->collision);
-                       if (!drbd_interval_empty(&req->i))
-                               drbd_remove_interval(&mdev->write_requests, &req->i);
+                       if (rw == WRITE)
+                               root = &mdev->write_requests;
+                       else
+                               root = &mdev->read_requests;
+                       drbd_remove_interval(root, &req->i);
                } else
                        D_ASSERT((s & (RQ_NET_MASK & ~RQ_NET_DONE)) == 0);
 
@@ -332,6 +337,7 @@ static int _req_conflicts(struct drbd_request *req)
        struct hlist_head *slot;
 
        D_ASSERT(hlist_unhashed(&req->collision));
+       D_ASSERT(drbd_interval_empty(&req->i));
 
        if (!get_net_conf(mdev))
                return 0;
@@ -493,6 +499,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
                /* so we can verify the handle in the answer packet
                 * corresponding hlist_del is in _req_may_be_done() */
                hlist_add_head(&req->collision, ar_hash_slot(mdev, req->i.sector));
+               drbd_insert_interval(&mdev->read_requests, &req->i);
 
                set_bit(UNPLUG_REMOTE, &mdev->flags);
 
-- 
1.7.4.1

-- 
: Dipl-Ing Philipp Reisner
: LINBIT | Your Way to High Availability
: Tel: +43-1-8178292-50, Fax: +43-1-8178292-82
: http://www.linbit.com

DRBD(R) and LINBIT(R) are registered trademarks of LINBIT, Austria.
