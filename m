Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839Ab1CNDvz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 23:51:55 -0400
Received: from flusers.ccur.com ([173.221.59.2]:29291 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755985Ab1CNDvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 23:51:50 -0400
Date: Sun, 13 Mar 2011 23:50:44 -0400
From: Joe Korty <joe.korty@ccur.com>
To: paulmck@linux.vnet.ibm.com
Cc: fweisbec@gmail.com, peterz@infradead.org, laijs@cn.fujitsu.com,
        mathieu.desnoyers@efficios.com, dhowells@redhat.com,
        loic.minier@linaro.org, dhaval.giani@gmail.com, tglx@linutronix.de,
        josh@joshtriplett.org, houston.jim@comcast.net, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 9/9] jrcu: introduce alternate implementation of rcu_cpu
Message-ID: <20110314035044.GA12997@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jrcu: introduce an alternate implementation of rcu_cpu().

This new implementation is based on smp_processor_id().
It is for those architectures which do not have
thread_info->cpu.

(We prefer the thread_info version as it works in early
boot where smp_processor_id() has not yet been set up).

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: b/kernel/jrcu.c
===================================================================
--- a/kernel/jrcu.c
+++ b/kernel/jrcu.c
@@ -140,11 +140,27 @@ static u64 rcu_timestamp;
  * know what that is.  For RCU to work correctly, a cpu named '0' must
  * eventually be present (but need not ever be online).
  */
+#ifdef HAVE_THREAD_INFO_CPU
 static inline int rcu_cpu(void)
 {
 	return current_thread_info()->cpu;
 }
 
+#else
+
+static unsigned rcu_cpu_early_flag __read_mostly = 1;
+
+static inline int rcu_cpu(void)
+{
+	if (unlikely(rcu_cpu_early_flag)) {
+		if (!(rcu_scheduler_active && nr_cpu_ids > 1))
+			return 0;
+		rcu_cpu_early_flag = 0;
+	}
+	return raw_smp_processor_id();
+}
+#endif /* HAVE_THREAD_INFO_CPU */
+
 /*
  * Invoke whenever the calling CPU consents to end-of-batch.  All CPUs
  * must so consent before the batch is truly ended.
Index: b/arch/x86/include/asm/thread_info.h
===================================================================
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -29,6 +29,7 @@ struct thread_info {
 	__u32			flags;		/* low level flags */
 	__u32			status;		/* thread synchronous flags */
 	__u32			cpu;		/* current CPU */
+#define HAVE_THREAD_INFO_CPU	1
 	int			preempt_count;	/* 0 => preemptable,
 						   <0 => BUG */
 	mm_segment_t		addr_limit;
