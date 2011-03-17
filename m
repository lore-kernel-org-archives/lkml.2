Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab1CQV6f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 17:58:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:42941 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804Ab1CQV6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 17:58:30 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=vhdKIqpQuCYA:10 a=_Jr0yp7vvjoA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=1u61OwtPzuoNe0j5qtkA:9 a=jfoa9kWDqAsLanTyrl0A:7 a=MTf0buV7ctRNEKomNkRFJ360IPgA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110317215829.363324265@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 17 Mar 2011 17:56:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Darren Hart <dvhart@linux.intel.com>
Subject: [PATCH 1/2 v2] WARN_ON_SMP(): Allow use in if statements on UP
References: <20110317215612.566569234@goodmis.org>
Content-Disposition: inline; filename=0001-WARN_ON_SMP-Allow-use-in-if-statements-on-UP.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Both WARN_ON() and WARN_ON_SMP() should be able to be used in
an if statement.

	if (WARN_ON_SMP(foo)) { ... }

Because WARN_ON_SMP() is defined as a do { } while (0) on UP,
it can not be used this way.

Convert it to the same form that WARN_ON() is, even when
CONFIG_SMP is off.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/asm-generic/bug.h |   28 +++++++++++++++++++++++++++-
 1 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index c2c9ba0..f2d2faf 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -165,10 +165,36 @@ extern void warn_slowpath_null(const char *file, const int line);
 #define WARN_ON_RATELIMIT(condition, state)			\
 		WARN_ON((condition) && __ratelimit(state))
 
+/*
+ * WARN_ON_SMP() is for cases that the warning is either
+ * meaningless for !SMP or may even cause failures.
+ * This is usually used for cases that we have
+ * WARN_ON(!spin_is_locked(&lock)) checks, as spin_is_locked()
+ * returns 0 for uniprocessor settings.
+ * It can also be used with values that are only defined
+ * on SMP:
+ *
+ * struct foo {
+ *  [...]
+ * #ifdef CONFIG_SMP
+ *	int bar;
+ * #endif
+ * };
+ *
+ * void func(struct foo *zoot)
+ * {
+ *	WARN_ON_SMP(!zoot->bar);
+ *
+ * For CONFIG_SMP, WARN_ON_SMP() should act the same as WARN_ON(),
+ * and should be a nop and return false for uniprocessor.
+ *
+ * if (WARN_ON_SMP(x)) returns true only when CONFIG_SMP is set
+ * and x is true.
+ */
 #ifdef CONFIG_SMP
 # define WARN_ON_SMP(x)			WARN_ON(x)
 #else
-# define WARN_ON_SMP(x)			do { } while (0)
+# define WARN_ON_SMP(x)			({0;})
 #endif
 
 #endif
-- 
1.7.2.3


