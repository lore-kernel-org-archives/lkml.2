Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab1EYV63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 17:58:29 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:55562 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932584Ab1EYV60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 17:58:26 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        David Vrabel <david.vrabel@csr.com>
Cc: Chris Ball <cjb@laptop.org>, Per Forlin <per.forlin@linaro.org>
Subject: [PATCH v4 06/12] mmc: mmc_test: add test for none blocking transfers
Date: Wed, 25 May 2011 23:57:27 +0200
Message-Id: <1306360653-6196-7-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1306360653-6196-1-git-send-email-per.forlin@linaro.org>
References: <1306360653-6196-1-git-send-email-per.forlin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add four tests for read and write performance per
different transfer size, 4k to 4M.
 * Read using blocking mmc request
 * Read using none blocking mmc request
 * Write using blocking mmc request
 * Write using none blocking mmc request

The host dirver must support pre_req() and post_req()
in order to run the none blocking test cases.

Signed-off-by: Per Forlin <per.forlin@linaro.org>
---
 drivers/mmc/card/mmc_test.c |  322 +++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 313 insertions(+), 9 deletions(-)

diff --git a/drivers/mmc/card/mmc_test.c b/drivers/mmc/card/mmc_test.c
index 1853ebf..4b9cb5f 100644
--- a/drivers/mmc/card/mmc_test.c
+++ b/drivers/mmc/card/mmc_test.c
@@ -22,6 +22,7 @@
 #include <linux/debugfs.h>
 #include <linux/uaccess.h>
 #include <linux/seq_file.h>
+#include <linux/random.h>
 
 #define RESULT_OK		0
 #define RESULT_FAIL		1
