Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073Ab0JUVHB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 17:07:01 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:52063 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751220Ab0JUVG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 17:06:59 -0400
Subject: [PATCH] x86, Fix native_machine_shutdown for kexec case.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Haren Myneni <hbabu@us.ibm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Daniel Hecht <dhecht@vmware.com>,
        "jeremy@xensource.com" <jeremy@xensource.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Thu, 21 Oct 2010 14:06:59 -0700
Message-Id: <1287695219.27008.27.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a bug in the kexec case, when the AP's fail to process
the reboot IPI in the 1sec timeout and the BP starts with starting the
new kernel.
This problem was originally reported and discussed over here.
http://lkml.org/lkml/2010/10/8/422

-- 

x86 smp_ops now has a new op, stop_other_cpus which takes a parameter "wait"
this allows the caller to specify if it wants to stop until all the cpus
have processed the stop IPI. This is required specifically for the kexec case
where we should wait for all the cpus to be stopped before starting the new
kernel.
We now wait for the cpus to stop in all cases except for panic where we expect
things to be broken and we are doing our best to make things work anyway.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>

Index: linux-x86-tree.git/arch/x86/include/asm/smp.h
===================================================================
--- linux-x86-tree.git.orig/arch/x86/include/asm/smp.h	2010-10-21 13:53:25.000000000 -0700
+++ linux-x86-tree.git/arch/x86/include/asm/smp.h	2010-10-21 13:55:18.000000000 -0700
@@ -50,7 +50,7 @@ struct smp_ops {
 	void (*smp_prepare_cpus)(unsigned max_cpus);
 	void (*smp_cpus_done)(unsigned max_cpus);
 
-	void (*smp_send_stop)(void);
+	void (*stop_other_cpus)(int wait);
 	void (*smp_send_reschedule)(int cpu);
 
 	int (*cpu_up)(unsigned cpu);
@@ -73,7 +73,12 @@ extern struct smp_ops smp_ops;
 
 static inline void smp_send_stop(void)
 {
-	smp_ops.smp_send_stop();
+	smp_ops.stop_other_cpus(0);
+}
+
+static inline void stop_other_cpus(void)
+{
+	smp_ops.stop_other_cpus(1);
 }
 
 static inline void smp_prepare_boot_cpu(void)
Index: linux-x86-tree.git/arch/x86/kernel/reboot.c
===================================================================
--- linux-x86-tree.git.orig/arch/x86/kernel/reboot.c	2010-10-21 13:55:08.000000000 -0700
+++ linux-x86-tree.git/arch/x86/kernel/reboot.c	2010-10-21 13:55:18.000000000 -0700
@@ -635,7 +635,7 @@ void native_machine_shutdown(void)
 	/* O.K Now that I'm on the appropriate processor,
 	 * stop all of the others.
 	 */
-	smp_send_stop();
+	stop_other_cpus();
 #endif
 
 	lapic_shutdown();
Index: linux-x86-tree.git/arch/x86/kernel/smp.c
===================================================================
--- linux-x86-tree.git.orig/arch/x86/kernel/smp.c	2010-10-21 13:53:25.000000000 -0700
+++ linux-x86-tree.git/arch/x86/kernel/smp.c	2010-10-21 13:55:18.000000000 -0700
@@ -159,10 +159,10 @@ asmlinkage void smp_reboot_interrupt(voi
 	irq_exit();
 }
 
-static void native_smp_send_stop(void)
+static void native_stop_other_cpus(int wait)
 {
 	unsigned long flags;
-	unsigned long wait;
+	unsigned long timeout;
 
 	if (reboot_force)
 		return;
@@ -179,9 +179,12 @@ static void native_smp_send_stop(void)
 	if (num_online_cpus() > 1) {
 		apic->send_IPI_allbutself(REBOOT_VECTOR);
 
-		/* Don't wait longer than a second */
-		wait = USEC_PER_SEC;
-		while (num_online_cpus() > 1 && wait--)
+		/*
+		 * Don't wait longer than a second if the caller
+		 * didn't ask us to wait.
+		 */
+		timeout = USEC_PER_SEC;
+		while (num_online_cpus() > 1 && (wait || timeout--))
 			udelay(1);
 	}
 
@@ -227,7 +230,7 @@ struct smp_ops smp_ops = {
 	.smp_prepare_cpus	= native_smp_prepare_cpus,
 	.smp_cpus_done		= native_smp_cpus_done,
 
-	.smp_send_stop		= native_smp_send_stop,
+	.stop_other_cpus	= native_stop_other_cpus,
 	.smp_send_reschedule	= native_smp_send_reschedule,
 
 	.cpu_up			= native_cpu_up,
Index: linux-x86-tree.git/arch/x86/xen/enlighten.c
===================================================================
--- linux-x86-tree.git.orig/arch/x86/xen/enlighten.c	2010-10-21 13:53:25.000000000 -0700
+++ linux-x86-tree.git/arch/x86/xen/enlighten.c	2010-10-21 13:55:18.000000000 -0700
@@ -1019,7 +1019,7 @@ static void xen_reboot(int reason)
 	struct sched_shutdown r = { .reason = reason };
 
 #ifdef CONFIG_SMP
-	smp_send_stop();
+	stop_other_cpus();
 #endif
 
 	if (HYPERVISOR_sched_op(SCHEDOP_shutdown, &r))
Index: linux-x86-tree.git/arch/x86/xen/smp.c
===================================================================
--- linux-x86-tree.git.orig/arch/x86/xen/smp.c	2010-10-21 13:53:25.000000000 -0700
+++ linux-x86-tree.git/arch/x86/xen/smp.c	2010-10-21 13:55:18.000000000 -0700
@@ -400,9 +400,9 @@ static void stop_self(void *v)
 	BUG();
 }
 
-static void xen_smp_send_stop(void)
+static void xen_stop_other_cpus(int wait)
 {
-	smp_call_function(stop_self, NULL, 0);
+	smp_call_function(stop_self, NULL, wait);
 }
 
 static void xen_smp_send_reschedule(int cpu)
@@ -470,7 +470,7 @@ static const struct smp_ops xen_smp_ops 
 	.cpu_disable = xen_cpu_disable,
 	.play_dead = xen_play_dead,
 
-	.smp_send_stop = xen_smp_send_stop,
+	.stop_other_cpus = xen_stop_other_cpus,
 	.smp_send_reschedule = xen_smp_send_reschedule,
 
 	.send_call_func_ipi = xen_smp_send_call_function_ipi,


