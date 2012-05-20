Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab2ETTpb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 15:45:31 -0400
Received: from 212.199.104.198.static.012.net.il ([212.199.104.198]:5522 "EHLO
	lx-merez.qi.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751609Ab2ETTp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 15:45:28 -0400
From: Maya Erez <merez@codeaurora.org>
To: linux-mmc@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Maya Erez <merez@codeaurora.org>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1 1/1] block: Add test-iosched scheduler
Date: Sun, 20 May 2012 22:40:31 +0300
Message-Id: <1337542832-19810-2-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1337542832-19810-1-git-send-email-merez@codeaurora.org>
References: <1337542832-19810-1-git-send-email-merez@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The test scheduler allows testing a block device by dispatching
specific requests according to the test case and declare PASS/FAIL
according to the requests completion error code

Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 Documentation/block/test-iosched.txt |   32 ++
 block/Kconfig.iosched                |    8 +
 block/Makefile                       |    1 +
 block/blk-core.c                     |    4 +-
 block/test-iosched.c                 |  966 ++++++++++++++++++++++++++++++++++
 5 files changed, 1010 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/block/test-iosched.txt
 create mode 100644 block/test-iosched.c

diff --git a/Documentation/block/test-iosched.txt b/Documentation/block/test-iosched.txt
new file mode 100644
index 0000000..b86eb8d
--- /dev/null
+++ b/Documentation/block/test-iosched.txt
@@ -0,0 +1,32 @@
+Test IO scheduler
+==================
+
+The test scheduler allows to test the a block device by dispatching
+specific requests according to the test case and declare PASS/FAIL
+according to the requests completion error code.
+
+Each test is exposed via debugfs and can be triggered by writing to
+the debugfs file. In order to add a new test one should expose a new debugfs
+file for the new test.
+
+The test IO scheduler includes the no-op scheduler operations, and uses
+them in order to dispatch the non-test requests when no test is running.
+This will allow to keep a normal FS operation in parallel to the test
+capability.
+The test IO sceduler keeps two different queues, one for non-test requests
+(inserted by the FS) and the other for test requests.
+The test IO scheduler chooses the queue for dispatch requests according to the
+test state (IDLE/RUNNING).
+
+the test IO scheduler is compiled by default as a dynamic module and enabled
+only if CONFIG_DEBUG_FS is defined.
+
+Selecting IO schedulers
+-----------------------
+Refer to Documentation/block/switching-sched.txt for information on
+selecting an io scheduler on a per-device basis.
+
+
+May 10 2012, maya Erez <merez@codeaurora.org>
+
+
diff --git a/block/Kconfig.iosched b/block/Kconfig.iosched
index 421bef9..34a1f9e 100644
--- a/block/Kconfig.iosched
+++ b/block/Kconfig.iosched
@@ -12,6 +12,14 @@ config IOSCHED_NOOP
 	  that do their own scheduling and require only minimal assistance from
 	  the kernel.
 
+config IOSCHED_TEST
+	tristate "Test I/O scheduler"
+	depends on DEBUG_FS
+	default m
+	---help---
+	  The test I/O scheduler is duplicate of the noop scheduler with
+	  test ability.
+
 config IOSCHED_DEADLINE
 	tristate "Deadline I/O scheduler"
 	default y
diff --git a/block/Makefile b/block/Makefile
index 39b76ba..436b220 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -15,6 +15,7 @@ obj-$(CONFIG_BLK_DEV_THROTTLING)	+= blk-throttle.o
 obj-$(CONFIG_IOSCHED_NOOP)	+= noop-iosched.o
 obj-$(CONFIG_IOSCHED_DEADLINE)	+= deadline-iosched.o
 obj-$(CONFIG_IOSCHED_CFQ)	+= cfq-iosched.o
+obj-$(CONFIG_IOSCHED_TEST)	+= test-iosched.o
 
 obj-$(CONFIG_BLOCK_COMPAT)	+= compat_ioctl.o
 obj-$(CONFIG_BLK_DEV_INTEGRITY)	+= blk-integrity.o
diff --git a/block/blk-core.c b/block/blk-core.c
index 3c923a7..a789a98 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1072,7 +1072,8 @@ struct request *blk_get_request(struct request_queue *q, int rw, gfp_t gfp_mask)
 {
 	struct request *rq;
 
-	BUG_ON(rw != READ && rw != WRITE);
+	if (unlikely(test_bit(QUEUE_FLAG_DEAD, &q->queue_flags)))
+		return NULL;
 
 	spin_lock_irq(q->queue_lock);
 	if (gfp_mask & __GFP_WAIT)
@@ -1406,6 +1407,7 @@ void init_request_from_bio(struct request *req, struct bio *bio)
 	req->ioprio = bio_prio(bio);
 	blk_rq_bio_prep(req->q, req, bio);
 }
