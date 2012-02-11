Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761247Ab2BKCeJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 21:34:09 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:48971 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754866Ab2BKCeH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 21:34:07 -0500
MIME-Version: 1.0
In-Reply-To: <20120210190412.GB12975@phenom.dumpdata.com>
References: <CAKbGBLgVyWC3iuu8n+aQ8UhziSPnbpHVNGtQ=9m-PzvVA1kzdg@mail.gmail.com>
	<1328894901.25989.20.camel@laptop>
	<20120210190412.GB12975@phenom.dumpdata.com>
Date: Fri, 10 Feb 2012 21:34:05 -0500
X-Google-Sender-Auth: AGw2MtGkD9j_nbUBQ-lv-76mFUU
Message-ID: <CAOvdn6WcdrLHOPJc0Hv53+0trEFnU=RQJL5+xUMhAO3C3HWqbw@mail.gmail.com>
Subject: Re: bisected: 'perf top' causing soft lockups under Xen
From: Ben Guthro <ben@guthro.net>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Noonan <steven@uplinklabs.net>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re-send, with patch pasted in-line, rather than attached...


Hmm - sorry I neglected this - it got filtered into my LKML folder,
which I usually ignore, unless I'm looking for something.
I'll have to adjust that filter for when I'm in the To: line.

I've attached a work-in-progress patch, that allows for kdb to work
with the hvc console.

It assigns some IPI functions that may be applicable here...

That said - I'm not convinced it "rounds up" the cpus
properly...though I haven't been able to prove otherwise. It seems to
work generally...



diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index d5e0e0a..88815a1 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -65,6 +65,7 @@

 #include "xen-ops.h"
 #include "mmu.h"
+#include "smp.h"
 #include "multicalls.h"

 EXPORT_SYMBOL_GPL(hypercall_page);
@@ -768,6 +769,12 @@ static void set_xen_basic_apic_ops(void)
 	apic->icr_write = xen_apic_icr_write;
 	apic->wait_icr_idle = xen_apic_wait_icr_idle;
 	apic->safe_wait_icr_idle = xen_safe_apic_wait_icr_idle;
+
+	apic->send_IPI_allbutself = xen_send_IPI_allbutself;
+	apic->send_IPI_mask_allbutself = xen_send_IPI_mask_allbutself;
+	apic->send_IPI_mask = xen_send_IPI_mask;
+	apic->send_IPI_all = xen_send_IPI_all;
+	apic->send_IPI_self = xen_send_IPI_self;
 }

 #endif
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 3061244..d8928a1 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -436,8 +436,8 @@ static void xen_smp_send_reschedule(int cpu)
 	xen_send_IPI_one(cpu, XEN_RESCHEDULE_VECTOR);
 }

-static void xen_send_IPI_mask(const struct cpumask *mask,
-			      enum ipi_vector vector)
+void xen_send_IPI_mask(const struct cpumask *mask,
+			      int vector)
 {
 	unsigned cpu;

@@ -466,6 +466,39 @@ static void xen_smp_send_call_function_single_ipi(int cpu)
 			  XEN_CALL_FUNCTION_SINGLE_VECTOR);
 }

+void xen_send_IPI_all(int vector)
+{
+	xen_send_IPI_mask(cpu_online_mask, vector);
+}
+
+void xen_send_IPI_self(int vector)
+{
+	xen_send_IPI_one(smp_processor_id(), vector);
+}
+
+void xen_send_IPI_mask_allbutself(const struct cpumask *mask,
+				int vector)
+{
+	unsigned cpu;
+	unsigned int this_cpu = smp_processor_id();
+
+	if (!(num_online_cpus() > 1))
+		return;
+
+	for_each_cpu_and(cpu, mask, cpu_online_mask) {
+		if (this_cpu == cpu)
+			continue;
+		
+		xen_smp_send_call_function_single_ipi(cpu);
+	}
+}
+
+void xen_send_IPI_allbutself(int vector)
+{
+	xen_send_IPI_mask_allbutself(cpu_online_mask, vector);
+}
+
+
 static irqreturn_t xen_call_function_interrupt(int irq, void *dev_id)
 {
 	irq_enter();
diff --git a/arch/x86/xen/smp.h b/arch/x86/xen/smp.h
new file mode 100644
index 0000000..8981a76
--- /dev/null
+++ b/arch/x86/xen/smp.h
@@ -0,0 +1,12 @@
+#ifndef _XEN_SMP_H
+
+extern void xen_send_IPI_mask(const struct cpumask *mask,
+			      int vector);
+extern void xen_send_IPI_mask_allbutself(const struct cpumask *mask,
+				int vector);
+extern void xen_send_IPI_allbutself(int vector);
+extern void physflat_send_IPI_allbutself(int vector);
+extern void xen_send_IPI_all(int vector);
+extern void xen_send_IPI_self(int vector);
+
+#endif
diff --git a/drivers/tty/hvc/hvc_console.c b/drivers/tty/hvc/hvc_console.c
index 58ca7ce..4addc80 100644
--- a/drivers/tty/hvc/hvc_console.c
+++ b/drivers/tty/hvc/hvc_console.c
@@ -754,13 +754,10 @@ int hvc_poll_init(struct tty_driver *driver, int
line, char *options)

 static int hvc_poll_get_char(struct tty_driver *driver, int line)
 {
-	struct tty_struct *tty = driver->ttys[0];
-	struct hvc_struct *hp = tty->driver_data;
 	int n;
 	char ch;

-	n = hp->ops->get_chars(hp->vtermno, &ch, 1);
-
+	n = cons_ops[last_hvc]->get_chars(vtermnos[last_hvc], &ch, 1);
 	if (n == 0)
 		return NO_POLL_CHAR;

@@ -769,12 +766,10 @@ static int hvc_poll_get_char(struct tty_driver
*driver, int line)

 static void hvc_poll_put_char(struct tty_driver *driver, int line, char ch)
 {
-	struct tty_struct *tty = driver->ttys[0];
-	struct hvc_struct *hp = tty->driver_data;
 	int n;

 	do {
-		n = hp->ops->put_chars(hp->vtermno, &ch, 1);
+		n = cons_ops[last_hvc]->put_chars(vtermnos[last_hvc], &ch, 1);
 	} while (n <= 0);
 }
 #endif
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index cefd4a1..df904a5 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -581,12 +581,14 @@ return_normal:
 		kgdb_roundup_cpus(flags);
 #endif

+#ifndef CONFIG_XEN
 	/*
 	 * Wait for the other CPUs to be notified and be waiting for us:
 	 */
 	while (kgdb_do_roundup && (atomic_read(&masters_in_kgdb) +
 				atomic_read(&slaves_in_kgdb)) != online_cpus)
 		cpu_relax();
+#endif

 	/*
 	 * At this point the primary processor is completely



On Fri, Feb 10, 2012 at 2:04 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
>
> On Fri, Feb 10, 2012 at 06:28:21PM +0100, Peter Zijlstra wrote:
> > On Thu, 2012-02-09 at 18:32 -0800, Steven Noonan wrote:
> > > [   88.517599]  [<ffffffff81085a86>] smp_call_function_single+0xec/0xfd
> >
> > This looks like its waiting for an IPI to complete..
>
> Hmm, Ben you tried some kdb debugging using Xen and ran in some IPI issues
> didn't you? Do you remember what was the problem?
>
> >
> > There's no actual BUGS or WARNs in the output, just the soft lockup
> > thing saying things are taking a bit of time (clearly 15s waiting for an
> > IPI isn't quite normal).
> >
> > I've no idea why this wouldn't work on Xen, nor do the trace have any
> > Xen specific muck in them.
>
