Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965048Ab2EWPGs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:06:48 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:53973 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932653Ab2EWPGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:06:44 -0400
Date: Wed, 23 May 2012 17:06:41 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Dave Mueller <d.mueller@elsoft.ch>,
        Devendra Naga <devendra.aaru@gmail.com>,
        Diego Elio =?iso-8859-1?Q?Petten=F2?= <flameeyes@flameeyes.eu>,
        Hans de Goede <hdegoede@redhat.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Michael Olbrich <m.olbrich@pengutronix.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Rob Herring <rob.herring@calxeda.com>,
        Roland Stigge <stigge@antcom.de>
Subject: [GIT PULL REQUEST] watchdog - v3.5 Merge window part 1
Message-ID: <20120523150641.GK3074@spo001.leaseweb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://www.linux-watchdog.org/linux-watchdog.git

This pull contains:
* The removal of ixp2000_wdt
* The addition of ie6xx_wdt
* Some documentation fixes
* Small fixes and improvements

(Note: Part 2 will contain generic watchdog core changes + conversion
of some more drivers.)

This will update the following files:

 b/Documentation/devicetree/bindings/watchdog/pnx4008-wdt.txt |   13 
 b/Documentation/watchdog/src/watchdog-test.c                 |   20 
 b/Documentation/watchdog/watchdog-kernel-api.txt             |    2 
 b/drivers/watchdog/Kconfig                                   |   35 -
 b/drivers/watchdog/Makefile                                  |    2 
 b/drivers/watchdog/ar7_wdt.c                                 |   33 -
 b/drivers/watchdog/hpwdt.c                                   |   13 
 b/drivers/watchdog/i6300esb.c                                |   14 
 b/drivers/watchdog/ie6xx_wdt.c                               |  348 +++++++++++
 b/drivers/watchdog/it87_wdt.c                                |    7 
 b/drivers/watchdog/pcwd_pci.c                                |   18 
 b/drivers/watchdog/pnx4008_wdt.c                             |   10 
 b/drivers/watchdog/s3c2410_wdt.c                             |    7 
 b/drivers/watchdog/sch311x_wdt.c                             |   39 -
 b/drivers/watchdog/sp5100_tco.c                              |    2 
 b/drivers/watchdog/via_wdt.c                                 |   18 
 b/drivers/watchdog/wdt_pci.c                                 |   34 -
 b/drivers/watchdog/wm831x_wdt.c                              |   13 
 drivers/watchdog/ixp2000_wdt.c                               |  215 ------
 19 files changed, 447 insertions(+), 396 deletions(-)

with these Changes:

commit cad19fa66469d2a745fae0c168833d5d33d64489
Author: Devendra Naga <devendra.aaru@gmail.com>
Date:   Thu May 17 15:07:48 2012 +0530

    Documentation/watchdog: Fix the file descriptor leak when no cmdline arg given
    
    we start a infinite loop when user gives ./watchdog-test, and when user
    ctrl + c's the program, we just exit immeadiately with out closing the
    filedescriptor of the watchdog device. a signal handler is used to
    do the job of closing the filedescriptor and exiting the program.
    
    Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 3c2a6186c1a69d647e3a48ad3f7f9078c451111e
Author: Devendra Naga <devendra.aaru@gmail.com>
Date:   Mon May 14 23:42:02 2012 +0530

    Documentation/watchdog: close the fd when cmdline arg given
    
    in the watchdog test code, the ioctl is performed on the watchdog device
    and just doing exit(0) so we leak a filedescripor.
    
    Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 2deca7365582b7568dbdd2c3d9eef7ac17d41fd6
Author: Devendra Naga <devendra.aaru@gmail.com>
Date:   Mon May 14 14:33:37 2012 +0530

    Documentation/watchdog: Fix a small typo
    
    Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 5f2430f554aabb4810b2a6f906be571ac1241d96
Author: Hans de Goede <hdegoede@redhat.com>
Date:   Fri May 11 12:00:27 2012 +0200

    watchdog: s3c2410_wdt: Set timeout to actually achieved timeout
    
    While rebasing my "watchdog_dev: Let the driver update the timeout field on
    set_timeout success" patch (before I noticed it was already picked up by Wim),
    I noticed that the s3c2410_wdt driver may not always have a 1 second
    resolution, this patch changes s3c2410wdt_set_heartbeat to update the
    timeout to the actually achieved timeout.
    
    Signed-off-by: Hans de Goede <hdegoede@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit abcf834b80eefb2ded56254ce7de94d2ab258d22
Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
Date:   Sun May 13 23:42:55 2012 +0100

    watchdog: wm831x: Convert to gpio_request_one()
    
    Use the more modern API.
    
    Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 690e7a706da6cb1af0363529603048ef3fce9e82
Author: Randy Dunlap <rdunlap@xenotime.net>
Date:   Fri May 11 16:37:22 2012 -0700

    watchdog: via_wdt: depends on PCI
    
    via_wdt is a PCI driver so it should depend on PCI so that
    it will not cause build errors.
    
    drivers/watchdog/via_wdt.c:256:1: warning: data definition has no type or storage class
    drivers/watchdog/via_wdt.c:256:1: warning: type defaults to 'int' in declaration of 'module_pci_driver'
    drivers/watchdog/via_wdt.c:256:1: warning: parameter names (without types) in function declaration
    
    Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 491d9e2a5f0e845a91ef53065afb4805a668d80d
Author: Randy Dunlap <rdunlap@xenotime.net>
Date:   Mon May 14 13:14:29 2012 -0700

    watchdog: ie6xx_wdt needs io.h
    
    Fix build error by including <linux/io.h>:
    
    drivers/watchdog/ie6xx_wdt.c:97:2: error: implicit declaration of function 'outb'
    drivers/watchdog/ie6xx_wdt.c:133:2: error: implicit declaration of function 'outl'
    drivers/watchdog/ie6xx_wdt.c:161:2: error: implicit declaration of function 'inb'
    drivers/watchdog/ie6xx_wdt.c:199:3: error: implicit declaration of function 'inl'
    drivers/watchdog/ie6xx_wdt.c:203:3: error: implicit declaration of function 'inw'
    
    Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 744f6f4d3db2e9f153c9381b169aaee5c6ad4187
Author: Randy Dunlap <rdunlap@xenotime.net>
Date:   Fri May 11 18:33:31 2012 -0700

    watchdog: ie6xx_wdt.c: fix printk format warning
    
    Fix printk format warning; use cast to u64 since resource_size_t can
    be either u32 or u64.
    
    drivers/watchdog/ie6xx_wdt.c:261:4: warning: format '%x' expects type 'unsigned int', but argument 3 has type 'resource_size_t'
    
    Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 101ce87b3bdd5352edceb5a079e765685c13dbc3
Author: Alexander Stein <alexander.stein@systec-electronic.com>
Date:   Thu May 10 16:37:43 2012 +0200

    watchdog: Add watchdog driver for Intel Atom E6XX
    
    Add driver for the watchdog timer built into the
    Intel Atom E6XX (TunnelCreek) processor.
    
    Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 198ca0153412a97e968b5deb67d789000faef129
Author: Diego Elio Pettenò <flameeyes@flameeyes.eu>
Date:   Wed Mar 14 20:49:04 2012 +0100

    watchdog: it87_wdt: Add support for IT8728F watchdog.
    
    This works the same way IT8721F works, but it supports WDT_PWROK
    (checked on the datasheet).
    
    Signed-off-by: Diego Elio Pettenò <flameeyes@flameeyes.eu>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 7050bd54997a1606377a1985b508a145ea8c1555
