Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757760Ab0JRVV2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 17:21:28 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42380 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754955Ab0JRVV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 17:21:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=c8o1pLLtX+CyZ8P7LZNwmnY42S+thj+EAywRGjKYRPENBQMKQMwQmPhSC5PbJGjv4N
         /u1L+KMM5b/dHsaCAFUUM9oy/rQG7i13apb8USuFEw+GWM4ySu9vn0hLQtjnDbxFTn4w
         MTvpN7e2SAg28KLUzH/eRhAFQAAmVpCAbZ/DQ=
Date: Tue, 19 Oct 2010 01:21:23 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip] x86, io-apic: Simplify ioapic_register_intr
Message-ID: <20101018212123.GA6545@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of setting IRQ_LEVEL flag early and then check for
IRQ being remapped and spread set_irq_chip_and_handler_name
over function body several times, defer IRQ_LEVEL setting
and save irq_chip in local variable with subsequent call depending
on IRQ level. This seems to be more natural and easier to read
in result.

And 'trigger' parameter has int type, not long.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

Please review, thanks! Complains are welcome.

 arch/x86/kernel/apic/io_apic.c |   37 ++++++++++++++-----------------------
 1 files changed, 14 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 98c27b3..af5c911 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1228,35 +1228,26 @@ static inline int IO_APIC_irq_trigger(int irq)
 }
 #endif
 
-static void ioapic_register_intr(unsigned int irq, unsigned long trigger)
+static void ioapic_register_intr(unsigned int irq, int trigger)
 {
-
-	if ((trigger == IOAPIC_AUTO && IO_APIC_irq_trigger(irq)) ||
-	    trigger == IOAPIC_LEVEL)
-		irq_set_status_flags(irq, IRQ_LEVEL);
-	else
-		irq_clear_status_flags(irq, IRQ_LEVEL);
+	struct irq_chip *chip;
 
 	if (irq_remapped(get_irq_chip_data(irq))) {
 		irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
-		if (trigger)
-			set_irq_chip_and_handler_name(irq, &ir_ioapic_chip,
-						      handle_fasteoi_irq,
-						     "fasteoi");
-		else
-			set_irq_chip_and_handler_name(irq, &ir_ioapic_chip,
-						      handle_edge_irq, "edge");
-		return;
-	}
+		chip = &ir_ioapic_chip;
+	} else
+		chip = &ioapic_chip;
 
 	if ((trigger == IOAPIC_AUTO && IO_APIC_irq_trigger(irq)) ||
-	    trigger == IOAPIC_LEVEL)
-		set_irq_chip_and_handler_name(irq, &ioapic_chip,
-					      handle_fasteoi_irq,
-					      "fasteoi");
-	else
-		set_irq_chip_and_handler_name(irq, &ioapic_chip,
-					      handle_edge_irq, "edge");
+		trigger == IOAPIC_LEVEL) {
+		irq_set_status_flags(irq, IRQ_LEVEL);
+		set_irq_chip_and_handler_name(irq, chip,
+				handle_fasteoi_irq, "fasteoi");
+	} else {
+		irq_clear_status_flags(irq, IRQ_LEVEL);
+		set_irq_chip_and_handler_name(irq, chip,
+				 handle_edge_irq, "edge");
+	}
 }
 
 static int setup_ioapic_entry(int apic_id, int irq,
-- 
1.7.3

