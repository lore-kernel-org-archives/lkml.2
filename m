Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429Ab0IFIMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 04:12:23 -0400
Received: from mgw-sa02.nokia.com ([147.243.1.48]:62460 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab0IFIMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 04:12:03 -0400
From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
To: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Hunter Adrian <adrian.hunter@nokia.com>, Chris Ball <cjb@laptop.org>,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: [PATCHv5 3/3] mmc_test: collect data and show it via sysfs by demand
Date: Mon,  6 Sep 2010 11:12:19 +0300
Message-Id: <58a51561c9d2195c5efd18322e03cc067ff204ac.1283760476.git.ext-andriy.shevchenko@nokia.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <59ad4bca0f707b11525dcdbe65dd117d964e4523.1283760476.git.ext-andriy.shevchenko@nokia.com>
In-Reply-To: <3fa57fe7152b608279ec56dcfe969a42b672a197.1283760476.git.ext-andriy.shevchenko@nokia.com>
References: <3fa57fe7152b608279ec56dcfe969a42b672a197.1283760476.git.ext-andriy.shevchenko@nokia.com>
 <59ad4bca0f707b11525dcdbe65dd117d964e4523.1283760476.git.ext-andriy.shevchenko@nokia.com>
References: <3fa57fe7152b608279ec56dcfe969a42b672a197.1283760476.git.ext-andriy.shevchenko@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TODO:
 - implement show() method based on seq_file API

Changes since v4:
 - BUG_ON at exit if the list of the results isn't empty
 - rebase against recent linux-next tree

Changes since v3:
 - fix multi-line commentary style
 - protect mmc_test_free_result() by mutex
 - apply known values to newly created mmc_test_general_result structure before
   attaching it to the list
 - call list_del() before free mmc_test_transfer_result structure
 - check truncated output in show() method, return -ENOBUFS if so
 - avoid deadlock in show() method if snprintf() fails

Changes since v2:
 - move card memeber to mmc_test_general_result structrure and thus throw away
   mmc_test_overall_result which was overkill
 - check result of kmalloc and kzalloc
 - keep pointer to the actual mmc_test_general_result structure in the
   mmc_test_card

Changes since v1:
 - structrure members are described
 - save transfer results code is split to separate function
 - in mmc_test_print_rate() use count = 1 instead of 0
 - mmc_test_result keeps overall results (across all tested cards), however
   it's still global variable
 - list_head variables inside structures have a suffix _lst now

Here is a patch which brings possibility to get test results via sysfs. It
helps to do tests non-interactively.

We have the file created under sysfs already and we could use it to out test
results.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
---
 drivers/mmc/card/mmc_test.c |  170 ++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 168 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/card/mmc_test.c b/drivers/mmc/card/mmc_test.c
index 6bffb33..bfb0e7f 100644
--- a/drivers/mmc/card/mmc_test.c
+++ b/drivers/mmc/card/mmc_test.c
@@ -17,6 +17,7 @@
 
 #include <linux/scatterlist.h>
 #include <linux/swap.h>		/* For nr_free_buffer_pages() */
+#include <linux/list.h>
 
 #define RESULT_OK		0
 #define RESULT_FAIL		1
@@ -73,12 +74,45 @@ struct mmc_test_area {
 };
 
 /**
+ * struct mmc_test_transfer_result - transfer results for performance tests.
+ * @link: double-linked list
+ * @count: amount of group of sectors to check
+ * @sectors: amount of sectors to check in one group
+ * @ts: time values of transfer
+ * @rate: calculated transfer rate
+ */
+struct mmc_test_transfer_result {
+	struct list_head link;
+	unsigned int count;
+	unsigned int sectors;
+	struct timespec ts;
+	unsigned int rate;
+};
+
+/**
+ * struct mmc_test_general_result - results for tests.
+ * @link: double-linked list
+ * @card: card under test
+ * @testcase: number of test case
+ * @result: result of test run
+ * @tr_lst: transfer measurements if any as mmc_test_transfer_result
+ */
+struct mmc_test_general_result {
+	struct list_head link;
+	struct mmc_card *card;
+	int testcase;
+	int result;
+	struct list_head tr_lst;
+};
+
+/**
  * struct mmc_test_card - test information.
  * @card: card under test
  * @scratch: transfer buffer
  * @buffer: transfer buffer
  * @highmem: buffer for highmem tests
  * @area: information for performance tests
+ * @gr: pointer to results of current testcase
  */
 struct mmc_test_card {
 	struct mmc_card	*card;
@@ -88,7 +122,8 @@ struct mmc_test_card {
 #ifdef CONFIG_HIGHMEM
 	struct page	*highmem;
 #endif
-	struct mmc_test_area area;
+	struct mmc_test_area		area;
+	struct mmc_test_general_result	*gr;
 };
 
 /*******************************************************************/
@@ -421,6 +456,30 @@ static unsigned int mmc_test_rate(uint64_t bytes, struct timespec *ts)
 }
 
 /*
+ * Save transfer results for future usage
+ */
+static void mmc_test_save_transfer_result(struct mmc_test_card *test,
+	unsigned int count, unsigned int sectors, struct timespec ts,
+	unsigned int rate)
+{
+	struct mmc_test_transfer_result *tr;
+
+	if (!test->gr)
+		return;
+
+	tr = kmalloc(sizeof(struct mmc_test_transfer_result), GFP_KERNEL);
+	if (!tr)
+		return;
+
+	tr->count = count;
+	tr->sectors = sectors;
+	tr->ts = ts;
+	tr->rate = rate;
+
+	list_add_tail(&tr->link, &test->gr->tr_lst);
+}
+
+/*
  * Print the transfer rate.
  */
 static void mmc_test_print_rate(struct mmc_test_card *test, uint64_t bytes,
@@ -438,6 +497,8 @@ static void mmc_test_print_rate(struct mmc_test_card *test, uint64_t bytes,
 			 mmc_hostname(test->card->host), sectors, sectors >> 1,
 			 (sectors == 1 ? ".5" : ""), (unsigned long)ts.tv_sec,
 			 (unsigned long)ts.tv_nsec, rate / 1000, rate / 1024);
+
+	mmc_test_save_transfer_result(test, 1, sectors, ts, rate);
 }
 
 /*
@@ -461,6 +522,8 @@ static void mmc_test_print_avg_rate(struct mmc_test_card *test, uint64_t bytes,
 			 sectors >> 1, (sectors == 1 ? ".5" : ""),
 			 (unsigned long)ts.tv_sec, (unsigned long)ts.tv_nsec,
 			 rate / 1000, rate / 1024);
+
+	mmc_test_save_transfer_result(test, count, sectors, ts, rate);
 }
 
 /*
@@ -1853,6 +1916,8 @@ static const struct mmc_test_case mmc_test_cases[] = {
 
 static DEFINE_MUTEX(mmc_test_lock);
 
+static LIST_HEAD(mmc_test_result);
+
 static void mmc_test_run(struct mmc_test_card *test, int testcase)
 {
 	int i, ret;
@@ -1863,6 +1928,8 @@ static void mmc_test_run(struct mmc_test_card *test, int testcase)
 	mmc_claim_host(test->card->host);
 
 	for (i = 0;i < ARRAY_SIZE(mmc_test_cases);i++) {
+		struct mmc_test_general_result *gr;
+
 		if (testcase && ((i + 1) != testcase))
 			continue;
 
@@ -1881,6 +1948,25 @@ static void mmc_test_run(struct mmc_test_card *test, int testcase)
 			}
 		}
 
+		gr = kzalloc(sizeof(struct mmc_test_general_result),
+			GFP_KERNEL);
+		if (gr) {
+			INIT_LIST_HEAD(&gr->tr_lst);
+
+			/* Assign data what we know already */
+			gr->card = test->card;
+			gr->testcase = i;
+
+			/* Append container to global one */
+			list_add_tail(&gr->link, &mmc_test_result);
+
+			/*
+			 * Save the pointer to created container in our private
+			 * structure.
+			 */
+			test->gr = gr;
+		}
+
 		ret = mmc_test_cases[i].run(test);
 		switch (ret) {
 		case RESULT_OK:
@@ -1906,6 +1992,10 @@ static void mmc_test_run(struct mmc_test_card *test, int testcase)
 				mmc_hostname(test->card->host), ret);
 		}
 
