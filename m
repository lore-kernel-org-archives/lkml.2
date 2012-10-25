Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946224Ab2JYQMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 12:12:20 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46619 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946198Ab2JYQMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 12:12:17 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
To: <mturquette@linaro.org>, <arnd@arndb.de>, <akpm@linux-foundation.org>,
        <shawn.guo@linaro.org>, <rob.herring@calxeda.com>,
        <linus.walleij@linaro.org>, <viresh.linux@gmail.com>,
        <linux-kernel@vger.kernel.org>, <nsekhar@ti.com>, <khilman@ti.com>,
        <linux@arm.linux.org.uk>, <sshtylyov@mvista.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>
CC: <linux-keystone@list.ti.com>, Murali Karicheri <m-karicheri2@ti.com>
Subject: [PATCH v3 06/11] clk: davinci - add build infrastructure for DaVinci clock drivers
Date: Thu, 25 Oct 2012 12:11:52 -0400
Message-ID: <1351181518-11882-7-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com>
References: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This updates clk Makefile and Kconfig to integrate the DaVinci specific
clock drivers. Also add new Kconfig and Makefile for these drivers.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 drivers/clk/Kconfig          |    2 ++
 drivers/clk/Makefile         |    1 +
 drivers/clk/davinci/Kconfig  |   44 ++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/davinci/Makefile |    5 +++++
 4 files changed, 52 insertions(+)
 create mode 100644 drivers/clk/davinci/Kconfig
 create mode 100644 drivers/clk/davinci/Makefile

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 7f0b5ca..1ad2ab0 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -33,6 +33,8 @@ config COMMON_CLK_DEBUG
 	  clk_flags, clk_prepare_count, clk_enable_count &
 	  clk_notifier_count.
 
+source "drivers/clk/davinci/Kconfig"
+
 config COMMON_CLK_WM831X
 	tristate "Clock driver for WM831x/2x PMICs"
 	depends on MFD_WM831X
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 5869ea3..b127b6f 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -10,6 +10,7 @@ obj-$(CONFIG_ARCH_SOCFPGA)	+= socfpga/
 obj-$(CONFIG_PLAT_SPEAR)	+= spear/
 obj-$(CONFIG_ARCH_U300)		+= clk-u300.o
 obj-$(CONFIG_ARCH_INTEGRATOR)	+= versatile/
+obj-$(CONFIG_DAVINCI_CLKS)	+= davinci/
 
 # Chip specific
 obj-$(CONFIG_COMMON_CLK_WM831X) += clk-wm831x.o
diff --git a/drivers/clk/davinci/Kconfig b/drivers/clk/davinci/Kconfig
new file mode 100644
index 0000000..e53bbc3
--- /dev/null
+++ b/drivers/clk/davinci/Kconfig
@@ -0,0 +1,44 @@
+menu "TI DaVinci Clock drivers"
+	depends on COMMON_CLK
+
+config  CLK_DAVINCI_PSC
+	bool "TI DaVici PSC clock driver"
+	default n
+	---help---
+	  Selects clock driver for DaVinci PSC clocks. This clock
+	  hardware is found on TI DaVinci SoCs and other SoCs that
+	  uses this hardware IP. This hardware has a local power
+	  sleep control module that gate the clock to the IP.
+
+config  CLK_DAVINCI_PLL
+	bool "DaVici main PLL clock"
+	---help---
+	  Selects clock driver for DaVinci main PLL. This clock
+	  hardware is found on TI DaVinci SoCs. This typically has
+	  a multiplier, a pre divider and post driver. Some of the
+	  SoCs has the the dividers fixed, and others have it
+	  programmable
+
+config  CLK_DAVINCI_PLLDIV
+	bool "DaVici PLL divider clock"
+	---help---
+	  Selects clock driver for DaVinci PLL divider. This clock
+	  hardware is found on TI DaVinci SoCs. This typically has
+	  a divider and an enable bit to bypass or enable the
+	  divider.
+
+config DAVINCI_CLKS
+	bool "TI DaVinci common clocks"
+	default n
+	select CLK_DAVINCI_PSC
+	select CLK_DAVINCI_PLLDIV
+	---help---
+	  Selects common clock drivers for DaVinci. These clocks
+	  are re-used across many TI SoCs that are based on DaVinci and
+	  Keystone (c6x) families. This config option is used to select
+	  the common clock driver for DaVinci based SoCs. SoCs specific
+	  Kconfig option needs to select the driver for clocks specific
+	  to the SoC.
+
+endmenu
+
diff --git a/drivers/clk/davinci/Makefile b/drivers/clk/davinci/Makefile
new file mode 100644
index 0000000..0e13986
--- /dev/null
+++ b/drivers/clk/davinci/Makefile
@@ -0,0 +1,5 @@
+obj-$(CONFIG_CLK_DAVINCI_PLL)		+= clk-pll.o
+obj-$(CONFIG_CLK_DAVINCI_PLLDIV)	+= clk-div.o
+obj-$(CONFIG_CLK_DAVINCI_PSC)		+= clk-psc.o
+obj-$(CONFIG_DAVINCI_CLKS)		+= clock.o
+obj-$(CONFIG_ARCH_DAVINCI_DM644x)	+= dm644x-clock.o
-- 
1.7.9.5

