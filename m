Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759989Ab1EOLfT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 07:35:19 -0400
Received: from londo.lunn.ch ([80.238.139.98]:59482 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759368Ab1EOLfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 07:35:15 -0400
From: Andrew Lunn <andrew@lunn.ch>
To: kernel@wantstofly.org, nico@fluxnic.net
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        saeed.bishara@gmail.com, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCHv2 02/15] [orion] Consolidate the creation of the uart platform data.
Date: Sun, 15 May 2011 13:32:41 +0200
Message-Id: <1305459174-25517-3-git-send-email-andrew@lunn.ch>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305459174-25517-1-git-send-email-andrew@lunn.ch>
References: <1305459174-25517-1-git-send-email-andrew@lunn.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 arch/arm/mach-dove/common.c               |  159 ++-------------------------
 arch/arm/mach-kirkwood/common.c           |   79 +-------------
 arch/arm/mach-loki/common.c               |   78 +------------
 arch/arm/mach-mv78xx0/common.c            |  160 ++-------------------------
 arch/arm/mach-orion5x/common.c            |   81 +-------------
 arch/arm/plat-orion/Makefile              |    2 +-
 arch/arm/plat-orion/common.c              |  171 +++++++++++++++++++++++++++++
 arch/arm/plat-orion/include/plat/common.h |   34 ++++++
 8 files changed, 242 insertions(+), 522 deletions(-)
 create mode 100644 arch/arm/plat-orion/common.c
 create mode 100644 arch/arm/plat-orion/include/plat/common.h

diff --git a/arch/arm/mach-dove/common.c b/arch/arm/mach-dove/common.c
index 30c9518..fffa92e 100644
--- a/arch/arm/mach-dove/common.c
+++ b/arch/arm/mach-dove/common.c
@@ -36,8 +36,11 @@
 #include <plat/mv_xor.h>
 #include <plat/ehci-orion.h>
 #include <plat/time.h>
+#include <plat/common.h>
 #include "common.h"
 
+static int get_tclk(void);
+
 /*****************************************************************************
  * I/O Address Mapping
  ****************************************************************************/
@@ -255,173 +258,37 @@ void __init dove_sata_init(struct mv_sata_platform_data *sata_data)
 /*****************************************************************************
  * UART0
  ****************************************************************************/
