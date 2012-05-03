Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab2ECOYN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 10:24:13 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58785 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756147Ab2ECOYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 10:24:09 -0400
From: Venkatraman S <svenkatr@ti.com>
To: <linux-mmc@vger.kernel.org>, <cjb@laptop.org>, <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-omap@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <arnd.bergmann@linaro.org>,
        <alex.lemberg@sandisk.com>, <ilan.smith@sandisk.com>,
        <lporzio@micron.com>, <rmk+kernel@arm.linux.org.uk>,
        Venkatraman S <svenkatr@ti.com>
Subject: [PATCH v2 02/16] MM: Added page swapping markers to memory management
Date: Thu, 3 May 2012 19:53:01 +0530
Message-ID: <1336054995-22988-3-git-send-email-svenkatr@ti.com>
X-Mailer: git-send-email 1.7.10.rc2
In-Reply-To: <1336054995-22988-1-git-send-email-svenkatr@ti.com>
References: <1336054995-22988-1-git-send-email-svenkatr@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ilan Smith <ilan.smith@sandisk.com>

Add attribute to identify swapin requests
Mark memory management requests with swapin requests

Signed-off-by: Ilan Smith <ilan.smith@sandisk.com>
Signed-off-by: Alex Lemberg <alex.lemberg@sandisk.com>
Signed-off-by: Venkatraman S <svenkatr@ti.com>
---
 include/linux/bio.h       |    1 +
 include/linux/blk_types.h |    2 ++
 mm/page_io.c              |    3 ++-
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index 264e0ef..8494b2f 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -63,6 +63,7 @@ static inline bool bio_rw_flagged(struct bio *bio, unsigned long flag)
 }
 
 #define bio_dmpg(bio)	bio_rw_flagged(bio, REQ_RW_DMPG)
+#define bio_swapin(bio)	bio_rw_flagged(bio, REQ_RW_SWAPIN)
 
 /*
  * various member access, note that bio_data should of course not be used
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 87feb80..df2b9ea 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -151,6 +151,7 @@ enum rq_flag_bits {
 	__REQ_IO_STAT,		/* account I/O stat */
 	__REQ_MIXED_MERGE,	/* merge of different types, fail separately */
 	__REQ_RW_DMPG,
+	__REQ_RW_SWAPIN,
 	__REQ_NR_BITS,		/* stops here */
 };
 
@@ -193,5 +194,6 @@ enum rq_flag_bits {
 #define REQ_MIXED_MERGE		(1 << __REQ_MIXED_MERGE)
 #define REQ_SECURE		(1 << __REQ_SECURE)
 #define REQ_RW_DMPG		(1 << __REQ_RW_DMPG)
+#define REQ_RW_SWAPIN		(1 << __REQ_RW_SWAPIN)
 
 #endif /* __LINUX_BLK_TYPES_H */
diff --git a/mm/page_io.c b/mm/page_io.c
index dc76b4d..a148bea 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -128,8 +128,9 @@ int swap_readpage(struct page *page)
 		ret = -ENOMEM;
 		goto out;
 	}
+	bio->bi_rw |= REQ_RW_SWAPIN;
 	count_vm_event(PSWPIN);
-	submit_bio(READ, bio);
+	submit_bio(READ | REQ_RW_SWAPIN, bio);
 out:
 	return ret;
 }
-- 
1.7.10.rc2

