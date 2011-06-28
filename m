Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945Ab1F1IPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 04:15:53 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57418 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756749Ab1F1INM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 04:13:12 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linaro-dev@lists.linaro.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org,
        Nickolay Nickolaev <nicknickolaev@gmail.com>,
        Venkatraman S <svenkatr@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Chris Ball <cjb@laptop.org>, Per Forlin <per.forlin@linaro.org>
Subject: [PATCH v8 06/12] mmc: mmc_test: test to measure how sg_len affect performance
Date: Tue, 28 Jun 2011 10:11:51 +0200
Message-Id: <1309248717-14606-7-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309248717-14606-1-git-send-email-per.forlin@linaro.org>
References: <1309248717-14606-1-git-send-email-per.forlin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

test that measures how the mmc bandwidth depends on the numbers of sg elements
in the sg list. The transfer size if fixed and sg length goes from a few up
to 512. The purpose is to measure overhead caused by multiple sg elements.

Signed-off-by: Per Forlin <per.forlin@linaro.org>
---
 drivers/mmc/card/mmc_test.c |  151 +++++++++++++++++++++++++++++++++++++++----
 1 files changed, 139 insertions(+), 12 deletions(-)

diff --git a/drivers/mmc/card/mmc_test.c b/drivers/mmc/card/mmc_test.c
index 466a192..453d770 100644
--- a/drivers/mmc/card/mmc_test.c
+++ b/drivers/mmc/card/mmc_test.c
@@ -155,6 +155,7 @@ enum mmc_test_prep_media {
 };
 
 struct mmc_test_multiple_rw {
+	unsigned int *sg_len;
 	unsigned int *bs;
 	unsigned int len;
 	unsigned int size;
@@ -387,21 +388,26 @@ out_free:
  * Map memory into a scatterlist.  Optionally allow the same memory to be
  * mapped more than once.
  */
-static int mmc_test_map_sg(struct mmc_test_mem *mem, unsigned long sz,
+static int mmc_test_map_sg(struct mmc_test_mem *mem, unsigned long size,
 			   struct scatterlist *sglist, int repeat,
 			   unsigned int max_segs, unsigned int max_seg_sz,
-			   unsigned int *sg_len)
+			   unsigned int *sg_len, int min_sg_len)
 {
 	struct scatterlist *sg = NULL;
 	unsigned int i;
+	unsigned long sz = size;
 
 	sg_init_table(sglist, max_segs);
+	if (min_sg_len > max_segs)
+		min_sg_len = max_segs;
 
 	*sg_len = 0;
 	do {
 		for (i = 0; i < mem->cnt; i++) {
 			unsigned long len = PAGE_SIZE << mem->arr[i].order;
 
+			if (min_sg_len && (size / min_sg_len < len))
+				len = size / min_sg_len;
 			if (len > sz)
 				len = sz;
 			if (len > max_seg_sz)
@@ -574,11 +580,12 @@ static void mmc_test_print_avg_rate(struct mmc_test_card *test, uint64_t bytes,
 
 	printk(KERN_INFO "%s: Transfer of %u x %u sectors (%u x %u%s KiB) took "
 			 "%lu.%09lu seconds (%u kB/s, %u KiB/s, "
-			 "%u.%02u IOPS)\n",
+			 "%u.%02u IOPS, sg_len %d)\n",
 			 mmc_hostname(test->card->host), count, sectors, count,
 			 sectors >> 1, (sectors & 1 ? ".5" : ""),
 			 (unsigned long)ts.tv_sec, (unsigned long)ts.tv_nsec,
-			 rate / 1000, rate / 1024, iops / 100, iops % 100);
+			 rate / 1000, rate / 1024, iops / 100, iops % 100,
+			 test->area.sg_len);
 
 	mmc_test_save_transfer_result(test, count, sectors, ts, rate, iops);
 }
@@ -1416,7 +1423,7 @@ static int mmc_test_no_highmem(struct mmc_test_card *test)
  * Map sz bytes so that it can be transferred.
  */
 static int mmc_test_area_map(struct mmc_test_card *test, unsigned long sz,
-			     int max_scatter)
+			     int max_scatter, int min_sg_len)
 {
 	struct mmc_test_area *t = &test->area;
 	int err;
@@ -1429,7 +1436,7 @@ static int mmc_test_area_map(struct mmc_test_card *test, unsigned long sz,
 				       &t->sg_len);
 	} else {
 		err = mmc_test_map_sg(t->mem, sz, t->sg, 1, t->max_segs,
-				      t->max_seg_sz, &t->sg_len);
+				      t->max_seg_sz, &t->sg_len, min_sg_len);
 	}
 	if (err)
 		printk(KERN_INFO "%s: Failed to map sg list\n",
@@ -1455,7 +1462,7 @@ static int mmc_test_area_transfer(struct mmc_test_card *test,
 static int mmc_test_area_io_seq(struct mmc_test_card *test, unsigned long sz,
 				unsigned int dev_addr, int write,
 				int max_scatter, int timed, int count,
-				bool nonblock)
+				bool nonblock, int min_sg_len)
 {
 	struct timespec ts1, ts2;
 	int ret = 0;
@@ -1478,7 +1485,7 @@ static int mmc_test_area_io_seq(struct mmc_test_card *test, unsigned long sz,
 			sz = max_tfr;
 	}
 
-	ret = mmc_test_area_map(test, sz, max_scatter);
+	ret = mmc_test_area_map(test, sz, max_scatter, min_sg_len);
 	if (ret)
 		return ret;
 
@@ -1510,7 +1517,7 @@ static int mmc_test_area_io(struct mmc_test_card *test, unsigned long sz,
 			    int timed)
 {
 	return mmc_test_area_io_seq(test, sz, dev_addr, write, max_scatter,
-				    timed, 1, false);
+				    timed, 1, false, 0);
 }
 
 /*
@@ -2088,7 +2095,8 @@ static int mmc_test_large_seq_write_perf(struct mmc_test_card *test)
 
 static int mmc_test_rw_multiple(struct mmc_test_card *test,
 				struct mmc_test_multiple_rw *tdata,
-				unsigned int reqsize, unsigned int size)
+				unsigned int reqsize, unsigned int size,
+				int min_sg_len)
 {
 	unsigned int dev_addr;
 	struct mmc_test_area *t = &test->area;
@@ -2122,7 +2130,7 @@ static int mmc_test_rw_multiple(struct mmc_test_card *test,
 	/* Run test */
 	ret = mmc_test_area_io_seq(test, reqsize, dev_addr,
 				   tdata->do_write, 0, 1, size / reqsize,
-				   tdata->do_nonblock_req);
+				   tdata->do_nonblock_req, min_sg_len);
 	if (ret)
 		goto err;
 
@@ -2139,7 +2147,22 @@ static int mmc_test_rw_multiple_size(struct mmc_test_card *test,
 	int i;
 
 	for (i = 0 ; i < rw->len && ret == 0; i++) {
-		ret = mmc_test_rw_multiple(test, rw, rw->bs[i], rw->size);
+		ret = mmc_test_rw_multiple(test, rw, rw->bs[i], rw->size, 0);
+		if (ret)
+			break;
+	}
+	return ret;
+}
+
+static int mmc_test_rw_multiple_sg_len(struct mmc_test_card *test,
+				       struct mmc_test_multiple_rw *rw)
+{
+	int ret = 0;
+	int i;
+
+	for (i = 0 ; i < rw->len && ret == 0; i++) {
+		ret = mmc_test_rw_multiple(test, rw, 512*1024, rw->size,
+					   rw->sg_len[i]);
 		if (ret)
 			break;
 	}
@@ -2222,6 +2245,82 @@ static int mmc_test_profile_mult_read_nonblock_perf(struct mmc_test_card *test)
 	return mmc_test_rw_multiple_size(test, &test_data);
 }
 
+/*
+ * Multiple blocking write 1 to 512 sg elements
+ */
+static int mmc_test_profile_sglen_wr_blocking_perf(struct mmc_test_card *test)
+{
+	unsigned int sg_len[] = {1, 1 << 3, 1 << 4, 1 << 5, 1 << 6,
+				 1 << 7, 1 << 8, 1 << 9};
+	struct mmc_test_multiple_rw test_data = {
+		.sg_len = sg_len,
+		.size = 128*1024*1024,
+		.len = ARRAY_SIZE(sg_len),
+		.do_write = true,
+		.do_nonblock_req = false,
+		.prepare = MMC_TEST_PREP_ERASE,
+	};
+
+	return mmc_test_rw_multiple_sg_len(test, &test_data);
+};
+
+/*
+ * Multiple non-blocking write 1 to 512 sg elements
+ */
+static int mmc_test_profile_sglen_wr_nonblock_perf(struct mmc_test_card *test)
+{
+	unsigned int sg_len[] = {1, 1 << 3, 1 << 4, 1 << 5, 1 << 6,
+				 1 << 7, 1 << 8, 1 << 9};
+	struct mmc_test_multiple_rw test_data = {
+		.sg_len = sg_len,
+		.size = 128*1024*1024,
+		.len = ARRAY_SIZE(sg_len),
+		.do_write = true,
+		.do_nonblock_req = true,
+		.prepare = MMC_TEST_PREP_ERASE,
+	};
+
+	return mmc_test_rw_multiple_sg_len(test, &test_data);
+}
+
+/*
+ * Multiple blocking read 1 to 512 sg elements
+ */
+static int mmc_test_profile_sglen_r_blocking_perf(struct mmc_test_card *test)
+{
+	unsigned int sg_len[] = {1, 1 << 3, 1 << 4, 1 << 5, 1 << 6,
+				 1 << 7, 1 << 8, 1 << 9};
+	struct mmc_test_multiple_rw test_data = {
+		.sg_len = sg_len,
+		.size = 128*1024*1024,
+		.len = ARRAY_SIZE(sg_len),
+		.do_write = false,
+		.do_nonblock_req = false,
+		.prepare = MMC_TEST_PREP_NONE,
+	};
+
+	return mmc_test_rw_multiple_sg_len(test, &test_data);
+}
+
+/*
+ * Multiple non-blocking read 1 to 512 sg elements
+ */
+static int mmc_test_profile_sglen_r_nonblock_perf(struct mmc_test_card *test)
+{
+	unsigned int sg_len[] = {1, 1 << 3, 1 << 4, 1 << 5, 1 << 6,
+				 1 << 7, 1 << 8, 1 << 9};
+	struct mmc_test_multiple_rw test_data = {
+		.sg_len = sg_len,
+		.size = 128*1024*1024,
+		.len = ARRAY_SIZE(sg_len),
+		.do_write = false,
+		.do_nonblock_req = true,
+		.prepare = MMC_TEST_PREP_NONE,
+	};
+
+	return mmc_test_rw_multiple_sg_len(test, &test_data);
+}
+
 static const struct mmc_test_case mmc_test_cases[] = {
 	{
 		.name = "Basic write (no data verification)",
@@ -2516,6 +2615,34 @@ static const struct mmc_test_case mmc_test_cases[] = {
 		.run = mmc_test_profile_mult_read_nonblock_perf,
 		.cleanup = mmc_test_area_cleanup,
 	},
+
+	{
+		.name = "Write performance blocking req 1 to 512 sg elems",
+		.prepare = mmc_test_area_prepare,
+		.run = mmc_test_profile_sglen_wr_blocking_perf,
+		.cleanup = mmc_test_area_cleanup,
+	},
+
+	{
+		.name = "Write performance non-blocking req 1 to 512 sg elems",
+		.prepare = mmc_test_area_prepare,
+		.run = mmc_test_profile_sglen_wr_nonblock_perf,
+		.cleanup = mmc_test_area_cleanup,
+	},
+
+	{
+		.name = "Read performance blocking req 1 to 512 sg elems",
+		.prepare = mmc_test_area_prepare,
+		.run = mmc_test_profile_sglen_r_blocking_perf,
+		.cleanup = mmc_test_area_cleanup,
+	},
+
+	{
+		.name = "Read performance non-blocking req 1 to 512 sg elems",
+		.prepare = mmc_test_area_prepare,
+		.run = mmc_test_profile_sglen_r_nonblock_perf,
+		.cleanup = mmc_test_area_cleanup,
+	},
 };
 
 static DEFINE_MUTEX(mmc_test_lock);
-- 
1.7.4.1

