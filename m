Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964975Ab2B1KWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 05:22:55 -0500
Received: from exprod5og102.obsmtp.com ([64.18.0.143]:48033 "EHLO
	exprod5og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964872Ab2B1KWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 05:22:52 -0500
From: Martyn Welch <martyn.welch@ge.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Wim Van Sebroeck <wim@iguana.be>,
        Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org,
        Martyn Welch <martyn.welch@ge.com>
Subject: [PATCH V2 1/2] powerpc: Move GE GPIO and PIC drivers
Date: Tue, 28 Feb 2012 10:22:20 +0000
Message-Id: <1330424541-5299-2-git-send-email-martyn.welch@ge.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1330424541-5299-1-git-send-email-martyn.welch@ge.com>
References: <1330424541-5299-1-git-send-email-martyn.welch@ge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the GE GPIO and PIC drivers to allow these to be used by non-86xx
boards.

Signed-off-by: Martyn Welch <martyn.welch@ge.com>
---

v2: Move GPIO and PIC drivers to sysdev/ge/ rather than platforms/.

 arch/powerpc/platforms/86xx/Kconfig                |    3 +++
 arch/powerpc/platforms/86xx/Makefile               |    7 +++----
 arch/powerpc/platforms/86xx/gef_ppc9a.c            |    2 +-
 arch/powerpc/platforms/86xx/gef_sbc310.c           |    2 +-
 arch/powerpc/platforms/86xx/gef_sbc610.c           |    2 +-
 arch/powerpc/sysdev/Kconfig                        |    7 +++++++
 arch/powerpc/sysdev/Makefile                       |    2 ++
 arch/powerpc/sysdev/ge/Makefile                    |    2 ++
 .../86xx/gef_gpio.c => sysdev/ge/ge_gpio.c}        |    2 +-
 .../86xx/gef_pic.c => sysdev/ge/ge_pic.c}          |    2 +-
 .../86xx/gef_pic.h => sysdev/ge/ge_pic.h}          |    0
 drivers/watchdog/Kconfig                           |    2 +-
 12 files changed, 23 insertions(+), 10 deletions(-)
 create mode 100644 arch/powerpc/sysdev/ge/Makefile
 rename arch/powerpc/{platforms/86xx/gef_gpio.c => sysdev/ge/ge_gpio.c} (98%)
 rename arch/powerpc/{platforms/86xx/gef_pic.c => sysdev/ge/ge_pic.c} (99%)
 rename arch/powerpc/{platforms/86xx/gef_pic.h => sysdev/ge/ge_pic.h} (100%)

diff --git a/arch/powerpc/platforms/86xx/Kconfig b/arch/powerpc/platforms/86xx/Kconfig
index 8d6599d..2015022 100644
--- a/arch/powerpc/platforms/86xx/Kconfig
+++ b/arch/powerpc/platforms/86xx/Kconfig
@@ -39,6 +39,7 @@ config GEF_PPC9A
 	select MMIO_NVRAM
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
+	select GE_FPGA
 	help
 	  This option enables support for the GE PPC9A.
 
@@ -48,6 +49,7 @@ config GEF_SBC310
 	select MMIO_NVRAM
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
+	select GE_FPGA
 	help
 	  This option enables support for the GE SBC310.
 
@@ -58,6 +60,7 @@ config GEF_SBC610
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
 	select HAS_RAPIDIO
+	select GE_FPGA
 	help
 	  This option enables support for the GE SBC610.
 
diff --git a/arch/powerpc/platforms/86xx/Makefile b/arch/powerpc/platforms/86xx/Makefile
index 4b0d7b1..ede815d 100644
--- a/arch/powerpc/platforms/86xx/Makefile
+++ b/arch/powerpc/platforms/86xx/Makefile
@@ -7,7 +7,6 @@ obj-$(CONFIG_SMP)		+= mpc86xx_smp.o
 obj-$(CONFIG_MPC8641_HPCN)	+= mpc86xx_hpcn.o
 obj-$(CONFIG_SBC8641D)		+= sbc8641d.o
 obj-$(CONFIG_MPC8610_HPCD)	+= mpc8610_hpcd.o
-gef-gpio-$(CONFIG_GPIOLIB)	+= gef_gpio.o
-obj-$(CONFIG_GEF_SBC610)	+= gef_sbc610.o gef_pic.o $(gef-gpio-y)
-obj-$(CONFIG_GEF_SBC310)	+= gef_sbc310.o gef_pic.o $(gef-gpio-y)
-obj-$(CONFIG_GEF_PPC9A)		+= gef_ppc9a.o gef_pic.o $(gef-gpio-y)
+obj-$(CONFIG_GEF_SBC610)	+= gef_sbc610.o
+obj-$(CONFIG_GEF_SBC310)	+= gef_sbc310.o
+obj-$(CONFIG_GEF_PPC9A)		+= gef_ppc9a.o
diff --git a/arch/powerpc/platforms/86xx/gef_ppc9a.c b/arch/powerpc/platforms/86xx/gef_ppc9a.c
index 60ce07e..ed58b6c 100644
--- a/arch/powerpc/platforms/86xx/gef_ppc9a.c
+++ b/arch/powerpc/platforms/86xx/gef_ppc9a.c
@@ -37,9 +37,9 @@
 
 #include <sysdev/fsl_pci.h>
 #include <sysdev/fsl_soc.h>
