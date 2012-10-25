Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946292Ab2JYQMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 12:12:33 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48043 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946255Ab2JYQMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 12:12:25 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
To: <mturquette@linaro.org>, <arnd@arndb.de>, <akpm@linux-foundation.org>,
        <shawn.guo@linaro.org>, <rob.herring@calxeda.com>,
        <linus.walleij@linaro.org>, <viresh.linux@gmail.com>,
        <linux-kernel@vger.kernel.org>, <nsekhar@ti.com>, <khilman@ti.com>,
        <linux@arm.linux.org.uk>, <sshtylyov@mvista.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>
CC: <linux-keystone@list.ti.com>, Murali Karicheri <m-karicheri2@ti.com>
Subject: [PATCH v3 10/11] ARM: davinci - migrate to common clock
Date: Thu, 25 Oct 2012 12:11:56 -0400
Message-ID: <1351181518-11882-11-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com>
References: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently migrate only DM644x as this is being reviewed. Once all
platforms are migrated, the Makefile will be cleaned up to remove
obsoleted files clock.o and psc.o

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 arch/arm/Kconfig               |    1 +
 arch/arm/mach-davinci/Kconfig  |    2 ++
 arch/arm/mach-davinci/Makefile |   11 ++++++++++-
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index c5f9ae5..4611987 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -967,6 +967,7 @@ config ARCH_DAVINCI
 	select ARCH_REQUIRE_GPIOLIB
 	select ZONE_DMA
 	select HAVE_IDE
+	select COMMON_CLK
 	select CLKDEV_LOOKUP
 	select GENERIC_ALLOCATOR
 	select GENERIC_IRQ_CHIP
diff --git a/arch/arm/mach-davinci/Kconfig b/arch/arm/mach-davinci/Kconfig
index ab99c3c..ab414b4 100644
--- a/arch/arm/mach-davinci/Kconfig
+++ b/arch/arm/mach-davinci/Kconfig
@@ -19,6 +19,8 @@ config ARCH_DAVINCI_DM644x
 	bool "DaVinci 644x based system"
 	select AINTC
 	select ARCH_DAVINCI_DMx
+	select DAVINCI_CLKS
+	select CLK_DAVINCI_PLL
 
 config ARCH_DAVINCI_DM355
 	bool "DaVinci 355 based system"
diff --git a/arch/arm/mach-davinci/Makefile b/arch/arm/mach-davinci/Makefile
index 2227eff..5a5b3dc 100644
--- a/arch/arm/mach-davinci/Makefile
+++ b/arch/arm/mach-davinci/Makefile
@@ -4,18 +4,25 @@
 #
 
 # Common objects
+ifndef CONFIG_COMMON_CLK
 obj-y 			:= time.o clock.o serial.o psc.o \
 			   dma.o usb.o common.o sram.o aemif.o
+else
+obj-y 			:= time.o serial.o \
+			   dma.o usb.o common.o sram.o aemif.o
+endif
 
 obj-$(CONFIG_DAVINCI_MUX)		+= mux.o
 
 # Chip specific
 obj-$(CONFIG_ARCH_DAVINCI_DM644x)       += dm644x.o devices.o
+ifndef CONFIG_COMMON_CLK
 obj-$(CONFIG_ARCH_DAVINCI_DM355)        += dm355.o devices.o
-obj-$(CONFIG_ARCH_DAVINCI_DM646x)       += dm646x.o devices.o
 obj-$(CONFIG_ARCH_DAVINCI_DM365)	+= dm365.o devices.o
+obj-$(CONFIG_ARCH_DAVINCI_DM646x)       += dm646x.o devices.o
 obj-$(CONFIG_ARCH_DAVINCI_DA830)        += da830.o devices-da8xx.o
 obj-$(CONFIG_ARCH_DAVINCI_DA850)        += da850.o devices-da8xx.o
+endif
 obj-$(CONFIG_ARCH_DAVINCI_TNETV107X)    += tnetv107x.o devices-tnetv107x.o
 
 obj-$(CONFIG_AINTC)			+= irq.o
@@ -23,6 +30,7 @@ obj-$(CONFIG_CP_INTC)			+= cp_intc.o
 
 # Board specific
 obj-$(CONFIG_MACH_DAVINCI_EVM)  	+= board-dm644x-evm.o
+ifndef CONFIG_COMMON_CLK
 obj-$(CONFIG_MACH_SFFSDR)		+= board-sffsdr.o
 obj-$(CONFIG_MACH_NEUROS_OSD2)		+= board-neuros-osd2.o
 obj-$(CONFIG_MACH_DAVINCI_DM355_EVM)	+= board-dm355-evm.o
@@ -31,6 +39,7 @@ obj-$(CONFIG_MACH_DAVINCI_DM6467_EVM)	+= board-dm646x-evm.o cdce949.o
 obj-$(CONFIG_MACH_DAVINCI_DM365_EVM)	+= board-dm365-evm.o
 obj-$(CONFIG_MACH_DAVINCI_DA830_EVM)	+= board-da830-evm.o
 obj-$(CONFIG_MACH_DAVINCI_DA850_EVM)	+= board-da850-evm.o
+endif
 obj-$(CONFIG_MACH_TNETV107X)		+= board-tnetv107x-evm.o
 obj-$(CONFIG_MACH_MITYOMAPL138)		+= board-mityomapl138.o
 obj-$(CONFIG_MACH_OMAPL138_HAWKBOARD)	+= board-omapl138-hawk.o
-- 
1.7.9.5

