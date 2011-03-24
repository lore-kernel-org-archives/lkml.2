Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933939Ab1CXRJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 13:09:48 -0400
Received: from relay1.sgi.com ([192.48.179.29]:48261 "HELO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933890Ab1CXRJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 13:09:47 -0400
Date: Thu, 24 Mar 2011 12:09:44 -0500
From: Jack Steiner <steiner@sgi.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86, UV: Fix NMI handler for UV platforms
Message-ID: <20110324170944.GA28825@sgi.com>
References: <20110321193740.GN1239@redhat.com> <20110322171118.GA6294@sgi.com> <20110322184450.GU1239@redhat.com> <20110322212519.GA12076@sgi.com> <20110322220505.GB13453@redhat.com> <20110323163255.GA17178@sgi.com> <20110323175320.GB9413@redhat.com> <20110323200008.GZ1239@redhat.com> <20110323204647.GA30938@sgi.com> <20110323212358.GC29184@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110323212358.GC29184@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 05:23:58PM -0400, Don Zickus wrote:
> On Wed, Mar 23, 2011 at 03:46:47PM -0500, Jack Steiner wrote:
> > On Wed, Mar 23, 2011 at 04:00:08PM -0400, Don Zickus wrote:
> > > On Wed, Mar 23, 2011 at 01:53:20PM -0400, Don Zickus wrote:
> > > > Let me know if the patch fixes that problem.  Then it will be one less
> > > > thing to worry about. :-)
> > > 
> > > Ok, I was an idiot and made the patch against RHEL-6.  Here is the one
> > > against 2.6.38.  Sorry about that.
> > 
> > No problem.
> > 
> > I applied the patch below. However, I still see the "dazed" messages with
> > about the same frequency.
> 
> Crap.  It fixed acme's problem though where he was using 3 counters at
> high frequency.  The problem must be elsewhere.  I'll have to figure out a
> new strategy.  I'll probably put together a patch full of trace_printk
> output to see if I can characterize it.


I added tracing to see if I could get more clues on the cause
of the "dazed" message. Unfortunately, I don't see anything - maybe
you do.

I used a tracing module that I've used for other things. I'm sure
there are other facilities available, but I've used this for a long time & it's
easy to update for specific purposes.
	rtc = usec clock
	rtc-delta = usec since previous trace entry
	id  = trace identifier (not particularily useful here)
	p1, p2 = tracepoint specific data. See patch below
	   For hw_perf
		p1 [63:32] this_nmi
		   [31:0]  handled
		p2 [63:32] pmu_nmi.marked
		   [31:0]  pmu_nmi.handled


Here is a trace leading up to a failure. Times are in usec:

 cpu              rtc    rtc-delta   id               p1               p2 desc
  10         80996952        44005    1                0                0 NMI handler
  10         80996952            0   40                0                0 perf_event_nmi_handler
  10         80996952            0   40                0                0 perf_event_nmi_handler NMI
  10         80996955            3   40     343000000001     33bc00000002 perf_event_nmi_handler NMI handled - this/handled pmumarked/handled
  10         80996955            0    1                0                0 NMI handler OK

  10         81036965        40010    1                0                0 NMI handler
  10         81036965            0   40                0                0 perf_event_nmi_handler
  10         81036966            1   40                0                0 perf_event_nmi_handler NMI
  10         81036968            2   40     343100000001     33bc00000002 perf_event_nmi_handler NMI handled - this/handled pmumarked/handled
  10         81036968            0    1                0                0 NMI handler OK

  10         81064135        27167    1                0                0 NMI handler
  10         81064136            1   40                0                0 perf_event_nmi_handler
  10         81064137            1   40                0                0 perf_event_nmi_handler NMI
  10         81064138            1   40                0                0 perf_event_nmi_handler - not handled
  10         81064138            0    3                0                0 NMI handler failed
  10         81064146            8    4                0                0 Unknown NMI handler
  10         81064147            1   20               95                0 UV NMI not received
  10         81064147            0   40                0                0 perf_event_nmi_handler
  10         81064148            1   40             3432             33bc perf_event_nmi_handler NMIUNKNOWN
  10         81064148            0   99                0                0 Unknown NMI handler


