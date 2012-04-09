Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046Ab2DIHWG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 03:22:06 -0400
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:44040 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754354Ab2DIHWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 03:22:04 -0400
From: Tanmay Inamdar <tinamdar@apm.com>
To: benh@kernel.crashing.org, jwboyer@gmail.com, grant.likely@secretlab.ca,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: Tanmay Inamdar <tinamdar@apm.com>
Subject: [V2 5/5] powerpc: kernel: 16650 UART reg-shift support
Date: Mon,  9 Apr 2012 12:50:52 +0530
Message-Id: <1333956052-25319-5-git-send-email-tinamdar@apm.com>
X-Mailer: git-send-email 1.6.1.rc3
In-Reply-To: <1333956052-25319-4-git-send-email-tinamdar@apm.com>
References: <1333956052-25319-1-git-send-email-tinamdar@apm.com>
 <1333956052-25319-2-git-send-email-tinamdar@apm.com>
 <1333956052-25319-3-git-send-email-tinamdar@apm.com>
 <1333956052-25319-4-git-send-email-tinamdar@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In APM8018X SOC, UART register address space has been relocated to 32-bit
data boundaries for APB bus implementation.
Current legacy_serial driver ignores the reg-shift property. This patch
modifies legacy_serial.c and udbg_16550.c to work with above mentioned UARTs.

Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>
---
:100644 100644 8338aef... f5fc106... M	arch/powerpc/include/asm/udbg.h
:100644 100644 bedd12e... d523b7d... M	arch/powerpc/kernel/legacy_serial.c
:100644 100644 6837f83... e0cb7dc... M	arch/powerpc/kernel/udbg_16550.c
 arch/powerpc/include/asm/udbg.h     |    2 +-
 arch/powerpc/kernel/legacy_serial.c |   16 +++++---
 arch/powerpc/kernel/udbg_16550.c    |   64 ++++++++++++++++++++++------------
 3 files changed, 52 insertions(+), 30 deletions(-)

diff --git a/arch/powerpc/include/asm/udbg.h b/arch/powerpc/include/asm/udbg.h
index 8338aef..f5fc106 100644
--- a/arch/powerpc/include/asm/udbg.h
+++ b/arch/powerpc/include/asm/udbg.h
@@ -29,7 +29,7 @@ extern void udbg_printf(const char *fmt, ...)
 extern void udbg_progress(char *s, unsigned short hex);
 
 extern void udbg_init_uart(void __iomem *comport, unsigned int speed,
-			   unsigned int clock);
+			   unsigned int clock,  unsigned int regshift);
 extern unsigned int udbg_probe_uart_speed(void __iomem *comport,
 					  unsigned int clock);
 
diff --git a/arch/powerpc/kernel/legacy_serial.c b/arch/powerpc/kernel/legacy_serial.c
index bedd12e..d523b7d 100644
--- a/arch/powerpc/kernel/legacy_serial.c
+++ b/arch/powerpc/kernel/legacy_serial.c
@@ -33,6 +33,7 @@ static struct legacy_serial_info {
 	unsigned int			clock;
 	int				irq_check_parent;
 	phys_addr_t			taddr;
+	unsigned int			regshift;
 } legacy_serial_infos[MAX_LEGACY_SERIAL_PORTS];
 
 static struct __initdata of_device_id legacy_serial_parents[] = {
@@ -42,6 +43,7 @@ static struct __initdata of_device_id legacy_serial_parents[] = {
 	{.compatible = "ibm,opb",},
 	{.compatible = "simple-bus",},
 	{.compatible = "wrs,epld-localbus",},
+	{.compatible = "apm,apb",},
 	{},
 };
 
@@ -163,11 +165,6 @@ static int __init add_legacy_soc_port(struct device_node *np,
 	if (of_get_property(np, "clock-frequency", NULL) == NULL)
 		return -1;
 
-	/* if reg-shift or offset, don't try to use it */
-	if ((of_get_property(np, "reg-shift", NULL) != NULL) ||
-		(of_get_property(np, "reg-offset", NULL) != NULL))
-		return -1;
-
 	/* if rtas uses this device, don't try to use it as well */
 	if (of_get_property(np, "used-by-rtas", NULL) != NULL)
 		return -1;
@@ -319,7 +316,7 @@ static void __init setup_legacy_serial_console(int console)
 	if (info->speed == 0)
 		info->speed = udbg_probe_uart_speed(addr, info->clock);
 	DBG("default console speed = %d\n", info->speed);
-	udbg_init_uart(addr, info->speed, info->clock);
+	udbg_init_uart(addr, info->speed, info->clock, info->regshift);
 }
 
 /*
@@ -336,6 +333,7 @@ void __init find_legacy_serial_ports(void)
 	struct device_node *np, *stdout = NULL;
 	const char *path;
 	int index;
+	unsigned int regshift;
 
 	DBG(" -> find_legacy_serial_port()\n");
 
@@ -359,6 +357,12 @@ void __init find_legacy_serial_ports(void)
 				index = add_legacy_soc_port(np, np);
 				if (index >= 0 && np == stdout)
 					legacy_serial_console = index;
+				if (of_property_read_u32(np, "reg-shift",
+							&regshift) == 0) {
+					legacy_serial_infos
+					[legacy_serial_console].regshift =
+								regshift;
+				}
 			}
 		}
 		of_node_put(parent);
diff --git a/arch/powerpc/kernel/udbg_16550.c b/arch/powerpc/kernel/udbg_16550.c
index 6837f83..e0cb7dc 100644
--- a/arch/powerpc/kernel/udbg_16550.c
+++ b/arch/powerpc/kernel/udbg_16550.c
@@ -47,12 +47,29 @@ struct NS16550 {
 
 #define LCR_DLAB 0x80
 
+static unsigned int reg_shift;
+#define ns16550_offset(addr) (addr - (unsigned char *)udbg_comport)
+
 static struct NS16550 __iomem *udbg_comport;
 
+static inline u8 serial_read(unsigned char *addr)
+{
+	u32 offset = ns16550_offset(addr) << reg_shift;
+	return readb(udbg_comport + offset);
+}
+
+static inline void serial_write(unsigned char *addr, char val)
+{
+	u32 offset = ns16550_offset(addr) << reg_shift;
+	writeb(val, udbg_comport + offset);
+}
+
 static void udbg_550_flush(void)
 {
+	u32 timeout = 1000;
 	if (udbg_comport) {
-		while ((in_8(&udbg_comport->lsr) & LSR_THRE) == 0)
+		while (((serial_read(&udbg_comport->lsr) & LSR_THRE) == 0)
+							&& --timeout)
 			/* wait for idle */;
 	}
 }