Author: Michael Olbrich <m.olbrich@pengutronix.de>
Date:   Sun Apr 8 13:56:06 2012 +0200

    watchdog: i6300esb: don't depend on X86
    
    i6300esb is on of the watchdogs QEMU can emulate. It is also available
    when emulating ARM. The driver works without problems and is quite
    useful to test userspace dealing with /dev/watchdog.
    
    Signed-off-by: Michael Olbrich <m.olbrich@pengutronix.de>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 5ce9c371c788638890980b27f0cd8af7071b3a50
Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Fri May 4 14:43:25 2012 +0200

    watchdog: Use module_pci_driver
    
    This patch converts the PCI watchdog drivers so that they use the
    module_pci_driver() macro. This makes the code smaller and simpler.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Cc: Thomas Mingarelli <thomas.mingarelli@hp.com>
    Cc: Marc Vertes <marc.vertes@sigfox.com>

commit 8f90a3ae8f67a6c521e2d8fcb488262833f2a4cd
Author: Dave Mueller <d.mueller@elsoft.ch>
Date:   Wed Apr 11 15:43:22 2012 +0200

    watchdog: sch311x_wdt.c: Remove RESGEN
    
    The SCH311x chip contains 2 watchdogs. One is the watchdog programmable
    by the runtime register at address 0x65-0x68, the other is the watchdog
    inside the power on reset generator. This second watchdog has a fixed
    timeout value of ~1.6 seconds and is configurable only by the RESGEN
    register.
    
    The BIOS normally takes care of the RESGEN watchdog and disables it (at
    least) before the OS is booted.
    
    Unfortunately the sch311x_wdt driver clears bit 0 of the RESGEN register
    which has the effect that at the latest 1.6 seconds later, a POR is
    triggered.
    
    The attached patch fixes this problem by completely removing any
    reference to the RESGEN watchdog from the sch311x_wdt driver.
    
    Signed-off-by: Dave Mueller <d.mueller@elsoft.ch>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 3016a552a8314b2734aed0a1acbb983459e2acc4
Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Thu May 3 05:24:17 2012 +0000

    watchdog: s3c2410-wdt: Use of_match_ptr().
    
    Use of_match_ptr definition for the of_match_table.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

commit 3ba3774b8c433fe9e91158d65cf2324ff0c5a15d
Author: Roland Stigge <stigge@antcom.de>
Date:   Fri Apr 20 21:55:29 2012 +0200

    watchdog: Device tree support for pnx4008-wdt
    
    This patch adds device tree support to pnx4008-wdt.c
    
    Signed-off-by: Roland Stigge <stigge@antcom.de>
    Reviewed-by: Arnd Bergmann <arnd@arndb.de>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit ae21cc20a604b45e97d0cdbce7e9302ce7dd7d5c
Author: Julia Lawall <Julia.Lawall@lip6.fr>
Date:   Sun Apr 15 12:27:33 2012 +0200

    watchdog: ar7_wdt.c: use devm_request_and_ioremap
    
    Combine request_region and ioremap into devm_request_and_ioremap.  This has
    the effect of fixing a missing iounmap on the failure of clk_get.
    
    This also introduces a call to clk_put and clears the vbus_clk variable in
    the case of failure or device removal.
    
    Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 065e8238302b630046ba3621943907cf509e78dd
Author: Rob Herring <rob.herring@calxeda.com>
Date:   Tue Apr 3 20:34:03 2012 -0500

    watchdog: remove ixp2000 driver
    
    The platform is removed, so there are no users of this driver.
    
    Signed-off-by: Rob Herring <rob.herring@calxeda.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 62a9aebc5b8e28073a8609b9af6e8321cc622344
Author: H Hartley Sweeten <hartleys@visionengravers.com>
Date:   Wed May 2 16:54:43 2012 -0700

    watchdog: sp5100_tco.c: quiet sparse noise about using plain integer was NULL pointer
    
    Pointers should not be compared to plain integers.
    Quiets the sparse warning:
    warning: Using plain integer as NULL pointer
    
    Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/Documentation/devicetree/bindings/watchdog/pnx4008-wdt.txt b/Documentation/devicetree/bindings/watchdog/pnx4008-wdt.txt
new file mode 100644
index 0000000..7c7f688
--- /dev/null
+++ b/Documentation/devicetree/bindings/watchdog/pnx4008-wdt.txt
@@ -0,0 +1,13 @@
+* NXP PNX watchdog timer
+
+Required properties:
+- compatible: must be "nxp,pnx4008-wdt"
+- reg: physical base address of the controller and length of memory mapped
+  region.
+
+Example:
+
+	watchdog@4003C000 {
+		compatible = "nxp,pnx4008-wdt";
+		reg = <0x4003C000 0x1000>;
+	};
diff --git a/Documentation/watchdog/src/watchdog-test.c b/Documentation/watchdog/src/watchdog-test.c
index 63fdc34..73ff5cc 100644
--- a/Documentation/watchdog/src/watchdog-test.c
+++ b/Documentation/watchdog/src/watchdog-test.c
@@ -7,6 +7,7 @@
 #include <string.h>
 #include <unistd.h>
 #include <fcntl.h>
+#include <signal.h>
 #include <sys/ioctl.h>
 #include <linux/types.h>
 #include <linux/watchdog.h>
@@ -29,6 +30,14 @@ static void keep_alive(void)
  * The main program.  Run the program with "-d" to disable the card,
  * or "-e" to enable the card.
  */
+
+void term(int sig)
+{
+    close(fd);
+    fprintf(stderr, "Stopping watchdog ticks...\n");
+    exit(0);
+}
+
 int main(int argc, char *argv[])
 {
     int flags;
@@ -47,26 +56,31 @@ int main(int argc, char *argv[])
 	    ioctl(fd, WDIOC_SETOPTIONS, &flags);
 	    fprintf(stderr, "Watchdog card disabled.\n");
 	    fflush(stderr);
-	    exit(0);
+	    goto end;
 	} else if (!strncasecmp(argv[1], "-e", 2)) {
 	    flags = WDIOS_ENABLECARD;
 	    ioctl(fd, WDIOC_SETOPTIONS, &flags);
 	    fprintf(stderr, "Watchdog card enabled.\n");
 	    fflush(stderr);
-	    exit(0);
+	    goto end;
 	} else {
 	    fprintf(stderr, "-d to disable, -e to enable.\n");
 	    fprintf(stderr, "run by itself to tick the card.\n");
 	    fflush(stderr);
-	    exit(0);
+	    goto end;
 	}
     } else {
 	fprintf(stderr, "Watchdog Ticking Away!\n");
 	fflush(stderr);
     }
 
+    signal(SIGINT, term);
+
     while(1) {
 	keep_alive();
 	sleep(1);
     }
+end:
+    close(fd);
+    return 0;
 }
diff --git a/Documentation/watchdog/watchdog-kernel-api.txt b/Documentation/watchdog/watchdog-kernel-api.txt
index 227f6cd..25fe430 100644
--- a/Documentation/watchdog/watchdog-kernel-api.txt
+++ b/Documentation/watchdog/watchdog-kernel-api.txt
@@ -59,7 +59,7 @@ It contains following fields:
 * bootstatus: status of the device after booting (reported with watchdog
   WDIOF_* status bits).
 * driver_data: a pointer to the drivers private data of a watchdog device.
