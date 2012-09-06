Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933329Ab2IFVfE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 17:35:04 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55956 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933246Ab2IFVdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 17:33:18 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v9 6/9] block: Add bio_reset()
Date: Thu,  6 Sep 2012 14:32:53 -0700
Message-Id: <1346967179-28596-7-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346967179-28596-1-git-send-email-koverstreet@google.com>
References: <1346967179-28596-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reusing bios is something that's been highly frowned upon in the past,
but driver code keeps doing it anyways. If it's going to happen anyways,
we should provide a generic method.

This'll help with getting rid of bi_destructor - drivers/block/pktcdvd.c
was open coding it, by doing a bio_init() and resetting bi_destructor.

This required reordering struct bio, but the block layer is not yet
nearly fast enough for any cacheline effects to matter here.

v5: Add a define BIO_RESET_BITS, to be very explicit about what parts of
bio->bi_flags are saved.
v6: Further commenting verbosity, per Tejun
v9: Add a function comment

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
Acked-by: Tejun Heo <tj@kernel.org>
---
 fs/bio.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/bio.c b/fs/bio.c
index 208141f..74ab3f0 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -277,6 +277,30 @@ void bio_reset(struct bio *bio)
 EXPORT_SYMBOL(bio_reset);
 
 /**
+ * bio_reset - reinitialize a bio
+ * @bio:	bio to reset
+ *
+ * Description:
+ *   After calling bio_reset(), @bio will be in the same state as a freshly
+ *   allocated bio returned bio bio_alloc_bioset() - the only fields that are
+ *   preserved are the ones that are initialized by bio_alloc_bioset(). See
+ *   comment in struct bio.
+ */
+void bio_reset(struct bio *bio)
+{
+	unsigned long flags = bio->bi_flags & (~0UL << BIO_RESET_BITS);
+
+	if (bio_integrity(bio))
+		bio_integrity_free(bio, bio->bi_pool);
+
+	bio_disassociate_task(bio);
+
+	memset(bio, 0, BIO_RESET_BYTES);
+	bio->bi_flags = flags|(1 << BIO_UPTODATE);
+}
+EXPORT_SYMBOL(bio_reset);
+
+/**
  * bio_alloc_bioset - allocate a bio for I/O
  * @gfp_mask:   the GFP_ mask given to the slab allocator
  * @nr_iovecs:	number of iovecs to pre-allocate
-- 
1.7.12