@@ -51,10 +52,12 @@ struct mmc_test_pages {
  * struct mmc_test_mem - allocated memory.
  * @arr: array of allocations
  * @cnt: number of allocations
+ * @size_min_cmn: lowest common size in array of allocations
  */
 struct mmc_test_mem {
 	struct mmc_test_pages *arr;
 	unsigned int cnt;
+	unsigned int size_min_cmn;
 };
 
 /**
@@ -148,6 +151,26 @@ struct mmc_test_card {
 	struct mmc_test_general_result	*gr;
 };
 
+enum mmc_test_prep_media {
+	MMC_TEST_PREP_NONE = 0,
+	MMC_TEST_PREP_WRITE_FULL = 1 << 0,
+	MMC_TEST_PREP_ERASE = 1 << 1,
+};
+
+struct mmc_test_multiple_rw {
+	unsigned int *bs;
+	unsigned int len;
+	unsigned int size;
+	bool do_write;
+	bool do_nonblock_req;
+	enum mmc_test_prep_media prepare;
+};
+
+struct mmc_test_async_req {
+	struct mmc_async_req areq;
+	struct mmc_test_card *test;
+};
+
 /*******************************************************************/
 /*  General helper functions                                       */
 /*******************************************************************/
@@ -307,6 +330,7 @@ static struct mmc_test_mem *mmc_test_alloc_mem(unsigned long min_sz,
 	unsigned long max_seg_page_cnt = DIV_ROUND_UP(max_seg_sz, PAGE_SIZE);
 	unsigned long page_cnt = 0;
 	unsigned long limit = nr_free_buffer_pages() >> 4;
+	unsigned int min_cmn = 0;
 	struct mmc_test_mem *mem;
 
 	if (max_page_cnt > limit)
@@ -350,6 +374,12 @@ static struct mmc_test_mem *mmc_test_alloc_mem(unsigned long min_sz,
 		mem->arr[mem->cnt].page = page;
 		mem->arr[mem->cnt].order = order;
 		mem->cnt += 1;
+		if (!min_cmn)
+			min_cmn = PAGE_SIZE << order;
+		else
+			min_cmn = min(min_cmn,
+				      (unsigned int) (PAGE_SIZE << order));
+
 		if (max_page_cnt <= (1UL << order))
 			break;
 		max_page_cnt -= 1UL << order;
@@ -360,6 +390,7 @@ static struct mmc_test_mem *mmc_test_alloc_mem(unsigned long min_sz,
 			break;
 		}
 	}
+	mem->size_min_cmn = min_cmn;
 
 	return mem;
 
@@ -386,7 +417,6 @@ static int mmc_test_map_sg(struct mmc_test_mem *mem, unsigned long sz,
 	do {
 		for (i = 0; i < mem->cnt; i++) {
 			unsigned long len = PAGE_SIZE << mem->arr[i].order;
-
 			if (len > sz)
 				len = sz;
 			if (len > max_seg_sz)
@@ -666,7 +696,7 @@ static void mmc_test_prepare_broken_mrq(struct mmc_test_card *test,
  * Checks that a normal transfer didn't have any errors
  */
 static int mmc_test_check_result(struct mmc_test_card *test,
-	struct mmc_request *mrq)
+				 struct mmc_request *mrq)
 {
 	int ret;
 
@@ -690,6 +720,16 @@ static int mmc_test_check_result(struct mmc_test_card *test,
 	return ret;
 }
 
+
+static int mmc_test_check_result_async(struct mmc_card *card,
+				       struct mmc_async_req *areq)
+{
+	struct mmc_test_async_req *test_async =
+		container_of(areq, struct mmc_test_async_req, areq);
+
+	return mmc_test_check_result(test_async->test, areq->mrq);
+}
+
 /*
  * Checks that a "short transfer" behaved as expected
  */
@@ -725,6 +765,89 @@ static int mmc_test_check_broken_result(struct mmc_test_card *test,
 }
 
 /*
+ * Tests nonblock transfer with certain parameters
+ */
+static void mmc_test_nonblock_reset(struct mmc_request *mrq,
+				    struct mmc_command *cmd,
+				    struct mmc_command *stop,
+				    struct mmc_data *data)
+{
+	memset(mrq, 0, sizeof(struct mmc_request));
+	memset(cmd, 0, sizeof(struct mmc_command));
+	memset(data, 0, sizeof(struct mmc_data));
+	memset(stop, 0, sizeof(struct mmc_command));
+
+	mrq->cmd = cmd;
+	mrq->data = data;
+	mrq->stop = stop;
+}
+static int mmc_test_nonblock_transfer(struct mmc_test_card *test,
+				      struct scatterlist *sg, unsigned sg_len,
+				      unsigned dev_addr, unsigned blocks,
+				      unsigned blksz, int write, int count)
+{
+	struct mmc_request mrq1;
+	struct mmc_command cmd1;
+	struct mmc_command stop1;
+	struct mmc_data data1;
+
+	struct mmc_request mrq2;
+	struct mmc_command cmd2;
+	struct mmc_command stop2;
+	struct mmc_data data2;
+
+	struct mmc_test_async_req test_areq[2];
+	struct mmc_async_req *done_areq;
+	struct mmc_async_req *cur_areq = &test_areq[0].areq;
+	struct mmc_async_req *other_areq = &test_areq[1].areq;
+	int i;
+	int ret;
+
+	test_areq[0].test = test;
+	test_areq[1].test = test;
+
+	if (!test->card->host->ops->pre_req ||
+		!test->card->host->ops->post_req)
+		return -RESULT_UNSUP_HOST;
+
+	mmc_test_nonblock_reset(&mrq1, &cmd1, &stop1, &data1);
+	mmc_test_nonblock_reset(&mrq2, &cmd2, &stop2, &data2);
+
+	cur_areq->mrq = &mrq1;
+	cur_areq->err_check = mmc_test_check_result_async;
+	other_areq->mrq = &mrq2;
+	other_areq->err_check = mmc_test_check_result_async;
+
+	for (i = 0; i < count; i++) {
+		mmc_test_prepare_mrq(test, cur_areq->mrq, sg, sg_len, dev_addr,
+				     blocks, blksz, write);
+		done_areq = mmc_start_req(test->card->host, cur_areq, &ret);
+
+		if (ret || (!done_areq && i > 0))
+			goto err;
+
+		if (done_areq) {
+			if (done_areq->mrq == &mrq2)
+				mmc_test_nonblock_reset(&mrq2, &cmd2,
+							&stop2, &data2);
+			else
+				mmc_test_nonblock_reset(&mrq1, &cmd1,
+							&stop1, &data1);
+		}
+		done_areq = cur_areq;
+		cur_areq = other_areq;
+		other_areq = done_areq;
+		dev_addr += blocks;
+	}
+
+	done_areq = mmc_start_req(test->card->host, NULL, &ret);
+
+	return ret;
+err:
+	return ret;
+}
+
+/*
  * Tests a basic transfer with certain parameters
  */
 static int mmc_test_simple_transfer(struct mmc_test_card *test,
@@ -1351,14 +1474,17 @@ static int mmc_test_area_transfer(struct mmc_test_card *test,
 }
 
 /*
- * Map and transfer bytes.
+ * Map and transfer bytes for multiple transfers.
  */
-static int mmc_test_area_io(struct mmc_test_card *test, unsigned long sz,
-			    unsigned int dev_addr, int write, int max_scatter,
-			    int timed)
+static int mmc_test_area_io_seq(struct mmc_test_card *test, unsigned long sz,
+				unsigned int dev_addr, int write,
+				int max_scatter, int timed, int count,
+				bool nonblock)
 {
 	struct timespec ts1, ts2;
-	int ret;
+	int ret = 0;
+	int i;
+	struct mmc_test_area *t = &test->area;
 
 	/*
 	 * In the case of a maximally scattered transfer, the maximum transfer
@@ -1382,8 +1508,15 @@ static int mmc_test_area_io(struct mmc_test_card *test, unsigned long sz,
 
 	if (timed)
 		getnstimeofday(&ts1);
+	if (nonblock)
+		ret = mmc_test_nonblock_transfer(test, t->sg, t->sg_len,
+				 dev_addr, t->blocks, 512, write, count);
+	else
+		for (i = 0; i < count && ret == 0; i++) {
+			ret = mmc_test_area_transfer(test, dev_addr, write);
+			dev_addr += sz >> 9;
+		}
 
-	ret = mmc_test_area_transfer(test, dev_addr, write);
 	if (ret)
 		return ret;
 
@@ -1391,11 +1524,19 @@ static int mmc_test_area_io(struct mmc_test_card *test, unsigned long sz,
 		getnstimeofday(&ts2);
 
 	if (timed)
-		mmc_test_print_rate(test, sz, &ts1, &ts2);
+		mmc_test_print_avg_rate(test, sz, count, &ts1, &ts2);
 
 	return 0;
 }
 
+static int mmc_test_area_io(struct mmc_test_card *test, unsigned long sz,
+			    unsigned int dev_addr, int write, int max_scatter,
+			    int timed)
+{
+	return mmc_test_area_io_seq(test, sz, dev_addr, write, max_scatter,
+				    timed, 1, false);
+}
+
 /*
  * Write the test area entirely.
  */
@@ -1956,6 +2097,142 @@ static int mmc_test_large_seq_write_perf(struct mmc_test_card *test)
 	return mmc_test_large_seq_perf(test, 1);
 }
 
+static int mmc_test_rw_multiple(struct mmc_test_card *test,
+				struct mmc_test_multiple_rw *tdata,
+				unsigned int reqsize, unsigned int size)
+{
+	unsigned int dev_addr;
+	struct mmc_test_area *t = &test->area;
+	int ret = 0;
+
+	/* Set up test area */
+	if (size > mmc_test_capacity(test->card) / 2 * 512)
+		size = mmc_test_capacity(test->card) / 2 * 512;
+	if (reqsize > t->max_tfr)
+		reqsize = t->max_tfr;
+	dev_addr = mmc_test_capacity(test->card) / 4;
+	if ((dev_addr & 0xffff0000))
+		dev_addr &= 0xffff0000; /* Round to 64MiB boundary */
+	else
+		dev_addr &= 0xfffff800; /* Round to 1MiB boundary */
+	if (!dev_addr)
+		goto err;
+
+	/* prepare test area */
+	if (mmc_can_erase(test->card) &&
+	    tdata->prepare & MMC_TEST_PREP_ERASE) {
+		ret = mmc_erase(test->card, dev_addr,
+				size / 512, MMC_SECURE_ERASE_ARG);
+		if (ret)
+			ret = mmc_erase(test->card, dev_addr,
+					size / 512, MMC_ERASE_ARG);
+		if (ret)
+			goto err;
+	}
+
+	/* Run test */
+	ret = mmc_test_area_io_seq(test, reqsize, dev_addr,
+				   tdata->do_write, 0, 1, size / reqsize,
+				   tdata->do_nonblock_req);
+	if (ret)
+		goto err;
+
+	return ret;
+ err:
+	printk(KERN_INFO "[%s] error\n", __func__);
+	return ret;
+}
+
+static int mmc_test_rw_multiple_size(struct mmc_test_card *test,
+				     struct mmc_test_multiple_rw *rw)
+{
+	int ret = 0;
+	int i;
+
+	for (i = 0 ; i < rw->len && ret == 0; i++) {
+		ret = mmc_test_rw_multiple(test, rw, rw->bs[i], rw->size);
+		if (ret)
+			break;
+	}
+	return ret;
+}
+
+/*
+ * Multiple blocking write 4k to 4 MB chunks
+ */
+static int mmc_test_profile_mult_write_blocking_perf(struct mmc_test_card *test)
+{
+	unsigned int bs[] = {1 << 12, 1 << 13, 1 << 14, 1 << 15, 1 << 16,
+			     1 << 17, 1 << 18, 1 << 19, 1 << 20, 1 << 22};
+	struct mmc_test_multiple_rw test_data = {
+		.bs = bs,
+		.size = 128*1024*1024,
+		.len = ARRAY_SIZE(bs),
+		.do_write = true,
+		.do_nonblock_req = false,
+		.prepare = MMC_TEST_PREP_ERASE,
+	};
+
+	return mmc_test_rw_multiple_size(test, &test_data);
+};
+
+/*
+ * Multiple none blocking write 4k to 4 MB chunks
+ */
+static int mmc_test_profile_mult_write_nonblock_perf(struct mmc_test_card *test)
+{
+	unsigned int bs[] = {1 << 12, 1 << 13, 1 << 14, 1 << 15, 1 << 16,
+			     1 << 17, 1 << 18, 1 << 19, 1 << 20, 1 << 22};
+	struct mmc_test_multiple_rw test_data = {
+		.bs = bs,
+		.size = 128*1024*1024,
+		.len = ARRAY_SIZE(bs),
+		.do_write = true,
+		.do_nonblock_req = true,
+		.prepare = MMC_TEST_PREP_ERASE,
+	};
+
+	return mmc_test_rw_multiple_size(test, &test_data);
+}
+
+/*
+ * Multiple blocking read 4k to 4 MB chunks
+ */
+static int mmc_test_profile_mult_read_blocking_perf(struct mmc_test_card *test)
+{
+	unsigned int bs[] = {1 << 12, 1 << 13, 1 << 14, 1 << 15, 1 << 16,
+			     1 << 17, 1 << 18, 1 << 19, 1 << 20, 1 << 22};
+	struct mmc_test_multiple_rw test_data = {
+		.bs = bs,
+		.size = 128*1024*1024,
+		.len = ARRAY_SIZE(bs),
+		.do_write = false,
+		.do_nonblock_req = false,
+		.prepare = MMC_TEST_PREP_NONE,
+	};
+
+	return mmc_test_rw_multiple_size(test, &test_data);
+}
+
+/*
+ * Multiple none blocking read 4k to 4 MB chunks
+ */
+static int mmc_test_profile_mult_read_nonblock_perf(struct mmc_test_card *test)
+{
+	unsigned int bs[] = {1 << 12, 1 << 13, 1 << 14, 1 << 15, 1 << 16,
+			     1 << 17, 1 << 18, 1 << 19, 1 << 20, 1 << 22};
+	struct mmc_test_multiple_rw test_data = {
+		.bs = bs,
+		.size = 128*1024*1024,
+		.len = ARRAY_SIZE(bs),
+		.do_write = false,
+		.do_nonblock_req = true,
+		.prepare = MMC_TEST_PREP_NONE,
+	};
+
+	return mmc_test_rw_multiple_size(test, &test_data);
+}
+
 static const struct mmc_test_case mmc_test_cases[] = {
 	{
 		.name = "Basic write (no data verification)",
@@ -2223,6 +2500,33 @@ static const struct mmc_test_case mmc_test_cases[] = {
 		.cleanup = mmc_test_area_cleanup,
 	},
 
+	{
+		.name = "Write performance with blocking req 4k to 4MB",
+		.prepare = mmc_test_area_prepare,
+		.run = mmc_test_profile_mult_write_blocking_perf,
+		.cleanup = mmc_test_area_cleanup,
+	},
+
+	{
+		.name = "Write performance with none blocking req 4k to 4MB",
+		.prepare = mmc_test_area_prepare,
+		.run = mmc_test_profile_mult_write_nonblock_perf,
+		.cleanup = mmc_test_area_cleanup,
+	},
+
+	{
+		.name = "Read performance with blocking req 4k to 4MB",
+		.prepare = mmc_test_area_prepare,
+		.run = mmc_test_profile_mult_read_blocking_perf,
+		.cleanup = mmc_test_area_cleanup,
+	},
+
+	{
+		.name = "Read performance with none blocking req 4k to 4MB",
+		.prepare = mmc_test_area_prepare,
+		.run = mmc_test_profile_mult_read_nonblock_perf,
+		.cleanup = mmc_test_area_cleanup,
+	},
 };
 
 static DEFINE_MUTEX(mmc_test_lock);
-- 
1.7.4.1

