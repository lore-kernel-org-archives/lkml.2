Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849Ab1GXH2a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 03:28:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37096 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181Ab1GXH20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 03:28:26 -0400
Date: Sun, 24 Jul 2011 09:27:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Drake <dsd@laptop.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org,
        Andres Salomon <dilinger@queued.net>, tglx@linutronix.de,
        x86@kernel.org
Subject: Re: OLPC power management patches - merge for 3.1?
Message-ID: <20110724072729.GA21281@elte.hu>
References: <CAGq3pz4VHgagUQ+jGJdt9LL4UnFt+CDgcLLXbuVeKfWMc=0wAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGq3pz4VHgagUQ+jGJdt9LL4UnFt+CDgcLLXbuVeKfWMc=0wAA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Drake <dsd@laptop.org> wrote:

> Hi,
> 
> Many thanks for committing the OLPC power management patches to
> linux-tip a few weeks ago.
> 
> Even though they were never merged into the master branch of linux-tip

it's excluded because in testing i found a boot crash with it.  
Thomas did a quick fix for it but i have not heard about it since 
then - Thomas/Peter, is this all resolved in x86/olpc?

(There's also the build failure Randy reported.)

> (where I presume linux-next pulls from), they have been included in 
> linux-next for even longer via Andrew Morton's tree.

Andrew probably thought they were missed - they werent.

Thanks,

	Ingo

------------->
Subject: drivers/serial/apbuart: Fix boot crash
From: Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 16 Dec 2010 12:38:03 +0100

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/serial/apbuart.c |   58 ++++++++++++++++++-----------------------------
 1 file changed, 23 insertions(+), 35 deletions(-)

Index: linux-2.6-tip/drivers/serial/apbuart.c
===================================================================
--- linux-2.6-tip.orig/drivers/serial/apbuart.c
+++ linux-2.6-tip/drivers/serial/apbuart.c
@@ -593,71 +593,57 @@ static struct of_platform_driver grlib_a
 };
 
 
-static void grlib_apbuart_configure(void)
+static int grlib_apbuart_configure(void)
 {
-	static int enum_done;
 	struct device_node *np, *rp;
-	struct uart_port *port = NULL;
 	const u32 *prop;
-	int freq_khz;
-	int v = 0, d = 0;
-	unsigned int addr;
-	int irq, line;
-	struct amba_prom_registers *regs;
-
-	if (enum_done)
-		return;
+	int freq_khz, line = 0;
 
 	/* Get bus frequency */
 	rp = of_find_node_by_path("/");
+	if (!rp)
+		return -ENODEV;
 	rp = of_get_next_child(rp, NULL);
+	if (!rp)
+		return -ENODEV;
 	prop = of_get_property(rp, "clock-frequency", NULL);
+	if (!prop)
+		return -ENODEV;
 	freq_khz = *prop;
 
-	line = 0;
 	for_each_matching_node(np, apbuart_match) {
+		const int *irqs = of_get_property(np, "interrupts", NULL);
+		const struct amba_prom_registers *regs;
+		struct uart_port *port;
 
-		int *vendor = (int *) of_get_property(np, "vendor", NULL);
-		int *device = (int *) of_get_property(np, "device", NULL);
-		int *irqs = (int *) of_get_property(np, "interrupts", NULL);
-		regs = (struct amba_prom_registers *)
-		    of_get_property(np, "reg", NULL);
-
-		if (vendor)
-			v = *vendor;
-		if (device)
-			d = *device;
+		regs = of_get_property(np, "reg", NULL);
 
 		if (!irqs || !regs)
-			return;
+			return -ENODEV;
 
 		grlib_apbuart_nodes[line] = np;
 
-		addr = regs->phys_addr;
-		irq = *irqs;
-
 		port = &grlib_apbuart_ports[line];
-
-		port->mapbase = addr;
-		port->membase = ioremap(addr, sizeof(struct grlib_apbuart_regs_map));
-		port->irq = irq;
+		port->mapbase = regs->phys_addr;
+		port->membase = ioremap(regs->phys_addr,
+					sizeof(struct grlib_apbuart_regs_map));
+		port->irq = *irqs;
 		port->iotype = UPIO_MEM;
 		port->ops = &grlib_apbuart_ops;
 		port->flags = UPF_BOOT_AUTOCONF;
 		port->line = line;
 		port->uartclk = freq_khz * 1000;
-		port->fifosize = apbuart_scan_fifo_size((struct uart_port *) port, line);
+		port->fifosize =
+			apbuart_scan_fifo_size((struct uart_port *) port, line);
 		line++;
 
 		/* We support maximum UART_NR uarts ... */
 		if (line == UART_NR)
 			break;
-
 	}
 
-	enum_done = 1;
-
 	grlib_apbuart_driver.nr = grlib_apbuart_port_nr = line;
+	return line ? 0 : -ENODEV;
 }
 
 static int __init grlib_apbuart_init(void)
@@ -665,7 +651,9 @@ static int __init grlib_apbuart_init(voi
 	int ret;
 
 	/* Find all APBUARTS in device the tree and initialize their ports */
-	grlib_apbuart_configure();
+	ret = grlib_apbuart_configure();
+	if (ret)
+		return ret;
 
 	printk(KERN_INFO "Serial: GRLIB APBUART driver\n");
 
