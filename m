Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab2A3Vha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 16:37:30 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44901 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932Ab2A3Vh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 16:37:28 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jeroen.vandenkeybus@gmail.com designates 10.68.218.68 as permitted sender) smtp.mail=jeroen.vandenkeybus@gmail.com; dkim=pass header.i=jeroen.vandenkeybus@gmail.com
MIME-Version: 1.0
Date: Mon, 30 Jan 2012 22:37:28 +0100
Message-ID: <CAPRPZsAt+e3cy1YTriikpb2SNN=jOusvnPF0ByFeun+uaBa5Og@mail.gmail.com>
Subject: [PATCH] Unhandled IRQs on AMD E-450: temporarily switch to
 low-performance polling IRQ mode
From: Jeroen Van den Keybus <jeroen.vandenkeybus@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Clemens Ladisch <clemens@ladisch.de>, "Huang, Shane" <Shane.Huang@amd.com>,
        Borislav Petkov <bp@amd64.org>, "Nguyen, Dong" <Dong.Nguyen@amd.com>,
        jesse.brandeburg@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that some motherboard designs using the ASM1083 PCI/PCIe
bridge (PCI device ID 1b21:1080, Rev. 01) suffer from stuck IRQ lines
on the PCI bus (causing the kernel to emit 'IRQxx: nobody cared' and
disable the IRQ). The following patch is an attempt to mitigate the
serious impact of permanently disabling an IRQ in that case and
actually make PCI devices better usable on this platform.

It seems that the bridge fails to issue a IRQ deassertion message on
the PCIe bus, when the relevant driver causes the interrupting PCI
device to deassert its IRQ line. To solve this issue, it was tried to
re-issue an IRQ on a PCI device being able to do so (e1000 in this
case), but we suspect that the attempt to re-assert/deassert may have
occurred too soon after the initial IRQ for the ASM1083. Anyway, it
didn't work but if, after some delay, a new IRQ occurred, the related
IRQ deassertion message eventually did clear the IOAPIC IRQ. It would
be useful to re-enable the IRQ here.

Therefore the patch below to poll_spurious_irqs() in spurious.c is
proposed, It does the following:

1. lets the kernel decide that an IRQ is unhandled after only 10
positives (instead of 100,000);
2. briefly (a few seconds or so, currently 1 s) switches to polling
IRQ at a higher rate than usual (100..1,000Hz instead of 10Hz,
currently 100Hz), but not too high to avoid excessive CPU load. Any
device drivers 'see' their interrupts handled with a higher latency
than usual, but they will still operate properly;
3. afterwards, simply reenable the IRQ.

If proper operation of the PCIe legacy IRQ line emulation is restored
after 3, the system operates again at normal performance. If the IRQ
is still stuck after this procedure, the sequence repeats.

If a genuinely stuck IRQ is used with this solution, the system would
simply sustain short bursts of 10 unhandled IRQs per second, and use
polling mode indefinitely at a moderate 100Hz rate. It seemed a good
alternative to the default irqpoll behaviour to me, which is why I
left it in poll_spurious_irqs() (instead of creating a new kernel
option). Additionally, if any device happens to share an IRQ with a
faulty one, that device is no longer banned forever.

Debugging output is still present and may be removed. Bad IRQ
reporting is also commented out now.

I have now tried it for about 2 months and I can conclude the following:

1. The patch works and, judging from my Firewire card interrupt on
IRQ16, which repeats every 64 secs, I can confirm that the IRQ usually
gets reset when a new IRQ arrives (polling mode runs for 64 seconds
every time).
2. When testing a SiL-3114 SATA PCI card behind the ASM1083, I could
keep this running at fairly high speeds (50..70MB/s) for an hour or
so, but eventually the SiL driver crashed. In such conditions the PCI
system had to deal with a few hundred IRQs per second / polling mode
kicking in every 5..10 seconds).

I would like to thank Clemens Ladisch for his invaluable help in
finding a solution (and providing a patch to avoid my SATA going down
every time during debugging).


Signed-off-by: Jeroen Van den Keybus <jeroen.vandenkeybus@gmail.com>
======

diff -up linux-3.2-rc4.orig/kernel/irq/spurious.c
linux-3.2-rc4/kernel/irq/spurious.c
--- linux-3.2-rc4.orig/kernel/irq/spurious.c	2011-12-01 23:56:01.000000000 +0100
+++ linux-3.2-rc4/kernel/irq/spurious.c	2011-12-11 16:14:48.188377387 +0100
@@ -18,7 +18,7 @@

 static int irqfixup __read_mostly;

