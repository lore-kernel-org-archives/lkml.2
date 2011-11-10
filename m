Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934465Ab1KJNMP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 08:12:15 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:57061 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932585Ab1KJNMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 08:12:14 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 2/2] serial, mfd: don't hardcode the console
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Thu, 10 Nov 2011 13:18:09 +0000
Message-ID: <20111110131807.13023.54577.stgit@bob.linux.org.uk>
In-Reply-To: <20111110131752.13023.60767.stgit@bob.linux.org.uk>
References: <20111110131752.13023.60767.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

Add support to specify which HSU port to use as an early console. This can
be selected by passing "earlyprintk=hsu<n>" on the kernel command line. By
default port 0 is still used.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 arch/x86/include/asm/mrst.h                |    2 +-
 arch/x86/kernel/early_printk.c             |    2 +-
 arch/x86/platform/mrst/early_printk_mrst.c |   16 ++++++++++++----
 drivers/tty/serial/mfd.c                   |   18 +++++++-----------
 4 files changed, 21 insertions(+), 17 deletions(-)


diff --git a/arch/x86/include/asm/mrst.h b/arch/x86/include/asm/mrst.h
index 719f00b..4707760 100644
--- a/arch/x86/include/asm/mrst.h
+++ b/arch/x86/include/asm/mrst.h
@@ -51,7 +51,7 @@ extern struct console early_mrst_console;
 extern void mrst_early_console_init(void);
 
 extern struct console early_hsu_console;
-extern void hsu_early_console_init(void);
+extern void hsu_early_console_init(const char *);
 
 extern void intel_scu_devices_create(void);
 extern void intel_scu_devices_destroy(void);
diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index cd28a35..9d42a52 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -247,7 +247,7 @@ static int __init setup_early_printk(char *buf)
 		}
 
 		if (!strncmp(buf, "hsu", 3)) {
-			hsu_early_console_init();
+			hsu_early_console_init(buf + 3);
 			early_console_register(&early_hsu_console, keep);
 		}
 #endif
diff --git a/arch/x86/platform/mrst/early_printk_mrst.c b/arch/x86/platform/mrst/early_printk_mrst.c
index 25bfdbb..3c6e328 100644
--- a/arch/x86/platform/mrst/early_printk_mrst.c
+++ b/arch/x86/platform/mrst/early_printk_mrst.c
@@ -245,16 +245,24 @@ struct console early_mrst_console = {
  * Following is the early console based on Medfield HSU (High
  * Speed UART) device.
  */
-#define HSU_PORT2_PADDR		0xffa28180
+#define HSU_PORT_BASE		0xffa28080
 
 static void __iomem *phsu;
 
-void hsu_early_console_init(void)
+void hsu_early_console_init(const char *s)
 {
+	unsigned long paddr, port = 0;
 	u8 lcr;
 
-	phsu = (void *)set_fixmap_offset_nocache(FIX_EARLYCON_MEM_BASE,
-							HSU_PORT2_PADDR);
+	/*
+	 * Select the early HSU console port if specified by user in the
+	 * kernel command line.
+	 */
+	if (*s && !kstrtoul(s, 10, &port))
+		port = clamp_val(port, 0, 2);
+
+	paddr = HSU_PORT_BASE + port * 0x80;
+	phsu = (void *)set_fixmap_offset_nocache(FIX_EARLYCON_MEM_BASE, paddr);
 
 	/* Disable FIFO */
 	writeb(0x0, phsu + UART_FCR);
diff --git a/drivers/tty/serial/mfd.c b/drivers/tty/serial/mfd.c
index e272d39..a9234ba 100644
--- a/drivers/tty/serial/mfd.c
+++ b/drivers/tty/serial/mfd.c
@@ -1154,7 +1154,6 @@ serial_hsu_console_setup(struct console *co, char *options)
 	int bits = 8;
 	int parity = 'n';
 	int flow = 'n';
-	int ret;
 
 	if (co->index == -1 || co->index >= serial_hsu_reg.nr)
 		co->index = 0;
@@ -1165,9 +1164,7 @@ serial_hsu_console_setup(struct console *co, char *options)
 	if (options)
 		uart_parse_options(options, &baud, &parity, &bits, &flow);
 
-	ret = uart_set_options(&up->port, co, baud, parity, bits, flow);
-
-	return ret;
+	return uart_set_options(&up->port, co, baud, parity, bits, flow);
 }
 
 static struct console serial_hsu_console = {
@@ -1176,9 +1173,13 @@ static struct console serial_hsu_console = {
 	.device		= uart_console_device,
 	.setup		= serial_hsu_console_setup,
 	.flags		= CON_PRINTBUFFER,
-	.index		= 2,
+	.index		= -1,
 	.data		= &serial_hsu_reg,
 };
+
+#define SERIAL_HSU_CONSOLE	(&serial_hsu_console)
+#else
+#define SERIAL_HSU_CONSOLE	NULL
 #endif
 
 struct uart_ops serial_hsu_pops = {
@@ -1208,6 +1209,7 @@ static struct uart_driver serial_hsu_reg = {
 	.major		= TTY_MAJOR,
 	.minor		= 128,
 	.nr		= 3,
+	.cons		= SERIAL_HSU_CONSOLE,
 };
 
 #ifdef CONFIG_PM
@@ -1342,12 +1344,6 @@ static int serial_hsu_probe(struct pci_dev *pdev,
 		}
 		uart_add_one_port(&serial_hsu_reg, &uport->port);
 
-#ifdef CONFIG_SERIAL_MFD_HSU_CONSOLE
-		if (index == 2) {
-			register_console(&serial_hsu_console);
-			uport->port.cons = &serial_hsu_console;
-		}
-#endif
 		pci_set_drvdata(pdev, uport);
 	}
 