+		/* Save the result */
+		if (gr)
+			gr->result = ret;
+
 		if (mmc_test_cases[i].cleanup) {
 			ret = mmc_test_cases[i].cleanup(test);
 			if (ret) {
@@ -1923,13 +2013,81 @@ static void mmc_test_run(struct mmc_test_card *test, int testcase)
 		mmc_hostname(test->card->host));
 }
 
+static void mmc_test_free_result(struct mmc_card *card)
+{
+	struct mmc_test_general_result *gr, *grs;
+
+	mutex_lock(&mmc_test_lock);
+
+	list_for_each_entry_safe(gr, grs, &mmc_test_result, link) {
+		struct mmc_test_transfer_result *tr, *trs;
+
+		if (gr->card != card)
+			continue;
+
+		list_for_each_entry_safe(tr, trs, &gr->tr_lst, link) {
+			list_del(&tr->link);
+			kfree(tr);
+		}
+
+		list_del(&gr->link);
+
+		kfree(gr);
+	}
+
+	mutex_unlock(&mmc_test_lock);
+}
+
 static ssize_t mmc_test_show(struct device *dev,
 	struct device_attribute *attr, char *buf)
 {
+	struct mmc_card *card = mmc_dev_to_card(dev);
+	struct mmc_test_general_result *gr;
+	char *p = buf;
+	size_t len = PAGE_SIZE;
+	int ret;
+
 	mutex_lock(&mmc_test_lock);
+
+	list_for_each_entry(gr, &mmc_test_result, link) {
+		struct mmc_test_transfer_result *tr;
+
+		if (gr->card != card)
+			continue;
+
+		ret = snprintf(p, len, "Test %d: %d\n", gr->testcase + 1,
+			gr->result);
+		if (ret < 0)
+			goto err;
+		if (ret >= len) {
+			ret = -ENOBUFS;
+			goto err;
+		}
+		p += ret;
+		len -= ret;
+
+		list_for_each_entry(tr, &gr->tr_lst, link) {
+			ret = snprintf(p, len, "%u %d %lu.%09lu %u\n",
+				tr->count, tr->sectors,
+				(unsigned long)tr->ts.tv_sec,
+				(unsigned long)tr->ts.tv_nsec,
+				tr->rate);
+			if (ret < 0)
+				goto err;
+			if (ret >= len) {
+				ret = -ENOBUFS;
+				goto err;
+			}
+			p += ret;
+			len -= ret;
+		}
+	}
+
+	ret = PAGE_SIZE - len;
+err:
 	mutex_unlock(&mmc_test_lock);
 
-	return 0;
+	return ret;
 }
 
 static ssize_t mmc_test_store(struct device *dev,
@@ -1946,6 +2104,12 @@ static ssize_t mmc_test_store(struct device *dev,
 	if (!test)
 		return -ENOMEM;
 
+	/*
+	 * Remove all test cases associated with given card. Thus we have only
+	 * actual data of the last run.
+	 */
+	mmc_test_free_result(card);
+
 	test->card = card;
 
 	test->buffer = kzalloc(BUFFER_SIZE, GFP_KERNEL);
@@ -1992,6 +2156,7 @@ static int mmc_test_probe(struct mmc_card *card)
 
 static void mmc_test_remove(struct mmc_card *card)
 {
+	mmc_test_free_result(card);
 	device_remove_file(&card->dev, &dev_attr_test);
 }
 
@@ -2010,6 +2175,7 @@ static int __init mmc_test_init(void)
 
 static void __exit mmc_test_exit(void)
 {
+	BUG_ON(!list_empty(&mmc_test_result));
 	mmc_unregister_driver(&mmc_driver);
 }
 
-- 
1.6.3.3