+#include <sysdev/ge/ge_pic.h>
 
 #include "mpc86xx.h"
-#include "gef_pic.h"
 
 #undef DEBUG
 
diff --git a/arch/powerpc/platforms/86xx/gef_sbc310.c b/arch/powerpc/platforms/86xx/gef_sbc310.c
index 3ecee25..710db69 100644
--- a/arch/powerpc/platforms/86xx/gef_sbc310.c
+++ b/arch/powerpc/platforms/86xx/gef_sbc310.c
@@ -37,9 +37,9 @@
 
 #include <sysdev/fsl_pci.h>
 #include <sysdev/fsl_soc.h>
+#include <sysdev/ge/ge_pic.h>
 
 #include "mpc86xx.h"
-#include "gef_pic.h"
 
 #undef DEBUG
 
diff --git a/arch/powerpc/platforms/86xx/gef_sbc610.c b/arch/powerpc/platforms/86xx/gef_sbc610.c
index 5090d60..4a13d2f 100644
--- a/arch/powerpc/platforms/86xx/gef_sbc610.c
+++ b/arch/powerpc/platforms/86xx/gef_sbc610.c
@@ -37,9 +37,9 @@
 
 #include <sysdev/fsl_pci.h>
 #include <sysdev/fsl_soc.h>
+#include <sysdev/ge/ge_pic.h>
 
 #include "mpc86xx.h"
-#include "gef_pic.h"
 
 #undef DEBUG
 
diff --git a/arch/powerpc/sysdev/Kconfig b/arch/powerpc/sysdev/Kconfig
index 7b4df37..cd0ef0b 100644
--- a/arch/powerpc/sysdev/Kconfig
+++ b/arch/powerpc/sysdev/Kconfig
@@ -29,3 +29,10 @@ config SCOM_DEBUGFS
 	bool "Expose SCOM controllers via debugfs"
 	depends on PPC_SCOM
 	default n
+
+config GE_FPGA
+	bool
+	default n
+	help
+	  Support for common GPIO and interrupt routing functionality provided
+	  on some GE Single Board Computers.
diff --git a/arch/powerpc/sysdev/Makefile b/arch/powerpc/sysdev/Makefile
index 5e37b47..f80ff9f 100644
--- a/arch/powerpc/sysdev/Makefile
+++ b/arch/powerpc/sysdev/Makefile
@@ -65,3 +65,5 @@ obj-$(CONFIG_PPC_SCOM)		+= scom.o
 subdir-ccflags-$(CONFIG_PPC_WERROR) := -Werror
 
 obj-$(CONFIG_PPC_XICS)		+= xics/
+
+obj-$(CONFIG_GE_FPGA)		+= ge/
diff --git a/arch/powerpc/sysdev/ge/Makefile b/arch/powerpc/sysdev/ge/Makefile
new file mode 100644
index 0000000..6a10372
--- /dev/null
+++ b/arch/powerpc/sysdev/ge/Makefile
@@ -0,0 +1,2 @@
+gef-gpio-$(CONFIG_GPIOLIB)	+= ge_gpio.o
+obj-$(CONFIG_GE_FPGA)		+= ge_pic.o $(gef-gpio-y)
diff --git a/arch/powerpc/platforms/86xx/gef_gpio.c b/arch/powerpc/sysdev/ge/ge_gpio.c
similarity index 98%
rename from arch/powerpc/platforms/86xx/gef_gpio.c
rename to arch/powerpc/sysdev/ge/ge_gpio.c
index 2a70336..f8e6289 100644
--- a/arch/powerpc/platforms/86xx/gef_gpio.c
+++ b/arch/powerpc/sysdev/ge/ge_gpio.c
@@ -14,7 +14,7 @@
  *
  * Configuration of output modes (totem-pole/open-drain)
  * Interrupt configuration - interrupts are always generated the FPGA relies on
- * 	the I/O interrupt controllers mask to stop them propergating
+ * the I/O interrupt controllers mask to stop them propergating
  */
 
 #include <linux/kernel.h>
diff --git a/arch/powerpc/platforms/86xx/gef_pic.c b/arch/powerpc/sysdev/ge/ge_pic.c
similarity index 99%
rename from arch/powerpc/platforms/86xx/gef_pic.c
rename to arch/powerpc/sysdev/ge/ge_pic.c
index 94594e5..002a562 100644
--- a/arch/powerpc/platforms/86xx/gef_pic.c
+++ b/arch/powerpc/sysdev/ge/ge_pic.c
@@ -22,7 +22,7 @@
 #include <asm/prom.h>
 #include <asm/irq.h>
 
-#include "gef_pic.h"
+#include "ge_pic.h"
 
 #define DEBUG
 #undef DEBUG
diff --git a/arch/powerpc/platforms/86xx/gef_pic.h b/arch/powerpc/sysdev/ge/ge_pic.h
similarity index 100%
rename from arch/powerpc/platforms/86xx/gef_pic.h
rename to arch/powerpc/sysdev/ge/ge_pic.h
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 877b107..2955c3f 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -1039,7 +1039,7 @@ config LANTIQ_WDT
 
 config GEF_WDT
 	tristate "GE Watchdog Timer"
-	depends on GEF_SBC610 || GEF_SBC310 || GEF_PPC9A
+	depends on GE_FPGA
 	---help---
 	  Watchdog timer found in a number of GE single board computers.
 
-- 
1.7.0.4