The last trace is just prior to a "dazed" failure.

I dont see anything unusual. Just looks like a spurious NMI with no cause. The PMU did not
see an NMI cause. The previous couple of NMIs looked (at least to me) normal.
NMIs are occuring every ~40msec. No UV NMIs were recently received. No multiple PMU
events handled.

Here is a trace where a UV NMI was received:

   0        371742833         2453    1                0                0 NMI handler
   0        371742834            1   40                0                0 perf_event_nmi_handler
   0        371742834            0   40                0                0 perf_event_nmi_handler NMI
   0        371742836            2   40                0                0 perf_event_nmi_handler - not handled
   0        371742836            0    3                0                0 NMI handler failed
   0        371742856           20    4                0                0 Unknown NMI handler
   0        371742913           57   21               f1                0 UV NMI received



I've include the patch (latest x86 tree) so you can see exactly where the trace points
were inserted.



Index: linux/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c	2011-03-23 10:30:35.000000000 -0500
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c	2011-03-24 10:47:59.865562087 -0500
@@ -23,6 +23,7 @@
 #include <linux/io.h>
 #include <linux/pci.h>
 #include <linux/kdebug.h>
+#include <linux/utrace.h>
 
 #include <asm/uv/uv_mmrs.h>
 #include <asm/uv/uv_hub.h>
@@ -54,6 +55,9 @@ unsigned int uv_apicid_hibits;
 EXPORT_SYMBOL_GPL(uv_apicid_hibits);
 static DEFINE_SPINLOCK(uv_nmi_lock);
 
