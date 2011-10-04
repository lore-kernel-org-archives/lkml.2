Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933145Ab1JDTSO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 15:18:14 -0400
Received: from claw.goop.org ([74.207.240.146]:56713 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932539Ab1JDTSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 15:18:13 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>, Jason Baron <jbaron@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH RFC V3 2/8] stop_machine: make stop_machine safe and efficient to call early
Date: Tue,  4 Oct 2011 12:18:03 -0700
Message-Id: <619c66d6da63aa086e2eac017e7aed216cc8ddc3.1317755691.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <cover.1317755691.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1317755691.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1317755691.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1317755691.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Make stop_machine() safe to call early in boot, before stop_machine()
has been set up, by simply calling the callback function directly if
there's only one CPU online.

[ Fixes from AKPM:
   - add comment
   - local_irq_flags, not save_flags
   - also call hard_irq_disable() for systems which need it

  Tejun suggested using an explicit flag rather than just looking at
  the online cpu count. ]

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/stop_machine.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index ba5070c..d3f960a 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -41,6 +41,7 @@ struct cpu_stopper {
 };
 
 static DEFINE_PER_CPU(struct cpu_stopper, cpu_stopper);
+static bool stop_machine_initialized = false;
 
 static void cpu_stop_init_done(struct cpu_stop_done *done, unsigned int nr_todo)
 {
@@ -386,6 +387,8 @@ static int __init cpu_stop_init(void)
 	cpu_stop_cpu_callback(&cpu_stop_cpu_notifier, CPU_ONLINE, bcpu);
 	register_cpu_notifier(&cpu_stop_cpu_notifier);
 
+	stop_machine_initialized = true;
+
 	return 0;
 }
 early_initcall(cpu_stop_init);
@@ -485,6 +488,25 @@ int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
 					    .num_threads = num_online_cpus(),
 					    .active_cpus = cpus };
 
+	if (!stop_machine_initialized) {
+		/*
+		 * Handle the case where stop_machine() is called
+		 * early in boot before stop_machine() has been
+		 * initialized.
+		 */
+ 		unsigned long flags;
+		int ret;
+
+		WARN_ON_ONCE(smdata.num_threads != 1);
+
+		local_irq_save(flags);
+		hard_irq_disable();
+		ret = (*fn)(data);
+		local_irq_restore(flags);
+
+		return ret;
+	}
+
 	/* Set the initial state and stop all online cpus. */
 	set_state(&smdata, STOPMACHINE_PREPARE);
 	return stop_cpus(cpu_online_mask, stop_machine_cpu_stop, &smdata);
-- 
1.7.6.4

