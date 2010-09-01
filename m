Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab0IAG0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 02:26:35 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39920 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab0IAG01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 02:26:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=V1GcE8dohf0bsMhdRnb5egxmvbVwKTY+x1d/j8WqWU8AJGcQmwXrhjPdpCA60zn25A
         wC+cN3/RUdkBt/c+F8pgpoo5g2sCr7N6fV3pMCjzXyWEw/2yCxJ8G2X37m1vzBgnOYFM
         SBUPhZ22Ew1qkr5Bk8entJ0TNLH5HFvNaYfdw=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Adrian Hunter <adrian.hunter@nokia.com>,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: [PATCH 3/3] mmc_test: collect data and show it via sysfs by demand
Date: Wed,  1 Sep 2010 09:26:47 +0300
Message-Id: <5f816a17d1a3a630eeb2850ec217d32a9b55fc8d.1283276161.git.ext-andriy.shevchenko@nokia.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <e144c2087fbdfd718b5caeac4eb7d0a7ce4896e0.1283276161.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1283276161.git.ext-andriy.shevchenko@nokia.com>
 <756943b35144532a3c8de22c6dcfb179e5a7f69f.1283276161.git.ext-andriy.shevchenko@nokia.com>
 <e144c2087fbdfd718b5caeac4eb7d0a7ce4896e0.1283276161.git.ext-andriy.shevchenko@nokia.com>
In-Reply-To: <cover.1283276161.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1283276161.git.ext-andriy.shevchenko@nokia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
---
 drivers/mmc/card/mmc_test.c |  116 ++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 114 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/card/mmc_test.c b/drivers/mmc/card/mmc_test.c
index 5423ac9..3cfef37 100644
--- a/drivers/mmc/card/mmc_test.c
+++ b/drivers/mmc/card/mmc_test.c
@@ -16,6 +16,7 @@
 
 #include <linux/scatterlist.h>
 #include <linux/swap.h>
+#include <linux/list.h>
 
 #define RESULT_OK		0
 #define RESULT_FAIL		1
@@ -66,6 +67,28 @@ struct mmc_test_area {
 };
 
 /**
+ * struct mmc_test_transfer_result - container of the transfer results for
+ * performance tests.
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
+ * struct mmc_test_general_result - container of the results for tests.
+ */
+struct mmc_test_general_result {
+	struct list_head link;
+	int testcase;
+	int result;
+	struct list_head transfer;
+};
+
+/**
  * struct mmc_test_card - test information.
  * @card: card under test
  * @scratch: transfer buffer
@@ -81,7 +104,8 @@ struct mmc_test_card {
 #ifdef CONFIG_HIGHMEM
 	struct page	*highmem;
 #endif
-	struct mmc_test_area area;
+	struct mmc_test_area	area;
+	struct list_head	*result;
 };
 
 /*******************************************************************/