+void (*utrace_func)(int id, unsigned long, unsigned long, const char*);
+EXPORT_SYMBOL_GPL(utrace_func);
+
 /* Should be part of uv_hub_info but that breas the KABI */
 static struct uv_nmi_info {
 	spinlock_t	nmi_lock;
@@ -692,11 +696,14 @@ int uv_handle_nmi(struct notifier_block
 	 * if a hw_perf and BMC NMI are received at about the same time
 	 * and both events are processed with the first NMI.
 	 */
-	if (__get_cpu_var(cpu_last_nmi_count) == uv_nmi_info[blade].nmi_count)
+	if (__get_cpu_var(cpu_last_nmi_count) == uv_nmi_info[blade].nmi_count) {
+		UTRACE(20, __get_cpu_var(cpu_last_nmi_count), 0, "UV NMI not received");
 		return NOTIFY_DONE;
+	}
 
 	printk("ZZZ:%d NMI %ld %ld\n", smp_processor_id(), __get_cpu_var(cpu_last_nmi_count), uv_nmi_info[blade].nmi_count);
 	__get_cpu_var(cpu_last_nmi_count) = uv_nmi_info[blade].nmi_count;
+	UTRACE(21, __get_cpu_var(cpu_last_nmi_count), 0, "UV NMI received");
 
 	/*
 	 * Use a lock so only one cpu prints at a time.
Index: linux/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/perf_event.c	2011-03-23 15:33:48.000000000 -0500
+++ linux/arch/x86/kernel/cpu/perf_event.c	2011-03-24 10:47:20.101496911 -0500
@@ -25,6 +25,7 @@
 #include <linux/highmem.h>
 #include <linux/cpu.h>
 #include <linux/bitops.h>
+#include <linux/utrace.h>
 
 #include <asm/apic.h>
 #include <asm/stacktrace.h>
@@ -1341,15 +1342,19 @@ perf_event_nmi_handler(struct notifier_b
 	struct die_args *args = __args;
 	unsigned int this_nmi;
 	int handled;
+	unsigned long tmp1, tmp2;
 
 	if (!atomic_read(&active_events))
 		return NOTIFY_DONE;
 
+	UTRACE(40, 0, 0, "perf_event_nmi_handler");
 	switch (cmd) {
 	case DIE_NMI:
+		UTRACE(40, 0, 0, "perf_event_nmi_handler NMI");
 		break;
 	case DIE_NMIUNKNOWN:
 		this_nmi = percpu_read(irq_stat.__nmi_count);
+		UTRACE(40, this_nmi, __this_cpu_read(pmu_nmi.marked), "perf_event_nmi_handler NMIUNKNOWN");
 		if (this_nmi != __this_cpu_read(pmu_nmi.marked))
 			/* let the kernel handle the unknown nmi */
 			return NOTIFY_DONE;
@@ -1368,10 +1373,15 @@ perf_event_nmi_handler(struct notifier_b
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
 
 	handled = x86_pmu.handle_irq(args->regs);
-	if (!handled)
+	if (!handled) {
+		UTRACE(40, handled, 0, "perf_event_nmi_handler - not handled");
 		return NOTIFY_DONE;
+	}
 
 	this_nmi = percpu_read(irq_stat.__nmi_count);
+	tmp1 = ((unsigned long)this_nmi << 32) | handled;
+	tmp2 = ((unsigned long)__this_cpu_read(pmu_nmi.marked) << 32) | __this_cpu_read(pmu_nmi.handled);
+	UTRACE(40, tmp1, tmp2, "perf_event_nmi_handler NMI handled - this/handled pmumarked/handled");
 	if ((handled > 1) ||
 		/* the next nmi could be a back-to-back nmi */
 	    ((__this_cpu_read(pmu_nmi.marked) == this_nmi) &&
Index: linux/arch/x86/kernel/traps.c
===================================================================
--- linux.orig/arch/x86/kernel/traps.c	2011-03-22 15:10:36.000000000 -0500
+++ linux/arch/x86/kernel/traps.c	2011-03-24 10:35:15.410168027 -0500
@@ -31,6 +31,7 @@
 #include <linux/mm.h>
 #include <linux/smp.h>
 #include <linux/io.h>
+#include <linux/utrace.h>
 
 #ifdef CONFIG_EISA
 #include <linux/ioport.h>
@@ -371,9 +372,11 @@ io_check_error(unsigned char reason, str
 static notrace __kprobes void
 unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 {
+	UTRACE(4, 0, 0, "Unknown NMI handler");
 	if (notify_die(DIE_NMIUNKNOWN, "nmi", regs, reason, 2, SIGINT) ==
 			NOTIFY_STOP)
 		return;
+	UTRACE(99, 0, 0, "Unknown NMI handler");
 #ifdef CONFIG_MCA
 	/*
 	 * Might actually be able to figure out what the guilty party
@@ -403,8 +406,12 @@ static notrace __kprobes void default_do
 	 * NMI, otherwise we may lose it, because the CPU-specific
 	 * NMI can not be detected/processed on other CPUs.
 	 */
-	if (notify_die(DIE_NMI, "nmi", regs, 0, 2, SIGINT) == NOTIFY_STOP)
+	UTRACE(1, 0, 0, "NMI handler");
+	if (notify_die(DIE_NMI, "nmi", regs, 0, 2, SIGINT) == NOTIFY_STOP) {
+		UTRACE(1, 0, 0, "NMI handler OK");
 		return;
+	}
+	UTRACE(3, 0, 0, "NMI handler failed");
 
 	/* Non-CPU-specific NMI: NMI sources can be processed on any CPU */
 	raw_spin_lock(&nmi_reason_lock);
Index: linux/include/linux/utrace.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux/include/linux/utrace.h	2011-03-24 10:30:52.438555195 -0500
@@ -0,0 +1,14 @@
+#ifndef _LINUX_UTRACE_H_
+#define _LINUX_UTRACE_H_
+
+
+extern void (*utrace_func)(int id, unsigned long, unsigned long, const char *);
+
+#define UTRACE(id, a, b, c)						\
+       do {								\
+               if (unlikely(utrace_func))				\
+                       (*utrace_func)(id, a, b, c);			\
+       } while (0)
+
+#endif         /* _LINUX_UTRACE_H_ */
+

