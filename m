Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab1HAKxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 06:53:31 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33700 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab1HAKx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 06:53:26 -0400
From: Per Forlin <per.forlin@linaro.org>
To: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org, Per Forlin <per.forlin@linaro.org>
Subject: [PATCH -mmotm 1/2] fault-injection: improve naming of public function should_fail()
Date: Mon,  1 Aug 2011 12:52:36 +0200
Message-Id: <1312195957-12223-2-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1312195957-12223-1-git-send-email-per.forlin@linaro.org>
References: <1312195957-12223-1-git-send-email-per.forlin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rename fault injection function should_fail() to fault_should_fail()

Signed-off-by: Per Forlin <per.forlin@linaro.org>
---
 Documentation/fault-injection/fault-injection.txt |    8 ++++----
 block/blk-core.c                                  |    3 ++-
 block/blk-timeout.c                               |    2 +-
 include/linux/fault-inject.h                      |    2 +-
 lib/fault-inject.c                                |    2 +-
 mm/failslab.c                                     |    2 +-
 mm/page_alloc.c                                   |    2 +-
 7 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/Documentation/fault-injection/fault-injection.txt b/Documentation/fault-injection/fault-injection.txt
index 82a5d25..b65a4a8 100644
--- a/Documentation/fault-injection/fault-injection.txt
+++ b/Documentation/fault-injection/fault-injection.txt
@@ -41,7 +41,7 @@ configuration of fault-injection capabilities.
 - /sys/kernel/debug/fail*/interval:
 
 	specifies the interval between failures, for calls to
-	should_fail() that pass all the other tests.
+	fault_should_fail() that pass all the other tests.
 
 	Note that if you enable this, by setting interval>1, you will
 	probably want to set probability=100.
@@ -54,7 +54,7 @@ configuration of fault-injection capabilities.
 - /sys/kernel/debug/fail*/space:
 
 	specifies an initial resource "budget", decremented by "size"
-	on each call to should_fail(,size).  Failure injection is
+	on each call to fault_should_fail(,size).  Failure injection is
 	suppressed until "space" reaches zero.
 
 - /sys/kernel/debug/fail*/verbose
@@ -153,9 +153,9 @@ o provide a way to configure fault attributes
 
 o add a hook to insert failures
 
-  Upon should_fail() returning true, client code should inject a failure.
+  Upon fault_should_fail() returning true, client code should inject a failure.
 
-	should_fail(attr, size);
+	fault_should_fail(attr, size);
 
 Application Examples
 --------------------
diff --git a/block/blk-core.c b/block/blk-core.c
index 0d23a1c..ba3ea33 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1363,7 +1363,8 @@ __setup("fail_make_request=", setup_fail_make_request);
 
 static bool should_fail_request(struct hd_struct *part, unsigned int bytes)
 {
-	return part->make_it_fail && should_fail(&fail_make_request, bytes);
+	return part->make_it_fail &&
+		fault_should_fail(&fail_make_request, bytes);
 }
 
 static int __init fail_make_request_debugfs(void)
diff --git a/block/blk-timeout.c b/block/blk-timeout.c
index 7803548..0733c0975 100644
--- a/block/blk-timeout.c
+++ b/block/blk-timeout.c
@@ -23,7 +23,7 @@ int blk_should_fake_timeout(struct request_queue *q)
 	if (!test_bit(QUEUE_FLAG_FAIL_IO, &q->queue_flags))
 		return 0;
 
-	return should_fail(&fail_io_timeout, 1);
+	return fault_should_fail(&fail_io_timeout, 1);
 }
 
 static int __init fail_io_timeout_debugfs(void)
diff --git a/include/linux/fault-inject.h b/include/linux/fault-inject.h
index f1945d6..bab4fe2 100644
--- a/include/linux/fault-inject.h
+++ b/include/linux/fault-inject.h
@@ -37,7 +37,7 @@ struct fault_attr {
 
 #define DECLARE_FAULT_ATTR(name) struct fault_attr name = FAULT_ATTR_INITIALIZER
 int setup_fault_attr(struct fault_attr *attr, char *str);
-bool should_fail(struct fault_attr *attr, ssize_t size);
+bool fault_should_fail(struct fault_attr *attr, ssize_t size);
 
 #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
 
diff --git a/lib/fault-inject.c b/lib/fault-inject.c
index f193b77..c7af6d4 100644
--- a/lib/fault-inject.c
+++ b/lib/fault-inject.c
@@ -98,7 +98,7 @@ static inline bool fail_stacktrace(struct fault_attr *attr)
  * http://www.nongnu.org/failmalloc/
  */
 
-bool should_fail(struct fault_attr *attr, ssize_t size)
+bool fault_should_fail(struct fault_attr *attr, ssize_t size)
 {
 	if (attr->task_filter && !fail_task(attr, current))
 		return false;
diff --git a/mm/failslab.c b/mm/failslab.c
index 0dd7b8f..2e346f9 100644
--- a/mm/failslab.c
+++ b/mm/failslab.c
@@ -22,7 +22,7 @@ bool should_failslab(size_t size, gfp_t gfpflags, unsigned long cache_flags)
 	if (failslab.cache_filter && !(cache_flags & SLAB_FAILSLAB))
 		return false;
 
-	return should_fail(&failslab.attr, size);
+	return fault_should_fail(&failslab.attr, size);
 }
 
 static int __init setup_failslab(char *str)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2a25213..6ce935f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1400,7 +1400,7 @@ static int should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
 	if (fail_page_alloc.ignore_gfp_wait && (gfp_mask & __GFP_WAIT))
 		return 0;
 
-	return should_fail(&fail_page_alloc.attr, 1 << order);
+	return fault_should_fail(&fail_page_alloc.attr, 1 << order);
 }
 
 #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
-- 
1.7.4.1