@@ -420,6 +444,10 @@ static void mmc_test_print_rate(struct mmc_test_card *test, uint64_t bytes,
 {
 	unsigned int rate, sectors = bytes >> 9;
 	struct timespec ts;
+	struct mmc_test_transfer_result *transfer;
+	struct mmc_test_general_result *result =
+		list_entry(test->result->prev, struct mmc_test_general_result,
+			link);
 
 	ts = timespec_sub(*ts2, *ts1);
 
@@ -430,6 +458,15 @@ static void mmc_test_print_rate(struct mmc_test_card *test, uint64_t bytes,
 			 mmc_hostname(test->card->host), sectors, sectors >> 1,
 			 (sectors == 1 ? ".5" : ""), (unsigned long)ts.tv_sec,
 			 (unsigned long)ts.tv_nsec, rate / 1000, rate / 1024);
+
+	transfer = kmalloc(sizeof(struct mmc_test_transfer_result), GFP_KERNEL);
+
+	transfer->count = 0;
+	transfer->sectors = sectors;
+	memcpy(&transfer->ts, &ts, sizeof(struct timespec));
+	transfer->rate = rate;
+
+	list_add_tail(&transfer->link, &result->transfer);
 }
 
 /*
@@ -442,6 +479,10 @@ static void mmc_test_print_avg_rate(struct mmc_test_card *test, uint64_t bytes,
 	unsigned int rate, sectors = bytes >> 9;
 	uint64_t tot = bytes * count;
 	struct timespec ts;
+	struct mmc_test_transfer_result *transfer;
+	struct mmc_test_general_result *result =
+		list_entry(test->result->prev, struct mmc_test_general_result,
+			link);
 
 	ts = timespec_sub(*ts2, *ts1);
 
@@ -453,6 +494,15 @@ static void mmc_test_print_avg_rate(struct mmc_test_card *test, uint64_t bytes,
 			 sectors >> 1, (sectors == 1 ? ".5" : ""),
 			 (unsigned long)ts.tv_sec, (unsigned long)ts.tv_nsec,
 			 rate / 1000, rate / 1024);
+
+	transfer = kmalloc(sizeof(struct mmc_test_transfer_result), GFP_KERNEL);
+
+	transfer->count = count;
+	transfer->sectors = sectors;
+	memcpy(&transfer->ts, &ts, sizeof(struct timespec));
+	transfer->rate = rate;
+
+	list_add_tail(&transfer->link, &result->transfer);
 }
 
 /*
@@ -1847,6 +1897,8 @@ static void mmc_test_run(struct mmc_test_card *test, long testcase)
 	mmc_claim_host(test->card->host);
 
 	for (i = 0;i < ARRAY_SIZE(mmc_test_cases);i++) {
+		struct mmc_test_general_result *result;
+
 		if (testcase && ((i + 1) != testcase))
 			continue;
 
@@ -1865,6 +1917,11 @@ static void mmc_test_run(struct mmc_test_card *test, long testcase)
 			}
 		}
 
+		result = kzalloc(sizeof(struct mmc_test_general_result),
+			GFP_KERNEL);
+		INIT_LIST_HEAD(&result->transfer);
+		list_add_tail(&result->link, test->result);
+
 		ret = mmc_test_cases[i].run(test);
 		switch (ret) {
 		case RESULT_OK:
@@ -1890,6 +1947,10 @@ static void mmc_test_run(struct mmc_test_card *test, long testcase)
 				mmc_hostname(test->card->host), ret);
 		}
 
+		/* Save the result */
+		result->testcase = i;
+		result->result = ret;
+
 		if (mmc_test_cases[i].cleanup) {
 			ret = mmc_test_cases[i].cleanup(test);
 			if (ret) {
@@ -1907,13 +1968,57 @@ static void mmc_test_run(struct mmc_test_card *test, long testcase)
 		mmc_hostname(test->card->host));
 }
 
+static struct list_head mmc_test_result;
+
+static void mmc_test_result_free(struct list_head *result)
+{
+	struct mmc_test_general_result *gr, *grs;
+
+	list_for_each_entry_safe(gr, grs, result, link) {
+		struct mmc_test_transfer_result *tr, *trs;
+
+		list_for_each_entry_safe(tr, trs, &gr->transfer, link)
+			kfree(tr);
+		kfree(gr);
+	}
+}
+
 static ssize_t mmc_test_show(struct device *dev,
 	struct device_attribute *attr, char *buf)
 {
+	struct mmc_test_general_result *result;
+	char *p = buf;
+	size_t len = PAGE_SIZE;
+
 	mutex_lock(&mmc_test_lock);
+
+	list_for_each_entry(result, &mmc_test_result, link) {
+		struct mmc_test_transfer_result *transfer;
+		int ret;
+
+		ret = snprintf(p, len, "Test %d: %d\n", result->testcase + 1,
+			result->result);
+		if (ret < 0)
+			return ret;
+		p += ret;
+		len -= ret;
+
+		list_for_each_entry(transfer, &result->transfer, link) {
+			ret = snprintf(p, len, "%u %d %lu.%09lu %u\n",
+				transfer->count, transfer->sectors,
+				(unsigned long)transfer->ts.tv_sec,
+				(unsigned long)transfer->ts.tv_nsec,
+				transfer->rate);
+			if (ret < 0)
+				return ret;
+			p += ret;
+			len -= ret;
+		}
+	}
+
 	mutex_unlock(&mmc_test_lock);
 
-	return 0;
+	return PAGE_SIZE - len;
 }
 
 static ssize_t mmc_test_store(struct device *dev,
@@ -1932,6 +2037,10 @@ static ssize_t mmc_test_store(struct device *dev,
 
 	test->card = card;
 
+	mmc_test_result_free(&mmc_test_result);
+	INIT_LIST_HEAD(&mmc_test_result);
+	test->result = &mmc_test_result;
+
 	test->buffer = kzalloc(BUFFER_SIZE, GFP_KERNEL);
 #ifdef CONFIG_HIGHMEM
 	test->highmem = alloc_pages(GFP_KERNEL | __GFP_HIGHMEM, BUFFER_ORDER);
@@ -1969,6 +2078,8 @@ static int mmc_test_probe(struct mmc_card *card)
 	if (ret)
 		return ret;
 
+	INIT_LIST_HEAD(&mmc_test_result);
+
 	dev_info(&card->dev, "Card claimed for testing.\n");
 
 	return 0;
@@ -1976,6 +2087,7 @@ static int mmc_test_probe(struct mmc_card *card)
 
 static void mmc_test_remove(struct mmc_card *card)
 {
+	mmc_test_result_free(&mmc_test_result);
 	device_remove_file(&card->dev, &dev_attr_test);
 }
 
-- 
1.6.3.3

