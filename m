Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031035Ab2ERDCs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 23:02:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51875 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030929Ab2ERDAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 23:00:14 -0400
From: koverstreet@google.com
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        agk@redhat.com, neilb@suse.de
Subject: [PATCH 06/13] block: Add bio_reset()
Date: Thu, 17 May 2012 22:59:53 -0400
Message-Id: <9953623f6fae97018e59d96971a2612caf6c01e7.1337308722.git.koverstreet@google.com>
X-Mailer: git-send-email 1.7.9.rc2
In-Reply-To: <cover.1337308722.git.koverstreet@google.com>
References: <cover.1337308722.git.koverstreet@google.com>
In-Reply-To: <cover.1337308722.git.koverstreet@google.com>
References: <cover.1337308722.git.koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kent Overstreet <koverstreet@google.com>

Reusing bios is something that's been highly frowned upon in the past,
but driver code keeps doing it anyways. If it's going to happen anyways,
we should provide a generic method.

This'll help with getting rid of bi_destructor.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 fs/bio.c                  |    8 ++++++++
 include/linux/bio.h       |    1 +
 include/linux/blk_types.h |    6 ++++++
 3 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index de0733e..90e4c3a 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -259,6 +259,14 @@ void bio_init(struct bio *bio)
 }
 EXPORT_SYMBOL(bio_init);
 
+void bio_reset(struct bio *bio)
+{
+	memset(bio, 0, BIO_RESET_OFFSET);
+	bio->bi_flags = 1 << BIO_UPTODATE;
+
+}
+EXPORT_SYMBOL(bio_reset);
+
 /**
  * bio_alloc_bioset - allocate a bio for I/O
  * @gfp_mask:   the GFP_ mask given to the slab allocator
diff --git a/include/linux/bio.h b/include/linux/bio.h
index b27f16b..35f7c4d 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -228,6 +228,7 @@ extern struct bio *bio_clone(struct bio *, gfp_t);
 struct bio *bio_clone_kmalloc(struct bio *, gfp_t);
 
 extern void bio_init(struct bio *);
+extern void bio_reset(struct bio *);
 
 extern int bio_add_page(struct bio *, struct page *, unsigned int,unsigned int);
 extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index dc0e399..4a47783 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -57,6 +57,10 @@ struct bio {
 	unsigned int		bi_seg_front_size;
 	unsigned int		bi_seg_back_size;
 
+	/*
+	 * Everything starting with bi_max_vecs will be preserved by bio_reset()
+	 */
+
 	unsigned int		bi_max_vecs;	/* max bvl_vecs we can hold */
 
 	atomic_t		bi_cnt;		/* pin count */
@@ -83,6 +87,8 @@ struct bio {
 	struct bio_vec		bi_inline_vecs[0];
 };
 
+#define BIO_RESET_OFFSET	offsetof(struct bio, bi_max_vecs)
+
 /*
  * bio flags
  */
-- 
1.7.9.rc2

