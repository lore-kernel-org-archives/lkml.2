Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab1AFWZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:25:53 -0500
Received: from kroah.org ([198.145.64.141]:55712 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754622Ab1AFWYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 17:24:02 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kristoffer Glembo <kristoffer@gaisler.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 33/36] drivers: serial: apbuart: Handle OF failures gracefully
Date: Thu,  6 Jan 2011 14:23:22 -0800
Message-Id: <1294352605-31906-33-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110106215404.GA30624@kroah.com>
References: <20110106215404.GA30624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

The apbuart driver depends on OF and relies on everything being
available. So if it's probed on a platform which has OF support, but
no device tree is available it crashes. Triggered by the upcoming x86
OF support in randconfig testing.

Further it's inconsistent vs. the probing and exiting from the
of_match loop.

Make it robust and consistent:

 - check the availablility of OF nodes before dereferencing
 - return -ENODEV when the device tree lookup fails
 - return -ENODEV when no uart port configuration is found
 - return -ENODEV when invalid uart port configuration is found

Remove the enum_done check while at it. Driver init functions are only
called once. Remove the pointless vendor and device queries as well.

Reported-by: Ingo Molnar <mingo.elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Kristoffer Glembo <kristoffer@gaisler.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/apbuart.c |   48 ++++++++++++++++++---------------------------
 1 files changed, 19 insertions(+), 29 deletions(-)

diff --git a/drivers/serial/apbuart.c b/drivers/serial/apbuart.c
index cc01c65..2e84d9c 100644
--- a/drivers/serial/apbuart.c
+++ b/drivers/serial/apbuart.c
@@ -593,54 +593,44 @@ static struct of_platform_driver grlib_apbuart_of_driver = {
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
+		unsigned long addr;
 
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
 
 		addr = regs->phys_addr;
-		irq = *irqs;
 
 		port = &grlib_apbuart_ports[line];
 
 		port->mapbase = addr;
 		port->membase = ioremap(addr, sizeof(struct grlib_apbuart_regs_map));
-		port->irq = irq;
+		port->irq = *irqs;
 		port->iotype = UPIO_MEM;
 		port->ops = &grlib_apbuart_ops;
 		port->flags = UPF_BOOT_AUTOCONF;
@@ -652,12 +642,10 @@ static void grlib_apbuart_configure(void)
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
@@ -665,7 +653,9 @@ static int __init grlib_apbuart_init(void)
 	int ret;
 
 	/* Find all APBUARTS in device the tree and initialize their ports */
-	grlib_apbuart_configure();
+	ret = grlib_apbuart_configure();
+	if (ret)
+		return ret;
 
 	printk(KERN_INFO "Serial: GRLIB APBUART driver\n");
 
-- 
1.7.3.2