-  This data should only be accessed via the watchdog_set_drvadata and
+  This data should only be accessed via the watchdog_set_drvdata and
   watchdog_get_drvdata routines.
 * status: this field contains a number of status bits that give extra
   information about the status of the device (Like: is the watchdog timer
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index eeea76f..bc2ff8b 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -129,17 +129,6 @@ config 977_WATCHDOG
 
 	  Not sure? It's safe to say N.
 
-config IXP2000_WATCHDOG
-	tristate "IXP2000 Watchdog"
-	depends on ARCH_IXP2000
-	help
-	  Say Y here if to include support for the watchdog timer
-	  in the Intel IXP2000(2400, 2800, 2850) network processors.
-	  This driver can be built as a module by choosing M. The module
-	  will be called ixp2000_wdt.
-
-	  Say N if you are unsure.
-
 config IXP4XX_WATCHDOG
 	tristate "IXP4xx Watchdog"
 	depends on ARCH_IXP4XX
@@ -543,7 +532,7 @@ config WAFER_WDT
 
 config I6300ESB_WDT
 	tristate "Intel 6300ESB Timer/Watchdog"
-	depends on X86 && PCI
+	depends on PCI
 	---help---
 	  Hardware driver for the watchdog timer built into the Intel
 	  6300ESB controller hub.
@@ -551,6 +540,19 @@ config I6300ESB_WDT
 	  To compile this driver as a module, choose M here: the
 	  module will be called i6300esb.
 
+config IE6XX_WDT
+	tristate "Intel Atom E6xx Watchdog"
+	depends on X86 && PCI
+	select WATCHDOG_CORE
+	select MFD_CORE
+	select LPC_SCH
+	---help---
+	  Hardware driver for the watchdog timer built into the Intel
+	  Atom E6XX (TunnelCreek) processor.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called ie6xx_wdt.
+
 config INTEL_SCU_WATCHDOG
 	bool "Intel SCU Watchdog for Mobile Platforms"
 	depends on X86_MRST
@@ -607,7 +609,12 @@ config IT87_WDT
 	depends on X86 && EXPERIMENTAL
 	---help---
 	  This is the driver for the hardware watchdog on the ITE IT8702,
-	  IT8712, IT8716, IT8718, IT8720, IT8721, IT8726 Super I/O chips.
+	  IT8712, IT8716, IT8718, IT8720, IT8721, IT8726 and IT8728
+	  Super I/O chips.
+
+	  If the driver does not work, then make sure that the game port in
+	  the BIOS is enabled.
+
 	  This watchdog simply watches your kernel to make sure it doesn't
 	  freeze, and if it does, it reboots your computer after a certain
 	  amount of time.
@@ -780,7 +787,7 @@ config SMSC37B787_WDT
 
 config VIA_WDT
 	tristate "VIA Watchdog Timer"
-	depends on X86
+	depends on X86 && PCI
 	select WATCHDOG_CORE
 	---help---
 	This is the driver for the hardware watchdog timer on VIA
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index e8f479a..442bfbe 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -36,7 +36,6 @@ obj-$(CONFIG_OMAP_WATCHDOG) += omap_wdt.o
 obj-$(CONFIG_TWL4030_WATCHDOG) += twl4030_wdt.o
 obj-$(CONFIG_21285_WATCHDOG) += wdt285.o
 obj-$(CONFIG_977_WATCHDOG) += wdt977.o
-obj-$(CONFIG_IXP2000_WATCHDOG) += ixp2000_wdt.o
 obj-$(CONFIG_IXP4XX_WATCHDOG) += ixp4xx_wdt.o
 obj-$(CONFIG_KS8695_WATCHDOG) += ks8695_wdt.o
 obj-$(CONFIG_S3C2410_WATCHDOG) += s3c2410_wdt.o
@@ -81,6 +80,7 @@ obj-$(CONFIG_IB700_WDT) += ib700wdt.o
 obj-$(CONFIG_IBMASR) += ibmasr.o
 obj-$(CONFIG_WAFER_WDT) += wafer5823wdt.o
 obj-$(CONFIG_I6300ESB_WDT) += i6300esb.o
+obj-$(CONFIG_IE6XX_WDT) += ie6xx_wdt.o
 obj-$(CONFIG_ITCO_WDT) += iTCO_wdt.o
 ifeq ($(CONFIG_ITCO_VENDOR_SUPPORT),y)
 obj-$(CONFIG_ITCO_WDT) += iTCO_vendor_support.o
diff --git a/drivers/watchdog/ar7_wdt.c b/drivers/watchdog/ar7_wdt.c
index 639ae9a..dc30dbd 100644
--- a/drivers/watchdog/ar7_wdt.c
+++ b/drivers/watchdog/ar7_wdt.c
@@ -282,29 +282,19 @@ static int __devinit ar7_wdt_probe(struct platform_device *pdev)
 		platform_get_resource_byname(pdev, IORESOURCE_MEM, "regs");
 	if (!ar7_regs_wdt) {
 		pr_err("could not get registers resource\n");
-		rc = -ENODEV;
-		goto out;
-	}
-
-	if (!request_mem_region(ar7_regs_wdt->start,
-				resource_size(ar7_regs_wdt), LONGNAME)) {
-		pr_warn("watchdog I/O region busy\n");
-		rc = -EBUSY;
-		goto out;
+		return -ENODEV;
 	}
 
-	ar7_wdt = ioremap(ar7_regs_wdt->start, resource_size(ar7_regs_wdt));
+	ar7_wdt = devm_request_and_ioremap(&pdev->dev, ar7_regs_wdt);
 	if (!ar7_wdt) {
 		pr_err("could not ioremap registers\n");
-		rc = -ENXIO;
-		goto out_mem_region;
+		return -ENXIO;
 	}
 
 	vbus_clk = clk_get(NULL, "vbus");
 	if (IS_ERR(vbus_clk)) {
 		pr_err("could not get vbus clock\n");
-		rc = PTR_ERR(vbus_clk);
-		goto out_mem_region;
+		return PTR_ERR(vbus_clk);
 	}
 
 	ar7_wdt_disable_wdt();
@@ -314,24 +304,21 @@ static int __devinit ar7_wdt_probe(struct platform_device *pdev)
 	rc = misc_register(&ar7_wdt_miscdev);
 	if (rc) {
 		pr_err("unable to register misc device\n");
-		goto out_alloc;
+		goto out;
 	}
-	goto out;
+	return 0;
 
-out_alloc:
-	iounmap(ar7_wdt);
-out_mem_region:
-	release_mem_region(ar7_regs_wdt->start, resource_size(ar7_regs_wdt));
 out:
+	clk_put(vbus_clk);
+	vbus_clk = NULL;
 	return rc;
 }
 
 static int __devexit ar7_wdt_remove(struct platform_device *pdev)
 {
 	misc_deregister(&ar7_wdt_miscdev);
-	iounmap(ar7_wdt);
-	release_mem_region(ar7_regs_wdt->start, resource_size(ar7_regs_wdt));
-
+	clk_put(vbus_clk);
+	vbus_clk = NULL;
 	return 0;
 }
 
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 23885f2..2b76381 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -861,16 +861,6 @@ static struct pci_driver hpwdt_driver = {
 	.remove = __devexit_p(hpwdt_exit),
 };
 
-static void __exit hpwdt_cleanup(void)
-{
-	pci_unregister_driver(&hpwdt_driver);
-}
-
-static int __init hpwdt_init(void)
-{
-	return pci_register_driver(&hpwdt_driver);
-}
-
 MODULE_AUTHOR("Tom Mingarelli");
 MODULE_DESCRIPTION("hp watchdog driver");
 MODULE_LICENSE("GPL");
