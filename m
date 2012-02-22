Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922Ab2BVJ0R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 04:26:17 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63107 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753750Ab2BVJZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 04:25:05 -0500
Message-ID: <4F44B57C.3020104@cn.fujitsu.com>
Date: Wed, 22 Feb 2012 17:29:32 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: [PATCH 2/3 RFC paul/rcu/srcu] srcu: only increase the upper bit for
 srcu_read_lock()
References: <20120213020951.GA12138@linux.vnet.ibm.com> <4F41F315.1040900@cn.fujitsu.com> <20120220174418.GI2470@linux.vnet.ibm.com> <4F42EF53.6060400@cn.fujitsu.com> <20120221015037.GE2384@linux.vnet.ibm.com> <4F435966.9020106@cn.fujitsu.com> <20120221172442.GG2375@linux.vnet.ibm.com>
In-Reply-To: <20120221172442.GG2375@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-22 17:23:21,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-22 17:23:22,
	Serialize complete at 2012-02-22 17:23:22
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From de49bb517e6367776e2226b931346ab6c798b122 Mon Sep 17 00:00:00 2001
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Date: Wed, 22 Feb 2012 10:41:59 +0800
Subject: [PATCH 2/3 RFC paul/rcu/srcu] srcu: only increase the upper bit for srcu_read_lock()

The algorithm/smp_mb()s ensure 'there is only one srcu_read_lock()
between flip and recheck for a cpu'.
Increment of the upper bit for srcu_read_lock() only can
ensure a single pair of lock/unlock change the cpu counter.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/srcu.h |    2 +-
 kernel/srcu.c        |   11 +++++------
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index a478c8e..5b49d41 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -35,7 +35,7 @@ struct srcu_struct_array {
 };
 
 /* Bit definitions for field ->c above and ->snap below. */
-#define SRCU_USAGE_BITS		2
+#define SRCU_USAGE_BITS		1
 #define SRCU_REF_MASK		(ULONG_MAX >> SRCU_USAGE_BITS)
 #define SRCU_USAGE_COUNT	(SRCU_REF_MASK + 1)
 
diff --git a/kernel/srcu.c b/kernel/srcu.c
index 17e95bc..a51ac48 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -138,10 +138,10 @@ static bool srcu_readers_active_idx_check(struct srcu_struct *sp, int idx)
 
 	/*
 	 * Now, we check the ->snap array that srcu_readers_active_idx()
-	 * filled in from the per-CPU counter values.  Since both
-	 * __srcu_read_lock() and __srcu_read_unlock() increment the
-	 * upper bits of the per-CPU counter, an increment/decrement
-	 * pair will change the value of the counter.  Since there is
+	 * filled in from the per-CPU counter values. Since
+	 * __srcu_read_lock() increments the upper bits of
+	 * the per-CPU counter, an increment/decrement pair will
+	 * change the value of the counter.  Since there is
 	 * only one possible increment, the only way to wrap the counter
 	 * is to have a huge number of counter decrements, which requires
 	 * a huge number of tasks and huge SRCU read-side critical-section
@@ -234,8 +234,7 @@ void __srcu_read_unlock(struct srcu_struct *sp, int idx)
 {
 	preempt_disable();
 	smp_mb(); /* C */  /* Avoid leaking the critical section. */
-	ACCESS_ONCE(this_cpu_ptr(sp->per_cpu_ref)->c[idx]) +=
-		SRCU_USAGE_COUNT - 1;
+	ACCESS_ONCE(this_cpu_ptr(sp->per_cpu_ref)->c[idx]) += -1;
 	preempt_enable();
 }
 EXPORT_SYMBOL_GPL(__srcu_read_unlock);
-- 
1.7.4.4
