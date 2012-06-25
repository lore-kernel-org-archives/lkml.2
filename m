Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab2FYKUE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 06:20:04 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:29633 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab2FYKUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 06:20:01 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6752"; a="201841965"
From: Lee Susman <lsusman@codeaurora.org>
To: linux-mmc@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Lee Susman <lsusman@codeaurora.org>,
        Maya Erez <merez@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] block: Add eMMC4.5 packing control unit-tests
Date: Mon, 25 Jun 2012 13:19:18 +0300
Message-Id: <1340619582-8908-1-git-send-email-lsusman@codeaurora.org>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expose the packing control test.
Test the packing control feature under these scenarios:
- Packing expected: entering write packing state, staying in write packing state
- Packing not expected: not entering write packing state when not supposed to
- Mixed states: test the ability to shift from packing to no-packing and back, and the opposite.

Signed-off-by: Lee Susman <lsusman@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
This patch is dependant on the following patches:
  [PATCH RESEND v7 1/3] mmc: core: Add packed command feature of eMMC4.5
  [PATCH RESEND v7 2/3] mmc: core: Support packed write command for eMMC4.5 device
  [PATCH v2 1/3] mmc: block: Add MMC write packing statistics
  [PATCH v2 2/3] block: Add test-iosched scheduler
  [PATCH v2 3/3] block: Add eMMC4.5 write packed commands unit-tests
  [PATCH v2 1/1] mmc: block: Add write packing control