@@ -889,5 +879,4 @@ module_param(allow_kdump, int, 0);
 MODULE_PARM_DESC(allow_kdump, "Start a kernel dump after NMI occurs");
 #endif /* !CONFIG_HPWDT_NMI_DECODING */
 
-module_init(hpwdt_init);
-module_exit(hpwdt_cleanup);
+module_pci_driver(hpwdt_driver);
diff --git a/drivers/watchdog/i6300esb.c b/drivers/watchdog/i6300esb.c
index 738032a..276877d 100644
--- a/drivers/watchdog/i6300esb.c
+++ b/drivers/watchdog/i6300esb.c
@@ -492,19 +492,7 @@ static struct pci_driver esb_driver = {
 	.shutdown       = esb_shutdown,
 };
 
-static int __init watchdog_init(void)
-{
-	return pci_register_driver(&esb_driver);
-}
-
-static void __exit watchdog_cleanup(void)
-{
-	pci_unregister_driver(&esb_driver);
-	pr_info("Watchdog Module Unloaded\n");
-}
-
-module_init(watchdog_init);
-module_exit(watchdog_cleanup);
+module_pci_driver(esb_driver);
 
 MODULE_AUTHOR("Ross Biro and David Härdeman");
 MODULE_DESCRIPTION("Watchdog driver for Intel 6300ESB chipsets");
