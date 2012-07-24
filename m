Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab2GXUMM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 16:12:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45200 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800Ab2GXUMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 16:12:06 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        agk@redhat.com, neilb@suse.de, drbd-dev@lists.linbit.com,
        bharrosh@panasas.com, vgoyal@redhat.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net
Subject: [PATCH v4 10/12] block: Add bio_clone_kmalloc()
Date: Tue, 24 Jul 2012 13:11:27 -0700
Message-Id: <1343160689-12378-11-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1343160689-12378-1-git-send-email-koverstreet@google.com>
References: <1343160689-12378-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 drivers/block/osdblk.c |    3 +--
 fs/bio.c               |   13 +++++++++++++
 fs/exofs/ore.c         |    5 ++---
 include/linux/bio.h    |    1 +
 4 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/block/osdblk.c b/drivers/block/osdblk.c
index 87311eb..1bbc681 100644
--- a/drivers/block/osdblk.c
+++ b/drivers/block/osdblk.c
@@ -266,11 +266,10 @@ static struct bio *bio_chain_clone(struct bio *old_chain, gfp_t gfpmask)
 	struct bio *tmp, *new_chain = NULL, *tail = NULL;
 
 	while (old_chain) {
-		tmp = bio_kmalloc(gfpmask, old_chain->bi_max_vecs);
+		tmp = bio_clone_kmalloc(old_chain, gfpmask);
 		if (!tmp)
 			goto err_out;
 
-		__bio_clone(tmp, old_chain);
 		tmp->bi_bdev = NULL;
 		gfpmask &= ~__GFP_WAIT;
 		tmp->bi_next = NULL;
diff --git a/fs/bio.c b/fs/bio.c
index fa6dee4..9d0ceb2 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -499,6 +499,19 @@ struct bio *bio_clone(struct bio *bio, gfp_t gfp_mask)
 }
 EXPORT_SYMBOL(bio_clone);
 
+struct bio *bio_clone_kmalloc(struct bio *bio, gfp_t gfp_mask)
+{
+	struct bio *b = bio_kmalloc(gfp_mask, bio->bi_max_vecs);
+
+	if (!b)
+		return NULL;
+
+	__bio_clone(b, bio);
+
+	return b;
+}
+EXPORT_SYMBOL(bio_clone_kmalloc);
+
 /**
  *	bio_get_nr_vecs		- return approx number of vecs
  *	@bdev:  I/O target
diff --git a/fs/exofs/ore.c b/fs/exofs/ore.c
index 24a49d4..a8d92fc 100644
--- a/fs/exofs/ore.c
+++ b/fs/exofs/ore.c
@@ -814,8 +814,8 @@ static int _write_mirror(struct ore_io_state *ios, int cur_comp)
 			struct bio *bio;
 
 			if (per_dev != master_dev) {
-				bio = bio_kmalloc(GFP_KERNEL,
-						  master_dev->bio->bi_max_vecs);
+				bio = bio_clone_kmalloc(master_dev->bio,
+							GFP_KERNEL);
 				if (unlikely(!bio)) {
 					ORE_DBGMSG(
 					      "Failed to allocate BIO size=%u\n",
@@ -824,7 +824,6 @@ static int _write_mirror(struct ore_io_state *ios, int cur_comp)
 					goto out;
 				}
 
-				__bio_clone(bio, master_dev->bio);
 				bio->bi_bdev = NULL;
 				bio->bi_next = NULL;
 				per_dev->offset = master_dev->offset;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 9720544..e180f1d 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -221,6 +221,7 @@ extern int bio_phys_segments(struct request_queue *, struct bio *);
 
 extern void __bio_clone(struct bio *, struct bio *);
 extern struct bio *bio_clone(struct bio *, gfp_t);
+struct bio *bio_clone_kmalloc(struct bio *, gfp_t);
 
 extern void bio_init(struct bio *);
 extern void bio_reset(struct bio *);
-- 
1.7.7.3

