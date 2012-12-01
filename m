Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024Ab2LASFZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 13:05:25 -0500
Received: from mail.df.lth.se ([194.47.250.12]:57125 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675Ab2LASFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 13:05:24 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] irqdomain: update documentation
Date: Sat,  1 Dec 2012 19:05:16 +0100
Message-Id: <1354385116-18606-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This updates the IRQdomain documentation a bit, by adding a more
verbose explanation to why we need this, and by adding some
extended documentation of the irq_domain_simple() usecase.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 Documentation/IRQ-domain.txt | 34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/Documentation/IRQ-domain.txt b/Documentation/IRQ-domain.txt
index 1401cec..9bc9594 100644
--- a/Documentation/IRQ-domain.txt
+++ b/Documentation/IRQ-domain.txt
@@ -7,6 +7,21 @@ systems with multiple interrupt controllers the kernel must ensure
 that each one gets assigned non-overlapping allocations of Linux
 IRQ numbers.
 
+The number of interrupt controllers registered as unique irqchips
+show a rising tendency: for example subdrivers of different kinds
+such as GPIO controllers avoid reimplementing identical callback
+mechanisms as the IRQ core system by modelling their interrupt
+handlers as irqchips, i.e. in effect cascading interrupt controllers.
+
+Here the interrupt number loose all kind of correspondence to
+hardware interrupt numbers: whereas in the past, IRQ numbers could
+be chosen so they matched the hardware IRQ line into the root
+interrupt controller (i.e. the component actually fireing the
+interrupt line to the CPU) nowadays this number is just a number.
+
+For this reason we need a mechanism to separate controller-local
+interrupt numbers, called hardware irq's, from Linux IRQ numbers.
+
 The irq_alloc_desc*() and irq_free_desc*() APIs provide allocation of
 irq numbers, but they don't provide any support for reverse mapping of
 the controller-local IRQ (hwirq) number into the Linux IRQ number
@@ -40,6 +55,10 @@ required hardware setup.
 When an interrupt is received, irq_find_mapping() function should
 be used to find the Linux IRQ number from the hwirq number.
 
+The irq_create_mapping() function must be called *atleast once*
+before any call to irq_find_mapping(), lest the descriptor will not
+be allocated.
+
 If the driver has the Linux IRQ number or the irq_data pointer, and
 needs to know the associated hwirq number (such as in the irq_chip
 callbacks) then it can be directly obtained from irq_data->hwirq.
@@ -119,4 +138,17 @@ numbers.
 
 Most users of legacy mappings should use irq_domain_add_simple() which
 will use a legacy domain only if an IRQ range is supplied by the
-system and will otherwise use a linear domain mapping.
+system and will otherwise use a linear domain mapping. The semantics
+of this call are such that if an IRQ range is specified then
+descriptors will be allocated on-the-fly for it, and if no range is
+specified it will fall through to irq_domain_add_linear() which meand
+*no* irq descriptors will be allocated.
+
+A typical use case for simple domains is where an irqchip provider
+is supporting both dynamic and static IRQ assignments.
+
+In order to avoid ending up in a situation where a linear domain is
+used and no descriptor gets allocated it is very important to make sure
+that the driver using the simple domain call irq_create_mapping()
+before any irq_find_mapping() since the latter will actually work
+for the static IRQ assignment case.
-- 
1.7.11.7

