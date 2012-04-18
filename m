Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425Ab2DRG0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 02:26:09 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42903 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab2DRGZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 02:25:56 -0400
From: Venkatraman S <svenkatr@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>
CC: <arnd.bergmann@linaro.org>, <cjb@laptop.org>, <alex.limberg@sandisk.com>,
        <ilan.smith@sandisk.com>, <lporzio@micron.com>,
        Venkatraman S <svenkatr@ti.com>,
        Alex Lemberg <alex.lemberg@sandisk.com>
Subject: [RFC PATCH 03/11] block: Add queue attributes to manage dpmg and swapin requests
Date: Wed, 18 Apr 2012 11:55:24 +0530
Message-ID: <1334730332-22244-4-git-send-email-svenkatr@ti.com>
X-Mailer: git-send-email 1.7.10.rc2
In-Reply-To: <1334730332-22244-1-git-send-email-svenkatr@ti.com>
References: <1334730332-22244-1-git-send-email-svenkatr@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add block queue properties to identify and manage demand paging
and swap read requests differently. sysfs entries are included
to enable or disable this feature at runtime.

Signed-off-by: Venkatraman S <svenkatr@ti.com>
Signed-off-by: Ilan Smith <ilan.smith@sandisk.com>
Signed-off-by: Alex Lemberg <alex.lemberg@sandisk.com>
---
 block/blk-sysfs.c      |   16 ++++++++++++++++
 include/linux/blkdev.h |    8 ++++++++
 2 files changed, 24 insertions(+)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index cf15001..764de9f 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -213,6 +213,8 @@ queue_store_##name(struct request_queue *q, const char *page, size_t count) \
 }
 
 QUEUE_SYSFS_BIT_FNS(nonrot, NONROT, 1);
+QUEUE_SYSFS_BIT_FNS(expedite_dmpg, EXP_DMPG, 0);
+QUEUE_SYSFS_BIT_FNS(expedite_swapin, EXP_SWAPIN, 0);
 QUEUE_SYSFS_BIT_FNS(random, ADD_RANDOM, 0);
 QUEUE_SYSFS_BIT_FNS(iostats, IO_STAT, 0);
 #undef QUEUE_SYSFS_BIT_FNS
@@ -387,6 +389,18 @@ static struct queue_sysfs_entry queue_random_entry = {
 	.store = queue_store_random,
 };
 
+static struct queue_sysfs_entry queue_dmpg_entry = {
+	.attr = {.name = "expedite_demandpaging", .mode = S_IRUGO | S_IWUSR },
+	.show = queue_show_expedite_dmpg,
+	.store = queue_store_expedite_dmpg,
+};
+
+static struct queue_sysfs_entry queue_swapin_entry = {
+	.attr = {.name = "expedite_swapping", .mode = S_IRUGO | S_IWUSR },
+	.show = queue_show_expedite_swapin,
+	.store = queue_store_expedite_swapin,
+};
+
 static struct attribute *default_attrs[] = {
 	&queue_requests_entry.attr,
 	&queue_ra_entry.attr,
@@ -409,6 +423,8 @@ static struct attribute *default_attrs[] = {
 	&queue_rq_affinity_entry.attr,
 	&queue_iostats_entry.attr,
 	&queue_random_entry.attr,
+	&queue_dmpg_entry.attr,
+	&queue_swapin_entry.attr,
 	NULL,
 };
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 606cf33..fd620b9 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -420,6 +420,8 @@ struct request_queue {
 #define QUEUE_FLAG_ADD_RANDOM  16	/* Contributes to random pool */
 #define QUEUE_FLAG_SECDISCARD  17	/* supports SECDISCARD */
 #define QUEUE_FLAG_SAME_FORCE  18	/* force complete on same CPU */
+#define QUEUE_FLAG_EXP_DMPG    19	/* Expedite Demand paging requests */
+#define QUEUE_FLAG_EXP_SWAPIN  20	/* Expedit page swapping */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_STACKABLE)	|	\
@@ -506,6 +508,12 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 #define blk_queue_secdiscard(q)	(blk_queue_discard(q) && \
 	test_bit(QUEUE_FLAG_SECDISCARD, &(q)->queue_flags))
 
+#define blk_queue_exp_dmpg(q) \
+	test_bit(QUEUE_FLAG_EXP_DMPG, &(q)->queue_flags)
+
+#define blk_queue_exp_swapin(q) \
+	test_bit(QUEUE_FLAG_EXP_SWAPIN, &(q)->queue_flags)
+
 #define blk_noretry_request(rq) \
 	((rq)->cmd_flags & (REQ_FAILFAST_DEV|REQ_FAILFAST_TRANSPORT| \
 			     REQ_FAILFAST_DRIVER))
-- 
1.7.10.rc2

