Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106Ab1IUJbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 05:31:17 -0400
Received: from mail-wy0-f180.google.com ([74.125.82.180]:49741 "EHLO
	mail-wy0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071Ab1IUJbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 05:31:15 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, yong.zhang0@gmail.com,
        David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Mark Salter <msalter@redhat.com>, John Stultz <johnstul@us.ibm.com>,
        Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-am33-list@redhat.com
Subject: [PATCH 13/57] mn10300: irq: Remove IRQF_DISABLED
Date: Wed, 21 Sep 2011 17:28:14 +0800
Message-Id: <1316597339-29861-14-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316597339-29861-1-git-send-email-yong.zhang0@gmail.com>
References: <1316597339-29861-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit [c58543c8: genirq: Run irq handlers with interrupts disabled],
We run all interrupt handlers with interrupts disabled
and we even check and yell when an interrupt handler
returns with interrupts enabled (see commit [b738a50a:
genirq: Warn when handler enables interrupts]).

So now this flag is a NOOP and can be removed.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Acked-by: David Howells <dhowells@redhat.com>
---
 arch/mn10300/kernel/cevt-mn10300.c   |    2 +-
 arch/mn10300/kernel/mn10300-serial.c |    6 +++---
 arch/mn10300/kernel/smp.c            |    1 -
 arch/mn10300/unit-asb2364/irq-fpga.c |    2 +-
 4 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/mn10300/kernel/cevt-mn10300.c b/arch/mn10300/kernel/cevt-mn10300.c
index 69cae02..2415b76 100644
--- a/arch/mn10300/kernel/cevt-mn10300.c
+++ b/arch/mn10300/kernel/cevt-mn10300.c
@@ -103,7 +103,7 @@ int __init init_clockevents(void)
 	cd->set_next_event	= next_event;
 
 	iact = &per_cpu(timer_irq, cpu);
-	iact->flags = IRQF_DISABLED | IRQF_SHARED | IRQF_TIMER;
+	iact->flags = IRQF_SHARED | IRQF_TIMER;
 	iact->handler = timer_interrupt;
 
 	clockevents_register_device(cd);
diff --git a/arch/mn10300/kernel/mn10300-serial.c b/arch/mn10300/kernel/mn10300-serial.c
index 94901c5..6644c0d 100644
--- a/arch/mn10300/kernel/mn10300-serial.c
+++ b/arch/mn10300/kernel/mn10300-serial.c
@@ -936,15 +936,15 @@ static int mn10300_serial_startup(struct uart_port *_port)
 	irq_set_chip(port->tm_irq, &mn10300_serial_pic);
 
 	if (request_irq(port->rx_irq, mn10300_serial_interrupt,
-			IRQF_DISABLED, port->rx_name, port) < 0)
+			0, port->rx_name, port) < 0)
 		goto error;
 
 	if (request_irq(port->tx_irq, mn10300_serial_interrupt,
-			IRQF_DISABLED, port->tx_name, port) < 0)
+			0, port->tx_name, port) < 0)
 		goto error2;
 
 	if (request_irq(port->tm_irq, mn10300_serial_interrupt,
-			IRQF_DISABLED, port->tm_name, port) < 0)
+			0, port->tm_name, port) < 0)
 		goto error3;
 	mn10300_serial_mask_ack(port->tm_irq);
 
diff --git a/arch/mn10300/kernel/smp.c b/arch/mn10300/kernel/smp.c
index 9242e9f..6159ad8 100644
--- a/arch/mn10300/kernel/smp.c
+++ b/arch/mn10300/kernel/smp.c
@@ -142,7 +142,6 @@ static struct irqaction call_function_ipi = {
 static irqreturn_t smp_ipi_timer_interrupt(int irq, void *dev_id);
 static struct irqaction local_timer_ipi = {
 	.handler	= smp_ipi_timer_interrupt,
-	.flags		= IRQF_DISABLED,
 	.name		= "smp local timer IPI"
 };
 #endif
diff --git a/arch/mn10300/unit-asb2364/irq-fpga.c b/arch/mn10300/unit-asb2364/irq-fpga.c
index e16c216..073e2cc 100644
--- a/arch/mn10300/unit-asb2364/irq-fpga.c
+++ b/arch/mn10300/unit-asb2364/irq-fpga.c
@@ -76,7 +76,7 @@ static irqreturn_t fpga_interrupt(int irq, void *_mask)
 static struct irqaction fpga_irq[]  = {
 	[0] = {
 		.handler	= fpga_interrupt,
-		.flags		= IRQF_DISABLED | IRQF_SHARED,
+		.flags		= IRQF_SHARED,
 		.name		= "fpga",
 	},
 };
-- 
1.7.4.1