-static struct plat_serial8250_port dove_uart0_data[] = {
-	{
-		.mapbase	= DOVE_UART0_PHYS_BASE,
-		.membase	= (char *)DOVE_UART0_VIRT_BASE,
-		.irq		= IRQ_DOVE_UART_0,
-		.flags		= UPF_SKIP_TEST | UPF_BOOT_AUTOCONF,
-		.iotype		= UPIO_MEM,
-		.regshift	= 2,
-		.uartclk	= 0,
-	}, {
-	},
-};
-
-static struct resource dove_uart0_resources[] = {
-	{
-		.start		= DOVE_UART0_PHYS_BASE,
-		.end		= DOVE_UART0_PHYS_BASE + SZ_256 - 1,
-		.flags		= IORESOURCE_MEM,
-	}, {
-		.start		= IRQ_DOVE_UART_0,
-		.end		= IRQ_DOVE_UART_0,
-		.flags		= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device dove_uart0 = {
-	.name			= "serial8250",
-	.id			= PLAT8250_DEV_PLATFORM,
-	.dev			= {
-		.platform_data	= dove_uart0_data,
-	},
-	.resource		= dove_uart0_resources,
-	.num_resources		= ARRAY_SIZE(dove_uart0_resources),
-};
-
 void __init dove_uart0_init(void)
 {
-	platform_device_register(&dove_uart0);
+	orion_uart0_init(DOVE_UART0_VIRT_BASE, DOVE_UART0_PHYS_BASE,
+			 IRQ_DOVE_UART_0, get_tclk());
 }
 
 /*****************************************************************************
  * UART1
  ****************************************************************************/
-static struct plat_serial8250_port dove_uart1_data[] = {
-	{
-		.mapbase	= DOVE_UART1_PHYS_BASE,
-		.membase	= (char *)DOVE_UART1_VIRT_BASE,
-		.irq		= IRQ_DOVE_UART_1,
-		.flags		= UPF_SKIP_TEST | UPF_BOOT_AUTOCONF,
-		.iotype		= UPIO_MEM,
-		.regshift	= 2,
-		.uartclk	= 0,
-	}, {
-	},
-};
-
-static struct resource dove_uart1_resources[] = {
-	{
-		.start		= DOVE_UART1_PHYS_BASE,
-		.end		= DOVE_UART1_PHYS_BASE + SZ_256 - 1,
-		.flags		= IORESOURCE_MEM,
-	}, {
-		.start		= IRQ_DOVE_UART_1,
-		.end		= IRQ_DOVE_UART_1,
-		.flags		= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device dove_uart1 = {
-	.name			= "serial8250",
-	.id			= PLAT8250_DEV_PLATFORM1,
-	.dev			= {
-		.platform_data	= dove_uart1_data,
-	},
-	.resource		= dove_uart1_resources,
-	.num_resources		= ARRAY_SIZE(dove_uart1_resources),
-};
-
 void __init dove_uart1_init(void)
 {
-	platform_device_register(&dove_uart1);
+	orion_uart1_init(DOVE_UART1_VIRT_BASE, DOVE_UART1_PHYS_BASE,
+			 IRQ_DOVE_UART_1, get_tclk());
 }
 
 /*****************************************************************************
  * UART2
  ****************************************************************************/
-static struct plat_serial8250_port dove_uart2_data[] = {
-	{
-		.mapbase	= DOVE_UART2_PHYS_BASE,
-		.membase	= (char *)DOVE_UART2_VIRT_BASE,
-		.irq		= IRQ_DOVE_UART_2,
-		.flags		= UPF_SKIP_TEST | UPF_BOOT_AUTOCONF,
-		.iotype		= UPIO_MEM,
-		.regshift	= 2,
-		.uartclk	= 0,
-	}, {
-	},
-};
-
-static struct resource dove_uart2_resources[] = {
-	{
-		.start		= DOVE_UART2_PHYS_BASE,
-		.end		= DOVE_UART2_PHYS_BASE + SZ_256 - 1,
-		.flags		= IORESOURCE_MEM,
-	}, {
-		.start		= IRQ_DOVE_UART_2,
-		.end		= IRQ_DOVE_UART_2,
-		.flags		= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device dove_uart2 = {
-	.name			= "serial8250",
-	.id			= PLAT8250_DEV_PLATFORM2,
-	.dev			= {
-		.platform_data	= dove_uart2_data,
-	},
-	.resource		= dove_uart2_resources,
-	.num_resources		= ARRAY_SIZE(dove_uart2_resources),
-};
-
 void __init dove_uart2_init(void)
 {
-	platform_device_register(&dove_uart2);
+	orion_uart2_init(DOVE_UART2_VIRT_BASE, DOVE_UART2_PHYS_BASE,
+			 IRQ_DOVE_UART_2, get_tclk());
 }
 
 /*****************************************************************************
  * UART3
  ****************************************************************************/
-static struct plat_serial8250_port dove_uart3_data[] = {
-	{
-		.mapbase	= DOVE_UART3_PHYS_BASE,
-		.membase	= (char *)DOVE_UART3_VIRT_BASE,
-		.irq		= IRQ_DOVE_UART_3,
-		.flags		= UPF_SKIP_TEST | UPF_BOOT_AUTOCONF,
-		.iotype		= UPIO_MEM,
-		.regshift	= 2,
-		.uartclk	= 0,
-	}, {
-	},
-};
-
-static struct resource dove_uart3_resources[] = {
-	{
-		.start		= DOVE_UART3_PHYS_BASE,
-		.end		= DOVE_UART3_PHYS_BASE + SZ_256 - 1,
-		.flags		= IORESOURCE_MEM,
-	}, {
-		.start		= IRQ_DOVE_UART_3,
-		.end		= IRQ_DOVE_UART_3,
-		.flags		= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device dove_uart3 = {
-	.name			= "serial8250",
-	.id			= 3,
-	.dev			= {
-		.platform_data	= dove_uart3_data,
-	},
-	.resource		= dove_uart3_resources,
-	.num_resources		= ARRAY_SIZE(dove_uart3_resources),
-};
-
 void __init dove_uart3_init(void)
 {
-	platform_device_register(&dove_uart3);
+	orion_uart3_init(DOVE_UART3_VIRT_BASE, DOVE_UART3_PHYS_BASE,
+			 IRQ_DOVE_UART_3, get_tclk());
 }
 
 /*****************************************************************************
@@ -835,10 +702,6 @@ void __init dove_init(void)
 	dove_setup_cpu_mbus();
 
 	dove_ge00_shared_data.t_clk = tclk;
-	dove_uart0_data[0].uartclk = tclk;
-	dove_uart1_data[0].uartclk = tclk;
-	dove_uart2_data[0].uartclk = tclk;
-	dove_uart3_data[0].uartclk = tclk;
 	dove_spi0_data.tclk = tclk;
 	dove_spi1_data.tclk = tclk;
 
diff --git a/arch/arm/mach-kirkwood/common.c b/arch/arm/mach-kirkwood/common.c
index 4b89eed2..8cdf9f9 100644
--- a/arch/arm/mach-kirkwood/common.c
+++ b/arch/arm/mach-kirkwood/common.c
@@ -33,6 +33,7 @@
 #include <plat/mv_xor.h>
 #include <plat/orion_nand.h>
 #include <plat/orion_wdt.h>
+#include <plat/common.h>
 #include <plat/time.h>
 #include "common.h"
 
@@ -491,91 +492,23 @@ void __init kirkwood_i2c_init(void)
 /*****************************************************************************
  * UART0
  ****************************************************************************/
-static struct plat_serial8250_port kirkwood_uart0_data[] = {
-	{
-		.mapbase	= UART0_PHYS_BASE,
-		.membase	= (char *)UART0_VIRT_BASE,
-		.irq		= IRQ_KIRKWOOD_UART_0,
-		.flags		= UPF_SKIP_TEST | UPF_BOOT_AUTOCONF,
-		.iotype		= UPIO_MEM,
-		.regshift	= 2,
-		.uartclk	= 0,
-	}, {
-	},
-};
-
-static struct resource kirkwood_uart0_resources[] = {
-	{
-		.start		= UART0_PHYS_BASE,
-		.end		= UART0_PHYS_BASE + 0xff,
-		.flags		= IORESOURCE_MEM,
-	}, {
-		.start		= IRQ_KIRKWOOD_UART_0,
-		.end		= IRQ_KIRKWOOD_UART_0,
-		.flags		= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device kirkwood_uart0 = {
-	.name			= "serial8250",
-	.id			= PLAT8250_DEV_PLATFORM,
-	.dev			= {
-		.platform_data	= kirkwood_uart0_data,
-	},
-	.resource		= kirkwood_uart0_resources,
-	.num_resources		= ARRAY_SIZE(kirkwood_uart0_resources),
-};
 
 void __init kirkwood_uart0_init(void)
 {
-	platform_device_register(&kirkwood_uart0);
+	orion_uart0_init(UART0_VIRT_BASE, UART0_PHYS_BASE,
+			 IRQ_KIRKWOOD_UART_0, kirkwood_tclk);
 }
 
 
 /*****************************************************************************
  * UART1
  ****************************************************************************/
-static struct plat_serial8250_port kirkwood_uart1_data[] = {
-	{
-		.mapbase	= UART1_PHYS_BASE,
-		.membase	= (char *)UART1_VIRT_BASE,
-		.irq		= IRQ_KIRKWOOD_UART_1,
-		.flags		= UPF_SKIP_TEST | UPF_BOOT_AUTOCONF,
-		.iotype		= UPIO_MEM,
-		.regshift	= 2,
-		.uartclk	= 0,
-	}, {
-	},
-};
-
-static struct resource kirkwood_uart1_resources[] = {
-	{
-		.start		= UART1_PHYS_BASE,
-		.end		= UART1_PHYS_BASE + 0xff,
-		.flags		= IORESOURCE_MEM,
-	}, {
-		.start		= IRQ_KIRKWOOD_UART_1,
-		.end		= IRQ_KIRKWOOD_UART_1,
-		.flags		= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device kirkwood_uart1 = {
-	.name			= "serial8250",
-	.id			= PLAT8250_DEV_PLATFORM1,
-	.dev			= {
-		.platform_data	= kirkwood_uart1_data,
-	},
-	.resource		= kirkwood_uart1_resources,
-	.num_resources		= ARRAY_SIZE(kirkwood_uart1_resources),
-};
-
 void __init kirkwood_uart1_init(void)
 {
-	platform_device_register(&kirkwood_uart1);
+	orion_uart1_init(UART1_VIRT_BASE, UART1_PHYS_BASE,
+			 IRQ_KIRKWOOD_UART_1, kirkwood_tclk);
 }
 
-
 /*****************************************************************************
  * Cryptographic Engines and Security Accelerator (CESA)
  ****************************************************************************/
@@ -987,8 +920,6 @@ void __init kirkwood_init(void)
 	kirkwood_ge00_shared_data.t_clk = kirkwood_tclk;
 	kirkwood_ge01_shared_data.t_clk = kirkwood_tclk;
 	kirkwood_spi_plat_data.tclk = kirkwood_tclk;
-	kirkwood_uart0_data[0].uartclk = kirkwood_tclk;
-	kirkwood_uart1_data[0].uartclk = kirkwood_tclk;
 	kirkwood_i2s_data.tclk = kirkwood_tclk;
 
 	/*
diff --git a/arch/arm/mach-loki/common.c b/arch/arm/mach-loki/common.c
index 4ff4c62..c071804 100644
--- a/arch/arm/mach-loki/common.c
+++ b/arch/arm/mach-loki/common.c
@@ -23,6 +23,7 @@
 #include <mach/loki.h>
 #include <plat/orion_nand.h>
 #include <plat/time.h>
+#include <plat/common.h>
 #include "common.h"
 
 /*****************************************************************************
@@ -204,88 +205,19 @@ void __init loki_sas_init(void)
 /*****************************************************************************
  * UART0
  ****************************************************************************/
-static struct plat_serial8250_port loki_uart0_data[] = {
-	{
-		.mapbase	= UART0_PHYS_BASE,
-		.membase	= (char *)UART0_VIRT_BASE,
-		.irq		= IRQ_LOKI_UART0,
-		.flags		= UPF_SKIP_TEST | UPF_BOOT_AUTOCONF,
-		.iotype		= UPIO_MEM,
-		.regshift	= 2,
-		.uartclk	= LOKI_TCLK,
-	}, {
-	},
-};
-
-static struct resource loki_uart0_resources[] = {
-	{
-		.start		= UART0_PHYS_BASE,
-		.end		= UART0_PHYS_BASE + 0xff,
-		.flags		= IORESOURCE_MEM,
-	}, {
-		.start		= IRQ_LOKI_UART0,
-		.end		= IRQ_LOKI_UART0,
-		.flags		= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device loki_uart0 = {
-	.name			= "serial8250",
-	.id			= PLAT8250_DEV_PLATFORM,
-	.dev			= {
-		.platform_data	= loki_uart0_data,
-	},
-	.resource		= loki_uart0_resources,
-	.num_resources		= ARRAY_SIZE(loki_uart0_resources),
-};
-
 void __init loki_uart0_init(void)
 {
-	platform_device_register(&loki_uart0);
+	orion_uart0_init(UART0_VIRT_BASE, UART0_PHYS_BASE,
+			 IRQ_LOKI_UART0, LOKI_TCLK);
 }
 
-
 /*****************************************************************************
  * UART1
  ****************************************************************************/
-static struct plat_serial8250_port loki_uart1_data[] = {
-	{
-		.mapbase	= UART1_PHYS_BASE,
-		.membase	= (char *)UART1_VIRT_BASE,
-		.irq		= IRQ_LOKI_UART1,
-		.flags		= UPF_SKIP_TEST | UPF_BOOT_AUTOCONF,
-		.iotype		= UPIO_MEM,
-		.regshift	= 2,
-		.uartclk	= LOKI_TCLK,
-	}, {
-	},
-};
-
-static struct resource loki_uart1_resources[] = {
-	{
-		.start		= UART1_PHYS_BASE,
-		.end		= UART1_PHYS_BASE + 0xff,
-		.flags		= IORESOURCE_MEM,
-	}, {
-		.start		= IRQ_LOKI_UART1,
-		.end		= IRQ_LOKI_UART1,
-		.flags		= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device loki_uart1 = {
-	.name			= "serial8250",
-	.id			= PLAT8250_DEV_PLATFORM1,
-	.dev			= {
-		.platform_data	= loki_uart1_data,
-	},
-	.resource		= loki_uart1_resources,
-	.num_resources		= ARRAY_SIZE(loki_uart1_resources),
-};
-
 void __init loki_uart1_init(void)
 {
-	platform_device_register(&loki_uart1);
+	orion_uart1_init(UART1_VIRT_BASE, UART1_PHYS_BASE,
+			 IRQ_LOKI_UART1, LOKI_TCLK);
 }
 
 
diff --git a/arch/arm/mach-mv78xx0/common.c b/arch/arm/mach-mv78xx0/common.c
index c38250d..5b474e4 100644
--- a/arch/arm/mach-mv78xx0/common.c
+++ b/arch/arm/mach-mv78xx0/common.c
@@ -25,8 +25,10 @@
 #include <plat/ehci-orion.h>
 #include <plat/orion_nand.h>
 #include <plat/time.h>
+#include <plat/common.h>
 #include "common.h"
 
+static int get_tclk(void);
 
 /*****************************************************************************
  * Common bits
@@ -642,179 +644,41 @@ void __init mv78xx0_sata_init(struct mv_sata_platform_data *sata_data)
 /*****************************************************************************
  * UART0
  ****************************************************************************/
-static struct plat_serial8250_port mv78xx0_uart0_data[] = {
-	{
-		.mapbase	= UART0_PHYS_BASE,
-		.membase	= (char *)UART0_VIRT_BASE,
-		.irq		= IRQ_MV78XX0_UART_0,
-		.flags		= UPF_SKIP_TEST | UPF_BOOT_AUTOCONF,
-		.iotype		= UPIO_MEM,
-		.regshift	= 2,
-		.uartclk	= 0,
-	}, {
-	},
-};
-
-static struct resource mv78xx0_uart0_resources[] = {
-	{
-		.start		= UART0_PHYS_BASE,
-		.end		= UART0_PHYS_BASE + 0xff,
-		.flags		= IORESOURCE_MEM,
-	}, {
-		.start		= IRQ_MV78XX0_UART_0,
-		.end		= IRQ_MV78XX0_UART_0,
-		.flags		= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device mv78xx0_uart0 = {
-	.name			= "serial8250",
-	.id			= PLAT8250_DEV_PLATFORM,
-	.dev			= {
-		.platform_data	= mv78xx0_uart0_data,
-	},
-	.resource		= mv78xx0_uart0_resources,
-	.num_resources		= ARRAY_SIZE(mv78xx0_uart0_resources),
-};
-
 void __init mv78xx0_uart0_init(void)
 {
-	platform_device_register(&mv78xx0_uart0);
+	orion_uart0_init(UART0_VIRT_BASE, UART0_PHYS_BASE,
+			 IRQ_MV78XX0_UART_0, get_tclk());
 }
 
 
 /*****************************************************************************
  * UART1
  ****************************************************************************/
-static struct plat_serial8250_port mv78xx0_uart1_data[] = {
-	{
-		.mapbase	= UART1_PHYS_BASE,
-		.membase	= (char *)UART1_VIRT_BASE,
-		.irq		= IRQ_MV78XX0_UART_1,
-		.flags		= UPF_SKIP_TEST | UPF_BOOT_AUTOCONF,
-		.iotype		= UPIO_MEM,
-		.regshift	= 2,
-		.uartclk	= 0,
-	}, {
-	},
-};
-
-static struct resource mv78xx0_uart1_resources[] = {
-	{
-		.start		= UART1_PHYS_BASE,
-		.end		= UART1_PHYS_BASE + 0xff,
-		.flags		= IORESOURCE_MEM,
-	}, {
-		.start		= IRQ_MV78XX0_UART_1,
-		.end		= IRQ_MV78XX0_UART_1,
-		.flags		= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device mv78xx0_uart1 = {
-	.name			= "serial8250",
-	.id			= PLAT8250_DEV_PLATFORM1,
-	.dev			= {
-		.platform_data	= mv78xx0_uart1_data,
-	},
-	.resource		= mv78xx0_uart1_resources,
-	.num_resources		= ARRAY_SIZE(mv78xx0_uart1_resources),
-};
-
 void __init mv78xx0_uart1_init(void)
 {
-	platform_device_register(&mv78xx0_uart1);
+	orion_uart1_init(UART1_VIRT_BASE, UART1_PHYS_BASE,
+			 IRQ_MV78XX0_UART_1, get_tclk());
 }
 
 
 /*****************************************************************************
  * UART2
  ****************************************************************************/
-static struct plat_serial8250_port mv78xx0_uart2_data[] = {
-	{
-		.mapbase	= UART2_PHYS_BASE,
-		.membase	= (char *)UART2_VIRT_BASE,
-		.irq		= IRQ_MV78XX0_UART_2,
-		.flags		= UPF_SKIP_TEST | UPF_BOOT_AUTOCONF,
-		.iotype		= UPIO_MEM,
-		.regshift	= 2,
-		.uartclk	= 0,
-	}, {
-	},
-};
-
-static struct resource mv78xx0_uart2_resources[] = {
-	{
-		.start		= UART2_PHYS_BASE,
-		.end		= UART2_PHYS_BASE + 0xff,
-		.flags		= IORESOURCE_MEM,
-	}, {
-		.start		= IRQ_MV78XX0_UART_2,
-		.end		= IRQ_MV78XX0_UART_2,
-		.flags		= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device mv78xx0_uart2 = {
-	.name			= "serial8250",
-	.id			= PLAT8250_DEV_PLATFORM2,
-	.dev			= {
-		.platform_data	= mv78xx0_uart2_data,
-	},
-	.resource		= mv78xx0_uart2_resources,
-	.num_resources		= ARRAY_SIZE(mv78xx0_uart2_resources),
-};
-
 void __init mv78xx0_uart2_init(void)
 {
-	platform_device_register(&mv78xx0_uart2);
+	orion_uart2_init(UART2_VIRT_BASE, UART2_PHYS_BASE,
+			 IRQ_MV78XX0_UART_2, get_tclk());
 }
 
-
 /*****************************************************************************
  * UART3
  ****************************************************************************/
-static struct plat_serial8250_port mv78xx0_uart3_data[] = {
-	{
-		.mapbase	= UART3_PHYS_BASE,
-		.membase	= (char *)UART3_VIRT_BASE,
-		.irq		= IRQ_MV78XX0_UART_3,
-		.flags		= UPF_SKIP_TEST | UPF_BOOT_AUTOCONF,
-		.iotype		= UPIO_MEM,
-		.regshift	= 2,
-		.uartclk	= 0,
-	}, {
-	},
-};
-
-static struct resource mv78xx0_uart3_resources[] = {
-	{
-		.start		= UART3_PHYS_BASE,
-		.end		= UART3_PHYS_BASE + 0xff,
-		.flags		= IORESOURCE_MEM,
-	}, {
-		.start		= IRQ_MV78XX0_UART_3,
-		.end		= IRQ_MV78XX0_UART_3,
-		.flags		= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device mv78xx0_uart3 = {
-	.name			= "serial8250",
-	.id			= 3,
-	.dev			= {
-		.platform_data	= mv78xx0_uart3_data,
-	},
-	.resource		= mv78xx0_uart3_resources,
-	.num_resources		= ARRAY_SIZE(mv78xx0_uart3_resources),
-};
-
 void __init mv78xx0_uart3_init(void)
 {
-	platform_device_register(&mv78xx0_uart3);
+	orion_uart3_init(UART3_VIRT_BASE, UART3_PHYS_BASE,
+			 IRQ_MV78XX0_UART_3, get_tclk());
 }
 
-
 /*****************************************************************************
  * Time handling
  ****************************************************************************/
@@ -900,8 +764,4 @@ void __init mv78xx0_init(void)
 	mv78xx0_ge01_shared_data.t_clk = tclk;
 	mv78xx0_ge10_shared_data.t_clk = tclk;
 	mv78xx0_ge11_shared_data.t_clk = tclk;
-	mv78xx0_uart0_data[0].uartclk = tclk;
-	mv78xx0_uart1_data[0].uartclk = tclk;
-	mv78xx0_uart2_data[0].uartclk = tclk;
-	mv78xx0_uart3_data[0].uartclk = tclk;
 }
diff --git a/arch/arm/mach-orion5x/common.c b/arch/arm/mach-orion5x/common.c
index d281b19..310de50 100644
--- a/arch/arm/mach-orion5x/common.c
+++ b/arch/arm/mach-orion5x/common.c
@@ -34,6 +34,7 @@
 #include <plat/orion_nand.h>
 #include <plat/orion_wdt.h>
 #include <plat/time.h>
+#include <plat/common.h>
 #include "common.h"
 
 /*****************************************************************************
@@ -349,91 +350,21 @@ void __init orion5x_spi_init()
 /*****************************************************************************
  * UART0
  ****************************************************************************/
-static struct plat_serial8250_port orion5x_uart0_data[] = {
-	{
-		.mapbase	= UART0_PHYS_BASE,
-		.membase	= (char *)UART0_VIRT_BASE,
-		.irq		= IRQ_ORION5X_UART0,
-		.flags		= UPF_SKIP_TEST | UPF_BOOT_AUTOCONF,
-		.iotype		= UPIO_MEM,
-		.regshift	= 2,
-		.uartclk	= 0,
-	}, {
-	},
-};
-
-static struct resource orion5x_uart0_resources[] = {
-	{
-		.start		= UART0_PHYS_BASE,
-		.end		= UART0_PHYS_BASE + 0xff,
-		.flags		= IORESOURCE_MEM,
-	}, {
-		.start		= IRQ_ORION5X_UART0,
-		.end		= IRQ_ORION5X_UART0,
-		.flags		= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device orion5x_uart0 = {
-	.name			= "serial8250",
-	.id			= PLAT8250_DEV_PLATFORM,
-	.dev			= {
-		.platform_data	= orion5x_uart0_data,
-	},
-	.resource		= orion5x_uart0_resources,
-	.num_resources		= ARRAY_SIZE(orion5x_uart0_resources),
-};
-
 void __init orion5x_uart0_init(void)
 {
-	platform_device_register(&orion5x_uart0);
+	orion_uart0_init(UART0_VIRT_BASE, UART0_PHYS_BASE,
+			 IRQ_ORION5X_UART0, orion5x_tclk);
 }
 
-
 /*****************************************************************************
  * UART1
  ****************************************************************************/
-static struct plat_serial8250_port orion5x_uart1_data[] = {
-	{
-		.mapbase	= UART1_PHYS_BASE,
-		.membase	= (char *)UART1_VIRT_BASE,
-		.irq		= IRQ_ORION5X_UART1,
-		.flags		= UPF_SKIP_TEST | UPF_BOOT_AUTOCONF,
-		.iotype		= UPIO_MEM,
-		.regshift	= 2,
-		.uartclk	= 0,
-	}, {
-	},
-};
-
-static struct resource orion5x_uart1_resources[] = {
-	{
-		.start		= UART1_PHYS_BASE,
-		.end		= UART1_PHYS_BASE + 0xff,
-		.flags		= IORESOURCE_MEM,
-	}, {
-		.start		= IRQ_ORION5X_UART1,
-		.end		= IRQ_ORION5X_UART1,
-		.flags		= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device orion5x_uart1 = {
-	.name			= "serial8250",
-	.id			= PLAT8250_DEV_PLATFORM1,
-	.dev			= {
-		.platform_data	= orion5x_uart1_data,
-	},
-	.resource		= orion5x_uart1_resources,
-	.num_resources		= ARRAY_SIZE(orion5x_uart1_resources),
-};
-
 void __init orion5x_uart1_init(void)
 {
-	platform_device_register(&orion5x_uart1);
+	orion_uart1_init(UART1_VIRT_BASE, UART1_PHYS_BASE,
+			 IRQ_ORION5X_UART1, orion5x_tclk);
 }
 
-
 /*****************************************************************************
  * XOR engine
  ****************************************************************************/
@@ -687,8 +618,6 @@ void __init orion5x_init(void)
 
 	orion5x_ge00_shared_data.t_clk = orion5x_tclk;
 	orion5x_spi_plat_data.tclk = orion5x_tclk;
-	orion5x_uart0_data[0].uartclk = orion5x_tclk;
-	orion5x_uart1_data[0].uartclk = orion5x_tclk;
 
 	/*
 	 * Setup Orion address map
diff --git a/arch/arm/plat-orion/Makefile b/arch/arm/plat-orion/Makefile
index 56021a7..0f048c5 100644
--- a/arch/arm/plat-orion/Makefile
+++ b/arch/arm/plat-orion/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the linux kernel.
 #
 
-obj-y	:= irq.o pcie.o time.o
+obj-y	:= irq.o pcie.o time.o common.o
 obj-m	:=
 obj-n	:=
 obj-	:=
diff --git a/arch/arm/plat-orion/common.c b/arch/arm/plat-orion/common.c
new file mode 100644
index 0000000..4eac532
--- /dev/null
+++ b/arch/arm/plat-orion/common.c
@@ -0,0 +1,171 @@
+/*
+ * arch/arm/plat-orion/common.c
+ *
+ * Marvell Orion SoC common setup code used by multiple mach-/common.c
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/serial_8250.h>
+
+/* Fill in the resources structure and link it into the platform
+   device structure. There is always a memory region, and nearly
+   always an interrupt.*/
+static void fill_resources(struct platform_device *device,
+			   struct resource *resources,
+			   resource_size_t mapbase,
+			   resource_size_t size,
+			   unsigned int irq)
+{
+	device->resource = resources;
+	device->num_resources = 1;
+	resources[0].flags = IORESOURCE_MEM;
+	resources[0].start = mapbase;
+	resources[0].end = mapbase + size;
+
+	if (irq != NO_IRQ) {
+		device->num_resources++;
+		resources[1].flags = IORESOURCE_IRQ;
+		resources[1].start = irq;
+		resources[1].end = irq;
+	}
+}
+
+/*****************************************************************************
+ * UART
+ ****************************************************************************/
+static void __init uart_complete(
+	struct platform_device *orion_uart,
+	struct plat_serial8250_port *data,
+	struct resource *resources,
+	unsigned int membase,
+	resource_size_t mapbase,
+	unsigned int irq,
+	unsigned int uartclk)
+{
+	data->mapbase = mapbase;
+	data->membase = (void __iomem *)membase;
+	data->irq = irq;
+	data->uartclk = uartclk;
+	orion_uart->dev.platform_data = data;
+
+	fill_resources(orion_uart, resources, mapbase, 0xff, irq);
+	platform_device_register(orion_uart);
+}
+
+/*****************************************************************************
+ * UART0
+ ****************************************************************************/
+static struct plat_serial8250_port orion_uart0_data[] = {
+	{
+		.flags		= UPF_SKIP_TEST | UPF_BOOT_AUTOCONF,
+		.iotype		= UPIO_MEM,
+		.regshift	= 2,
+	}, {
+	},
+};
+
+static struct resource orion_uart0_resources[2];
+
+static struct platform_device orion_uart0 = {
+	.name			= "serial8250",
+	.id			= PLAT8250_DEV_PLATFORM,
+};
+
+void __init orion_uart0_init(unsigned int membase,
+			     resource_size_t mapbase,
+			     unsigned int irq,
+			     unsigned int uartclk)
+{
+	uart_complete(&orion_uart0, orion_uart0_data, orion_uart0_resources,
+		      membase, mapbase, irq, uartclk);
+}
+
+/*****************************************************************************
+ * UART1
+ ****************************************************************************/
+static struct plat_serial8250_port orion_uart1_data[] = {
+	{
+		.flags		= UPF_SKIP_TEST | UPF_BOOT_AUTOCONF,
+		.iotype		= UPIO_MEM,
+		.regshift	= 2,
+	}, {
+	},
+};
+
+static struct resource orion_uart1_resources[2];
+
+static struct platform_device orion_uart1 = {
+	.name			= "serial8250",
+	.id			= PLAT8250_DEV_PLATFORM1,
+};
+
+void __init orion_uart1_init(unsigned int membase,
+			     resource_size_t mapbase,
+			     unsigned int irq,
+			     unsigned int uartclk)
+{
+	uart_complete(&orion_uart1, orion_uart1_data, orion_uart1_resources,
+		      membase, mapbase, irq, uartclk);
+}
+
+/*****************************************************************************
+ * UART2
+ ****************************************************************************/
+static struct plat_serial8250_port orion_uart2_data[] = {
+	{
+		.flags		= UPF_SKIP_TEST | UPF_BOOT_AUTOCONF,
+		.iotype		= UPIO_MEM,
+		.regshift	= 2,
+	}, {
+	},
+};
+
+static struct resource orion_uart2_resources[2];
+
+static struct platform_device orion_uart2 = {
+	.name			= "serial8250",
+	.id			= PLAT8250_DEV_PLATFORM2,
+};
+
+void __init orion_uart2_init(unsigned int membase,
+			     resource_size_t mapbase,
+			     unsigned int irq,
+			     unsigned int uartclk)
+{
+	uart_complete(&orion_uart2, orion_uart2_data, orion_uart2_resources,
+		      membase, mapbase, irq, uartclk);
+}
+
+/*****************************************************************************
+ * UART3
+ ****************************************************************************/
+static struct plat_serial8250_port orion_uart3_data[] = {
+	{
+		.flags		= UPF_SKIP_TEST | UPF_BOOT_AUTOCONF,
+		.iotype		= UPIO_MEM,
+		.regshift	= 2,
+	}, {
+	},
+};
+
+static struct resource orion_uart3_resources[2];
+
+static struct platform_device orion_uart3 = {
+	.name			= "serial8250",
+	.id			= 3,
+};
+
+void __init orion_uart3_init(unsigned int membase,
+			     resource_size_t mapbase,
+			     unsigned int irq,
+			     unsigned int uartclk)
+{
+	uart_complete(&orion_uart3, orion_uart3_data, orion_uart3_resources,
+		      membase, mapbase, irq, uartclk);
+}
diff --git a/arch/arm/plat-orion/include/plat/common.h b/arch/arm/plat-orion/include/plat/common.h
new file mode 100644
index 0000000..d57e3bb
--- /dev/null
+++ b/arch/arm/plat-orion/include/plat/common.h
@@ -0,0 +1,34 @@
+/*
+ * arch/arm/plat-orion/include/plat/common.h
+ *
+ * Marvell Orion SoC common setup code used by different mach-/common.c
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef __PLAT_COMMON_H
+
+
+void __init orion_uart0_init(unsigned int membase,
+			     resource_size_t mapbase,
+			     unsigned int irq,
+			     unsigned int uartclk);
+
+void __init orion_uart1_init(unsigned int membase,
+			     resource_size_t mapbase,
+			     unsigned int irq,
+			     unsigned int uartclk);
+
+void __init orion_uart2_init(unsigned int membase,
+			     resource_size_t mapbase,
+			     unsigned int irq,
+			     unsigned int uartclk);
+
+void __init orion_uart3_init(unsigned int membase,
+			     resource_size_t mapbase,
+			     unsigned int irq,
+			     unsigned int uartclk);
+#endif
+
-- 
1.7.4.4

