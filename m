Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab0JKVhL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 17:37:11 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:19768 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756431Ab0JKVhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 17:37:09 -0400
Subject: Re: [RFC PATCH] Bug during kexec...not all cpus are stopped
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Daniel Hecht <dhecht@vmware.com>,
        "jeremy@xensource.com" <jeremy@xensource.com>
In-Reply-To: <m1k4lo77kq.fsf@fess.ebiederm.org>
References: <1286570087.8769.27.camel@ank32.eng.vmware.com>
	 <1286816964.1372.2.camel@ank32.eng.vmware.com>
	 <m1lj64ppri.fsf@fess.ebiederm.org>
	 <1286826083.1372.15.camel@ank32.eng.vmware.com>
	 <m1k4lo77kq.fsf@fess.ebiederm.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Mon, 11 Oct 2010 14:37:08 -0700
Message-Id: <1286833028.1372.20.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2010-10-11 at 14:17 -0700, Eric W. Biederman wrote:
> Alok Kataria <akataria@vmware.com> writes:
<snip>
...

> > Index: linux-2.6/include/linux/smp.h
> > ===================================================================
> > --- linux-2.6.orig/include/linux/smp.h        2010-10-11 11:56:40.000000000 -0700
> > +++ linux-2.6/include/linux/smp.h     2010-10-11 12:07:19.000000000 -0700
> > @@ -116,7 +116,8 @@ extern unsigned int setup_max_cpus;
> >
> >  #else /* !SMP */
> >
> > -static inline void smp_send_stop(void) { }
> > +static inline void smp_send_stop() { }
> > +static inline void stop_other_cpus() { }
> 
> You shouldn't change smp.h.
> 
> For the moment stop_other_cpus() is x86 specific so we shouldn't
> impose it in other architectures.
> 
> Also note removing the explicit void is a bad idea in C because that is
> equivalent to saying: smp_send_stop(...) { }  Which allows any set
> of parameters you can think of.
> 

You are right, that hunk was leftover from an earlier change. Thanks for
the eagle eyes. Below is the refreshed patch.

Alok

--
x86 smp_ops now has a new op, stop_other_cpus which takes a parameter "wait"
this allows the caller to specify if it wants to stop untill all the cpus
have processed the stop IPI. This is required specifically for the kexec case
where we should wait for all the cpus to be stopped before starting the new
kernel.
We now wait for the cpus to stop in all cases except for panic/kdump where
we expect things to be broken and we are doing our best to make things
work anyway.


Signed-off-by: Alok N Kataria <akataria@vmware.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>

Index: linux-2.6/arch/x86/include/asm/smp.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/smp.h	2010-10-11 11:56:40.000000000 -0700
+++ linux-2.6/arch/x86/include/asm/smp.h	2010-10-11 12:00:22.000000000 -0700
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
Index: linux-2.6/arch/x86/kernel/reboot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/reboot.c	2010-10-11 11:56:40.000000000 -0700
+++ linux-2.6/arch/x86/kernel/reboot.c	2010-10-11 12:05:02.000000000 -0700
@@ -641,7 +641,7 @@ void native_machine_shutdown(void)
 	/* O.K Now that I'm on the appropriate processor,
 	 * stop all of the others.
 	 */
-	smp_send_stop();
+	stop_other_cpus();
 #endif
 
 	lapic_shutdown();
Index: linux-2.6/arch/x86/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smp.c	2010-10-11 11:56:40.000000000 -0700
+++ linux-2.6/arch/x86/kernel/smp.c	2010-10-11 12:16:42.000000000 -0700
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
Index: linux-2.6/arch/x86/xen/enlighten.c
===================================================================
--- linux-2.6.orig/arch/x86/xen/enlighten.c	2010-10-11 11:56:40.000000000 -0700
+++ linux-2.6/arch/x86/xen/enlighten.c	2010-10-11 12:17:45.000000000 -0700
@@ -1018,7 +1018,7 @@ static void xen_reboot(int reason)
 	struct sched_shutdown r = { .reason = reason };
 
 #ifdef CONFIG_SMP
-	smp_send_stop();
+	stop_other_cpus();
 #endif
 
 	if (HYPERVISOR_sched_op(SCHEDOP_shutdown, &r))
Index: linux-2.6/arch/x86/xen/smp.c
===================================================================
--- linux-2.6.orig/arch/x86/xen/smp.c	2010-10-11 11:56:40.000000000 -0700
+++ linux-2.6/arch/x86/xen/smp.c	2010-10-11 11:58:53.000000000 -0700
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