---
drivers/mmc/card/mmc_block_test.c |  388 +++++++++++++++++++++++++++++++++++++
1 files changed, 388 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/card/mmc_block_test.c b/drivers/mmc/card/mmc_block_test.c
index 48719fb..b101e42 100644
--- a/drivers/mmc/card/mmc_block_test.c
+++ b/drivers/mmc/card/mmc_block_test.c
@@ -83,6 +83,24 @@ enum mmc_block_test_testcases {
 	TEST_CMD23_BITS_16TO29_SET,
 	TEST_CMD23_HDR_BLK_NOT_IN_COUNT,
 	INVALID_CMD_MAX_TESTCASE = TEST_CMD23_HDR_BLK_NOT_IN_COUNT,
+
+	/*
+	 * Start of packing control test group.
+	 * in these next testcases the abbreviation FB = followed by
+	 */
+	PACKING_CONTROL_MIN_TESTCASE,
+	TEST_PACKING_EXP_ONE_OVER_TRIGGER_FB_READ =
+				PACKING_CONTROL_MIN_TESTCASE,
+	TEST_PACKING_EXP_N_OVER_TRIGGER,
+	TEST_PACKING_EXP_N_OVER_TRIGGER_FB_READ,
+	TEST_PACKING_EXP_N_OVER_TRIGGER_FLUSH_N,
+	TEST_PACKING_EXP_THRESHOLD_OVER_TRIGGER,
+	TEST_PACKING_NOT_EXP_LESS_THAN_TRIGGER_REQUESTS,
+	TEST_PACKING_NOT_EXP_TRIGGER_REQUESTS,
+	TEST_PACKING_NOT_EXP_TRIGGER_READ_TRIGGER,
+	TEST_PACK_MIX_PACKED_NO_PACKED_PACKED,
+	TEST_PACK_MIX_NO_PACKED_PACKED_NO_PACKED,
+	PACKING_CONTROL_MAX_TESTCASE = TEST_PACK_MIX_NO_PACKED_PACKED_NO_PACKED,
 };
 
 enum mmc_block_test_group {
@@ -91,6 +109,7 @@ enum mmc_block_test_group {
 	TEST_SEND_WRITE_PACKING_GROUP,
 	TEST_ERR_CHECK_GROUP,
 	TEST_SEND_INVALID_GROUP,
+	TEST_PACKING_CONTROL_GROUP,
 };
 
 struct mmc_block_test_debug {
@@ -98,6 +117,7 @@ struct mmc_block_test_debug {
 	struct dentry *err_check_test;
 	struct dentry *send_invalid_packed_test;
 	struct dentry *random_test_seed;
+	struct dentry *packing_control_test;
 };
 
 struct mmc_block_test_data {
@@ -443,6 +463,26 @@ static char *get_test_case_str(struct test_data *td)
 		return "Test invalid - cmd23 bits [16-29] set";
 	case TEST_CMD23_HDR_BLK_NOT_IN_COUNT:
 		return "Test invalid - cmd23 header block not in count";
+	case TEST_PACKING_EXP_N_OVER_TRIGGER:
+		return "\nTest packing control - pack n";
+	case TEST_PACKING_EXP_N_OVER_TRIGGER_FB_READ:
+		return "\nTest packing control - pack n followed by read";
+	case TEST_PACKING_EXP_N_OVER_TRIGGER_FLUSH_N:
+		return "\nTest packing control - pack n followed by flush";
+	case TEST_PACKING_EXP_ONE_OVER_TRIGGER_FB_READ:
+		return "\nTest packing control - pack one followed by read";
+	case TEST_PACKING_EXP_THRESHOLD_OVER_TRIGGER:
+		return "\nTest packing control - pack threshold";
+	case TEST_PACKING_NOT_EXP_LESS_THAN_TRIGGER_REQUESTS:
+		return "\nTest packing control - no packing";
+	case TEST_PACKING_NOT_EXP_TRIGGER_REQUESTS:
+		return "\nTest packing control - no packing, trigger requests";
+	case TEST_PACKING_NOT_EXP_TRIGGER_READ_TRIGGER:
+		return "\nTest packing control - no pack, trigger-read-trigger";
+	case TEST_PACK_MIX_PACKED_NO_PACKED_PACKED:
+		return "\nTest packing control - mix: pack -> no pack -> pack";
+	case TEST_PACK_MIX_NO_PACKED_PACKED_NO_PACKED:
+		return "\nTest packing control - mix: no pack->pack->no pack";
 	default:
 		 return "Unknown testcase";
 	}
@@ -794,6 +834,169 @@ static int prepare_packed_requests(struct test_data *td, int is_err_expected,
 }
 
 /*
+ * Prepare the write, read and flush requests for the packing control
+ * testcases
+ */
+static int prepare_packed_control_tests_requests(struct test_data *td,
+			int is_err_expected, int num_requests, int is_random)
+{
+	int *num_events = mbtd->exp_packed_stats.packing_events;
+	int ret = 0;
+	struct mmc_queue *mq;
+	int max_packed_reqs;
+	int temp_num_req = num_requests;
+	struct request_queue *req_q;
+	int test_packed_trigger;
+	int num_packed_reqs;
+
+	if (!td) {
+		test_pr_err("%s: NULL td\n", __func__);
+		return -EINVAL;
+	}
+
+	req_q = td->req_q;
+
+	if (!req_q) {
+		test_pr_err("%s: NULL request queue\n", __func__);
+		return -EINVAL;
+	}
+
+	mq = req_q->queuedata;
+	max_packed_reqs = mq->card->ext_csd.max_packed_writes;
+	test_packed_trigger = mq->num_wr_reqs_to_start_packing;
+	num_packed_reqs = num_requests - test_packed_trigger;
+
+	if (mbtd->random_test_seed <= 0) {
+		mbtd->random_test_seed =
+			(unsigned int)(get_jiffies_64() & 0xFFFF);
+		test_pr_info("%s: got seed from jiffies %d",
+			     __func__, mbtd->random_test_seed);
+	}
+
+	mmc_blk_init_packed_statistics(mq->card);
+
+	if (td->test_info.testcase ==
+			TEST_PACK_MIX_NO_PACKED_PACKED_NO_PACKED) {
+		temp_num_req = num_requests;
+		num_requests = test_packed_trigger - 1;
+	}
+
+	/* Verify that the packing is disabled before starting the test*/
+	mq->wr_packing_enabled = 0;
+	mq->num_of_potential_packed_wr_reqs = 0;
+
+
+	if (td->test_info.testcase == TEST_PACK_MIX_PACKED_NO_PACKED_PACKED) {
+		mq->num_of_potential_packed_wr_reqs = test_packed_trigger + 1;
+		mq->wr_packing_enabled = 1;
+		num_requests = test_packed_trigger + 2;
+	}
+
+	ret = prepare_request_add_write_reqs(td, num_requests, is_err_expected,
+					     is_random);
+	if (ret)
+		return ret;
+
+	if (td->test_info.testcase == TEST_PACK_MIX_NO_PACKED_PACKED_NO_PACKED)
+		num_requests = temp_num_req;
+
+	memset((void *)mbtd->exp_packed_stats.pack_stop_reason, 0,
+		sizeof(mbtd->exp_packed_stats.pack_stop_reason));
+	memset(mbtd->exp_packed_stats.packing_events, 0,
+		(max_packed_reqs + 1) * sizeof(u32));
+
+	switch (td->test_info.testcase) {
+	case TEST_PACKING_EXP_N_OVER_TRIGGER_FB_READ:
+	case TEST_PACKING_EXP_ONE_OVER_TRIGGER_FB_READ:
+		ret = prepare_request_add_read(td);
+		if (ret)
+			goto exit;
+
+		mbtd->exp_packed_stats.pack_stop_reason[WRONG_DATA_DIR] = 1;
+		mbtd->exp_packed_stats.packing_events[num_packed_reqs] = 1;
+		break;
+	case TEST_PACKING_EXP_N_OVER_TRIGGER_FLUSH_N:
+		ret = prepare_request_add_flush(td);
+		if (ret)
+			goto exit;
+		ret = prepare_request_add_write_reqs(td, num_packed_reqs,
+					     is_err_expected, is_random);
+		mbtd->exp_packed_stats.pack_stop_reason[EMPTY_QUEUE] = 1;
+		mbtd->exp_packed_stats.pack_stop_reason[FLUSH_OR_DISCARD] = 1;
+		num_events[num_packed_reqs] = 2;
+		break;
+	case TEST_PACKING_NOT_EXP_TRIGGER_READ_TRIGGER:
+		ret = prepare_request_add_read(td);
+		if (ret)
+			goto exit;
+
+		ret = prepare_request_add_write_reqs(td, test_packed_trigger,
+						    is_err_expected, is_random);
+		if (ret)
+			goto exit;
+
+		mbtd->exp_packed_stats.packing_events[num_packed_reqs] = 1;
+
+		break;
+	case TEST_PACK_MIX_PACKED_NO_PACKED_PACKED:
+		ret = prepare_request_add_read(td);
+		if (ret)
+			goto exit;
+
+		ret = prepare_request_add_write_reqs(td, test_packed_trigger-1,
+						    is_err_expected, is_random);
+		if (ret)
+			return ret;
+
+		ret = prepare_request_add_write_reqs(td, num_requests,
+						    is_err_expected, is_random);
+		if (ret)
+			goto exit;
+
+		num_events[num_requests] = 1;
+		num_events[num_requests-1] = 1;
+		mbtd->exp_packed_stats.pack_stop_reason[WRONG_DATA_DIR] = 1;
+		mbtd->exp_packed_stats.pack_stop_reason[EMPTY_QUEUE] = 1;
+		break;
+	case TEST_PACK_MIX_NO_PACKED_PACKED_NO_PACKED:
+		ret = prepare_request_add_read(td);
+		if (ret)
+			goto exit;
+
+		ret = prepare_request_add_write_reqs(td, num_requests,
+						    is_err_expected, is_random);
+		if (ret)
+			goto exit;
+
+		ret = prepare_request_add_read(td);
+		if (ret)
+			goto exit;
+
+		ret = prepare_request_add_write_reqs(td, test_packed_trigger-1,
+						    is_err_expected, is_random);
+		if (ret)
+			return ret;
+
+		mbtd->exp_packed_stats.pack_stop_reason[WRONG_DATA_DIR] = 1;
+		mbtd->exp_packed_stats.packing_events[num_packed_reqs] = 1;
+
+		break;
+	case TEST_PACKING_NOT_EXP_LESS_THAN_TRIGGER_REQUESTS:
+	case TEST_PACKING_NOT_EXP_TRIGGER_REQUESTS:
+		mbtd->exp_packed_stats.packing_events[num_packed_reqs] = 1;
+		break;
+
+	default:
+		mbtd->exp_packed_stats.pack_stop_reason[EMPTY_QUEUE] = 1;
+		mbtd->exp_packed_stats.packing_events[num_packed_reqs] = 1;
+	}
+	mbtd->num_requests = num_requests;
+
+exit:
+	return ret;
+}
+
+/*
  * Prepare requests for the TEST_RET_PARTIAL_FOLLOWED_BY_ABORT testcase.
  * In this testcase we have mixed error expectations from different
  * write requests, hence the special prepare function.
@@ -849,6 +1052,8 @@ static int get_num_requests(struct test_data *td)
 	int num_requests;
 	int min_num_requests = 2;
 	int is_random = mbtd->is_random;
+	int max_for_double;
+	int test_packed_trigger;
 
 	req_q = test_iosched_get_req_queue();
 	if (req_q)
@@ -860,16 +1065,52 @@ static int get_num_requests(struct test_data *td)
 
 	max_num_requests = mq->card->ext_csd.max_packed_writes;
 	num_requests = max_num_requests - 2;
+	test_packed_trigger = mq->num_wr_reqs_to_start_packing;
+
+	/*
+	 * Here max_for_double is intended for packed control testcases
+	 * in which we issue many write requests. It's purpose is to prevent
+	 * exceeding max number of req_queue requests.
+	 */
+	max_for_double = max_num_requests - 10;
+
+	if (td->test_info.testcase ==
+				TEST_PACKING_NOT_EXP_LESS_THAN_TRIGGER_REQUESTS)
+		/* Don't expect packing, so issue up to trigger-1 reqs */
+		num_requests = test_packed_trigger - 1;
 
 	if (is_random) {
 		if (td->test_info.testcase ==
 		    TEST_RET_PARTIAL_FOLLOWED_BY_ABORT)
+			/*
+			 * Here we don't want num_requests to be less than 1
+			 * as a consequence of division by 2.
+			 */
 			min_num_requests = 3;
 
+		if (td->test_info.testcase ==
+				TEST_PACKING_NOT_EXP_LESS_THAN_TRIGGER_REQUESTS)
+			/* Don't expect packing, so issue up to trigger reqs */
+			max_num_requests = test_packed_trigger;
+
 		num_requests = pseudo_random_seed(seed, min_num_requests,
 						  max_num_requests - 1);
 	}
 
+	if (td->test_info.testcase ==
+				TEST_PACKING_NOT_EXP_LESS_THAN_TRIGGER_REQUESTS)
+		num_requests -= test_packed_trigger;
+
+	if (td->test_info.testcase == TEST_PACKING_EXP_N_OVER_TRIGGER_FLUSH_N)
+		num_requests =
+		num_requests > max_for_double ? max_for_double : num_requests;
+
+	if (mbtd->test_group == TEST_PACKING_CONTROL_GROUP)
+		num_requests += test_packed_trigger;
+
+	if (td->test_info.testcase == TEST_PACKING_NOT_EXP_TRIGGER_REQUESTS)
+		num_requests = test_packed_trigger;
+
 	return num_requests;
 }
 
@@ -885,6 +1126,7 @@ static int prepare_test(struct test_data *td)
 	int num_requests = 0;
 	int ret = 0;
 	int is_random = mbtd->is_random;
+	int test_packed_trigger = mq->num_wr_reqs_to_start_packing;
 
 	if (is_random && mbtd->random_test_seed <= 0) {
 		mbtd->random_test_seed =
@@ -946,6 +1188,32 @@ static int prepare_test(struct test_data *td)
 	case TEST_HDR_CMD23_PACKED_BIT_SET:
 		ret = prepare_packed_requests(td, 1, num_requests, is_random);
 		break;
+	case TEST_PACKING_EXP_N_OVER_TRIGGER:
+	case TEST_PACKING_EXP_N_OVER_TRIGGER_FB_READ:
+	case TEST_PACKING_NOT_EXP_TRIGGER_REQUESTS:
+	case TEST_PACKING_NOT_EXP_LESS_THAN_TRIGGER_REQUESTS:
+	case TEST_PACK_MIX_PACKED_NO_PACKED_PACKED:
+	case TEST_PACK_MIX_NO_PACKED_PACKED_NO_PACKED:
+		ret = prepare_packed_control_tests_requests(td, 0, num_requests,
+			is_random);
+		break;
+	case TEST_PACKING_EXP_THRESHOLD_OVER_TRIGGER:
+		ret = prepare_packed_control_tests_requests(td, 0,
+			max_num_requests, is_random);
+		break;
+	case TEST_PACKING_EXP_ONE_OVER_TRIGGER_FB_READ:
+		ret = prepare_packed_control_tests_requests(td, 0,
+			test_packed_trigger + 1,
+					is_random);
+		break;
+	case TEST_PACKING_EXP_N_OVER_TRIGGER_FLUSH_N:
+		ret = prepare_packed_control_tests_requests(td, 0, num_requests,
+			is_random);
+		break;
+	case TEST_PACKING_NOT_EXP_TRIGGER_READ_TRIGGER:
+		ret = prepare_packed_control_tests_requests(td, 0,
+			test_packed_trigger, is_random);
+		break;
 	default:
 		test_pr_info("%s: Invalid test case...", __func__);
 		return -EINVAL;
@@ -1336,6 +1604,116 @@ const struct file_operations send_invalid_packed_test_ops = {
 	.read = send_invalid_packed_test_read,
 };
 
+/* packing_control TEST */
+static ssize_t write_packing_control_test_write(struct file *file,
+				const char __user *buf,
+				size_t count,
+				loff_t *ppos)
+{
+	int ret = 0;
+	int i = 0;
+	int number = -1;
+	int j = 0;
+	struct mmc_queue *mq = test_iosched_get_req_queue()->queuedata;
+	int max_num_requests = mq->card->ext_csd.max_packed_writes;
+	int test_successful = 1;
+
+	test_pr_info("%s: -- write_packing_control TEST --", __func__);
+
+	sscanf(buf, "%d", &number);
+
+	if (number <= 0)
+		number = 1;
+
+	test_pr_info("%s: max_num_requests = %d ", __func__,
+			max_num_requests);
+
+	memset(&mbtd->test_info, 0, sizeof(struct test_info));
+	mbtd->test_group = TEST_PACKING_CONTROL_GROUP;
+
+	if (validate_packed_commands_settings())
+		return count;
+
+	mbtd->test_info.data = mbtd;
+	mbtd->test_info.prepare_test_fn = prepare_test;
+	mbtd->test_info.check_test_result_fn = check_wr_packing_statistics;
+	mbtd->test_info.get_test_case_str_fn = get_test_case_str;
+
+	for (i = 0 ; i < number ; ++i) {
+		test_pr_info("%s: Cycle # %d / %d", __func__, i+1, number);
+		test_pr_info("%s: ====================", __func__);
+
+		for (j = PACKING_CONTROL_MIN_TESTCASE;
+				j <= PACKING_CONTROL_MAX_TESTCASE ; j++) {
+
+			test_successful = 1;
+			mbtd->test_info.testcase = j;
+			mbtd->is_random = RANDOM_TEST;
+			ret = test_iosched_start_test(&mbtd->test_info);
+			if (ret) {
+				test_successful = 0;
+				break;
+			}
+			/* Allow FS requests to be dispatched */
+			msleep(1000);
+
+			mbtd->test_info.testcase = j;
+			mbtd->is_random = NON_RANDOM_TEST;
+			ret = test_iosched_start_test(&mbtd->test_info);
+			if (ret) {
+				test_successful = 0;
+				break;
+			}
+			/* Allow FS requests to be dispatched */
+			msleep(1000);
+		}
+
+		if (!test_successful)
+			break;
+	}
+
+	test_pr_info("%s: Completed all the test cases.", __func__);
+
+	return count;
+}
+
+static ssize_t write_packing_control_test_read(struct file *file,
+			       char __user *buffer,
+			       size_t count,
+			       loff_t *offset)
+{
+	memset((void *)buffer, 0, count);
+
+	snprintf(buffer, count,
+		 "\nwrite_packing_control_test\n"
+		 "=========\n"
+		 "Description:\n"
+		 "This test checks the following scenarios\n"
+		 "- Packing expected - one over trigger\n"
+		 "- Packing expected - N over trigger\n"
+		 "- Packing expected - N over trigger followed by read\n"
+		 "- Packing expected - N over trigger followed by flush\n"
+		 "- Packing expected - threshold over trigger FB by flush\n"
+		 "- Packing not expected - less than trigger\n"
+		 "- Packing not expected - trigger requests\n"
+		 "- Packing not expected - trigger, read, trigger\n"
+		 "- Mixed state - packing -> no packing -> packing\n"
+		 "- Mixed state - no packing -> packing -> no packing\n");
+
+	if (message_repeat == 1) {
+		message_repeat = 0;
+		return strnlen(buffer, count);
+	} else {
+		return 0;
+	}
+}
+
+const struct file_operations write_packing_control_test_ops = {
+	.open = test_open,
+	.write = write_packing_control_test_write,
+	.read = write_packing_control_test_read,
+};
+
 static void mmc_block_test_debugfs_cleanup(void)
 {
 	debugfs_remove(mbtd->debug.random_test_seed);
@@ -1393,6 +1771,16 @@ static int mmc_block_test_debugfs_init(void)
 	if (!mbtd->debug.send_invalid_packed_test)
 		goto err_nomem;
 
+	mbtd->debug.packing_control_test = debugfs_create_file(
+					"packing_control_test",
+					S_IRUGO | S_IWUGO,
+					tests_root,
+					NULL,
+					&write_packing_control_test_ops);
+
+	if (!mbtd->debug.packing_control_test)
+		goto err_nomem;
+
 	return 0;
 
 err_nomem:
-- 
1.7.6
--
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


