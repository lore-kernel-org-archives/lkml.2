Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852Ab0DFXkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 19:40:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35020
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757823Ab0DFXkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 19:40:00 -0400
Date: Tue, 06 Apr 2010 16:40:02 -0700 (PDT)
Message-Id: <20100406.164002.40105966.davem@davemloft.net>
To: a.p.zijlstra@chello.nl
Cc: mingo@elte.hu, acme@redhat.com, paulus@samba.org, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH 2/2] ftrace: Use local_irq_{save,restore}_nmi() in tracers.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: David S. Miller <davem@davemloft.net>
---
 kernel/trace/ftrace.c             |    4 ++--
 kernel/trace/trace_functions.c    |    8 ++++----
 kernel/trace/trace_sched_wakeup.c |    4 ++--
 kernel/trace/trace_stack.c        |    4 ++--
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index d9062f5..41d4282 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -612,7 +612,7 @@ function_profile_call(unsigned long ip, unsigned long parent_ip)
 	if (!ftrace_profile_enabled)
 		return;
 
-	local_irq_save(flags);
+	local_irq_save_nmi(flags);
 
 	stat = &__get_cpu_var(ftrace_profile_stats);
 	if (!stat->hash || !ftrace_profile_enabled)
@@ -627,7 +627,7 @@ function_profile_call(unsigned long ip, unsigned long parent_ip)
 
 	rec->counter++;
  out:
-	local_irq_restore(flags);
+	local_irq_restore_nmi(flags);
 }
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index b3f3776..cac3f8d 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -91,7 +91,7 @@ function_trace_call(unsigned long ip, unsigned long parent_ip)
 	 * Need to use raw, since this must be called before the
 	 * recursive protection is performed.
 	 */
-	local_irq_save(flags);
+	local_irq_save_nmi(flags);
 	cpu = raw_smp_processor_id();
 	data = tr->data[cpu];
 	disabled = atomic_inc_return(&data->disabled);
@@ -102,7 +102,7 @@ function_trace_call(unsigned long ip, unsigned long parent_ip)
 	}
 
 	atomic_dec(&data->disabled);
-	local_irq_restore(flags);
+	local_irq_restore_nmi(flags);
 }
 
 static void
@@ -122,7 +122,7 @@ function_stack_trace_call(unsigned long ip, unsigned long parent_ip)
 	 * Need to use raw, since this must be called before the
 	 * recursive protection is performed.
 	 */
-	local_irq_save(flags);
+	local_irq_save_nmi(flags);
 	cpu = raw_smp_processor_id();
 	data = tr->data[cpu];
 	disabled = atomic_inc_return(&data->disabled);
@@ -142,7 +142,7 @@ function_stack_trace_call(unsigned long ip, unsigned long parent_ip)
 	}
 
 	atomic_dec(&data->disabled);
-	local_irq_restore(flags);
+	local_irq_restore_nmi(flags);
 }
 
 
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 0271742..891d3a0 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -65,11 +65,11 @@ wakeup_tracer_call(unsigned long ip, unsigned long parent_ip)
 	if (unlikely(disabled != 1))
 		goto out;
 
-	local_irq_save(flags);
+	local_irq_save_nmi(flags);
 
 	trace_function(tr, ip, parent_ip, flags, pc);
 
-	local_irq_restore(flags);
+	local_irq_restore_nmi(flags);
 
  out:
 	atomic_dec(&data->disabled);
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index f4bc9b2..14fa61c 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -53,7 +53,7 @@ static inline void check_stack(void)
 	if (!object_is_on_stack(&this_size))
 		return;
 
-	local_irq_save(flags);
+	local_irq_save_nmi(flags);
 	arch_spin_lock(&max_stack_lock);
 
 	/* a race could have already updated it */
@@ -104,7 +104,7 @@ static inline void check_stack(void)
 
  out:
 	arch_spin_unlock(&max_stack_lock);
-	local_irq_restore(flags);
+	local_irq_restore_nmi(flags);
 }
 
 static void
-- 
1.6.6.1

