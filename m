Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab1IGGaM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:30:12 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:40006 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755658Ab1IGGUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:20:49 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        anton@samba.org, benh@kernel.crashing.org, paulus@samba.org
Subject: [PATCH tip/core/rcu 55/55] powerpc: Work around tracing from dyntick-idle mode
Date: Tue,  6 Sep 2011 11:00:49 -0700
Message-Id: <1315332049-2604-55-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PowerPC LPAR's __trace_hcall_exit() can invoke event tracing at a
point where RCU has been told that the CPU is in dyntick-idle mode.
Because event tracing uses RCU, this can result in failures.

A correct fix would arrange for RCU to be told about dyntick-idle
mode after tracing had completed, however, this will require some care
because it appears that __trace_hcall_exit() can also be called from
non-dyntick-idle mode.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: anton@samba.org
Cc: benh@kernel.crashing.org
Cc: paulus@samba.org
---
 arch/powerpc/platforms/pseries/lpar.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/lpar.c b/arch/powerpc/platforms/pseries/lpar.c
index 39e6e0a..668f300 100644
--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -715,12 +715,14 @@ EXPORT_SYMBOL(arch_free_page);
 /* NB: reg/unreg are called while guarded with the tracepoints_mutex */
 extern long hcall_tracepoint_refcount;
 
+#if 0 /* work around buggy use of RCU from dyntick-idle mode */
 /* 
  * Since the tracing code might execute hcalls we need to guard against
  * recursion. One example of this are spinlocks calling H_YIELD on
  * shared processor partitions.
  */
 static DEFINE_PER_CPU(unsigned int, hcall_trace_depth);
+#endif /* #if 0 work around buggy use of RCU from dyntick-idle mode */
 
 void hcall_tracepoint_regfunc(void)
 {
@@ -734,6 +736,7 @@ void hcall_tracepoint_unregfunc(void)
 
 void __trace_hcall_entry(unsigned long opcode, unsigned long *args)
 {
+#if 0 /* work around buggy use of RCU from dyntick-idle mode */
 	unsigned long flags;
 	unsigned int *depth;
 
@@ -750,11 +753,13 @@ void __trace_hcall_entry(unsigned long opcode, unsigned long *args)
 
 out:
 	local_irq_restore(flags);
+#endif /* #if 0 work around buggy use of RCU from dyntick-idle mode */
 }
 
 void __trace_hcall_exit(long opcode, unsigned long retval,
 			unsigned long *retbuf)
 {
+#if 0 /* work around buggy use of RCU from dyntick-idle mode */
 	unsigned long flags;
 	unsigned int *depth;
 
@@ -771,6 +776,7 @@ void __trace_hcall_exit(long opcode, unsigned long retval,
 
 out:
 	local_irq_restore(flags);
+#endif /* #if 0 work around buggy use of RCU from dyntick-idle mode */
 }
 #endif
 
-- 
1.7.3.2

