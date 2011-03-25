Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934491Ab1CYKt5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 06:49:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:54403 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934195Ab1CYKt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 06:49:56 -0400
Date: Fri, 25 Mar 2011 10:48:52 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, dvhart@linux.intel.com,
        peterz@infradead.org, akpm@linux-foundation.org, rostedt@goodmis.org,
        srostedt@redhat.com, tglx@linutronix.de, laijs@cn.fujitsu.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dvhart@linux.intel.com, torvalds@linux-foundation.org,
        peterz@infradead.org, akpm@linux-foundation.org, rostedt@goodmis.org,
        srostedt@redhat.com, tglx@linutronix.de, laijs@cn.fujitsu.com,
        mingo@elte.hu
In-Reply-To: <20110317192208.444147791@goodmis.org>
References: <20110317192208.444147791@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] WARN_ON_SMP(): Allow use in if() statements on UP
Message-ID: <tip-2092e6be82ec71ecbf5a8ceeef004bbcbdb78812@git.kernel.org>
Git-Commit-ID: 2092e6be82ec71ecbf5a8ceeef004bbcbdb78812
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 25 Mar 2011 10:48:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2092e6be82ec71ecbf5a8ceeef004bbcbdb78812
Gitweb:     http://git.kernel.org/tip/2092e6be82ec71ecbf5a8ceeef004bbcbdb78812
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Thu, 17 Mar 2011 15:21:06 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 25 Mar 2011 11:32:09 +0100

WARN_ON_SMP(): Allow use in if() statements on UP

Both WARN_ON() and WARN_ON_SMP() should be able to be used in
an if statement.

	if (WARN_ON_SMP(foo)) { ... }

Because WARN_ON_SMP() is defined as a do { } while (0) on UP,
it can not be used this way.

Convert it to the same form that WARN_ON() is, even when
CONFIG_SMP is off.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Darren Hart <dvhart@linux.intel.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <20110317192208.444147791@goodmis.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
