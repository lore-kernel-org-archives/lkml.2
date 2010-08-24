Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045Ab0HXVfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 17:35:46 -0400
Received: from claw.goop.org ([74.207.240.146]:60613 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755993Ab0HXVfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 17:35:43 -0400
Message-ID: <4C743B2C.8070208@goop.org>
Date: Tue, 24 Aug 2010 14:35:40 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Tom Kopec <tek@acm.org>, Daniel Stodden <daniel.stodden@citrix.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Stable Kernel <stable@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Fix lost interrupt race in Xen event channels
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Hi Linus,

This pair of patches fixes a long-standing bug whose most noticeable
symptom was that the Xen blkfront driver would hang up very occasionally
(sometimes never, sometimes after weeks or months of uptime).

We worked out the root cause was that it was incorrectly treating Xen
events as level rather than edge triggered interrupts, which works fine
unless you're handling one interrupt, the interrupt gets migrated to
another cpu and then re-raised.  This ends up losing the interrupt
because the edge-triggering of the second interrupt is lost.

The other change changes IPI and VIRQ event sources to use
handle_percpu_irq, because treating them as level is also wrong, and
they're actually inherently percpu events, much like LAPIC vectors.

I'd like to get this fix into the current kernel and into stable sooner
rather than later.

Thanks,
    J

The following changes since commit 76be97c1fc945db08aae1f1b746012662d643e97:

  Linux 2.6.36-rc2 (2010-08-22 17:43:29 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git upstream/core

Jeremy Fitzhardinge (2):
      xen: use percpu interrupts for IPIs and VIRQs
      xen: handle events as edge-triggered

 drivers/xen/events.c |   21 ++++++++++++++++-----
 1 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 72f91bf..13365ba 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -112,6 +112,7 @@ static inline unsigned long *cpu_evtchn_mask(int cpu)
 #define VALID_EVTCHN(chn)	((chn) != 0)
 
 static struct irq_chip xen_dynamic_chip;
+static struct irq_chip xen_percpu_chip;
 
 /* Constructor for packed IRQ information. */
 static struct irq_info mk_unbound_info(void)
@@ -377,7 +378,7 @@ int bind_evtchn_to_irq(unsigned int evtchn)
 		irq = find_unbound_irq();
 
 		set_irq_chip_and_handler_name(irq, &xen_dynamic_chip,
-					      handle_level_irq, "event");
+					      handle_edge_irq, "event");
 
 		evtchn_to_irq[evtchn] = irq;
 		irq_info[irq] = mk_evtchn_info(evtchn);
@@ -403,8 +404,8 @@ static int bind_ipi_to_irq(unsigned int ipi, unsigned int cpu)
 		if (irq < 0)
 			goto out;
 
-		set_irq_chip_and_handler_name(irq, &xen_dynamic_chip,
-					      handle_level_irq, "ipi");
+		set_irq_chip_and_handler_name(irq, &xen_percpu_chip,
+					      handle_percpu_irq, "ipi");
 
 		bind_ipi.vcpu = cpu;
 		if (HYPERVISOR_event_channel_op(EVTCHNOP_bind_ipi,
@@ -444,8 +445,8 @@ static int bind_virq_to_irq(unsigned int virq, unsigned int cpu)
 
 		irq = find_unbound_irq();
 
-		set_irq_chip_and_handler_name(irq, &xen_dynamic_chip,
-					      handle_level_irq, "virq");
+		set_irq_chip_and_handler_name(irq, &xen_percpu_chip,
+					      handle_percpu_irq, "virq");
 
 		evtchn_to_irq[evtchn] = irq;
 		irq_info[irq] = mk_virq_info(evtchn, virq);
@@ -964,6 +965,16 @@ static struct irq_chip xen_dynamic_chip __read_mostly = {
 	.retrigger	= retrigger_dynirq,
 };
 
+static struct irq_chip xen_percpu_chip __read_mostly = {
+	.name		= "xen-percpu",
+
+	.disable	= disable_dynirq,
+	.mask		= disable_dynirq,
+	.unmask		= enable_dynirq,
+
+	.ack		= ack_dynirq,
+};
+
 int xen_set_callback_via(uint64_t via)
 {
 	struct xen_hvm_param a;