@@ -63,15 +80,15 @@ static void udbg_550_putc(char c)
 		if (c == '\n')
 			udbg_550_putc('\r');
 		udbg_550_flush();
-		out_8(&udbg_comport->thr, c);
+		serial_write(&udbg_comport->thr, c);
 	}
 }
 
 static int udbg_550_getc_poll(void)
 {
 	if (udbg_comport) {
-		if ((in_8(&udbg_comport->lsr) & LSR_DR) != 0)
-			return in_8(&udbg_comport->rbr);
+		if ((serial_read(&udbg_comport->lsr) & LSR_DR) != 0)
+			return serial_read(&udbg_comport->rbr);
 		else
 			return -1;
 	}
@@ -81,15 +98,15 @@ static int udbg_550_getc_poll(void)
 static int udbg_550_getc(void)
 {
 	if (udbg_comport) {
-		while ((in_8(&udbg_comport->lsr) & LSR_DR) == 0)
+		while ((serial_read(&udbg_comport->lsr) & LSR_DR) == 0)
 			/* wait for char */;
-		return in_8(&udbg_comport->rbr);
+		return serial_read(&udbg_comport->rbr);
 	}
 	return -1;
 }
 
 void udbg_init_uart(void __iomem *comport, unsigned int speed,
-		    unsigned int clock)
+		    unsigned int clock, unsigned int regshift)
 {
 	unsigned int dll, base_bauds;
 
@@ -103,22 +120,23 @@ void udbg_init_uart(void __iomem *comport, unsigned int speed,
 
 	if (comport) {
 		udbg_comport = (struct NS16550 __iomem *)comport;
-		out_8(&udbg_comport->lcr, 0x00);
-		out_8(&udbg_comport->ier, 0xff);
-		out_8(&udbg_comport->ier, 0x00);
-		out_8(&udbg_comport->lcr, LCR_DLAB);
-		out_8(&udbg_comport->dll, dll & 0xff);
-		out_8(&udbg_comport->dlm, dll >> 8);
+		serial_write(&udbg_comport->lcr, 0x00);
+		serial_write(&udbg_comport->ier, 0xff);
+		serial_write(&udbg_comport->ier, 0x00);
+		serial_write(&udbg_comport->lcr, LCR_DLAB);
+		serial_write(&udbg_comport->dll, dll & 0xff);
+		serial_write(&udbg_comport->dlm, dll >> 8);
 		/* 8 data, 1 stop, no parity */
-		out_8(&udbg_comport->lcr, 0x03);
+		serial_write(&udbg_comport->lcr, 0x03);
 		/* RTS/DTR */
-		out_8(&udbg_comport->mcr, 0x03);
+		serial_write(&udbg_comport->mcr, 0x03);
 		/* Clear & enable FIFOs */
-		out_8(&udbg_comport->fcr ,0x07);
+		serial_write(&udbg_comport->fcr, 0x07);
 		udbg_putc = udbg_550_putc;
 		udbg_flush = udbg_550_flush;
 		udbg_getc = udbg_550_getc;
 		udbg_getc_poll = udbg_550_getc_poll;
+		reg_shift = regshift;
 	}
 }
 
@@ -128,24 +146,24 @@ unsigned int udbg_probe_uart_speed(void __iomem *comport, unsigned int clock)
 	u8 old_lcr;
 	struct NS16550 __iomem *port = comport;
 
-	old_lcr = in_8(&port->lcr);
+	old_lcr = serial_read(&port->lcr);
 
 	/* select divisor latch registers.  */
-	out_8(&port->lcr, LCR_DLAB);
+	serial_write(&port->lcr, LCR_DLAB);
 
 	/* now, read the divisor */
-	dll = in_8(&port->dll);
-	dlm = in_8(&port->dlm);
+	dll = serial_read(&port->dll);
+	dlm = serial_read(&port->dlm);
 	divisor = dlm << 8 | dll;
 
 	/* check prescaling */
-	if (in_8(&port->mcr) & 0x80)
+	if (serial_read(&port->mcr) & 0x80)
 		prescaler = 4;
 	else
 		prescaler = 1;
 
 	/* restore the LCR */
-	out_8(&port->lcr, old_lcr);
+	serial_write(&port->lcr, old_lcr);
 
 	/* calculate speed */
 	speed = (clock / prescaler) / (divisor * 16);
@@ -341,7 +359,7 @@ void __init udbg_init_wsp(void)
 {
 	udbg_comport = (struct NS16550 __iomem *)WSP_UART_VIRT;
 
-	udbg_init_uart(udbg_comport, 57600, 50000000);
+	udbg_init_uart(udbg_comport, 57600, 50000000, 0);
 
 	udbg_putc = udbg_wsp_putc;
 	udbg_flush = udbg_wsp_flush;
-- 
1.6.1.rc3

