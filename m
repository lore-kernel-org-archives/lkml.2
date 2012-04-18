Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609Ab2DRG0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 02:26:46 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35518 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781Ab2DRGZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 02:25:58 -0400
From: Venkatraman S <svenkatr@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>
CC: <arnd.bergmann@linaro.org>, <cjb@laptop.org>, <alex.limberg@sandisk.com>,
        <ilan.smith@sandisk.com>, <lporzio@micron.com>,
        Alex Lemberg <alex.lemberg@sandisk.com>,
        Venkatraman S <svenkatr@ti.com>
Subject: [RFC PATCH 01/11] fs: Add demand paging markers to filesystem
Date: Wed, 18 Apr 2012 11:55:22 +0530
Message-ID: <1334730332-22244-2-git-send-email-svenkatr@ti.com>
X-Mailer: git-send-email 1.7.10.rc2
In-Reply-To: <1334730332-22244-1-git-send-email-svenkatr@ti.com>
References: <1334730332-22244-1-git-send-email-svenkatr@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ilan Smith <ilan.smith@sandisk.com>

Add attribute to identify demand paging requests.
Mark readpages with demand paging attribute.

Signed-off-by: Ilan Smith <ilan.smith@sandisk.com>
Signed-off-by: Alex Lemberg <alex.lemberg@sandisk.com>
Signed-off-by: Venkatraman S <svenkatr@ti.com>
---
 fs/mpage.c                |    2 ++
 include/linux/bio.h       |    7 +++++++
 include/linux/blk_types.h |    2 ++
 3 files changed, 11 insertions(+)

diff --git a/fs/mpage.c b/fs/mpage.c
index 0face1c..8b144f5 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -386,6 +386,8 @@ mpage_readpages(struct address_space *mapping, struct list_head *pages,
 					&last_block_in_bio, &map_bh,
 					&first_logical_block,
 					get_block);
+			if (bio)
+				bio->bi_rw |= REQ_RW_DMPG;
 		}
 		page_cache_release(page);
 	}
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 4d94eb8..264e0ef 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -57,6 +57,13 @@
 	(bio)->bi_rw |= ((unsigned long) (prio) << BIO_PRIO_SHIFT);	\
 } while (0)
 
+static inline bool bio_rw_flagged(struct bio *bio, unsigned long flag)
+{
+	return ((bio->bi_rw & flag)  != 0);
+}
+
+#define bio_dmpg(bio)	bio_rw_flagged(bio, REQ_RW_DMPG)
+
 /*
  * various member access, note that bio_data should of course not be used
  * on highmem page vectors
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 4053cbd..87feb80 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -150,6 +150,7 @@ enum rq_flag_bits {
 	__REQ_FLUSH_SEQ,	/* request for flush sequence */
 	__REQ_IO_STAT,		/* account I/O stat */
 	__REQ_MIXED_MERGE,	/* merge of different types, fail separately */
+	__REQ_RW_DMPG,
 	__REQ_NR_BITS,		/* stops here */
 };
 
@@ -191,5 +192,6 @@ enum rq_flag_bits {
 #define REQ_IO_STAT		(1 << __REQ_IO_STAT)
 #define REQ_MIXED_MERGE		(1 << __REQ_MIXED_MERGE)
 #define REQ_SECURE		(1 << __REQ_SECURE)
+#define REQ_RW_DMPG		(1 << __REQ_RW_DMPG)
 
 #endif /* __LINUX_BLK_TYPES_H */
-- 
1.7.10.rc2