diff --git a/drivers/watchdog/ie6xx_wdt.c b/drivers/watchdog/ie6xx_wdt.c
new file mode 100644
index 0000000..5f0d776
--- /dev/null
+++ b/drivers/watchdog/ie6xx_wdt.c
@@ -0,0 +1,348 @@
+/*
+ *      Intel Atom E6xx Watchdog driver
+ *
+ *      Copyright (C) 2011 Alexander Stein
+ *                <alexander.stein@systec-electronic.com>
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of version 2 of the GNU General
+ *      Public License as published by the Free Software Foundation.
+ *
+ *      This program is distributed in the hope that it will be
+ *      useful, but WITHOUT ANY WARRANTY; without even the implied
+ *      warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
+ *      PURPOSE.  See the GNU General Public License for more details.
+ *      You should have received a copy of the GNU General Public
+ *      License along with this program; if not, write to the Free
+ *      Software Foundation, Inc., 59 Temple Place - Suite 330,
+ *      Boston, MA  02111-1307, USA.
+ *      The full GNU General Public License is included in this
+ *      distribution in the file called COPYING.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/watchdog.h>
+#include <linux/miscdevice.h>
+#include <linux/seq_file.h>
+#include <linux/debugfs.h>
+#include <linux/uaccess.h>
+#include <linux/spinlock.h>
+
+#define DRIVER_NAME "ie6xx_wdt"
+
+#define PV1	0x00
+#define PV2	0x04
+
+#define RR0	0x0c
+#define RR1	0x0d
+#define WDT_RELOAD	0x01
+#define WDT_TOUT	0x02
+
+#define WDTCR	0x10
+#define WDT_PRE_SEL	0x04
+#define WDT_RESET_SEL	0x08
+#define WDT_RESET_EN	0x10
+#define WDT_TOUT_EN	0x20
+
+#define DCR	0x14
+
+#define WDTLR	0x18
+#define WDT_LOCK	0x01
+#define WDT_ENABLE	0x02
+#define WDT_TOUT_CNF	0x03
+
+#define MIN_TIME	1
+#define MAX_TIME	(10 * 60) /* 10 minutes */
+#define DEFAULT_TIME	60
+
+static unsigned int timeout = DEFAULT_TIME;
+module_param(timeout, uint, 0);
+MODULE_PARM_DESC(timeout,
+		"Default Watchdog timer setting ("
+		__MODULE_STRING(DEFAULT_TIME) "s)."
+		"The range is from 1 to 600");
+
+static bool nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, bool, 0);
+MODULE_PARM_DESC(nowayout,
+	"Watchdog cannot be stopped once started (default="
+		__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+static u8 resetmode = 0x10;
+module_param(resetmode, byte, 0);
+MODULE_PARM_DESC(resetmode,
+	"Resetmode bits: 0x08 warm reset (cold reset otherwise), "
+	"0x10 reset enable, 0x20 disable toggle GPIO[4] (default=0x10)");
+
+static struct {
+	unsigned short sch_wdtba;
+	struct spinlock unlock_sequence;
+#ifdef CONFIG_DEBUG_FS
+	struct dentry *debugfs;
+#endif
+} ie6xx_wdt_data;
+
+/*
+ * This is needed to write to preload and reload registers
+ * struct ie6xx_wdt_data.unlock_sequence must be used
+ * to prevent sequence interrupts
+ */
+static void ie6xx_wdt_unlock_registers(void)
+{
+	outb(0x80, ie6xx_wdt_data.sch_wdtba + RR0);
+	outb(0x86, ie6xx_wdt_data.sch_wdtba + RR0);
+}
+
+static int ie6xx_wdt_ping(struct watchdog_device *wdd)
+{
+	spin_lock(&ie6xx_wdt_data.unlock_sequence);
+	ie6xx_wdt_unlock_registers();
+	outb(WDT_RELOAD, ie6xx_wdt_data.sch_wdtba + RR1);
+	spin_unlock(&ie6xx_wdt_data.unlock_sequence);
+	return 0;
+}
+
+static int ie6xx_wdt_set_timeout(struct watchdog_device *wdd, unsigned int t)
+{
+	u32 preload;
+	u64 clock;
+	u8 wdtcr;
+
+	/* Watchdog clock is PCI Clock (33MHz) */
+	clock = 33000000;
+	/* and the preload value is loaded into [34:15] of the down counter */
+	preload = (t * clock) >> 15;
+	/*
+	 * Manual states preload must be one less.
+	 * Does not wrap as t is at least 1
+	 */
+	preload -= 1;
+
+	spin_lock(&ie6xx_wdt_data.unlock_sequence);
+
+	/* Set ResetMode & Enable prescaler for range 10ms to 10 min */
+	wdtcr = resetmode & 0x38;
+	outb(wdtcr, ie6xx_wdt_data.sch_wdtba + WDTCR);
+
+	ie6xx_wdt_unlock_registers();
+	outl(0, ie6xx_wdt_data.sch_wdtba + PV1);
+
+	ie6xx_wdt_unlock_registers();
+	outl(preload, ie6xx_wdt_data.sch_wdtba + PV2);
+
+	ie6xx_wdt_unlock_registers();
+	outb(WDT_RELOAD | WDT_TOUT, ie6xx_wdt_data.sch_wdtba + RR1);
+
+	spin_unlock(&ie6xx_wdt_data.unlock_sequence);
+
+	wdd->timeout = t;
+	return 0;
+}
+
+static int ie6xx_wdt_start(struct watchdog_device *wdd)
+{
+	ie6xx_wdt_set_timeout(wdd, wdd->timeout);
+
+	/* Enable the watchdog timer */
+	spin_lock(&ie6xx_wdt_data.unlock_sequence);
+	outb(WDT_ENABLE, ie6xx_wdt_data.sch_wdtba + WDTLR);
+	spin_unlock(&ie6xx_wdt_data.unlock_sequence);
+
+	return 0;
+}
+
+static int ie6xx_wdt_stop(struct watchdog_device *wdd)
+{
+	if (inb(ie6xx_wdt_data.sch_wdtba + WDTLR) & WDT_LOCK)
+		return -1;
+
+	/* Disable the watchdog timer */
+	spin_lock(&ie6xx_wdt_data.unlock_sequence);
+	outb(0, ie6xx_wdt_data.sch_wdtba + WDTLR);
+	spin_unlock(&ie6xx_wdt_data.unlock_sequence);
+
+	return 0;
+}
+
+static const struct watchdog_info ie6xx_wdt_info = {
+	.identity =	"Intel Atom E6xx Watchdog",
+	.options =	WDIOF_SETTIMEOUT |
+			WDIOF_MAGICCLOSE |
+			WDIOF_KEEPALIVEPING,
+};
+
+static const struct watchdog_ops ie6xx_wdt_ops = {
+	.owner =	THIS_MODULE,
+	.start =	ie6xx_wdt_start,
+	.stop =		ie6xx_wdt_stop,
+	.ping =		ie6xx_wdt_ping,
+	.set_timeout =	ie6xx_wdt_set_timeout,
+};
+
+static struct watchdog_device ie6xx_wdt_dev = {
+	.info =		&ie6xx_wdt_info,
+	.ops =		&ie6xx_wdt_ops,
+	.min_timeout =	MIN_TIME,
+	.max_timeout =	MAX_TIME,
+};
+
+#ifdef CONFIG_DEBUG_FS
+
+static int ie6xx_wdt_dbg_show(struct seq_file *s, void *unused)
+{
+	seq_printf(s, "PV1   = 0x%08x\n",
+		inl(ie6xx_wdt_data.sch_wdtba + PV1));
+	seq_printf(s, "PV2   = 0x%08x\n",
+		inl(ie6xx_wdt_data.sch_wdtba + PV2));
+	seq_printf(s, "RR    = 0x%08x\n",
+		inw(ie6xx_wdt_data.sch_wdtba + RR0));
+	seq_printf(s, "WDTCR = 0x%08x\n",
+		inw(ie6xx_wdt_data.sch_wdtba + WDTCR));
+	seq_printf(s, "DCR   = 0x%08x\n",
+		inl(ie6xx_wdt_data.sch_wdtba + DCR));
+	seq_printf(s, "WDTLR = 0x%08x\n",
+		inw(ie6xx_wdt_data.sch_wdtba + WDTLR));
+
+	seq_printf(s, "\n");
+	return 0;
+}
+
+static int ie6xx_wdt_dbg_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ie6xx_wdt_dbg_show, NULL);
+}
+
+static const struct file_operations ie6xx_wdt_dbg_operations = {
+	.open		= ie6xx_wdt_dbg_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static void __devinit ie6xx_wdt_debugfs_init(void)
+{
+	/* /sys/kernel/debug/ie6xx_wdt */
+	ie6xx_wdt_data.debugfs = debugfs_create_file("ie6xx_wdt",
+		S_IFREG | S_IRUGO, NULL, NULL, &ie6xx_wdt_dbg_operations);
+}
+
+static void __devexit ie6xx_wdt_debugfs_exit(void)
+{
+	debugfs_remove(ie6xx_wdt_data.debugfs);
+}
+
+#else
+static void __devinit ie6xx_wdt_debugfs_init(void)
+{
+}
+
+static void __devexit ie6xx_wdt_debugfs_exit(void)
+{
+}
+#endif
+
+static int __devinit ie6xx_wdt_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	u8 wdtlr;
+	int ret;
+
+	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
+	if (!res)
+		return -ENODEV;
+
+	if (!request_region(res->start, resource_size(res), pdev->name)) {
+		dev_err(&pdev->dev, "Watchdog region 0x%llx already in use!\n",
+			(u64)res->start);
+		return -EBUSY;
+	}
+
+	ie6xx_wdt_data.sch_wdtba = res->start;
+	dev_dbg(&pdev->dev, "WDT = 0x%X\n", ie6xx_wdt_data.sch_wdtba);
+
+	ie6xx_wdt_dev.timeout = timeout;
+	watchdog_set_nowayout(&ie6xx_wdt_dev, nowayout);
+
+	spin_lock_init(&ie6xx_wdt_data.unlock_sequence);
+
+	wdtlr = inb(ie6xx_wdt_data.sch_wdtba + WDTLR);
+	if (wdtlr & WDT_LOCK)
+		dev_warn(&pdev->dev,
+			"Watchdog Timer is Locked (Reg=0x%x)\n", wdtlr);
+
+	ie6xx_wdt_debugfs_init();
+
+	ret = watchdog_register_device(&ie6xx_wdt_dev);
+	if (ret) {
+		dev_err(&pdev->dev,
+			"Watchdog timer: cannot register device (err =%d)\n",
+									ret);
+		goto misc_register_error;
+	}
+
+	return 0;
+
+misc_register_error:
+	ie6xx_wdt_debugfs_exit();
+	release_region(res->start, resource_size(res));
+	ie6xx_wdt_data.sch_wdtba = 0;
+	return ret;
+}
+
+static int __devexit ie6xx_wdt_remove(struct platform_device *pdev)
+{
+	struct resource *res;
+
+	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
+	ie6xx_wdt_stop(NULL);
+	watchdog_unregister_device(&ie6xx_wdt_dev);
+	ie6xx_wdt_debugfs_exit();
+	release_region(res->start, resource_size(res));
+	ie6xx_wdt_data.sch_wdtba = 0;
+
+	return 0;
+}
+
+static struct platform_driver ie6xx_wdt_driver = {
+	.probe		= ie6xx_wdt_probe,
+	.remove		= __devexit_p(ie6xx_wdt_remove),
+	.driver		= {
+		.name	= DRIVER_NAME,
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init ie6xx_wdt_init(void)
+{
+	/* Check boot parameters to verify that their initial values */
+	/* are in range. */
+	if ((timeout < MIN_TIME) ||
+	    (timeout > MAX_TIME)) {
+		pr_err("Watchdog timer: value of timeout %d (dec) "
+		  "is out of range from %d to %d (dec)\n",
+		  timeout, MIN_TIME, MAX_TIME);
+		return -EINVAL;
+	}
+
+	return platform_driver_register(&ie6xx_wdt_driver);
+}
+
+static void __exit ie6xx_wdt_exit(void)
+{
+	platform_driver_unregister(&ie6xx_wdt_driver);
+}
+
+late_initcall(ie6xx_wdt_init);
+module_exit(ie6xx_wdt_exit);
+
+MODULE_AUTHOR("Alexander Stein <alexander.stein@systec-electronic.com>");
+MODULE_DESCRIPTION("Intel Atom E6xx Watchdog Device Driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+MODULE_ALIAS("platform:" DRIVER_NAME);
diff --git a/drivers/watchdog/it87_wdt.c b/drivers/watchdog/it87_wdt.c
index 8a741bc..d3dcc69 100644
--- a/drivers/watchdog/it87_wdt.c
+++ b/drivers/watchdog/it87_wdt.c
@@ -12,7 +12,8 @@
  *		    http://www.ite.com.tw/
  *
  *	Support of the watchdog timers, which are available on
- *	IT8702, IT8712, IT8716, IT8718, IT8720, IT8721 and IT8726.
+ *	IT8702, IT8712, IT8716, IT8718, IT8720, IT8721, IT8726
+ *	and IT8728.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
@@ -84,6 +85,7 @@
 #define IT8720_ID	0x8720
 #define IT8721_ID	0x8721
 #define IT8726_ID	0x8726	/* the data sheet suggest wrongly 0x8716 */
+#define IT8728_ID	0x8728
 
 /* GPIO Configuration Registers LDN=0x07 */
 #define WDTCTRL		0x71
@@ -95,7 +97,7 @@
 #define WDT_CIRINT	0x80
 #define WDT_MOUSEINT	0x40
 #define WDT_KYBINT	0x20
-#define WDT_GAMEPORT	0x10 /* not in it8718, it8720, it8721 */
+#define WDT_GAMEPORT	0x10 /* not in it8718, it8720, it8721, it8728 */
 #define WDT_FORCE	0x02
 #define WDT_ZERO	0x01
 
@@ -616,6 +618,7 @@ static int __init it87_wdt_init(void)
 	case IT8718_ID:
 	case IT8720_ID:
 	case IT8721_ID:
+	case IT8728_ID:
 		max_units = 65535;
 		try_gameport = 0;
 		break;
diff --git a/drivers/watchdog/ixp2000_wdt.c b/drivers/watchdog/ixp2000_wdt.c
deleted file mode 100644
index 3f047a5..0000000
--- a/drivers/watchdog/ixp2000_wdt.c
+++ /dev/null
@@ -1,215 +0,0 @@
-/*
- * drivers/char/watchdog/ixp2000_wdt.c
- *
- * Watchdog driver for Intel IXP2000 network processors
- *
- * Adapted from the IXP4xx watchdog driver by Lennert Buytenhek.
- * The original version carries these notices:
- *
- * Author: Deepak Saxena <dsaxena@plexity.net>
- *
- * Copyright 2004 (c) MontaVista, Software, Inc.
- * Based on sa1100 driver, Copyright (C) 2000 Oleg Drokin <green@crimea.edu>
- *
- * This file is licensed under  the terms of the GNU General Public
- * License version 2. This program is licensed "as is" without any
- * warranty of any kind, whether express or implied.
- */
-
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#include <linux/module.h>
-#include <linux/moduleparam.h>
-#include <linux/types.h>
-#include <linux/timer.h>
-#include <linux/kernel.h>
-#include <linux/fs.h>
-#include <linux/miscdevice.h>
-#include <linux/watchdog.h>
-#include <linux/init.h>
-#include <linux/bitops.h>
-#include <linux/uaccess.h>
-#include <mach/hardware.h>
-
-static bool nowayout = WATCHDOG_NOWAYOUT;
-static unsigned int heartbeat = 60;	/* (secs) Default is 1 minute */
-static unsigned long wdt_status;
-static DEFINE_SPINLOCK(wdt_lock);
-
-#define	WDT_IN_USE		0
-#define	WDT_OK_TO_CLOSE		1
-
-static unsigned long wdt_tick_rate;
-
-static void wdt_enable(void)
-{
-	spin_lock(&wdt_lock);
-	ixp2000_reg_write(IXP2000_RESET0, *(IXP2000_RESET0) | WDT_RESET_ENABLE);
-	ixp2000_reg_write(IXP2000_TWDE, WDT_ENABLE);
-	ixp2000_reg_write(IXP2000_T4_CLD, heartbeat * wdt_tick_rate);
-	ixp2000_reg_write(IXP2000_T4_CTL, TIMER_DIVIDER_256 | TIMER_ENABLE);
-	spin_unlock(&wdt_lock);
-}
-
-static void wdt_disable(void)
-{
-	spin_lock(&wdt_lock);
-	ixp2000_reg_write(IXP2000_T4_CTL, 0);
-	spin_unlock(&wdt_lock);
-}
-
-static void wdt_keepalive(void)
-{
-	spin_lock(&wdt_lock);
-	ixp2000_reg_write(IXP2000_T4_CLD, heartbeat * wdt_tick_rate);
-	spin_unlock(&wdt_lock);
-}
-
-static int ixp2000_wdt_open(struct inode *inode, struct file *file)
-{
-	if (test_and_set_bit(WDT_IN_USE, &wdt_status))
-		return -EBUSY;
-
-	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
-
-	wdt_enable();
-
-	return nonseekable_open(inode, file);
-}
-
-static ssize_t ixp2000_wdt_write(struct file *file, const char *data,
-						size_t len, loff_t *ppos)
-{
-	if (len) {
-		if (!nowayout) {
-			size_t i;
-
-			clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
-
-			for (i = 0; i != len; i++) {
-				char c;
-
-				if (get_user(c, data + i))
-					return -EFAULT;
-				if (c == 'V')
-					set_bit(WDT_OK_TO_CLOSE, &wdt_status);
-			}
-		}
-		wdt_keepalive();
-	}
-
-	return len;
-}
-
-
-static const struct watchdog_info ident = {
-	.options	= WDIOF_MAGICCLOSE | WDIOF_SETTIMEOUT |
-				WDIOF_KEEPALIVEPING,
-	.identity	= "IXP2000 Watchdog",
-};
-
-static long ixp2000_wdt_ioctl(struct file *file, unsigned int cmd,
-							unsigned long arg)
-{
-	int ret = -ENOTTY;
-	int time;
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		ret = copy_to_user((struct watchdog_info *)arg, &ident,
-				   sizeof(ident)) ? -EFAULT : 0;
-		break;
-
-	case WDIOC_GETSTATUS:
-		ret = put_user(0, (int *)arg);
-		break;
-
-	case WDIOC_GETBOOTSTATUS:
-		ret = put_user(0, (int *)arg);
-		break;
-
-	case WDIOC_KEEPALIVE:
-		wdt_enable();
-		ret = 0;
-		break;
-
-	case WDIOC_SETTIMEOUT:
-		ret = get_user(time, (int *)arg);
-		if (ret)
-			break;
-
-		if (time <= 0 || time > 60) {
-			ret = -EINVAL;
-			break;
-		}
-
-		heartbeat = time;
-		wdt_keepalive();
-		/* Fall through */
-
-	case WDIOC_GETTIMEOUT:
-		ret = put_user(heartbeat, (int *)arg);
-		break;
-	}
-
-	return ret;
-}
-
-static int ixp2000_wdt_release(struct inode *inode, struct file *file)
-{
-	if (test_bit(WDT_OK_TO_CLOSE, &wdt_status))
-		wdt_disable();
-	else
-		pr_crit("Device closed unexpectedly - timer will not stop\n");
-	clear_bit(WDT_IN_USE, &wdt_status);
-	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
-
-	return 0;
-}
-
-
-static const struct file_operations ixp2000_wdt_fops = {
-	.owner		= THIS_MODULE,
-	.llseek		= no_llseek,
-	.write		= ixp2000_wdt_write,
-	.unlocked_ioctl	= ixp2000_wdt_ioctl,
-	.open		= ixp2000_wdt_open,
-	.release	= ixp2000_wdt_release,
-};
-
-static struct miscdevice ixp2000_wdt_miscdev = {
-	.minor		= WATCHDOG_MINOR,
-	.name		= "watchdog",
-	.fops		= &ixp2000_wdt_fops,
-};
-
-static int __init ixp2000_wdt_init(void)
-{
-	if ((*IXP2000_PRODUCT_ID & 0x001ffef0) == 0x00000000) {
-		pr_info("Unable to use IXP2000 watchdog due to IXP2800 erratum #25\n");
-		return -EIO;
-	}
-	wdt_tick_rate = (*IXP2000_T1_CLD * HZ) / 256;
-	return misc_register(&ixp2000_wdt_miscdev);
-}
-
-static void __exit ixp2000_wdt_exit(void)
-{
-	misc_deregister(&ixp2000_wdt_miscdev);
-}
-
-module_init(ixp2000_wdt_init);
-module_exit(ixp2000_wdt_exit);
-
-MODULE_AUTHOR("Deepak Saxena <dsaxena@plexity.net>");
-MODULE_DESCRIPTION("IXP2000 Network Processor Watchdog");
-
-module_param(heartbeat, int, 0);
-MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds (default 60s)");
-
-module_param(nowayout, bool, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started");
-
-MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
-
diff --git a/drivers/watchdog/pcwd_pci.c b/drivers/watchdog/pcwd_pci.c
index c891399..ee6900d 100644
--- a/drivers/watchdog/pcwd_pci.c
+++ b/drivers/watchdog/pcwd_pci.c
@@ -707,6 +707,7 @@ static int __devinit pcipcwd_card_init(struct pci_dev *pdev,
 		goto err_out_disable_device;
 	}
 
+	spin_lock_init(&pcipcwd_private.io_lock);
 	pcipcwd_private.pdev = pdev;
 	pcipcwd_private.io_addr = pci_resource_start(pdev, 0);
 
@@ -814,22 +815,7 @@ static struct pci_driver pcipcwd_driver = {
 	.remove		= __devexit_p(pcipcwd_card_exit),
 };
 
-static int __init pcipcwd_init_module(void)
-{
-	spin_lock_init(&pcipcwd_private.io_lock);
-
-	return pci_register_driver(&pcipcwd_driver);
-}
-
-static void __exit pcipcwd_cleanup_module(void)
-{
-	pci_unregister_driver(&pcipcwd_driver);
-
-	pr_info("Watchdog Module Unloaded\n");
-}
-
-module_init(pcipcwd_init_module);
-module_exit(pcipcwd_cleanup_module);
+module_pci_driver(pcipcwd_driver);
 
 MODULE_AUTHOR("Wim Van Sebroeck <wim@iguana.be>");
 MODULE_DESCRIPTION("Berkshire PCI-PC Watchdog driver");
diff --git a/drivers/watchdog/pnx4008_wdt.c b/drivers/watchdog/pnx4008_wdt.c
index 6b8432f..87722e1 100644
--- a/drivers/watchdog/pnx4008_wdt.c
+++ b/drivers/watchdog/pnx4008_wdt.c
@@ -32,6 +32,7 @@
 #include <linux/io.h>
 #include <linux/slab.h>
 #include <linux/err.h>
+#include <linux/of.h>
 #include <mach/hardware.h>
 
 /* WatchDog Timer - Chapter 23 Page 207 */
@@ -201,10 +202,19 @@ static int __devexit pnx4008_wdt_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_OF
+static const struct of_device_id pnx4008_wdt_match[] = {
+	{ .compatible = "nxp,pnx4008-wdt" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, pnx4008_wdt_match);
+#endif
+
 static struct platform_driver platform_wdt_driver = {
 	.driver = {
 		.name = "pnx4008-watchdog",
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(pnx4008_wdt_match),
 	},
 	.probe = pnx4008_wdt_probe,
 	.remove = __devexit_p(pnx4008_wdt_remove),
diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index 04e5a6d..200ece5 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -40,6 +40,7 @@
 #include <linux/cpufreq.h>
 #include <linux/slab.h>
 #include <linux/err.h>
+#include <linux/of.h>
 
 #include <mach/map.h>
 
@@ -201,7 +202,7 @@ static int s3c2410wdt_set_heartbeat(struct watchdog_device *wdd, unsigned timeou
 	writel(count, wdt_base + S3C2410_WTDAT);
 	writel(wtcon, wdt_base + S3C2410_WTCON);
 
-	wdd->timeout = timeout;
+	wdd->timeout = (count * divisor) / freq;
 
 	return 0;
 }
@@ -503,8 +504,6 @@ static const struct of_device_id s3c2410_wdt_match[] = {
 	{},
 };
 MODULE_DEVICE_TABLE(of, s3c2410_wdt_match);
-#else
-#define s3c2410_wdt_match NULL
 #endif
 
 static struct platform_driver s3c2410wdt_driver = {
@@ -516,7 +515,7 @@ static struct platform_driver s3c2410wdt_driver = {
 	.driver		= {
 		.owner	= THIS_MODULE,
 		.name	= "s3c2410-wdt",
-		.of_match_table	= s3c2410_wdt_match,
+		.of_match_table	= of_match_ptr(s3c2410_wdt_match),
 	},
 };
 
diff --git a/drivers/watchdog/sch311x_wdt.c b/drivers/watchdog/sch311x_wdt.c
index bd86f32..f847700 100644
--- a/drivers/watchdog/sch311x_wdt.c
+++ b/drivers/watchdog/sch311x_wdt.c
@@ -41,7 +41,6 @@
 #define DRV_NAME	"sch311x_wdt"
 
 /* Runtime registers */
-#define RESGEN			0x1d
 #define GP60			0x47
 #define WDT_TIME_OUT		0x65
 #define WDT_VAL			0x66
@@ -69,10 +68,6 @@ static unsigned short force_id;
 module_param(force_id, ushort, 0);
 MODULE_PARM_DESC(force_id, "Override the detected device ID");
 
-static unsigned short therm_trip;
-module_param(therm_trip, ushort, 0);
-MODULE_PARM_DESC(therm_trip, "Should a ThermTrip trigger the reset generator");
-
 #define WATCHDOG_TIMEOUT 60		/* 60 sec default timeout */
 static int timeout = WATCHDOG_TIMEOUT;	/* in seconds */
 module_param(timeout, int, 0);
@@ -358,26 +353,16 @@ static struct miscdevice sch311x_wdt_miscdev = {
 static int __devinit sch311x_wdt_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
-	unsigned char val;
 	int err;
 
 	spin_lock_init(&sch311x_wdt_data.io_lock);
 
-	if (!request_region(sch311x_wdt_data.runtime_reg + RESGEN, 1,
-								DRV_NAME)) {
-		dev_err(dev, "Failed to request region 0x%04x-0x%04x.\n",
-			sch311x_wdt_data.runtime_reg + RESGEN,
-			sch311x_wdt_data.runtime_reg + RESGEN);
-		err = -EBUSY;
-		goto exit;
-	}
-
 	if (!request_region(sch311x_wdt_data.runtime_reg + GP60, 1, DRV_NAME)) {
 		dev_err(dev, "Failed to request region 0x%04x-0x%04x.\n",
 			sch311x_wdt_data.runtime_reg + GP60,
 			sch311x_wdt_data.runtime_reg + GP60);
 		err = -EBUSY;
-		goto exit_release_region;
+		goto exit;
 	}
 
 	if (!request_region(sch311x_wdt_data.runtime_reg + WDT_TIME_OUT, 4,
@@ -386,7 +371,7 @@ static int __devinit sch311x_wdt_probe(struct platform_device *pdev)
 			sch311x_wdt_data.runtime_reg + WDT_TIME_OUT,
 			sch311x_wdt_data.runtime_reg + WDT_CTRL);
 		err = -EBUSY;
-		goto exit_release_region2;
+		goto exit_release_region;
 	}
 
 	/* Make sure that the watchdog is not running */
@@ -414,24 +399,13 @@ static int __devinit sch311x_wdt_probe(struct platform_device *pdev)
 	/* Get status at boot */
 	sch311x_wdt_get_status(&sch311x_wdt_data.boot_status);
 
-	/* enable watchdog */
-	/* -- Reset Generator --
-	 * Bit 0   Enable Watchdog Timer Generation: 0* = Enabled, 1 = Disabled
-	 * Bit 1   Thermtrip Source Select: O* = No Source, 1 = Source
-	 * Bit 2   WDT2_CTL: WDT input bit
-	 * Bit 3-7 Reserved
-	 */
-	outb(0, sch311x_wdt_data.runtime_reg + RESGEN);
-	val = therm_trip ? 0x06 : 0x04;
-	outb(val, sch311x_wdt_data.runtime_reg + RESGEN);
-
 	sch311x_wdt_miscdev.parent = dev;
 
 	err = misc_register(&sch311x_wdt_miscdev);
 	if (err != 0) {
 		dev_err(dev, "cannot register miscdev on minor=%d (err=%d)\n",
 							WATCHDOG_MINOR, err);
-		goto exit_release_region3;
+		goto exit_release_region2;
 	}
 
 	dev_info(dev,
@@ -440,12 +414,10 @@ static int __devinit sch311x_wdt_probe(struct platform_device *pdev)
 
 	return 0;
 
-exit_release_region3:
-	release_region(sch311x_wdt_data.runtime_reg + WDT_TIME_OUT, 4);
 exit_release_region2:
-	release_region(sch311x_wdt_data.runtime_reg + GP60, 1);
+	release_region(sch311x_wdt_data.runtime_reg + WDT_TIME_OUT, 4);
 exit_release_region:
-	release_region(sch311x_wdt_data.runtime_reg + RESGEN, 1);
+	release_region(sch311x_wdt_data.runtime_reg + GP60, 1);
 	sch311x_wdt_data.runtime_reg = 0;
 exit:
 	return err;
@@ -461,7 +433,6 @@ static int __devexit sch311x_wdt_remove(struct platform_device *pdev)
 	misc_deregister(&sch311x_wdt_miscdev);
 	release_region(sch311x_wdt_data.runtime_reg + WDT_TIME_OUT, 4);
 	release_region(sch311x_wdt_data.runtime_reg + GP60, 1);
-	release_region(sch311x_wdt_data.runtime_reg + RESGEN, 1);
 	sch311x_wdt_data.runtime_reg = 0;
 	return 0;
 }
diff --git a/drivers/watchdog/sp5100_tco.c b/drivers/watchdog/sp5100_tco.c
index 59108e4..ae5e82c 100644
--- a/drivers/watchdog/sp5100_tco.c
+++ b/drivers/watchdog/sp5100_tco.c
@@ -313,7 +313,7 @@ static unsigned char __devinit sp5100_tco_setupdevice(void)
 	tcobase_phys = val;
 
 	tcobase = ioremap(val, SP5100_WDT_MEM_MAP_SIZE);
-	if (tcobase == 0) {
+	if (!tcobase) {
 		pr_err("failed to get tcobase address\n");
 		goto unreg_mem_region;
 	}
diff --git a/drivers/watchdog/via_wdt.c b/drivers/watchdog/via_wdt.c
index 465e082..5603e31 100644
--- a/drivers/watchdog/via_wdt.c
+++ b/drivers/watchdog/via_wdt.c
@@ -202,6 +202,9 @@ static int __devinit wdt_probe(struct pci_dev *pdev,
 		goto err_out_release;
 	}
 
+	if (timeout < 1 || timeout > WDT_TIMEOUT_MAX)
+		timeout = WDT_TIMEOUT;
+
 	wdt_dev.timeout = timeout;
 	watchdog_set_nowayout(&wdt_dev, nowayout);
 	if (readl(wdt_mem) & VIA_WDT_FIRED)
@@ -250,20 +253,7 @@ static struct pci_driver wdt_driver = {
 	.remove		= __devexit_p(wdt_remove),
 };
 
-static int __init wdt_init(void)
-{
-	if (timeout < 1 || timeout > WDT_TIMEOUT_MAX)
-		timeout = WDT_TIMEOUT;
-	return pci_register_driver(&wdt_driver);
-}
-
-static void __exit wdt_exit(void)
-{
-	pci_unregister_driver(&wdt_driver);
-}
-
-module_init(wdt_init);
-module_exit(wdt_exit);
+module_pci_driver(wdt_driver);
 
 MODULE_AUTHOR("Marc Vertes");
 MODULE_DESCRIPTION("Driver for watchdog timer on VIA chipset");
diff --git a/drivers/watchdog/wdt_pci.c b/drivers/watchdog/wdt_pci.c
index 1c888c7..e32654e 100644
--- a/drivers/watchdog/wdt_pci.c
+++ b/drivers/watchdog/wdt_pci.c
@@ -739,39 +739,7 @@ static struct pci_driver wdtpci_driver = {
 	.remove		= __devexit_p(wdtpci_remove_one),
 };
 
-
-/**
- *	wdtpci_cleanup:
- *
- *	Unload the watchdog. You cannot do this with any file handles open.
- *	If your watchdog is set to continue ticking on close and you unload
- *	it, well it keeps ticking. We won't get the interrupt but the board
- *	will not touch PC memory so all is fine. You just have to load a new
- *	module in xx seconds or reboot.
- */
-
-static void __exit wdtpci_cleanup(void)
-{
-	pci_unregister_driver(&wdtpci_driver);
-}
-
-
-/**
- *	wdtpci_init:
- *
- *	Set up the WDT watchdog board. All we have to do is grab the
- *	resources we require and bitch if anyone beat us to them.
- *	The open() function will actually kick the board off.
- */
-
-static int __init wdtpci_init(void)
-{
-	return pci_register_driver(&wdtpci_driver);
-}
-
-
-module_init(wdtpci_init);
-module_exit(wdtpci_cleanup);
+module_pci_driver(wdtpci_driver);
 
 MODULE_AUTHOR("JP Nollmann, Alan Cox");
 MODULE_DESCRIPTION("Driver for the ICS PCI-WDT500/501 watchdog cards");
diff --git a/drivers/watchdog/wm831x_wdt.c b/drivers/watchdog/wm831x_wdt.c
index b1815c5..87d66d2 100644
--- a/drivers/watchdog/wm831x_wdt.c
+++ b/drivers/watchdog/wm831x_wdt.c
@@ -247,8 +247,9 @@ static int __devinit wm831x_wdt_probe(struct platform_device *pdev)
 		reg |= pdata->software << WM831X_WDOG_RST_SRC_SHIFT;
 
 		if (pdata->update_gpio) {
-			ret = gpio_request(pdata->update_gpio,
-					   "Watchdog update");
+			ret = gpio_request_one(pdata->update_gpio,
+					       GPIOF_DIR_OUT | GPIOF_INIT_LOW,
+					       "Watchdog update");
 			if (ret < 0) {
 				dev_err(wm831x->dev,
 					"Failed to request update GPIO: %d\n",
@@ -256,14 +257,6 @@ static int __devinit wm831x_wdt_probe(struct platform_device *pdev)
 				goto err;
 			}
 
-			ret = gpio_direction_output(pdata->update_gpio, 0);
-			if (ret != 0) {
-				dev_err(wm831x->dev,
-					"gpio_direction_output returned: %d\n",
-					ret);
-				goto err_gpio;
-			}
-
 			driver_data->update_gpio = pdata->update_gpio;
 
 			/* Make sure the watchdog takes hardware updates */
