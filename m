Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932895Ab0KSWdL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:33:11 -0500
Received: from kroah.org ([198.145.64.141]:45003 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932540Ab0KSV6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:58:30 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:56:40 2010
Message-Id: <20101119215640.148989836@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:55:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alok N Kataria <akataria@vmware.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jeremy Fitzhardinge <jeremy@xensource.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [17/82] x86, kexec: Make sure to stop all CPUs before exiting the kernel
In-Reply-To: <20101119215658.GA7804@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alok Kataria <akataria@vmware.com>

commit 76fac077db6b34e2c6383a7b4f3f4f7b7d06d8ce upstream.

x86 smp_ops now has a new op, stop_other_cpus which takes a parameter
"wait" this allows the caller to specify if it wants to stop until all
the cpus have processed the stop IPI.  This is required specifically
for the kexec case where we should wait for all the cpus to be stopped
before starting the new kernel.  We now wait for the cpus to stop in
all cases except for panic/kdump where we expect things to be broken
and we are doing our best to make things work anyway.

This patch fixes a legitimate regression, which was introduced during
2.6.30, by commit id 4ef702c10b5df18ab04921fc252c26421d4d6c75.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
LKML-Reference: <1286833028.1372.20.camel@ank32.eng.vmware.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/smp.h |    9 +++++++--
 arch/x86/kernel/reboot.c   |    2 +-
 arch/x86/kernel/smp.c      |   15 +++++++++------
 arch/x86/xen/enlighten.c   |    2 +-
 arch/x86/xen/smp.c         |    6 +++---
 5 files changed, 21 insertions(+), 13 deletions(-)

--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
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
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -641,7 +641,7 @@ void native_machine_shutdown(void)
 	/* O.K Now that I'm on the appropriate processor,
 	 * stop all of the others.
 	 */
-	smp_send_stop();
+	stop_other_cpus();
 #endif
 
 	lapic_shutdown();
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
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
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1001,7 +1001,7 @@ static void xen_reboot(int reason)
 	struct sched_shutdown r = { .reason = reason };
 
 #ifdef CONFIG_SMP
-	smp_send_stop();
+	stop_other_cpus();
 #endif
 
 	if (HYPERVISOR_sched_op(SCHEDOP_shutdown, &r))
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -398,9 +398,9 @@ static void stop_self(void *v)
 	BUG();
 }
 
-static void xen_smp_send_stop(void)
+static void xen_stop_other_cpus(int wait)
 {
-	smp_call_function(stop_self, NULL, 0);
+	smp_call_function(stop_self, NULL, wait);
 }
 
 static void xen_smp_send_reschedule(int cpu)
@@ -468,7 +468,7 @@ static const struct smp_ops xen_smp_ops
 	.cpu_disable = xen_cpu_disable,
 	.play_dead = xen_play_dead,
 
-	.smp_send_stop = xen_smp_send_stop,
+	.stop_other_cpus = xen_stop_other_cpus,
 	.smp_send_reschedule = xen_smp_send_reschedule,
 
 	.send_call_func_ipi = xen_smp_send_call_function_ipi,


