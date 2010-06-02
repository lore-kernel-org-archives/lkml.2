Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644Ab0FBTLR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 15:11:17 -0400
Received: from blue-ld-261.synserver.de ([217.119.54.83]:38181 "EHLO
	smtp-out-182.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758571Ab0FBTLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 15:11:14 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 13236
From: Lars-Peter Clausen <lars@metafoo.de>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Lars-Peter Clausen <lars@metafoo.de>
Subject: [RFC][PATCH 13/26] MIPS: JZ4740: Add platform devices
Date: Wed,  2 Jun 2010 21:10:29 +0200
Message-Id: <1275505832-17185-5-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1275505397-16758-1-git-send-email-lars@metafoo.de>
References: <1275505397-16758-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds platform devices for all the JZ4740 platform drivers.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 arch/mips/include/asm/mach-jz4740/platform.h |   36 ++++
 arch/mips/jz4740/platform.c                  |  288 ++++++++++++++++++++++++++
 2 files changed, 324 insertions(+), 0 deletions(-)
 create mode 100644 arch/mips/include/asm/mach-jz4740/platform.h
 create mode 100644 arch/mips/jz4740/platform.c

diff --git a/arch/mips/include/asm/mach-jz4740/platform.h b/arch/mips/include/asm/mach-jz4740/platform.h
new file mode 100644
index 0000000..7a51c70
--- /dev/null
+++ b/arch/mips/include/asm/mach-jz4740/platform.h
@@ -0,0 +1,36 @@
+/*
+ *  Copyright (C) 2009-2010, Lars-Peter Clausen <lars@metafoo.de>
+ *  JZ4740 platform device definitions
+ *
+ *  This program is free software; you can redistribute	 it and/or modify it
+ *  under  the terms of	 the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the	License, or (at your
+ *  option) any later version.
+ *
+ *  You should have received a copy of the  GNU General Public License along
+ *  with this program; if not, write  to the Free Software Foundation, Inc.,
+ *  675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+
+#ifndef __JZ4740_PLATFORM_H
+#define __JZ4740_PLATFORM_H
+
+#include <linux/platform_device.h>
+
+extern struct platform_device jz4740_usb_ohci_device;
+extern struct platform_device jz4740_udc_device;
+extern struct platform_device jz4740_mmc_device;
+extern struct platform_device jz4740_rtc_device;
+extern struct platform_device jz4740_i2c_device;
+extern struct platform_device jz4740_nand_device;
+extern struct platform_device jz4740_framebuffer_device;
+extern struct platform_device jz4740_i2s_device;
+extern struct platform_device jz4740_codec_device;
+extern struct platform_device jz4740_adc_device;
+extern struct platform_device jz4740_battery_device;
+
+void jz4740_serial_device_register(void);
+
+#endif
diff --git a/arch/mips/jz4740/platform.c b/arch/mips/jz4740/platform.c
new file mode 100644
index 0000000..734b441
--- /dev/null
+++ b/arch/mips/jz4740/platform.c
@@ -0,0 +1,288 @@
+/*
+ *  Copyright (C) 2009-2010, Lars-Peter Clausen <lars@metafoo.de>
+ *  JZ4740 platform devices
+ *
+ *  This program is free software; you can redistribute	 it and/or modify it
+ *  under  the terms of	 the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the	License, or (at your
+ *  option) any later version.
+ *
+ *  You should have received a copy of the  GNU General Public License along
+ *  with this program; if not, write  to the Free Software Foundation, Inc.,
+ *  675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/resource.h>
+
+#include <asm/mach-jz4740/platform.h>
+#include <asm/mach-jz4740/base.h>
+#include <asm/mach-jz4740/irq.h>
+
+#include <linux/serial_core.h>
+#include <linux/serial_8250.h>
+
+#include "serial.h"
+#include "clock.h"
+
+/* OHCI (USB full speed host controller) */
+static struct resource jz4740_usb_ohci_resources[] = {
+	[0] = {
+		.start	= CPHYSADDR(JZ4740_UHC_BASE_ADDR),
+		.end	= CPHYSADDR(JZ4740_UHC_BASE_ADDR) + 0x10000 - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= JZ4740_IRQ_UHC,
+		.end	= JZ4740_IRQ_UHC,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+/* The dmamask must be set for OHCI to work */
+static u64 ohci_dmamask = ~(u32)0;
+
+struct platform_device jz4740_usb_ohci_device = {
+	.name		= "jz4740-ohci",
+	.id		= -1,
+	.dev = {
+		.dma_mask		= &ohci_dmamask,
+		.coherent_dma_mask	= 0xffffffff,
+	},
+	.num_resources	= ARRAY_SIZE(jz4740_usb_ohci_resources),
+	.resource	= jz4740_usb_ohci_resources,
+};
+
+/* UDC (USB gadget controller) */
+static struct resource jz4740_usb_gdt_resources[] = {
+	[0] = {
+		.start	= CPHYSADDR(JZ4740_UDC_BASE_ADDR),
+		.end	= CPHYSADDR(JZ4740_UDC_BASE_ADDR) + 0x10000 - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= JZ4740_IRQ_UDC,
+		.end	= JZ4740_IRQ_UDC,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static u64 jz4740_udc_dmamask = ~(u32)0;
+
+struct platform_device jz4740_udc_device = {
+	.name		= "jz-udc",
+	.id		= -1,
+	.dev = {
+		.dma_mask		= &jz4740_udc_dmamask,
+		.coherent_dma_mask	= 0xffffffff,
+	},
+	.num_resources	= ARRAY_SIZE(jz4740_usb_gdt_resources),
+	.resource	= jz4740_usb_gdt_resources,
+};
+
+/** MMC/SD controller **/
+static struct resource jz4740_mmc_resources[] = {
+	[0] = {
+		.start	= CPHYSADDR(JZ4740_MSC_BASE_ADDR),
+		.end	= CPHYSADDR(JZ4740_MSC_BASE_ADDR) + 0x10000 - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= JZ4740_IRQ_MSC,
+		.end	= JZ4740_IRQ_MSC,
+		.flags	= IORESOURCE_IRQ,
+	}
+};
+
+static u64 jz4740_mmc_dmamask =  ~(u32)0;
+
+struct platform_device jz4740_mmc_device = {
+	.name = "jz4740-mmc",
+	.id = 0,
+	.dev = {
+		.dma_mask		= &jz4740_mmc_dmamask,
+		.coherent_dma_mask	= 0xffffffff,
+	},
+	.num_resources  = ARRAY_SIZE(jz4740_mmc_resources),
+	.resource	= jz4740_mmc_resources,
+};
+
+static struct resource jz4740_rtc_resources[] = {
+	[0] = {
+		.start	= CPHYSADDR(JZ4740_RTC_BASE_ADDR),
+		.end	= CPHYSADDR(JZ4740_RTC_BASE_ADDR) + 0x38 - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start  = JZ4740_IRQ_RTC,
+		.end	= JZ4740_IRQ_RTC,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+struct platform_device jz4740_rtc_device = {
+	.name	= "jz4740-rtc",
+	.id	= -1,
+	.num_resources	= ARRAY_SIZE(jz4740_rtc_resources),
+	.resource	= jz4740_rtc_resources,
+};
+
+/** I2C controller **/
+static struct resource jz4740_i2c_resources[] = {
+	[0] = {
+		.start	= CPHYSADDR(JZ4740_I2C_BASE_ADDR),
+		.end	= CPHYSADDR(JZ4740_I2C_BASE_ADDR) + 0x10000 - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= JZ4740_IRQ_I2C,
+		.end	= JZ4740_IRQ_I2C,
+		.flags	= IORESOURCE_IRQ,
+	}
+};
+
+static u64 jz4740_i2c_dmamask =  ~(u32)0;
+
+struct platform_device jz4740_i2c_device = {
+	.name = "jz_i2c",
+	.id = 0,
+	.dev = {
+		.dma_mask		= &jz4740_i2c_dmamask,
+		.coherent_dma_mask	= 0xffffffff,
+	},
+	.num_resources  = ARRAY_SIZE(jz4740_i2c_resources),
+	.resource	= jz4740_i2c_resources,
+};
+
+static struct resource jz4740_nand_resources[] = {
+	[0] = {
+		.start	= CPHYSADDR(JZ4740_EMC_BASE_ADDR),
+		.end	= CPHYSADDR(JZ4740_EMC_BASE_ADDR) + 0x10000 - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+};
+
+struct platform_device jz4740_nand_device = {
+	.name = "jz4740-nand",
+	.num_resources = ARRAY_SIZE(jz4740_nand_resources),
+	.resource = jz4740_nand_resources,
+};
+
+static struct resource jz4740_framebuffer_resources[] = {
+	[0] = {
+		.start	= CPHYSADDR(JZ4740_LCD_BASE_ADDR),
+		.end	= CPHYSADDR(JZ4740_LCD_BASE_ADDR) + 0x10000 - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+};
+
+static u64 jz4740_fb_dmamask = ~(u32)0;
+
+struct platform_device jz4740_framebuffer_device = {
+	.name = "jz4740-fb",
+	.id = -1,
+	.num_resources = ARRAY_SIZE(jz4740_framebuffer_resources),
+	.resource = jz4740_framebuffer_resources,
+	.dev = {
+		.dma_mask = &jz4740_fb_dmamask,
+		.coherent_dma_mask = 0xffffffff,
+	},
+};
+
+static struct resource jz4740_i2s_resources[] = {
+	[0] = {
+		.start	= CPHYSADDR(JZ4740_AIC_BASE_ADDR),
+		.end	= CPHYSADDR(JZ4740_AIC_BASE_ADDR) + 0x38 - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+};
+
+struct platform_device jz4740_i2s_device = {
+	.name = "jz4740-i2s",
+	.id = -1,
+	.num_resources = ARRAY_SIZE(jz4740_i2s_resources),
+	.resource = jz4740_i2s_resources,
+};
+
+static struct resource jz4740_codec_resources[] = {
+	[0] = {
+		.start	= CPHYSADDR(JZ4740_AIC_BASE_ADDR) + 0x80,
+		.end	= CPHYSADDR(JZ4740_AIC_BASE_ADDR) + 0x88 - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+};
+
+struct platform_device jz4740_codec_device = {
+	.name		= "jz4740-codec",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(jz4740_codec_resources),
+	.resource	= jz4740_codec_resources,
+};
+
+static struct resource jz4740_adc_resources[] = {
+	[0] = {
+		.start	= CPHYSADDR(JZ4740_SADC_BASE_ADDR),
+		.end	= CPHYSADDR(JZ4740_SADC_BASE_ADDR) + 0x30,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= JZ4740_IRQ_SADC,
+		.end	= JZ4740_IRQ_SADC,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+struct platform_device jz4740_adc_device = {
+	.name		= "jz4740-adc",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(jz4740_adc_resources),
+	.resource	= jz4740_adc_resources,
+};
+
+struct platform_device jz4740_battery_device = {
+	.name = "jz4740-battery",
+	.id = -1,
+	.dev = {
+		.parent	= &jz4740_adc_device.dev
+	},
+};
+
+/* Serial */
+#define JZ4740_UART_DATA(_id) \
+	{ \
+		.flags = UPF_SKIP_TEST | UPF_IOREMAP | UPF_FIXED_TYPE, \
+		.iotype = UPIO_MEM, \
+		.regshift = 2, \
+		.serial_out = jz4740_serial_out, \
+		.type = PORT_16550A, \
+		.mapbase = CPHYSADDR(JZ4740_UART ## _id ## _BASE_ADDR), \
+		.irq = JZ4740_IRQ_UART ## _id, \
+	}
+
+static struct plat_serial8250_port jz4740_uart_data[] = {
+	JZ4740_UART_DATA(0),
+	JZ4740_UART_DATA(1),
+	{},
+};
+
+static struct platform_device jz4740_uart_device = {
+	.name = "serial8250",
+	.id = 0,
+	.dev = {
+		.platform_data = jz4740_uart_data,
+	},
+};
+
+void jz4740_serial_device_register(void)
+{
+	struct plat_serial8250_port *p;
+
+	for (p = jz4740_uart_data; p->flags != 0; ++p)
+		p->uartclk = jz4740_clock_bdata.ext_rate;
+
+	platform_device_register(&jz4740_uart_device);
+}
-- 
1.5.6.5

