Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab1GRM6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 08:58:40 -0400
Received: from mga14.intel.com ([143.182.124.37]:39502 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605Ab1GRM6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 08:58:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,222,1309762800"; 
   d="scan'208";a="28438844"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCHv2 2/2] lib: kstrtox: add performance test case
Date: Mon, 18 Jul 2011 15:57:54 +0300
Message-Id: <f0625e0068a3efc9f7b289032ed4cc4e952178ae.1310993826.git.andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <9ebc58c68603c4a5d084e77d355b77dc72225a3f.1310993826.git.andriy.shevchenko@linux.intel.com>
References: <CACVxJT-0=cpieN52g2LZ1W+PPmpL-kR9nHCk53bBSR=Js1cbRA@mail.gmail.com>
 <9ebc58c68603c4a5d084e77d355b77dc72225a3f.1310993826.git.andriy.shevchenko@linux.intel.com>
In-Reply-To: <9ebc58c68603c4a5d084e77d355b77dc72225a3f.1310993826.git.andriy.shevchenko@linux.intel.com>
References: <9ebc58c68603c4a5d084e77d355b77dc72225a3f.1310993826.git.andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
---
 lib/test-kstrtox.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/lib/test-kstrtox.c b/lib/test-kstrtox.c
index d55769d..2da5950 100644
--- a/lib/test-kstrtox.c
+++ b/lib/test-kstrtox.c
@@ -65,6 +65,12 @@ struct test_fail {
 	}								\
 }
 
+static int loop_amount;
+
+module_param(loop_amount, int, 0);
+MODULE_PARM_DESC(loop_amount,
+		 "Amount of loops for performance test (0 - no test)");
+
 static void __init test_kstrtoull_ok(void)
 {
 	DECLARE_TEST_OK(unsigned long long, struct test_ull);
@@ -707,6 +713,27 @@ static void __init test_kstrtos8_fail(void)
 	TEST_FAIL(kstrtos8, s8, "%hhd", test_s8_fail);
 }
 
+static void __init test_kstrtox_perf(void)
+{
+	struct timespec ts, ts1, ts2;
+	int count = loop_amount;
+
+	if (!loop_amount)
+		return;
+
+	getnstimeofday(&ts1);
+	while (count--) {
+		test_kstrtoull_ok();
+		test_kstrtoull_fail();
+	}
+	getnstimeofday(&ts2);
+	ts = timespec_sub(ts2, ts1);
+
+	printk(KERN_INFO "kstrox: %d conversions of strings took %lu.%09lu "
+			 "seconds\n", loop_amount,
+			 (unsigned long)ts.tv_sec, (unsigned long)ts.tv_nsec);
+}
+
 static int __init test_kstrtox_init(void)
 {
 	test_kstrtoull_ok();
@@ -733,6 +760,9 @@ static int __init test_kstrtox_init(void)
 	test_kstrtou8_fail();
 	test_kstrtos8_ok();
 	test_kstrtos8_fail();
+
+	test_kstrtox_perf();
+
 	return -EINVAL;
 }
 module_init(test_kstrtox_init);
-- 
1.7.5.4