-#define POLL_SPURIOUS_IRQ_INTERVAL (HZ/10)
+#define POLL_SPURIOUS_IRQ_INTERVAL (HZ/100)
 static void poll_spurious_irqs(unsigned long dummy);
 static DEFINE_TIMER(poll_spurious_irq_timer, poll_spurious_irqs, 0, 0);
 static int irq_poll_cpu;
@@ -141,14 +141,15 @@ out:
 static void poll_spurious_irqs(unsigned long dummy)
 {
 	struct irq_desc *desc;
-	int i;
+	int i, poll_again;

 	if (atomic_inc_return(&irq_poll_active) != 1)
 		goto out;
 	irq_poll_cpu = smp_processor_id();

+	poll_again = 0; /* Will stay false as long as no polling candidate is found */
 	for_each_irq_desc(i, desc) {
-		unsigned int state;
+		unsigned int state, irq;

 		if (!i)
 			 continue;
@@ -158,15 +159,33 @@ static void poll_spurious_irqs(unsigned
 		barrier();
 		if (!(state & IRQS_SPURIOUS_DISABLED))
 			continue;2
-
-		local_irq_disable();
-		try_one_irq(i, desc, true);
-		local_irq_enable();
+		
+		/* We end up here with a disabled spurious interrupt.
+		   desc->irqs_unhandled now tracks the number of times
+		   the interrupt has been polled */
+
+		irq = desc->irq_data.irq;
+		if (desc->irqs_unhandled < 100) { /* 1 second delay with poll
frequency 100 Hz */
+			if (desc->irqs_unhandled == 0)
+				printk("Polling IRQ %d\n", irq);
+			local_irq_disable();
+			try_one_irq(i, desc, true);
+			local_irq_enable();
+			desc->irqs_unhandled++;
+			poll_again = 1;
+		} else {
+			printk("Reenabling IRQ %d\n", irq);
+			irq_enable(desc); /* Reenable the interrupt line */
+			desc->depth--;
+			desc->istate &= (~IRQS_SPURIOUS_DISABLED);
+			desc->irqs_unhandled = 0;
+		}
 	}
+	if (poll_again)
+		mod_timer(&poll_spurious_irq_timer,
+			  jiffies + POLL_SPURIOUS_IRQ_INTERVAL);
 out:
 	atomic_dec(&irq_poll_active);
-	mod_timer(&poll_spurious_irq_timer,
-		  jiffies + POLL_SPURIOUS_IRQ_INTERVAL);
 }

 static inline int bad_action_ret(irqreturn_t action_ret)
@@ -177,11 +196,19 @@ static inline int bad_action_ret(irqretu
 }

 /*
- * If 99,900 of the previous 100,000 interrupts have not been handled
+ * If 9 of the previous 10 interrupts have not been handled
  * then assume that the IRQ is stuck in some manner. Drop a diagnostic
  * and try to turn the IRQ off.
  *
- * (The other 100-of-100,000 interrupts may have been a correctly
+ * Although this may cause early deactivation of a sporadically
+ * malfunctioning IRQ line, the poll system will:
+ * a) Poll it for 100 cycles at a 100 Hz rate
+ * b) Reenable it afterwards
+ *
+ * In worst case, with current settings,  this will cause short bursts
+ * of 10 interrupts every second.
+ *
+ * (The other single interrupt may have been a correctly
  *  functioning device sharing an IRQ with the failing one)
  */
 static void
@@ -302,19 +329,19 @@ void note_interrupt(unsigned int irq, st
 	}

 	desc->irq_count++;
-	if (likely(desc->irq_count < 100000))
+	if (likely(desc->irq_count < 10))
 		return;

 	desc->irq_count = 0;
-	if (unlikely(desc->irqs_unhandled > 99900)) {
+	if (unlikely(desc->irqs_unhandled >= 9)) {
 		/*
 		 * The interrupt is stuck
 		 */
-		__report_bad_irq(irq, desc, action_ret);
+		/* __report_bad_irq(irq, desc, action_ret); */
 		/*
 		 * Now kill the IRQ
 		 */
-		printk(KERN_EMERG "Disabling IRQ #%d\n", irq);
+		printk(KERN_EMERG "Disabling IRQ %d\n", irq);
 		desc->istate |= IRQS_SPURIOUS_DISABLED;
 		desc->depth++;
 		irq_disable(desc);

======
