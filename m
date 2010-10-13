Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab0JMAXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 20:23:52 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:39023 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752373Ab0JMAXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 20:23:50 -0400
Subject: Re: [RFC PATCH] Bug during kexec...not all cpus are stopped
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Haren Myneni <hbabu@us.ibm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Daniel Hecht <dhecht@vmware.com>,
        "jeremy@xensource.com" <jeremy@xensource.com>
In-Reply-To: <20101012221717.GA27478@redhat.com>
References: <1286570087.8769.27.camel@ank32.eng.vmware.com>
	 <1286816964.1372.2.camel@ank32.eng.vmware.com>
	 <m1lj64ppri.fsf@fess.ebiederm.org>
	 <1286826083.1372.15.camel@ank32.eng.vmware.com>
	 <20101011213901.GR12743@redhat.com> <m1hbgs5qkc.fsf@fess.ebiederm.org>
	 <20101012221717.GA27478@redhat.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Tue, 12 Oct 2010 17:23:50 -0700
Message-Id: <1286929430.15658.30.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2010-10-12 at 15:17 -0700, Vivek Goyal wrote:
> On Mon, Oct 11, 2010 at 03:10:11PM -0700, Eric W. Biederman wrote:
> > Vivek Goyal <vgoyal@redhat.com> writes:
> > 
> > > On Mon, Oct 11, 2010 at 12:41:23PM -0700, Alok Kataria wrote:
> > 
> > > I don't think that kdump path uses smp_send_stop().
> > 
> > It doesn't.
> > 
> > > IIUC, on x86, we directly send NMI to other cpus.
> > >
> > > native_machine_crash_shutdown()
> > >   kdump_nmi_shootdown_cpus()
> > >         nmi_shootdown_cpus()
> > >            smp_send_nmi_allbutself
> > >                 apic->send_IPI_allbutself(NMI_VECTOR);
> > >
> > > So above description should be limited to only panic() path.
> > 
> > Is it actually confusing?  With respect to documenting the line
> > of thinking it seems reasonable.
> > 
> 
> No, just wanted to point out that let us modify the changelog to remove
> keyword "kdump" from it. 
> 
> > > On a side note, I am wondering why panic() and kdump path can't share the
> > > shutdown routine.
> > 
> > Hysterical raisins.  Andi's change to smp_send_stop says that NMIs not
> > working on some boxes.  When someone wants to weed through all of the
> > insanity it would probably be good to get the panic and the kdump paths
> > sharing code.  For now simply separating panic and reboot should be
> > enough, and it lets the code evolve where it needs to.
> > 
> 
> Ok. Agreed that atleast conceptually kdump and panic() path should share
> the code. But that's a different problem altogether and this patch can go in.

Okay now that we all agree, let me repost a patch with the updated
changelog, this fits on top of tip/master. 

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
--- linux-x86-tree.git.orig/arch/x86/include/asm/smp.h	2010-02-07 16:37:26.000000000 -0800
+++ linux-x86-tree.git/arch/x86/include/asm/smp.h	2010-10-12 16:37:04.000000000 -0700
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
--- linux-x86-tree.git.orig/arch/x86/kernel/reboot.c	2010-08-17 12:09:51.000000000 -0700
+++ linux-x86-tree.git/arch/x86/kernel/reboot.c	2010-10-12 16:37:04.000000000 -0700
@@ -641,7 +641,7 @@ void native_machine_shutdown(void)
 	/* O.K Now that I'm on the appropriate processor,
 	 * stop all of the others.
 	 */
-	smp_send_stop();
+	stop_other_cpus();
 #endif
 
 	lapic_shutdown();
Index: linux-x86-tree.git/arch/x86/kernel/smp.c
===================================================================
--- linux-x86-tree.git.orig/arch/x86/kernel/smp.c	2010-07-08 13:53:34.000000000 -0700
+++ linux-x86-tree.git/arch/x86/kernel/smp.c	2010-10-12 16:37:04.000000000 -0700
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
--- linux-x86-tree.git.orig/arch/x86/xen/enlighten.c	2010-10-12 16:36:28.000000000 -0700
+++ linux-x86-tree.git/arch/x86/xen/enlighten.c	2010-10-12 16:37:04.000000000 -0700
@@ -1019,7 +1019,7 @@ static void xen_reboot(int reason)
 	struct sched_shutdown r = { .reason = reason };
 
 #ifdef CONFIG_SMP
-	smp_send_stop();
+	stop_other_cpus();
 #endif
 
 	if (HYPERVISOR_sched_op(SCHEDOP_shutdown, &r))
Index: linux-x86-tree.git/arch/x86/xen/smp.c
===================================================================
--- linux-x86-tree.git.orig/arch/x86/xen/smp.c	2010-08-17 12:09:51.000000000 -0700
+++ linux-x86-tree.git/arch/x86/xen/smp.c	2010-10-12 16:37:04.000000000 -0700
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