+EXPORT_SYMBOL(init_request_from_bio);
 
 void blk_queue_bio(struct request_queue *q, struct bio *bio)
 {
diff --git a/block/test-iosched.c b/block/test-iosched.c
new file mode 100644
index 0000000..e856a51
--- /dev/null
+++ b/block/test-iosched.c
@@ -0,0 +1,966 @@
+
+/* Copyright (c) 2012, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * The test scheduler allows to test the block device by dispatching
+ * specific requests according to the test case and declare PASS/FAIL
+ * according to the requests completion error code.
+ * Each test is exposed via debugfs and can be triggered by writing to
+ * the debugfs file.
+ *
+ */
+
+/*
+ * elevator test iosched
+ */
+#include <linux/blkdev.h>
+#include <linux/elevator.h>
+#include <linux/bio.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/debugfs.h>
+#include "blk.h"
+
+#define MODULE_NAME "test-iosched"
+#define MAX_STR_SIZE	10
+#define BIO_U32_SIZE 1024
+#define TEST_PATTERN_SEQUENTIAL	-1
+#define TEST_PATTERN_5A		0x5A5A5A5A
+#define TEST_PATTERN_FF		0xFFFFFFFF
+#define TEST_NO_PATTERN		0xDEADBEEF
+#define WR_RD_START_REQ_ID 1234
+#define UNIQUE_START_REQ_ID 5678
+#define TIMEOUT_TIMER_MS 20000
+
+#define test_pr_debug(fmt, args...) pr_debug("%s: "fmt"\n", MODULE_NAME, args)
+#define test_pr_info(fmt, args...) pr_info("%s: "fmt"\n", MODULE_NAME, args)
+#define test_pr_err(fmt, args...) pr_err("%s: "fmt"\n", MODULE_NAME, args)
+
+enum test_results {
+	TEST_NO_RESULT,
+	TEST_FAILED,
+	TEST_PASSED,
+};
+
+enum test_testcases {
+	NO_TEST = 0,
+	/* An example test that sends write, read and flush requests */
+	TEST_WRITE_READ_FLUSH,
+};
+
+enum test_state {
+	TEST_IDLE,
+	TEST_RUNNING,
+	TEST_COMPLETED,
+};
+
+enum req_unique_type {
+	 REQ_UNIQUE_NONE,
+	/* REQ_DISCARD request */
+	 REQ_UNIQUE_DISCARD,
+	/* REQ_FLUSH request */
+	 REQ_UNIQUE_FLUSH,
+};
+
+struct test_debug {
+	struct dentry *debug_root;
+	struct dentry *debug_test_result;
+	struct dentry *write_read_flush_test;
+	struct dentry *start_sector;
+};
+
+struct test_request {
+	/* The test requests list */
+	struct list_head queuelist;
+	/* Write/read requests data buffer */
+	unsigned int *bios_buffer;
+	/* Write/read requests data buffer size (in bytes) */
+	int buf_size;
+	/* A block request, to be dispatched */
+	struct request *rq;
+	/* A flag to indicate if the request was completed */
+	bool req_completed;
+	/* Keeps the error code received in the request completion callback */
+	int req_result;
+	/*
+	 * A flag to indicate if the request should fail
+	 */
+	int is_err_expected;
+	/*
+	 * A pattern written to the write data buffer.
+	 * Can be used in read requests to verify the data
+	 */
+	int wr_rd_data_pattern;
+	/*
+	 * A unique ID to identify a test request to ease the debugging of
+	 * the test cases
+	 */
+	int req_id;
+};
+
+struct test_data {
+	/* The test IO scheduler requests list */
+	struct list_head queue;
+	/* The test requests list */
+	struct list_head test_queue;
+	/*
+	 * Points to the next request to be dispatched from the test requests
+	 * list
+	 */
+	struct test_request *next_req;
+	/* The current running test case */
+	int testcase;
+	/* A wait queue for waiting for the test requests completion */
+	wait_queue_head_t   wait_q;
+	/* Indicates if there is a running test. Used for dispatch function */
+	enum test_state test_state;
+	/* Indicates if the test passed or failed */
+	enum test_results test_result;
+	/* The test debugfs entries */
+	struct test_debug debug;
+	/* The block layer request queue */
+	struct request_queue *req_q;
+	/*
+	 * The number of write BIOs added to the test requests.
+	 * Used to calcualte the sector number of new BIOs.
+	 */
+	int num_of_write_bios;
+	/* The address of the first sector that can be accessed by the test */
+	u32 start_sector;
+	/*
+	 * A timer to verify test completion in case of non-completed
+	 * requests
+	 */
+	struct timer_list timeout_timer;
+	/*
+	 * A unique ID to identify WRITE/READ request to ease the debugging of
+	 * the test cases
+	 */
+	int wr_rd_next_req_id;
+
+	/*
+	 * A unique ID to identify FLUSH/DISCARD/SANITIZE request to ease the
+	 * debugging of the test cases
+	 */
+	int unique_next_req_id;
+};
+
+static struct test_data *ptd;
+
+/*
+ * Get the request after `test_rq' in the test requests list
+ */
+static struct test_request *
+latter_test_request(struct request_queue *q,
+				 struct test_request *test_rq)
+{
+	struct test_data *td = q->elevator->elevator_data;
+
+	if (test_rq->queuelist.next == &td->test_queue)
+		return NULL;
+	return list_entry(test_rq->queuelist.next, struct test_request,
+			  queuelist);
+}
+
+/*
+ * Check if all the queued test requests were completed.
+ */
+static void check_test_completion(void)
+{
+	struct test_request *test_rq;
+	struct request *rq;
+
+	list_for_each_entry(test_rq, &ptd->test_queue, queuelist) {
+		rq = test_rq->rq;
+		if (!test_rq->req_completed)
+			return;
+	}
+
+	test_pr_info("%s: Test is completed", __func__);
+	ptd->test_state = TEST_COMPLETED;
+	wake_up(&ptd->wait_q);
+}
+
+/*
+ * A callback to be called per bio completion.
+ * Frees the bio memory.
+ */
+static void end_test_bio(struct bio *bio, int err)
+{
+	if (err)
+		clear_bit(BIO_UPTODATE, &bio->bi_flags);
+
+	bio_put(bio);
+}
+
+/*
+ * A callback to be called per request completion.
+ * the request memory is not freed here, will be freed later after the test
+ * results checking.
+ */
+static void end_test_req(struct request *rq, int err)
+{
+	struct test_request *test_rq;
+
+	test_rq = (struct test_request *)rq->elv.priv[0];
+	BUG_ON(!test_rq);
+
+	test_pr_info("%s: request %d completed, err=%d",
+	       __func__, test_rq->req_id, err);
+
+	test_rq->req_completed = 1;
+	test_rq->req_result = err;
+
+	check_test_completion();
+}
+
+/*
+ * Create and queue a non read/write request (such as FLUSH/DISCRAD/SANITIZE).
+ */
+static int add_unique_test_req(struct test_data *td,
+				int is_err_expcted,
+				enum req_unique_type req_unique,
+				int start_sec, int nr_sects)
+{
+	struct bio *bio;
+	struct request *rq;
+	int rw_flags;
+	struct test_request *test_rq;
+
+	bio = bio_alloc(GFP_KERNEL, 0);
+	if (!bio) {
+		test_pr_err("%s: Failed to allocate a bio", __func__);
+		return -ENODEV;
+	}
+	bio_get(bio);
+	bio->bi_end_io = end_test_bio;
+
+	switch (req_unique) {
+	case REQ_UNIQUE_FLUSH:
+		bio->bi_rw = WRITE_FLUSH;
+		break;
+	case REQ_UNIQUE_DISCARD:
+		bio->bi_rw = REQ_WRITE | REQ_DISCARD;
+		bio->bi_size = nr_sects << 9;
+		bio->bi_sector = start_sec;
+		break;
+	default:
+		test_pr_err("%s: Invalid request type %d", __func__,
+			    req_unique);
+		bio_put(bio);
+		return -ENODEV;
+	}
+
+	rw_flags = bio_data_dir(bio);
+	if (bio->bi_rw & REQ_SYNC)
+		rw_flags |= REQ_SYNC;
+
+	rq = blk_get_request(td->req_q, rw_flags, GFP_KERNEL);
+	if (!rq) {
+		test_pr_err("%s: Failed to allocate a request", __func__);
+		bio_put(bio);
+		return -ENODEV;
+	}
+
+	init_request_from_bio(rq, bio);
+	rq->end_io = end_test_req;
+
+	test_rq = kzalloc(sizeof(struct test_request), GFP_KERNEL);
+	if (!test_rq) {
+		test_pr_err("%s: Failed to allocate a test request", __func__);
+		bio_put(bio);
+		blk_put_request(rq);
+		return -ENODEV;
+	}
+	test_rq->req_completed = 0;
+	test_rq->req_result = -1;
+	test_rq->rq = rq;
+	test_rq->is_err_expected = is_err_expcted;
+	rq->elv.priv[0] = (void *)test_rq;
+	test_rq->req_id = ++td->unique_next_req_id;
+
+	test_pr_info("%s: added request %d to the test requests "
+				"list, Request type = %d",
+				__func__, test_rq->req_id, req_unique);
+
+	list_add_tail(&test_rq->queuelist, &td->test_queue);
+
+	return 0;
+}
+
+/*
+ * Get a pattern to be filled in the request data buffer.
+ * If the pattern used is (-1) the buffer will be filled with sequential
+ * numbers
+ */
+static void fill_buf_with_pattern(int *buf, int num_bytes, int pattern)
+{
+	int i = 0;
+	int num_of_dwords = num_bytes/sizeof(int);
+
+	if (pattern == TEST_NO_PATTERN)
+		return;
+
+	/* num_bytes should be aligned to sizeof(int) */
+	BUG_ON((num_bytes % sizeof(int)) != 0);
+
+	if (pattern == TEST_PATTERN_SEQUENTIAL) {
+		for (i = 0; i < num_of_dwords; i++)
+			buf[i] = i;
+	} else {
+		for (i = 0; i < num_of_dwords; i++)
+			buf[i] = pattern;
+	}
+}
+
+/*
+ * Create and queue a read/write request.
+ * This function allocates the test request and the block request and calls
+ * blk_rq_map_kern which allocates the required BIO.
+ * The allocated test request and the block request memory is freed at the
+ * end of the test and the allocated BIO memory is freed by end_test_bio.
+ *
+ * In case of WRITE request, the given pattern is written into the data
+ * buffer. In case of READ request, the given pattern is kept as the expected
+ * pattern. The expected pattern will be compared in the test check result
+ * function.
+ * If no comparisson is required, set pattern to TEST_NO_PATTERN.
+ */
+static int add_wr_rd_test_req(struct test_data *td,
+			      int is_err_expcted,
+			      int direction, int start_sec,
+			      int num_bios, int pattern)
+{
+	struct request *rq = NULL;
+	struct test_request *test_rq = NULL;
+	int rw_flags = 0;
+	int buf_size = 0;
+	int ret = 0, i = 0;
+	unsigned int *bio_ptr = NULL;
+	struct bio *bio = NULL;
+
+	rw_flags = direction;
+
+	rq = blk_get_request(td->req_q, rw_flags, GFP_KERNEL);
+	if (!rq) {
+		test_pr_err("%s: Failed to allocate a request", __func__);
+		return -ENODEV;
+	}
+
+	test_rq = kzalloc(sizeof(struct test_request), GFP_KERNEL);
+	if (!test_rq) {
+		test_pr_err("%s: Failed to allocate test request", __func__);
+		blk_put_request(rq);
+		return -ENODEV;
+	}
+
+	buf_size = sizeof(unsigned int)*BIO_U32_SIZE*num_bios;
+	test_rq->bios_buffer = kzalloc(buf_size, GFP_KERNEL);
+	if (!test_rq->bios_buffer) {
+		test_pr_err("%s: Failed to allocate the data buf", __func__);
+		goto err;
+	}
+	test_rq->buf_size = buf_size;
+
+	if (direction == WRITE)
+		fill_buf_with_pattern(test_rq->bios_buffer,
+						   buf_size, pattern);
+	test_rq->wr_rd_data_pattern = pattern;
+
+	bio_ptr = test_rq->bios_buffer;
+	for (i = 0; i < num_bios; ++i) {
+		ret = blk_rq_map_kern(td->req_q, rq,
+				      (void *)bio_ptr,
+				      sizeof(unsigned int)*BIO_U32_SIZE,
+				      GFP_KERNEL);
+		if (ret) {
+			test_pr_err("%s: blk_rq_map_kern returned error %d",
+				    __func__, ret);
+			goto err;
+		}
+		bio_ptr += BIO_U32_SIZE;
+	}
+
+	rq->end_io = end_test_req;
+	rq->__sector = start_sec;
+	rq->cmd_type |= REQ_TYPE_FS;
+
+	if (rq->bio) {
+		rq->bio->bi_sector = start_sec;
+		rq->bio->bi_end_io = end_test_bio;
+		bio = rq->bio;
+		while ((bio = bio->bi_next) != NULL)
+			bio->bi_end_io = end_test_bio;
+	} else
+		test_pr_err("%s: NULL bio!!!!!", __func__);
+
+	td->num_of_write_bios += num_bios;
+	test_rq->req_id = ++td->wr_rd_next_req_id;
+
+	test_rq->req_completed = 0;
+	test_rq->req_result = -1;
+	test_rq->rq = rq;
+	test_rq->is_err_expected = is_err_expcted;
+	rq->elv.priv[0] = (void *)test_rq;
+
+	test_pr_info("%s: added request %d to the test requests list, "
+		     "buf_size=%d", __func__, test_rq->req_id, buf_size);
+
+	list_add_tail(&test_rq->queuelist, &td->test_queue);
+
+	return 0;
+err:
+	blk_put_request(rq);
+	kfree(test_rq->bios_buffer);
+	return -ENODEV;
+}
+
+/*
+ * Used by each test to add pass/fail checking that are specific to the test.
+ */
+static int check_testcase_result(struct test_data *td)
+{
+	switch (td->testcase) {
+	/* To be added by the specific tests per need */
+	default:
+		break;
+	}
+	return 0;
+}
+
+/*
+ * Verify that the test request data buffer includes the expected
+ * pattern.
+ */
+static int compare_buffer_to_pattern(struct test_request *test_rq)
+{
+	int i = 0;
+	int num_of_dwords = test_rq->buf_size/sizeof(int);
+
+	/* num_bytes should be aligned to sizeof(int) */
+	BUG_ON((test_rq->buf_size % sizeof(int)) != 0);
+	BUG_ON(test_rq->bios_buffer == NULL);
+
+	if (test_rq->wr_rd_data_pattern == TEST_NO_PATTERN)
+		return 0;
+
+	if (test_rq->wr_rd_data_pattern == TEST_PATTERN_SEQUENTIAL) {
+		for (i = 0; i < num_of_dwords; i++) {
+			if (test_rq->bios_buffer[i] != i) {
+				test_pr_err("%s: expected "
+					"pattern (0x%x) != read pattern (0x%x)"
+					" in index %d", __func__,
+				       test_rq->wr_rd_data_pattern,
+				       test_rq->bios_buffer[i], i);
+				return -EINVAL;
+			}
+		}
+	} else {
+		for (i = 0; i < num_of_dwords; i++) {
+			if (test_rq->bios_buffer[i] !=
+			    test_rq->wr_rd_data_pattern) {
+				test_pr_err("%s: expected "
+					"pattern (0x%x) != read pattern (0x%x)"
+					" in index %d", __func__,
+				       test_rq->wr_rd_data_pattern,
+				       test_rq->bios_buffer[i], i);
+				return -EINVAL;
+			}
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * Determine if the test passed or failed.
+ * The function checks the test request completion value and calls
+ * check_testcase_result for result checking that are specific
+ * to a test case.
+ */
+static void check_test_result(struct test_data *td)
+{
+	struct test_request *test_rq;
+	struct request *rq;
+	int res = 0;
+
+	list_for_each_entry(test_rq, &ptd->test_queue, queuelist) {
+		rq = test_rq->rq;
+		if (!test_rq->req_completed) {
+			test_pr_err("%s: rq %d not completed, "
+				"Test FAILED", __func__, test_rq->req_id);
+			td->test_result = TEST_FAILED;
+			return;
+		}
+
+		if ((test_rq->req_result < 0) && !test_rq->is_err_expected) {
+			test_pr_err("%s: rq %d completed with err, not as "
+				    "expected, Test FAILED", __func__,
+				    test_rq->req_id);
+			td->test_result = TEST_FAILED;
+			return;
+		}
+		if ((test_rq->req_result == 0) && test_rq->is_err_expected) {
+			test_pr_err("%s: rq %d succeeded, not as expected, "
+				"Test FAILED", __func__, test_rq->req_id);
+			td->test_result = TEST_FAILED;
+			return;
+		}
+		if (rq_data_dir(test_rq->rq) == READ) {
+			res = compare_buffer_to_pattern(test_rq);
+			if (res) {
+				test_pr_err("%s: read request %d"
+				"pattern not as expected 0x%x, Test FAILED",
+				       __func__, test_rq->req_id,
+				       test_rq->wr_rd_data_pattern);
+				td->test_result = TEST_FAILED;
+				return;
+			}
+		}
+	}
+
+	if (check_testcase_result(td)) {
+		test_pr_err("%s: Test FAILED", __func__);
+		td->test_result = TEST_FAILED;
+		return;
+	}
+
+	test_pr_info("%s: Test PASSED", __func__);
+	td->test_result = TEST_PASSED;
+}
+
+/*
+ * Create and queue the required requests for the write_read_flush test.
+ */
+static int prepare_write_read_flush(struct test_data *td)
+{
+	int ret = 0;
+
+	ret = add_wr_rd_test_req(td, 0, WRITE, td->start_sector,
+				   3, TEST_PATTERN_5A);
+	if (ret) {
+		test_pr_err("%s: failed to add a write request", __func__);
+		return ret;
+	}
+	ret = add_wr_rd_test_req(td, 0, READ, td->start_sector, 3,
+				   TEST_PATTERN_5A);
+	if (ret) {
+		test_pr_err("%s: failed to add a read request", __func__);
+		return ret;
+	}
+	ret = add_unique_test_req(td, 0, REQ_UNIQUE_FLUSH,
+				   td->start_sector, 0);
+	if (ret) {
+		test_pr_err("%s: failed to add a flush request", __func__);
+		return ret;
+	}
+	return 0;
+}
+
+/*
+ * Create and queue the required requests according to the test case.
+ */
+static int prepare_test(struct test_data *td)
+{
+	switch (td->testcase) {
+	case  TEST_WRITE_READ_FLUSH:
+		return prepare_write_read_flush(td);
+		break;
+	default:
+		test_pr_info("%s: Invalid test case...", __func__);
+		break;
+	}
+	return 0;
+}
+
+/*
+ * Free the allocated test requests, their requests and BIOs buffer.
+ */
+static void free_test_requests(struct test_data *td)
+{
+	struct test_request *test_rq;
+	while (!list_empty(&td->test_queue)) {
+		test_rq = list_entry(td->test_queue.next, struct test_request,
+				     queuelist);
+		list_del_init(&test_rq->queuelist);
+		blk_put_request(test_rq->rq);
+		kfree(test_rq->bios_buffer);
+		kfree(test_rq);
+	}
+}
+
+/*
+ * The timer verifies that the test will be completed even if we don't get
+ * the completion callback for all the requests.
+ */
+static void test_timeout_handler(unsigned long data)
+{
+	struct test_data *td = (struct test_data *)data;
+
+	test_pr_info("%s: TIMEOUT timer expired", __func__);
+	td->test_state = TEST_COMPLETED;
+	wake_up(&td->wait_q);
+	return;
+}
+
+/*
+ * The main function that prepares and runs the test. The function also checks
+ * the test result upon test completion.
+ */
+static int start_test(struct test_data *td)
+{
+	int ret = 0;
+
+	test_pr_info("%s: : ------------------ Starting testcase %d"
+				"------------------\n", __func__, td->testcase);
+
+	td->next_req = NULL;
+	td->test_result = TEST_NO_RESULT;
+	td->num_of_write_bios = 0;
+
+	td->unique_next_req_id = UNIQUE_START_REQ_ID;
+	td->wr_rd_next_req_id = WR_RD_START_REQ_ID;
+
+	td->test_state = TEST_RUNNING;
+
+	ret = prepare_test(td);
+	if (ret) {
+		test_pr_err("%s: failed to prepare the test\n", __func__);
+		td->test_result = TEST_FAILED;
+		td->testcase = NO_TEST;
+		free_test_requests(td);
+		return ret;
+	}
+
+	mod_timer(&td->timeout_timer, jiffies +
+		msecs_to_jiffies(TIMEOUT_TIMER_MS));
+
+	/*
+	 * Set the next_req pointer to the first request in the test requests
+	 * list
+	 */
+	td->next_req = list_entry(td->test_queue.next, struct test_request,
+			      queuelist);
+
+	__blk_run_queue(td->req_q);
+
+	test_pr_info("%s: Waiting for the test completion", __func__);
+
+	wait_event(td->wait_q, td->test_state == TEST_COMPLETED);
+	del_timer_sync(&td->timeout_timer);
+
+	check_test_result(td);
+
+	td->testcase = NO_TEST;
+	td->test_state = TEST_IDLE;
+
+	free_test_requests(td);
+
+	/*
+	 * Wakeup the queue thread to fetch FS requests that might got
+	 * postponded due to the test
+	 */
+	__blk_run_queue(td->req_q);
+
+	if (td->test_result == TEST_PASSED)
+		return 0;
+	else
+		return -EINVAL;
+}
+
+static bool message_repeat;
+static int test_open(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+	message_repeat = 1;
+	return 0;
+}
+
+/* write_read_flush TEST - An example test scenario. */
+static ssize_t write_read_flush_test_write(struct file *file,
+				const char __user *buf,
+				size_t count,
+				loff_t *ppos)
+{
+	int ret = 0;
+	int i = 0;
+	int number = -1;
+
+	test_pr_info("%s: -- write_read_flush TEST --", __func__);
+
+	if (ptd->start_sector == 0) {
+		test_pr_err("%s: Invalid start sector\n. "
+			"User should set the start sector before running the "
+			"test using this command:\n"
+			"echo <START_SECTOR> > "
+			"/<path-to-debugfs>/test-iosched/start_sector",
+		       __func__);
+		ptd->test_result = TEST_FAILED;
+		return count;
+	}
+
+	sscanf(buf, "%d", &number);
+
+	if (number < 0) {
+		test_pr_err("%s: failed to extract number %d", __func__,
+			    number);
+		ptd->test_result = TEST_FAILED;
+		return count;
+	}
+
+	for (i = 0; i < number; ++i) {
+		test_pr_info("%s: Cycle # %d / %d", __func__, i+1, number);
+		test_pr_info("%s: ===================", __func__);
+
+
+		ptd->testcase = TEST_WRITE_READ_FLUSH;
+		ret = start_test(ptd);
+		if (ret)
+			break;
+	}
+
+	return count;
+}
+
+static ssize_t write_read_flush_test_read(struct file *file,
+			       char __user *buffer,
+			       size_t count,
+			       loff_t *offset)
+{
+	memset((void *)buffer, 0, count);
+
+	snprintf(buffer, count,
+		 "\nwrite_read_flush_test\n========================\n"
+		 "Description:\nThis is an example test."
+		 "This test sends a write request followed by a read request\n"
+		 "and verifies the read data.\n"
+		 "The test also checks a flush request\n");
+
+	if (message_repeat == 1) {
+		message_repeat = 0;
+		return strnlen(buffer, count);
+	}
+
+	return 0;
+}
+
+const struct file_operations write_read_flush_test_ops = {
+	.open = test_open,
+	.write = write_read_flush_test_write,
+	.read = write_read_flush_test_read,
+};
+
+static int test_debugfs_init(struct test_data *td)
+{
+	td->debug.debug_root = debugfs_create_dir("test-iosched", NULL);
+	if (!td->debug.debug_root)
+		return -ENOENT;
+
+	td->debug.debug_test_result = debugfs_create_u32(
+					"test_result",
+					S_IRUGO | S_IWUGO,
+					td->debug.debug_root,
+					&td->test_result);
+
+	td->debug.write_read_flush_test =
+		debugfs_create_file("write_read_flush_test",
+				    S_IRUGO | S_IWUGO,
+				    td->debug.debug_root,
+				    NULL,
+				    &write_read_flush_test_ops);
+
+	td->debug.start_sector = debugfs_create_u32(
+					"start_sector",
+					S_IRUGO | S_IWUGO,
+					td->debug.debug_root,
+					&td->start_sector);
+
+	return 0;
+}
+
+static void test_debugfs_cleanup(struct test_data *td)
+{
+	debugfs_remove(td->debug.debug_test_result);
+	debugfs_remove(td->debug.write_read_flush_test);
+	debugfs_remove(td->debug.start_sector);
+	debugfs_remove(td->debug.debug_root);
+}
+
+static void print_req(struct request *req)
+{
+	struct bio *bio;
+	struct test_request *test_rq;
+
+	if (!req)
+		return;
+
+	test_rq = (struct test_request *)req->elv.priv[0];
+
+	if (test_rq) {
+		test_pr_debug("%s: Dispatch request %d: "
+			"__data_len=0x%x, __sector=0x%lx, atomic_flags=0x%lx, "
+		       "cmd_flags=0x%x, cmd_len=0x%x, cmd_type=0x%x, "
+		       "nr_phys_segments=%d, num_of_sectors=%d",
+		       __func__, test_rq->req_id, req->__data_len,
+		       (unsigned long)req->__sector,
+		       req->atomic_flags, req->cmd_flags, req->cmd_len,
+		       req->cmd_type,  req->nr_phys_segments,
+		       blk_rq_sectors(req));
+		bio = req->bio;
+		test_pr_debug("%s: bio: bi_size=%d, "
+				"bi_sector=0x%lx", __func__, bio->bi_size,
+				(unsigned long)bio->bi_sector);
+		while ((bio = bio->bi_next) != NULL) {
+			test_pr_debug("%s: bio: bi_size=%d, "
+				"bi_sector=0x%lx", __func__, bio->bi_size,
+			       (unsigned long)bio->bi_sector);
+		}
+	}
+}
+
+static void test_merged_requests(struct request_queue *q,
+			 struct request *rq, struct request *next)
+{
+	list_del_init(&next->queuelist);
+}
+
+/*
+ * Dispatch a test request in case there is a running test Otherwise, dispatch
+ * a request that was queued by the FS to keep the card functional.
+ */
+static int test_dispatch_requests(struct request_queue *q, int force)
+{
+	struct test_data *td = q->elevator->elevator_data;
+	struct request *rq = NULL;
+
+	switch (td->test_state) {
+	case TEST_IDLE:
+		if (!list_empty(&td->queue)) {
+			rq = list_entry(td->queue.next, struct request,
+					queuelist);
+			list_del_init(&rq->queuelist);
+			elv_dispatch_sort(q, rq);
+			return 1;
+		}
+		break;
+	case TEST_RUNNING:
+		if (td->next_req) {
+			rq = td->next_req->rq;
+			td->next_req =
+				latter_test_request(td->req_q, td->next_req);
+			if (!rq)
+				return 0;
+			print_req(rq);
+			elv_dispatch_sort(q, rq);
+			return 1;
+		}
+		break;
+	case TEST_COMPLETED:
+	default:
+		return 0;
+	}
+
+	return 0;
+}
+
+static void test_add_request(struct request_queue *q,
+				     struct request *rq)
+{
+	struct test_data *td = q->elevator->elevator_data;
+
+	list_add_tail(&rq->queuelist, &td->queue);
+}
+
+static struct request *
+test_former_request(struct request_queue *q, struct request *rq)
+{
+	struct test_data *td = q->elevator->elevator_data;
+
+	if (rq->queuelist.prev == &td->queue)
+		return NULL;
+	return list_entry(rq->queuelist.prev, struct request, queuelist);
+}
+
+static struct request *
+test_latter_request(struct request_queue *q, struct request *rq)
+{
+	struct test_data *td = q->elevator->elevator_data;
+
+	if (rq->queuelist.next == &td->queue)
+		return NULL;
+	return list_entry(rq->queuelist.next, struct request, queuelist);
+}
+
+static int test_init_queue(struct request_queue *q)
+{
+	ptd = kmalloc_node(sizeof(struct test_data), GFP_KERNEL,
+			     q->node);
+	if (!ptd)
+		return -ENODEV;
+
+	memset((void *)ptd, 0, sizeof(struct test_data));
+	INIT_LIST_HEAD(&ptd->queue);
+	INIT_LIST_HEAD(&ptd->test_queue);
+	init_waitqueue_head(&ptd->wait_q);
+	ptd->req_q = q;
+	q->elevator->elevator_data = ptd;
+
+	setup_timer(&ptd->timeout_timer, test_timeout_handler,
+		    (unsigned long)ptd);
+
+	test_debugfs_init(ptd);
+
+	return 0;
+}
+
+static void test_exit_queue(struct elevator_queue *e)
+{
+	struct test_data *td = e->elevator_data;
+
+	BUG_ON(!list_empty(&td->queue));
+
+	test_debugfs_cleanup(td);
+
+	kfree(td);
+}
+
+static struct elevator_type elevator_test_iosched = {
+	.ops = {
+		.elevator_merge_req_fn = test_merged_requests,
+		.elevator_dispatch_fn = test_dispatch_requests,
+		.elevator_add_req_fn = test_add_request,
+		.elevator_former_req_fn = test_former_request,
+		.elevator_latter_req_fn = test_latter_request,
+		.elevator_init_fn = test_init_queue,
+		.elevator_exit_fn = test_exit_queue,
+	},
+	.elevator_name = "test-iosched",
+	.elevator_owner = THIS_MODULE,
+};
+
+static int __init test_init(void)
+{
+	elv_register(&elevator_test_iosched);
+
+	return 0;
+}
+
+static void __exit test_exit(void)
+{
+	elv_unregister(&elevator_test_iosched);
+}
+
+module_init(test_init);
+module_exit(test_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Test IO scheduler");
-- 
1.7.3.3
-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

