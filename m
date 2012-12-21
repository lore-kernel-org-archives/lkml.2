Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927Ab2LUK3o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 05:29:44 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:39632 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751131Ab2LUK3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 05:29:32 -0500
Date: Fri, 21 Dec 2012 11:29:28 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        "devendra. aaru" <devendra.aaru@gmail.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Fabio Porcedda <fabio.porcedda@gmail.com>,
        Gabor Juhos <juhosg@openwrt.org>,
        Jarkko Nikula <jarkko.nikula@jollamobile.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Joe Perches <joe@perches.com>, Julia Lawall <Julia.Lawall@lip6.fr>,
        Karicheri@spo001.leaseweb.com, Muralidharan <m-karicheri2@ti.com>,
        Kees Cook <keescook@chromium.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Takahisa Tanaka <mc74hc00@gmail.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Tom Mingarelli <thomas.mingarelli@hp.com>,
        Tushar Behera <tushar.behera@linaro.org>
Subject: [GIT PULL REQUEST] watchdog - v3.8
Message-ID: <20121221102928.GA17666@spo001.leaseweb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://www.linux-watchdog.org/linux-watchdog.git

This includes some fixes and code improvements (like clk_prepare_enable and clk_disable_unprepare),
conversion from the omap_wdt and twl4030_wdt drivers to the watchdog framework,
addition of the SB8x0 chipset support and the DA9055 Watchdog driver
and some OF support for the davinci_wdt driver.

This will update the following files:

 Documentation/devicetree/bindings/watchdog/davinci-wdt.txt |   12 
 drivers/misc/mei/wd.c                                      |    2 
 drivers/watchdog/Kconfig                                   |   18 
 drivers/watchdog/Makefile                                  |    1 
 drivers/watchdog/ath79_wdt.c                               |   13 
 drivers/watchdog/cpu5wdt.c                                 |    1 
 drivers/watchdog/da9052_wdt.c                              |    4 
 drivers/watchdog/da9055_wdt.c                              |  216 ++++++++
 drivers/watchdog/davinci_wdt.c                             |   11 
 drivers/watchdog/hpwdt.c                                   |    2 
 drivers/watchdog/mpcore_wdt.c                              |   19 
 drivers/watchdog/omap_wdt.c                                |  311 ++++--------
 drivers/watchdog/orion_wdt.c                               |    2 
 drivers/watchdog/s3c2410_wdt.c                             |    6 
 drivers/watchdog/sp5100_tco.c                              |  321 ++++++++++---
 drivers/watchdog/sp5100_tco.h                              |   46 +
 drivers/watchdog/sp805_wdt.c                               |   11 
 drivers/watchdog/twl4030_wdt.c                             |  185 +------
 include/linux/watchdog.h                                   |    2 
 19 files changed, 738 insertions(+), 445 deletions(-)

with these Changes:

commit d692170037c0338b31dac5ac4722c1360a4b5257
Author: Tomas Winkler <tomas.winkler@intel.com>
Date:   Sun Dec 16 13:23:17 2012 +0200

    watchdog: mei: avoid oops in watchdog unregister code path
    
    With commit c7d3df3 "mei: use internal watchdog device registration
    tracking" will crash the kernel on shutdown path on systems
    where ME watchdog is not present.
    Since the watchdog was never initialized in such case
    the WDOG_UNREGISTERED bit is never set and the system
    crashes on access to uninitialized variables down the path.
    
    To solve the issue we query for NULL on watchdog driver driver_data
    to check whether the device is registered. This is handled in the
    driver and doesn't depend on watchdog core internals.
    
    Cc: Borislav Petkov <bp@alien8.de>
    Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>
    Signed-off-by: Jerry Snitselaar <jerry.snitselaar@oracle.com>
    Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 8c4c419ca3bd5a5b3389114e037a9d17bdec3a5f
Author: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Date:   Fri Dec 7 15:44:46 2012 -0700

    watchdog: Orion: Fix possible null-deference in orion_wdt_probe
    
    If the DT does not include a regs parameter then the null res
    would be dereferenced.
    
    Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 740fbddf5c3f9ad8b23c5d917ba1cc7e376a5104
Author: Takahisa Tanaka <mc74hc00@gmail.com>
Date:   Sun Dec 2 14:33:18 2012 +0900

    watchdog: sp5100_tco: Add SB8x0 chipset support
    
    The current sp5100_tco driver only supports SP5100/SB7x0 chipset, doesn't
    support SB8x0 chipset, because current sp5100_tco driver doesn't know that the
    offset address for watchdog timer was changed from SB8x0 chipset.
    
    The offset address of SP5100 and SB7x0 chipsets are as follows, quote from the
    AMD SB700/710/750 Register Reference Guide (Page 164) and the AMD SP5100
    Register Reference Guide (Page 166).
    
      WatchDogTimerControl 69h
      WatchDogTimerBase0   6Ch
      WatchDogTimerBase1   6Dh
      WatchDogTimerBase2   6Eh
      WatchDogTimerBase3   6Fh
    
    In contrast, the offset address of SB8x0 chipset is as follows, quote from
    AMD SB800-Series Southbridges Register Reference Guide (Page 147).
    
      WatchDogTimerEn      48h
      WatchDogTimerConfig  4Ch
    
    So, In the case of SB8x0 chipset, sp5100_tco reads meaningless MMIO
    address (for example, 0xbafe00) from wrong offset address, and the following
    message is logged.
    
       SP5100 TCO timer: mmio address 0xbafe00 already in use
    
    With this patch, sp5100_tco driver supports SB8x0 chipset, and can avoid
    iomem resource conflict. The processing of this patch is as follows.
    
     Step 1) Attempt to get the watchdog base address from indirect I/O (0xCD6
             and 0xCD7).
      - Go to the step 7 if obtained address hasn't conflicted with other
        resource. But, currently, the address (0xfec000f0) conflicts with the
        IOAPIC MMIO address, and the following message is logged.
    
           SP5100 TCO timer: mmio address 0xfec000f0 already in use
    
        0xfec000f0 is recommended by AMD BIOS Developer's Guide. So, go to the
        next step.
    
     Step 2) Attempt to get the SBResource_MMIO base address from AcpiMmioEN (for
             SB8x0,  PM_Reg:24h) or SBResource_MMIO (SP5100/SB7x0, PCI_Reg:9Ch)
             register.
      - Go to the step 7 if these register has enabled by BIOS, and obtained
        address hasn't conflicted with other resource.
      - If above condition isn't true, go to the next step.
    
     Step 3) Attempt to get the free MMIO address from allocate_resource().
      - Go to the step 7 if these register has enabled by BIOS, and obtained
        address hasn't conflicted with other resource.
      - Driver initialization has failed if obtained address has conflicted
        with other resource, and no 'force_addr' parameter is specified.
    
     Step 4) Use the specified address If 'force_addr' parameter is specified.
      - allocate_resource() function may fail, when the PCI bridge device occupies
        iomem resource from 0xf0000000 to 0xffffffff. To handle such a case,
        I added 'force_addr' parameter to sp5100_tco driver. With 'force_addr'
        parameter, sp5100_tco driver directly can assign MMIO address for watchdog
        timer from free iomem region. Note that It's dangerous to specify wrong
        address in the 'force_addr' parameter.
    
          Example of force_addr parameter use
            # cat /proc/iomem
            ...snip...
            fec00000-fec003ff : IOAPIC 0
                                          <--- free MMIO region
            fec10000-fec1001f : pnp 00:0b
            fec20000-fec203ff : IOAPIC 1
            ...snip...
            # cat /etc/modprobe.d/sp5100_tco.conf
            options sp5100_tco force_addr=0xfec00800
            # modprobe sp5100_tco
            # cat /proc/iomem
            ...snip...
            fec00000-fec003ff : IOAPIC 0
            fec00800-fec00807 : SP5100 TCO  <--- watchdog timer MMIO address
            fec10000-fec1001f : pnp 00:0b
            fec20000-fec203ff : IOAPIC 1
            ...snip...
            #
    
      - Driver initialization has failed if specified address has conflicted
        with other resource.
    
     Step 5) Disable the watchdog timer
      - To rewrite the watchdog timer register of the chipset, absolutely
        guarantee that the watchdog timer is disabled.
    
     Step 6) Re-program the watchdog timer MMIO address to chipset.
      - Re-program the obtained MMIO address in Step 3 or Step 4 to chipset via
        indirect I/O (0xCD6 and 0xCD7).
    
     Step 7) Enable and setup the watchdog timer
    
    This patch has worked fine on my test environment (ASUS M4A89GTD-PRO/USB3 and
    DL165G7). therefore I believe that it's no problem to re-program the MMIO
    address for watchdog timer to chipset during disabled watchdog. However,
    I'm not sure about it, because I don't know much about chipset programming.
    
    So, any comments will be welcome.
    
    Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=43176
    Tested-by: Arkadiusz Miskiewicz <arekm@maven.pl>
    Tested-by: Paul Menzel <paulepanter@users.sourceforge.net>
    Signed-off-by: Takahisa Tanaka <mc74hc00@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 902e2e7d482c55395652ff78cb3457fc390b101d
Author: Murali Karicheri <m-karicheri2@ti.com>
Date:   Mon Nov 26 16:41:35 2012 -0500

    watchdog: davinci_wdt: add OF support
    
    This adds OF support for davinci_wdt driver.
    
    Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
    Acked-by: Grant Likely <grant.likely@secretlab.ca>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 0360dffedd7bad92f174b2ce5e69e960451d2b59
Author: Tushar Behera <tushar.behera@linaro.org>
Date:   Thu Nov 22 10:13:04 2012 +0530

    watchdog: da9052: Fix invalid free of devm_ allocated data
    
    It is not required to free devm_ allocated data. Since kref_put
    needs a valid release function, da9052_wdt_release_resources()
    is not deleted.
    
    Fixes following warning.
    drivers/watchdog/da9052_wdt.c:59:1-6: WARNING: invalid free of
    devm_ allocated data
    
    Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 2bc3f62f9627f136bb52b4cfa43060ef04656d2f
Author: Peter Ujfalusi <peter.ujfalusi@ti.com>
Date:   Tue Nov 13 10:40:22 2012 +0100

    watchdog: twl4030_wdt: Change TWL4030_MODULE_PM_RECEIVER to TWL_MODULE_PM_RECEIVER
    
    To facilitate upcoming cleanup in twl stack.
    No functional changes.
    
    Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit e1926349c2e7051d44dc8a772cd819377b815c0c
Author: Kees Cook <keescook@chromium.org>
Date:   Mon Nov 5 15:04:42 2012 -0800

    watchdog: remove depends on CONFIG_EXPERIMENTAL
    
    The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
    while now and is almost always enabled by default. As agreed during the
    Linux kernel summit, remove it from any "depends on" lines in Kconfigs.
    
    Signed-off-by: Kees Cook <keescook@chromium.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 77e0dfcc0949303bbae75cac5c598c59e67b54c9
Author: Joe Perches <joe@perches.com>
Date:   Sun Oct 28 01:05:53 2012 -0700

    watchdog: Convert dev_printk(KERN_<LEVEL> to dev_<level>(
    
    dev_<level> calls take less code than dev_printk(KERN_<LEVEL>
    and reducing object size is good.
    
    Signed-off-by: Joe Perches <joe@perches.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 312b00e1c31011dd009f51a52e14a500f61f1f31
Author: Ashish Jangam <ashish.jangam@kpitcummins.com>
Date:   Fri Oct 12 15:00:03 2012 +0530

    watchdog: DA9055 Watchdog driver
    
    This is the Watchdog patch for the DA9055 PMIC. This patch has got dependency on
    the DA9055 MFD core.
    
    This patch is functionally tested on SMDK6410
    
    Signed-off-by: David Dajun Chen <dchen@diasemi.com>
    Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 1ba85387f0224dca9f0f9d783b09c9ceeb1c91bd
Author: Aaro Koskinen <aaro.koskinen@iki.fi>
Date:   Wed Oct 10 23:23:37 2012 +0300

    watchdog: omap_wdt: eliminate goto
    
    Eliminate a goto to simplify the code.
    
    Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit ef4817472982b3b6d993e6456cfad58dc848ef70
Author: Aaro Koskinen <aaro.koskinen@iki.fi>
Date:   Wed Oct 10 23:23:36 2012 +0300

    watchdog: omap_wdt: delete redundant platform_set_drvdata() calls
    
    It's not needed to manually reset the driver data.
    
    Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 4f4753d96d30cf4477eafa077ae7f1326a80c1d8
Author: Aaro Koskinen <aaro.koskinen@iki.fi>
Date:   Wed Oct 10 23:23:33 2012 +0300

    watchdog: omap_wdt: convert to devm_ functions
    
    Use devm_kzalloc(), devm_request_mem_region() ande devm_ioremap()
    to simplify the code.
    
    Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 67c0f55468443ef8a1edc6ee92f9a92e4915be24
Author: Aaro Koskinen <aaro.koskinen@iki.fi>
Date:   Wed Oct 10 23:23:32 2012 +0300

    watchdog: omap_wdt: convert to new watchdog core
    
    Convert omap_wdt to new watchdog core. On OMAP boards, there are usually
    multiple watchdogs. Since the new watchdog core supports multiple
    watchdogs, all watchdog drivers used on OMAP should be converted.
    
    The legacy watchdog device node is still created, so this should not
    break existing users.
    
    Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
    Tested-by: Jarkko Nikula <jarkko.nikula@jollamobile.com>
    Tested-by: Lokesh Vutla <lokeshvutla@ti.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit cf13a84d174947df4bb809edfb4887393642303e
Author: Fabio Porcedda <fabio.porcedda@gmail.com>
Date:   Fri Oct 5 12:16:09 2012 +0200

    watchdog: WatchDog Timer Driver Core: fix comment
    
    Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 50d854c8a72b87ffa5523aa07c5013e2c6657714
Author: Thomas Abraham <thomas.abraham@linaro.org>
Date:   Wed Oct 3 07:32:40 2012 +0900

    watchdog: s3c2410_wdt: use clk_prepare_enable and clk_disable_unprepare
    
    Convert clk_enable/clk_disable to clk_prepare_enable/clk_disable_unprepare
    calls as required by common clock framework.
    
    Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 2d076bb8397fea2480487e9547e34b8d4f77eb67
Author: Fabio Estevam <fabio.estevam@freescale.com>
Date:   Mon Jul 2 18:33:02 2012 -0300

    watchdog: imx2_wdt: Select the driver via ARCH_MXC
    
    With device tree support in place, we should not use IMX_HAVE_PLATFORM_IMX2_WDT
    as a dependency for selecting the imx2_wdt driver.
    
    Use ARCH_MXC symbol instead, so that the driver can be even selected by a device-tree
    only SoC, such as i.MX6.
    
    Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
    Acked-by: Shawn Guo <shawn.guo@linaro.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit e09d9c3e9f85b8190ca1e495890f4cf5ee30baf6
Author: devendra.aaru <devendra.aaru@gmail.com>
Date:   Tue Jun 26 14:48:26 2012 +0530

    watchdog: cpu5wdt.c: add missing del_timer call
    
    We do a setup_timer at init stage of the module, but we didn't
    de-activate the time using del_timer.
    
    Signed-off-by: devendra.aaru <devendra.aaru@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit e16cfb9d38541bf1591c2e0ca64a562074e25f72
Author: Tom Mingarelli <thomas.mingarelli@hp.com>
Date:   Mon Sep 24 20:34:40 2012 +0000

    watchdog: hpwdt.c: Increase version string
    
    Changing the version of the driver for all the latest patches being applied
    for kdump fixes.
    
    Signed-off-by: Thomas Mingarelli <thomas.mingarelli@hp.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit b2c4e4b2696287671723ef986f0db23cf4f52f15
Author: Jarkko Nikula <jarkko.nikula@jollamobile.com>
Date:   Tue Sep 11 09:01:10 2012 +0300

    watchdog: Convert twl4030_wdt to watchdog core
    
    Convert the twl4030_wdt watchdog driver to watchdog core.
    
    While at there use devm_kzalloc and set the default timeout in order to be
    able test this driver with a simple shell script.
    
    Signed-off-by: Jarkko Nikula <jarkko.nikula@jollamobile.com>
    Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 5235f57a6f460d5620acfcf236ca29ecca993325
Author: Karicheri, Muralidharan <m-karicheri2@ti.com>
Date:   Thu Aug 30 18:29:10 2012 +0000

    davinci_wdt: preparation for switch to common clock framework
    
    As a first step towards migrating davinci platforms to use common clock
    framework, replace all instances of clk_enable() with clk_prepare_enable()
    and clk_disable() with clk_disable_unprepare(). Until the platform is
    switched to use the CONFIG_HAVE_CLK_PREPARE Kconfig variable, this just
    adds a might_sleep() call and would work without any issues.
    
    This will make it easy later to switch to common clk based implementation
    of clk driver from DaVinci specific driver.
    
    Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 63fbbc169674496fc2ae501d97c3905232a3bf64
Author: Julia Lawall <Julia.Lawall@lip6.fr>
Date:   Sun Aug 26 18:01:02 2012 +0200

    watchdog: sp805_wdt.c: use clk_prepare_enable and clk_disable_unprepare
    
    Clk_prepare_enable and clk_disable_unprepare combine clk_prepare and
    clk_enable, and clk_disable and clk_unprepare.  They make the code more
    concise, and ensure that clk_unprepare is called when clk_enable fails.
    
    A simplified version of the semantic patch that introduces calls to these
    functions is as follows: (http://coccinelle.lip6.fr/)
    
    // <smpl>
    @@
    expression e;
    @@
    
    - clk_prepare(e);
    - clk_enable(e);
    + clk_prepare_enable(e);
    
    @@
    expression e;
    @@
    
    - clk_disable(e);
    - clk_unprepare(e);
    + clk_disable_unprepare(e);
    // </smpl>
    
    Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
    Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 8157becf8db0c798e1260f3af7c495a9b88e3b57
Author: Gabor Juhos <juhosg@openwrt.org>
Date:   Tue Aug 14 15:35:19 2012 +0200

    watchdog: ath79_wdt: convert to use module_platform_driver
    
    This makes the code a bit smaller by getting rid of
    some boilerplate code.
    
    Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/Documentation/devicetree/bindings/watchdog/davinci-wdt.txt b/Documentation/devicetree/bindings/watchdog/davinci-wdt.txt
new file mode 100644
index 0000000..75558cc
--- /dev/null
+++ b/Documentation/devicetree/bindings/watchdog/davinci-wdt.txt
@@ -0,0 +1,12 @@
+DaVinci Watchdog Timer (WDT) Controller
+
+Required properties:
+- compatible : Should be "ti,davinci-wdt"
+- reg : Should contain WDT registers location and length
+
+Examples:
+
+wdt: wdt@2320000 {
+	compatible = "ti,davinci-wdt";
+	reg = <0x02320000 0x80>;
+};
diff --git a/drivers/misc/mei/wd.c b/drivers/misc/mei/wd.c
index 636409f..9299a8c 100644
--- a/drivers/misc/mei/wd.c
+++ b/drivers/misc/mei/wd.c
@@ -370,7 +370,7 @@ void mei_watchdog_register(struct mei_device *dev)
 
 void mei_watchdog_unregister(struct mei_device *dev)
 {
-	if (test_bit(WDOG_UNREGISTERED, &amt_wd_dev.status))
+	if (watchdog_get_drvdata(&amt_wd_dev) == NULL)
 		return;
 
 	watchdog_set_drvdata(&amt_wd_dev, NULL);
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index ad1bb93..7f809fd 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -76,6 +76,16 @@ config DA9052_WATCHDOG
           Alternatively say M to compile the driver as a module,
           which will be called da9052_wdt.
 
+config DA9055_WATCHDOG
+	tristate "Dialog Semiconductor DA9055 Watchdog"
+	depends on MFD_DA9055
+	help
+	  If you say yes here you get support for watchdog on the Dialog
+	  Semiconductor DA9055 PMIC.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called da9055_wdt.
+
 config WM831X_WATCHDOG
 	tristate "WM831x watchdog"
 	depends on MFD_WM831X
@@ -232,6 +242,7 @@ config EP93XX_WATCHDOG
 config OMAP_WATCHDOG
 	tristate "OMAP Watchdog"
 	depends on ARCH_OMAP16XX || ARCH_OMAP2PLUS
+	select WATCHDOG_CORE
 	help
 	  Support for TI OMAP1610/OMAP1710/OMAP2420/OMAP3430/OMAP4430 watchdog.  Say 'Y'
 	  here to enable the OMAP1610/OMAP1710/OMAP2420/OMAP3430/OMAP4430 watchdog timer.
@@ -300,6 +311,7 @@ config COH901327_WATCHDOG
 config TWL4030_WATCHDOG
 	tristate "TWL4030 Watchdog"
 	depends on TWL4030_CORE
+	select WATCHDOG_CORE
 	help
 	  Support for TI TWL4030 watchdog.  Say 'Y' here to enable the
 	  watchdog timer support for TWL4030 chips.
@@ -342,7 +354,7 @@ config MAX63XX_WATCHDOG
 
 config IMX2_WDT
 	tristate "IMX2+ Watchdog"
-	depends on IMX_HAVE_PLATFORM_IMX2_WDT
+	depends on ARCH_MXC
 	help
 	  This is the driver for the hardware watchdog
 	  on the Freescale IMX2 and later processors.
@@ -431,7 +443,7 @@ config ALIM7101_WDT
 
 config F71808E_WDT
 	tristate "Fintek F71808E, F71862FG, F71869, F71882FG and F71889FG Watchdog"
-	depends on X86 && EXPERIMENTAL
+	depends on X86
 	help
 	  This is the driver for the hardware watchdog on the Fintek
 	  F71808E, F71862FG, F71869, F71882FG and F71889FG Super I/O controllers.
@@ -622,7 +634,7 @@ config IT8712F_WDT
 
 config IT87_WDT
 	tristate "IT87 Watchdog Timer"
-	depends on X86 && EXPERIMENTAL
+	depends on X86
 	---help---
 	  This is the driver for the hardware watchdog on the ITE IT8702,
 	  IT8712, IT8716, IT8718, IT8720, IT8721, IT8726 and IT8728
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 572b39b..97bbdb3 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -164,6 +164,7 @@ obj-$(CONFIG_XEN_WDT) += xen_wdt.o
 
 # Architecture Independent
 obj-$(CONFIG_DA9052_WATCHDOG) += da9052_wdt.o
+obj-$(CONFIG_DA9055_WATCHDOG) += da9055_wdt.o
 obj-$(CONFIG_WM831X_WATCHDOG) += wm831x_wdt.o
 obj-$(CONFIG_WM8350_WATCHDOG) += wm8350_wdt.o
 obj-$(CONFIG_MAX63XX_WATCHDOG) += max63xx_wdt.o
diff --git a/drivers/watchdog/ath79_wdt.c b/drivers/watchdog/ath79_wdt.c
index 7c8ede7..38a999e 100644
--- a/drivers/watchdog/ath79_wdt.c
+++ b/drivers/watchdog/ath79_wdt.c
@@ -284,6 +284,7 @@ static void ath97_wdt_shutdown(struct platform_device *pdev)
 }
 
 static struct platform_driver ath79_wdt_driver = {
+	.probe		= ath79_wdt_probe,
 	.remove		= ath79_wdt_remove,
 	.shutdown	= ath97_wdt_shutdown,
 	.driver		= {
@@ -292,17 +293,7 @@ static struct platform_driver ath79_wdt_driver = {
 	},
 };
 
-static int __init ath79_wdt_init(void)
-{
-	return platform_driver_probe(&ath79_wdt_driver, ath79_wdt_probe);
-}
-module_init(ath79_wdt_init);
-
-static void __exit ath79_wdt_exit(void)
-{
-	platform_driver_unregister(&ath79_wdt_driver);
-}
-module_exit(ath79_wdt_exit);
+module_platform_driver(ath79_wdt_driver);
 
 MODULE_DESCRIPTION("Atheros AR71XX/AR724X/AR913X hardware watchdog driver");
 MODULE_AUTHOR("Gabor Juhos <juhosg@openwrt.org");
diff --git a/drivers/watchdog/cpu5wdt.c b/drivers/watchdog/cpu5wdt.c
index cd87758..f270bb7 100644
--- a/drivers/watchdog/cpu5wdt.c
+++ b/drivers/watchdog/cpu5wdt.c
@@ -266,6 +266,7 @@ static void cpu5wdt_exit(void)
 	if (cpu5wdt_device.queue) {
 		cpu5wdt_device.queue = 0;
 		wait_for_completion(&cpu5wdt_device.stop);
+		del_timer(&cpu5wdt_device.timer);
 	}
 
 	misc_deregister(&cpu5wdt_misc);
diff --git a/drivers/watchdog/da9052_wdt.c b/drivers/watchdog/da9052_wdt.c
index 8be70d8..3674450 100644
--- a/drivers/watchdog/da9052_wdt.c
+++ b/drivers/watchdog/da9052_wdt.c
@@ -53,10 +53,6 @@ static const struct {
 
 static void da9052_wdt_release_resources(struct kref *r)
 {
-	struct da9052_wdt_data *driver_data =
-		container_of(r, struct da9052_wdt_data, kref);
-
-	kfree(driver_data);
 }
 
 static int da9052_wdt_set_timeout(struct watchdog_device *wdt_dev,
diff --git a/drivers/watchdog/da9055_wdt.c b/drivers/watchdog/da9055_wdt.c
new file mode 100644
index 0000000..709ea1a
--- /dev/null
+++ b/drivers/watchdog/da9055_wdt.c
@@ -0,0 +1,216 @@
+/*
+ * System monitoring driver for DA9055 PMICs.
+ *
+ * Copyright(c) 2012 Dialog Semiconductor Ltd.
+ *
+ * Author: David Dajun Chen <dchen@diasemi.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/watchdog.h>
+#include <linux/delay.h>
+
+#include <linux/mfd/da9055/core.h>
+#include <linux/mfd/da9055/reg.h>
+
+static bool nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, bool, 0);
+MODULE_PARM_DESC(nowayout,
+		 "Watchdog cannot be stopped once started (default="
+		 __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+#define DA9055_DEF_TIMEOUT	4
+#define DA9055_TWDMIN		256
+
+struct da9055_wdt_data {
+	struct watchdog_device wdt;
+	struct da9055 *da9055;
+	struct kref kref;
+};
+
+static const struct {
+	u8 reg_val;
+	int user_time;  /* In seconds */
+} da9055_wdt_maps[] = {
+	{ 0, 0 },
+	{ 1, 2 },
+	{ 2, 4 },
+	{ 3, 8 },
+	{ 4, 16 },
+	{ 5, 32 },
+	{ 5, 33 },  /* Actual time  32.768s so included both 32s and 33s */
+	{ 6, 65 },
+	{ 6, 66 },  /* Actual time 65.536s so include both, 65s and 66s */
+	{ 7, 131 },
+};
+
+static int da9055_wdt_set_timeout(struct watchdog_device *wdt_dev,
+				  unsigned int timeout)
+{
+	struct da9055_wdt_data *driver_data = watchdog_get_drvdata(wdt_dev);
+	struct da9055 *da9055 = driver_data->da9055;
+	int ret, i;
+
+	for (i = 0; i < ARRAY_SIZE(da9055_wdt_maps); i++)
+		if (da9055_wdt_maps[i].user_time == timeout)
+			break;
+
+	if (i == ARRAY_SIZE(da9055_wdt_maps))
+		ret = -EINVAL;
+	else
+		ret = da9055_reg_update(da9055, DA9055_REG_CONTROL_B,
+					DA9055_TWDSCALE_MASK,
+					da9055_wdt_maps[i].reg_val <<
+					DA9055_TWDSCALE_SHIFT);
+	if (ret < 0)
+		dev_err(da9055->dev,
+			"Failed to update timescale bit, %d\n", ret);
+
+	wdt_dev->timeout = timeout;
+
+	return ret;
+}
+
+static int da9055_wdt_ping(struct watchdog_device *wdt_dev)
+{
+	struct da9055_wdt_data *driver_data = watchdog_get_drvdata(wdt_dev);
+	struct da9055 *da9055 = driver_data->da9055;
+	int ret;
+
+	/*
+	 * We have a minimum time for watchdog window called TWDMIN. A write
+	 * to the watchdog before this elapsed time will cause an error.
+	 */
+	mdelay(DA9055_TWDMIN);
+
+	/* Reset the watchdog timer */
+	ret = da9055_reg_update(da9055, DA9055_REG_CONTROL_E,
+				DA9055_WATCHDOG_MASK, 1);
+
+	return ret;
+}
+
+static void da9055_wdt_release_resources(struct kref *r)
+{
+	struct da9055_wdt_data *driver_data =
+		container_of(r, struct da9055_wdt_data, kref);
+
+	kfree(driver_data);
+}
+
+static void da9055_wdt_ref(struct watchdog_device *wdt_dev)
+{
+	struct da9055_wdt_data *driver_data = watchdog_get_drvdata(wdt_dev);
+
+	kref_get(&driver_data->kref);
+}
+
+static void da9055_wdt_unref(struct watchdog_device *wdt_dev)
+{
+	struct da9055_wdt_data *driver_data = watchdog_get_drvdata(wdt_dev);
+
+	kref_put(&driver_data->kref, da9055_wdt_release_resources);
+}
+
+static int da9055_wdt_start(struct watchdog_device *wdt_dev)
+{
+	return da9055_wdt_set_timeout(wdt_dev, wdt_dev->timeout);
+}
+
+static int da9055_wdt_stop(struct watchdog_device *wdt_dev)
+{
+	return da9055_wdt_set_timeout(wdt_dev, 0);
+}
+
+static struct watchdog_info da9055_wdt_info = {
+	.options	= WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
+	.identity	= "DA9055 Watchdog",
+};
+
+static const struct watchdog_ops da9055_wdt_ops = {
+	.owner = THIS_MODULE,
+	.start = da9055_wdt_start,
+	.stop = da9055_wdt_stop,
+	.ping = da9055_wdt_ping,
+	.set_timeout = da9055_wdt_set_timeout,
+	.ref = da9055_wdt_ref,
+	.unref = da9055_wdt_unref,
+};
+
+static int da9055_wdt_probe(struct platform_device *pdev)
+{
+	struct da9055 *da9055 = dev_get_drvdata(pdev->dev.parent);
+	struct da9055_wdt_data *driver_data;
+	struct watchdog_device *da9055_wdt;
+	int ret;
+
+	driver_data = devm_kzalloc(&pdev->dev, sizeof(*driver_data),
+				   GFP_KERNEL);
+	if (!driver_data) {
+		dev_err(da9055->dev, "Failed to allocate watchdog device\n");
+		return -ENOMEM;
+	}
+
+	driver_data->da9055 = da9055;
+
+	da9055_wdt = &driver_data->wdt;
+
+	da9055_wdt->timeout = DA9055_DEF_TIMEOUT;
+	da9055_wdt->info = &da9055_wdt_info;
+	da9055_wdt->ops = &da9055_wdt_ops;
+	watchdog_set_nowayout(da9055_wdt, nowayout);
+	watchdog_set_drvdata(da9055_wdt, driver_data);
+
+	kref_init(&driver_data->kref);
+
+	ret = da9055_wdt_stop(da9055_wdt);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Failed to stop watchdog, %d\n", ret);
+		goto err;
+	}
+
+	dev_set_drvdata(&pdev->dev, driver_data);
+
+	ret = watchdog_register_device(&driver_data->wdt);
+	if (ret != 0)
+		dev_err(da9055->dev, "watchdog_register_device() failed: %d\n",
+			ret);
+
+err:
+	return ret;
+}
+
+static int da9055_wdt_remove(struct platform_device *pdev)
+{
+	struct da9055_wdt_data *driver_data = dev_get_drvdata(&pdev->dev);
+
+	watchdog_unregister_device(&driver_data->wdt);
+	kref_put(&driver_data->kref, da9055_wdt_release_resources);
+
+	return 0;
+}
+
+static struct platform_driver da9055_wdt_driver = {
+	.probe = da9055_wdt_probe,
+	.remove = da9055_wdt_remove,
+	.driver = {
+		.name	= "da9055-watchdog",
+	},
+};
+
+module_platform_driver(da9055_wdt_driver);
+
+MODULE_AUTHOR("David Dajun Chen <dchen@diasemi.com>");
+MODULE_DESCRIPTION("DA9055 watchdog");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:da9055-watchdog");
diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
index 8791879..e8e8724 100644
--- a/drivers/watchdog/davinci_wdt.c
+++ b/drivers/watchdog/davinci_wdt.c
@@ -208,7 +208,7 @@ static int davinci_wdt_probe(struct platform_device *pdev)
 	if (WARN_ON(IS_ERR(wdt_clk)))
 		return PTR_ERR(wdt_clk);
 
-	clk_enable(wdt_clk);
+	clk_prepare_enable(wdt_clk);
 
 	if (heartbeat < 1 || heartbeat > MAX_HEARTBEAT)
 		heartbeat = DEFAULT_HEARTBEAT;
@@ -256,16 +256,23 @@ static int davinci_wdt_remove(struct platform_device *pdev)
 		wdt_mem = NULL;
 	}
 
-	clk_disable(wdt_clk);
+	clk_disable_unprepare(wdt_clk);
 	clk_put(wdt_clk);
 
 	return 0;
 }
 
+static const struct of_device_id davinci_wdt_of_match[] = {
+	{ .compatible = "ti,davinci-wdt", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, davinci_wdt_of_match);
+
 static struct platform_driver platform_wdt_driver = {
 	.driver = {
 		.name = "watchdog",
 		.owner	= THIS_MODULE,
+		.of_match_table = davinci_wdt_of_match,
 	},
 	.probe = davinci_wdt_probe,
 	.remove = davinci_wdt_remove,
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 8717255..11796b9 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -39,7 +39,7 @@
 #endif /* CONFIG_HPWDT_NMI_DECODING */
 #include <asm/nmi.h>
 
-#define HPWDT_VERSION			"1.3.0"
+#define HPWDT_VERSION			"1.3.1"
 #define SECS_TO_TICKS(secs)		((secs) * 1000 / 128)
 #define TICKS_TO_SECS(ticks)		((ticks) * 128 / 1000)
 #define HPWDT_MAX_TIMER			TICKS_TO_SECS(65535)
diff --git a/drivers/watchdog/mpcore_wdt.c b/drivers/watchdog/mpcore_wdt.c
index a84eb55..233cfad 100644
--- a/drivers/watchdog/mpcore_wdt.c
+++ b/drivers/watchdog/mpcore_wdt.c
@@ -80,8 +80,7 @@ static irqreturn_t mpcore_wdt_fire(int irq, void *arg)
 
 	/* Check it really was our interrupt */
 	if (readl(wdt->base + TWD_WDOG_INTSTAT)) {
-		dev_printk(KERN_CRIT, wdt->dev,
-					"Triggered - Reboot ignored.\n");
+		dev_crit(wdt->dev, "Triggered - Reboot ignored\n");
 		/* Clear the interrupt on the watchdog */
 		writel(1, wdt->base + TWD_WDOG_INTSTAT);
 		return IRQ_HANDLED;
@@ -123,7 +122,7 @@ static void mpcore_wdt_stop(struct mpcore_wdt *wdt)
 
 static void mpcore_wdt_start(struct mpcore_wdt *wdt)
 {
-	dev_printk(KERN_INFO, wdt->dev, "enabling watchdog.\n");
+	dev_info(wdt->dev, "enabling watchdog\n");
 
 	/* This loads the count register but does NOT start the count yet */
 	mpcore_wdt_keepalive(wdt);
@@ -180,8 +179,8 @@ static int mpcore_wdt_release(struct inode *inode, struct file *file)
 	if (wdt->expect_close == 42)
 		mpcore_wdt_stop(wdt);
 	else {
-		dev_printk(KERN_CRIT, wdt->dev,
-				"unexpected close, not stopping watchdog!\n");
+		dev_crit(wdt->dev,
+			 "unexpected close, not stopping watchdog!\n");
 		mpcore_wdt_keepalive(wdt);
 	}
 	clear_bit(0, &wdt->timer_alive);
@@ -351,9 +350,9 @@ static int mpcore_wdt_probe(struct platform_device *pdev)
 		ret = devm_request_irq(wdt->dev, wdt->irq, mpcore_wdt_fire, 0,
 				"mpcore_wdt", wdt);
 		if (ret) {
-			dev_printk(KERN_ERR, wdt->dev,
-					"cannot register IRQ%d for watchdog\n",
-					wdt->irq);
+			dev_err(wdt->dev,
+				"cannot register IRQ%d for watchdog\n",
+				wdt->irq);
 			return ret;
 		}
 	}
@@ -365,9 +364,9 @@ static int mpcore_wdt_probe(struct platform_device *pdev)
 	mpcore_wdt_miscdev.parent = &pdev->dev;
 	ret = misc_register(&mpcore_wdt_miscdev);
 	if (ret) {
-		dev_printk(KERN_ERR, wdt->dev,
+		dev_err(wdt->dev,
 			"cannot register miscdev on minor=%d (err=%d)\n",
-							WATCHDOG_MINOR, ret);
+			WATCHDOG_MINOR, ret);
 		return ret;
 	}
 
diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index 3e3ebbc..34ed61e 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -31,42 +31,34 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/fs.h>
 #include <linux/mm.h>
-#include <linux/miscdevice.h>
 #include <linux/watchdog.h>
 #include <linux/reboot.h>
 #include <linux/init.h>
 #include <linux/err.h>
 #include <linux/platform_device.h>
 #include <linux/moduleparam.h>
-#include <linux/bitops.h>
 #include <linux/io.h>
-#include <linux/uaccess.h>
 #include <linux/slab.h>
 #include <linux/pm_runtime.h>
 #include <linux/platform_data/omap-wd-timer.h>
 
 #include "omap_wdt.h"
 
-static struct platform_device *omap_wdt_dev;
-
 static unsigned timer_margin;
 module_param(timer_margin, uint, 0);
 MODULE_PARM_DESC(timer_margin, "initial watchdog timeout (in seconds)");
 
-static unsigned int wdt_trgr_pattern = 0x1234;
-static DEFINE_SPINLOCK(wdt_lock);
-
 struct omap_wdt_dev {
 	void __iomem    *base;          /* physical */
 	struct device   *dev;
-	int             omap_wdt_users;
+	bool		omap_wdt_users;
 	struct resource *mem;
-	struct miscdevice omap_wdt_miscdev;
+	int		wdt_trgr_pattern;
+	struct mutex	lock;		/* to avoid races with PM */
 };
 
-static void omap_wdt_ping(struct omap_wdt_dev *wdev)
+static void omap_wdt_reload(struct omap_wdt_dev *wdev)
 {
 	void __iomem    *base = wdev->base;
 
@@ -74,8 +66,8 @@ static void omap_wdt_ping(struct omap_wdt_dev *wdev)
 	while ((__raw_readl(base + OMAP_WATCHDOG_WPS)) & 0x08)
 		cpu_relax();
 
-	wdt_trgr_pattern = ~wdt_trgr_pattern;
-	__raw_writel(wdt_trgr_pattern, (base + OMAP_WATCHDOG_TGR));
+	wdev->wdt_trgr_pattern = ~wdev->wdt_trgr_pattern;
+	__raw_writel(wdev->wdt_trgr_pattern, (base + OMAP_WATCHDOG_TGR));
 
 	/* wait for posted write to complete */
 	while ((__raw_readl(base + OMAP_WATCHDOG_WPS)) & 0x08)
@@ -111,18 +103,10 @@ static void omap_wdt_disable(struct omap_wdt_dev *wdev)
 		cpu_relax();
 }
 
-static void omap_wdt_adjust_timeout(unsigned new_timeout)
-{
-	if (new_timeout < TIMER_MARGIN_MIN)
-		new_timeout = TIMER_MARGIN_DEFAULT;
-	if (new_timeout > TIMER_MARGIN_MAX)
-		new_timeout = TIMER_MARGIN_MAX;
-	timer_margin = new_timeout;
-}
-
-static void omap_wdt_set_timeout(struct omap_wdt_dev *wdev)
+static void omap_wdt_set_timer(struct omap_wdt_dev *wdev,
+				   unsigned int timeout)
 {
-	u32 pre_margin = GET_WLDR_VAL(timer_margin);
+	u32 pre_margin = GET_WLDR_VAL(timeout);
 	void __iomem *base = wdev->base;
 
 	/* just count up at 32 KHz */
@@ -134,16 +118,14 @@ static void omap_wdt_set_timeout(struct omap_wdt_dev *wdev)
 		cpu_relax();
 }
 
-/*
- *	Allow only one task to hold it open
- */
-static int omap_wdt_open(struct inode *inode, struct file *file)
+static int omap_wdt_start(struct watchdog_device *wdog)
 {
-	struct omap_wdt_dev *wdev = platform_get_drvdata(omap_wdt_dev);
+	struct omap_wdt_dev *wdev = watchdog_get_drvdata(wdog);
 	void __iomem *base = wdev->base;
 
-	if (test_and_set_bit(1, (unsigned long *)&(wdev->omap_wdt_users)))
-		return -EBUSY;
+	mutex_lock(&wdev->lock);
+
+	wdev->omap_wdt_users = true;
 
 	pm_runtime_get_sync(wdev->dev);
 
@@ -155,223 +137,169 @@ static int omap_wdt_open(struct inode *inode, struct file *file)
 	while (__raw_readl(base + OMAP_WATCHDOG_WPS) & 0x01)
 		cpu_relax();
 
-	file->private_data = (void *) wdev;
-
-	omap_wdt_set_timeout(wdev);
-	omap_wdt_ping(wdev); /* trigger loading of new timeout value */
+	omap_wdt_set_timer(wdev, wdog->timeout);
+	omap_wdt_reload(wdev); /* trigger loading of new timeout value */
 	omap_wdt_enable(wdev);
 
-	return nonseekable_open(inode, file);
+	mutex_unlock(&wdev->lock);
+
+	return 0;
 }
 
-static int omap_wdt_release(struct inode *inode, struct file *file)
+static int omap_wdt_stop(struct watchdog_device *wdog)
 {
-	struct omap_wdt_dev *wdev = file->private_data;
+	struct omap_wdt_dev *wdev = watchdog_get_drvdata(wdog);
 
-	/*
-	 *      Shut off the timer unless NOWAYOUT is defined.
-	 */
-#ifndef CONFIG_WATCHDOG_NOWAYOUT
+	mutex_lock(&wdev->lock);
 	omap_wdt_disable(wdev);
-
 	pm_runtime_put_sync(wdev->dev);
-#else
-	pr_crit("Unexpected close, not stopping!\n");
-#endif
-	wdev->omap_wdt_users = 0;
-
+	wdev->omap_wdt_users = false;
+	mutex_unlock(&wdev->lock);
 	return 0;
 }
 
-static ssize_t omap_wdt_write(struct file *file, const char __user *data,
-		size_t len, loff_t *ppos)
+static int omap_wdt_ping(struct watchdog_device *wdog)
 {
-	struct omap_wdt_dev *wdev = file->private_data;
+	struct omap_wdt_dev *wdev = watchdog_get_drvdata(wdog);
 
-	/* Refresh LOAD_TIME. */
-	if (len) {
-		spin_lock(&wdt_lock);
-		omap_wdt_ping(wdev);
-		spin_unlock(&wdt_lock);
-	}
-	return len;
+	mutex_lock(&wdev->lock);
+	omap_wdt_reload(wdev);
+	mutex_unlock(&wdev->lock);
+
+	return 0;
 }
 
-static long omap_wdt_ioctl(struct file *file, unsigned int cmd,
-						unsigned long arg)
+static int omap_wdt_set_timeout(struct watchdog_device *wdog,
+				unsigned int timeout)
 {
-	struct omap_wd_timer_platform_data *pdata;
-	struct omap_wdt_dev *wdev;
-	u32 rs;
-	int new_margin, bs;
-	static const struct watchdog_info ident = {
-		.identity = "OMAP Watchdog",
-		.options = WDIOF_SETTIMEOUT,
-		.firmware_version = 0,
-	};
-
-	wdev = file->private_data;
-	pdata = wdev->dev->platform_data;
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		return copy_to_user((struct watchdog_info __user *)arg, &ident,
-				sizeof(ident));
-	case WDIOC_GETSTATUS:
-		return put_user(0, (int __user *)arg);
-	case WDIOC_GETBOOTSTATUS:
-		if (!pdata || !pdata->read_reset_sources)
-			return put_user(0, (int __user *)arg);
-		rs = pdata->read_reset_sources();
-		bs = (rs & (1 << OMAP_MPU_WD_RST_SRC_ID_SHIFT)) ?
-			WDIOF_CARDRESET : 0;
-		return put_user(bs, (int __user *)arg);
-	case WDIOC_KEEPALIVE:
-		spin_lock(&wdt_lock);
-		omap_wdt_ping(wdev);
-		spin_unlock(&wdt_lock);
-		return 0;
-	case WDIOC_SETTIMEOUT:
-		if (get_user(new_margin, (int __user *)arg))
-			return -EFAULT;
-		omap_wdt_adjust_timeout(new_margin);
-
-		spin_lock(&wdt_lock);
-		omap_wdt_disable(wdev);
-		omap_wdt_set_timeout(wdev);
-		omap_wdt_enable(wdev);
+	struct omap_wdt_dev *wdev = watchdog_get_drvdata(wdog);
 
-		omap_wdt_ping(wdev);
-		spin_unlock(&wdt_lock);
-		/* Fall */
-	case WDIOC_GETTIMEOUT:
-		return put_user(timer_margin, (int __user *)arg);
-	default:
-		return -ENOTTY;
-	}
+	mutex_lock(&wdev->lock);
+	omap_wdt_disable(wdev);
+	omap_wdt_set_timer(wdev, timeout);
+	omap_wdt_enable(wdev);
+	omap_wdt_reload(wdev);
+	wdog->timeout = timeout;
+	mutex_unlock(&wdev->lock);
+
+	return 0;
 }
 
-static const struct file_operations omap_wdt_fops = {
-	.owner = THIS_MODULE,
-	.write = omap_wdt_write,
-	.unlocked_ioctl = omap_wdt_ioctl,
-	.open = omap_wdt_open,
-	.release = omap_wdt_release,
-	.llseek = no_llseek,
+static const struct watchdog_info omap_wdt_info = {
+	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
+	.identity = "OMAP Watchdog",
+};
+
+static const struct watchdog_ops omap_wdt_ops = {
+	.owner		= THIS_MODULE,
+	.start		= omap_wdt_start,
+	.stop		= omap_wdt_stop,
+	.ping		= omap_wdt_ping,
+	.set_timeout	= omap_wdt_set_timeout,
 };
 
 static int omap_wdt_probe(struct platform_device *pdev)
 {
+	struct omap_wd_timer_platform_data *pdata = pdev->dev.platform_data;
+	bool nowayout = WATCHDOG_NOWAYOUT;
+	struct watchdog_device *omap_wdt;
 	struct resource *res, *mem;
 	struct omap_wdt_dev *wdev;
+	u32 rs;
 	int ret;
 
+	omap_wdt = devm_kzalloc(&pdev->dev, sizeof(*omap_wdt), GFP_KERNEL);
+	if (!omap_wdt)
+		return -ENOMEM;
+
 	/* reserve static register mappings */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		ret = -ENOENT;
-		goto err_get_resource;
-	}
+	if (!res)
+		return -ENOENT;
 
-	if (omap_wdt_dev) {
-		ret = -EBUSY;
-		goto err_busy;
-	}
+	mem = devm_request_mem_region(&pdev->dev, res->start,
+				      resource_size(res), pdev->name);
+	if (!mem)
+		return -EBUSY;
 
-	mem = request_mem_region(res->start, resource_size(res), pdev->name);
-	if (!mem) {
-		ret = -EBUSY;
-		goto err_busy;
-	}
+	wdev = devm_kzalloc(&pdev->dev, sizeof(*wdev), GFP_KERNEL);
+	if (!wdev)
+		return -ENOMEM;
 
-	wdev = kzalloc(sizeof(struct omap_wdt_dev), GFP_KERNEL);
-	if (!wdev) {
-		ret = -ENOMEM;
-		goto err_kzalloc;
-	}
+	wdev->omap_wdt_users	= false;
+	wdev->mem		= mem;
+	wdev->dev		= &pdev->dev;
+	wdev->wdt_trgr_pattern	= 0x1234;
+	mutex_init(&wdev->lock);
 
-	wdev->omap_wdt_users = 0;
-	wdev->mem = mem;
-	wdev->dev = &pdev->dev;
+	wdev->base = devm_ioremap(&pdev->dev, res->start, resource_size(res));
+	if (!wdev->base)
+		return -ENOMEM;
 
-	wdev->base = ioremap(res->start, resource_size(res));
-	if (!wdev->base) {
-		ret = -ENOMEM;
-		goto err_ioremap;
-	}
+	omap_wdt->info	      = &omap_wdt_info;
+	omap_wdt->ops	      = &omap_wdt_ops;
+	omap_wdt->min_timeout = TIMER_MARGIN_MIN;
+	omap_wdt->max_timeout = TIMER_MARGIN_MAX;
+
+	if (timer_margin >= TIMER_MARGIN_MIN &&
+	    timer_margin <= TIMER_MARGIN_MAX)
+		omap_wdt->timeout = timer_margin;
+	else
+		omap_wdt->timeout = TIMER_MARGIN_DEFAULT;
 
-	platform_set_drvdata(pdev, wdev);
+	watchdog_set_drvdata(omap_wdt, wdev);
+	watchdog_set_nowayout(omap_wdt, nowayout);
+
+	platform_set_drvdata(pdev, omap_wdt);
 
 	pm_runtime_enable(wdev->dev);
 	pm_runtime_get_sync(wdev->dev);
 
-	omap_wdt_disable(wdev);
-	omap_wdt_adjust_timeout(timer_margin);
+	if (pdata && pdata->read_reset_sources)
+		rs = pdata->read_reset_sources();
+	else
+		rs = 0;
+	omap_wdt->bootstatus = (rs & (1 << OMAP_MPU_WD_RST_SRC_ID_SHIFT)) ?
+				WDIOF_CARDRESET : 0;
 
-	wdev->omap_wdt_miscdev.parent = &pdev->dev;
-	wdev->omap_wdt_miscdev.minor = WATCHDOG_MINOR;
-	wdev->omap_wdt_miscdev.name = "watchdog";
-	wdev->omap_wdt_miscdev.fops = &omap_wdt_fops;
+	omap_wdt_disable(wdev);
 
-	ret = misc_register(&(wdev->omap_wdt_miscdev));
-	if (ret)
-		goto err_misc;
+	ret = watchdog_register_device(omap_wdt);
+	if (ret) {
+		pm_runtime_disable(wdev->dev);
+		return ret;
+	}
 
 	pr_info("OMAP Watchdog Timer Rev 0x%02x: initial timeout %d sec\n",
 		__raw_readl(wdev->base + OMAP_WATCHDOG_REV) & 0xFF,
-		timer_margin);
+		omap_wdt->timeout);
 
 	pm_runtime_put_sync(wdev->dev);
 
-	omap_wdt_dev = pdev;
-
 	return 0;
-
-err_misc:
-	pm_runtime_disable(wdev->dev);
-	platform_set_drvdata(pdev, NULL);
-	iounmap(wdev->base);
-
-err_ioremap:
-	wdev->base = NULL;
-	kfree(wdev);
-
-err_kzalloc:
-	release_mem_region(res->start, resource_size(res));
-
-err_busy:
-err_get_resource:
-
-	return ret;
 }
 
 static void omap_wdt_shutdown(struct platform_device *pdev)
 {
-	struct omap_wdt_dev *wdev = platform_get_drvdata(pdev);
+	struct watchdog_device *wdog = platform_get_drvdata(pdev);
+	struct omap_wdt_dev *wdev = watchdog_get_drvdata(wdog);
 
+	mutex_lock(&wdev->lock);
 	if (wdev->omap_wdt_users) {
 		omap_wdt_disable(wdev);
 		pm_runtime_put_sync(wdev->dev);
 	}
+	mutex_unlock(&wdev->lock);
 }
 
 static int omap_wdt_remove(struct platform_device *pdev)
 {
-	struct omap_wdt_dev *wdev = platform_get_drvdata(pdev);
+	struct watchdog_device *wdog = platform_get_drvdata(pdev);
+	struct omap_wdt_dev *wdev = watchdog_get_drvdata(wdog);
 	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
 	pm_runtime_disable(wdev->dev);
-	if (!res)
-		return -ENOENT;
-
-	misc_deregister(&(wdev->omap_wdt_miscdev));
-	release_mem_region(res->start, resource_size(res));
-	platform_set_drvdata(pdev, NULL);
-
-	iounmap(wdev->base);
-
-	kfree(wdev);
-	omap_wdt_dev = NULL;
+	watchdog_unregister_device(wdog);
 
 	return 0;
 }
@@ -386,25 +314,31 @@ static int omap_wdt_remove(struct platform_device *pdev)
 
 static int omap_wdt_suspend(struct platform_device *pdev, pm_message_t state)
 {
-	struct omap_wdt_dev *wdev = platform_get_drvdata(pdev);
+	struct watchdog_device *wdog = platform_get_drvdata(pdev);
+	struct omap_wdt_dev *wdev = watchdog_get_drvdata(wdog);
 
+	mutex_lock(&wdev->lock);
 	if (wdev->omap_wdt_users) {
 		omap_wdt_disable(wdev);
 		pm_runtime_put_sync(wdev->dev);
 	}
+	mutex_unlock(&wdev->lock);
 
 	return 0;
 }
 
 static int omap_wdt_resume(struct platform_device *pdev)
 {
-	struct omap_wdt_dev *wdev = platform_get_drvdata(pdev);
+	struct watchdog_device *wdog = platform_get_drvdata(pdev);
+	struct omap_wdt_dev *wdev = watchdog_get_drvdata(wdog);
 
+	mutex_lock(&wdev->lock);
 	if (wdev->omap_wdt_users) {
 		pm_runtime_get_sync(wdev->dev);
 		omap_wdt_enable(wdev);
-		omap_wdt_ping(wdev);
+		omap_wdt_reload(wdev);
 	}
+	mutex_unlock(&wdev->lock);
 
 	return 0;
 }
@@ -437,5 +371,4 @@ module_platform_driver(omap_wdt_driver);
 
 MODULE_AUTHOR("George G. Davis");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 MODULE_ALIAS("platform:omap_wdt");
diff --git a/drivers/watchdog/orion_wdt.c b/drivers/watchdog/orion_wdt.c
index 0478b00..7c18b3b 100644
--- a/drivers/watchdog/orion_wdt.c
+++ b/drivers/watchdog/orion_wdt.c
@@ -156,6 +156,8 @@ static int orion_wdt_probe(struct platform_device *pdev)
 	wdt_tclk = clk_get_rate(clk);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENODEV;
 	wdt_reg = devm_ioremap(&pdev->dev, res->start, resource_size(res));
 	if (!wdt_reg)
 		return -ENOMEM;
diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index b0dab10..27bcd4e 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -354,7 +354,7 @@ static int s3c2410wdt_probe(struct platform_device *pdev)
 		goto err_map;
 	}
 
-	clk_enable(wdt_clock);
+	clk_prepare_enable(wdt_clock);
 
 	ret = s3c2410wdt_cpufreq_register();
 	if (ret < 0) {
@@ -421,7 +421,7 @@ static int s3c2410wdt_probe(struct platform_device *pdev)
 	s3c2410wdt_cpufreq_deregister();
 
  err_clk:
-	clk_disable(wdt_clock);
+	clk_disable_unprepare(wdt_clock);
 	clk_put(wdt_clock);
 	wdt_clock = NULL;
 
@@ -445,7 +445,7 @@ static int s3c2410wdt_remove(struct platform_device *dev)
 
 	s3c2410wdt_cpufreq_deregister();
 
-	clk_disable(wdt_clock);
+	clk_disable_unprepare(wdt_clock);
 	clk_put(wdt_clock);
 	wdt_clock = NULL;
 
diff --git a/drivers/watchdog/sp5100_tco.c b/drivers/watchdog/sp5100_tco.c
index b387681..2b0e000 100644
--- a/drivers/watchdog/sp5100_tco.c
+++ b/drivers/watchdog/sp5100_tco.c
@@ -13,7 +13,9 @@
  *	as published by the Free Software Foundation; either version
  *	2 of the License, or (at your option) any later version.
  *
- *	See AMD Publication 43009 "AMD SB700/710/750 Register Reference Guide"
+ *	See AMD Publication 43009 "AMD SB700/710/750 Register Reference Guide",
+ *	    AMD Publication 45482 "AMD SB800-Series Southbridges Register
+ *	                                                      Reference Guide"
  */
 
 /*
@@ -38,18 +40,24 @@
 #include "sp5100_tco.h"
 
 /* Module and version information */
-#define TCO_VERSION "0.01"
+#define TCO_VERSION "0.03"
 #define TCO_MODULE_NAME "SP5100 TCO timer"
 #define TCO_DRIVER_NAME   TCO_MODULE_NAME ", v" TCO_VERSION
 
 /* internal variables */
 static u32 tcobase_phys;
+static u32 resbase_phys;
+static u32 tco_wdt_fired;
 static void __iomem *tcobase;
 static unsigned int pm_iobase;
 static DEFINE_SPINLOCK(tco_lock);	/* Guards the hardware */
 static unsigned long timer_alive;
 static char tco_expect_close;
 static struct pci_dev *sp5100_tco_pci;
+static struct resource wdt_res = {
+	.name = "Watchdog Timer",
+	.flags = IORESOURCE_MEM,
+};
 
 /* the watchdog platform device */
 static struct platform_device *sp5100_tco_platform_device;
@@ -64,9 +72,15 @@ MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds. (default="
 
 static bool nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, bool, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started"
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started."
 		" (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
+static unsigned int force_addr;
+module_param(force_addr, uint, 0);
+MODULE_PARM_DESC(force_addr, "Force the use of specified MMIO address."
+		" ONLY USE THIS PARAMETER IF YOU REALLY KNOW"
+		" WHAT YOU ARE DOING (default=none)");
+
 /*
  * Some TCO specific functions
  */
@@ -122,6 +136,79 @@ static int tco_timer_set_heartbeat(int t)
 	return 0;
 }
 
+static void tco_timer_enable(void)
+{
+	int val;
+
+	if (sp5100_tco_pci->revision >= 0x40) {
+		/* For SB800 or later */
+		/* Set the Watchdog timer resolution to 1 sec */
+		outb(SB800_PM_WATCHDOG_CONFIG, SB800_IO_PM_INDEX_REG);
+		val = inb(SB800_IO_PM_DATA_REG);
+		val |= SB800_PM_WATCHDOG_SECOND_RES;
+		outb(val, SB800_IO_PM_DATA_REG);
+
+		/* Enable watchdog decode bit and watchdog timer */
+		outb(SB800_PM_WATCHDOG_CONTROL, SB800_IO_PM_INDEX_REG);
+		val = inb(SB800_IO_PM_DATA_REG);
+		val |= SB800_PCI_WATCHDOG_DECODE_EN;
+		val &= ~SB800_PM_WATCHDOG_DISABLE;
+		outb(val, SB800_IO_PM_DATA_REG);
+	} else {
+		/* For SP5100 or SB7x0 */
+		/* Enable watchdog decode bit */
+		pci_read_config_dword(sp5100_tco_pci,
+				      SP5100_PCI_WATCHDOG_MISC_REG,
+				      &val);
+
+		val |= SP5100_PCI_WATCHDOG_DECODE_EN;
+
+		pci_write_config_dword(sp5100_tco_pci,
+				       SP5100_PCI_WATCHDOG_MISC_REG,
+				       val);
+
+		/* Enable Watchdog timer and set the resolution to 1 sec */
+		outb(SP5100_PM_WATCHDOG_CONTROL, SP5100_IO_PM_INDEX_REG);
+		val = inb(SP5100_IO_PM_DATA_REG);
+		val |= SP5100_PM_WATCHDOG_SECOND_RES;
+		val &= ~SP5100_PM_WATCHDOG_DISABLE;
+		outb(val, SP5100_IO_PM_DATA_REG);
+	}
+}
+
+static void tco_timer_disable(void)
+{
+	int val;
+
+	if (sp5100_tco_pci->revision >= 0x40) {
+		/* For SB800 or later */
+		/* Enable watchdog decode bit and Disable watchdog timer */
+		outb(SB800_PM_WATCHDOG_CONTROL, SB800_IO_PM_INDEX_REG);
+		val = inb(SB800_IO_PM_DATA_REG);
+		val |= SB800_PCI_WATCHDOG_DECODE_EN;
+		val |= SB800_PM_WATCHDOG_DISABLE;
+		outb(val, SB800_IO_PM_DATA_REG);
+	} else {
+		/* For SP5100 or SB7x0 */
+		/* Enable watchdog decode bit */
+		pci_read_config_dword(sp5100_tco_pci,
+				      SP5100_PCI_WATCHDOG_MISC_REG,
+				      &val);
+
+		val |= SP5100_PCI_WATCHDOG_DECODE_EN;
+
+		pci_write_config_dword(sp5100_tco_pci,
+				       SP5100_PCI_WATCHDOG_MISC_REG,
+				       val);
+
+		/* Disable Watchdog timer */
+		outb(SP5100_PM_WATCHDOG_CONTROL, SP5100_IO_PM_INDEX_REG);
+		val = inb(SP5100_IO_PM_DATA_REG);
+		val |= SP5100_PM_WATCHDOG_DISABLE;
+		outb(val, SP5100_IO_PM_DATA_REG);
+	}
+}
+
 /*
  *	/dev/watchdog handling
  */
@@ -270,11 +357,12 @@ MODULE_DEVICE_TABLE(pci, sp5100_tco_pci_tbl);
 /*
  * Init & exit routines
  */
-
 static unsigned char sp5100_tco_setupdevice(void)
 {
 	struct pci_dev *dev = NULL;
+	const char *dev_name = NULL;
 	u32 val;
+	u32 index_reg, data_reg, base_addr;
 
 	/* Match the PCI device */
 	for_each_pci_dev(dev) {
@@ -287,29 +375,160 @@ static unsigned char sp5100_tco_setupdevice(void)
 	if (!sp5100_tco_pci)
 		return 0;
 
+	pr_info("PCI Revision ID: 0x%x\n", sp5100_tco_pci->revision);
+
+	/*
+	 * Determine type of southbridge chipset.
+	 */
+	if (sp5100_tco_pci->revision >= 0x40) {
+		dev_name = SB800_DEVNAME;
+		index_reg = SB800_IO_PM_INDEX_REG;
+		data_reg = SB800_IO_PM_DATA_REG;
+		base_addr = SB800_PM_WATCHDOG_BASE;
+	} else {
+		dev_name = SP5100_DEVNAME;
+		index_reg = SP5100_IO_PM_INDEX_REG;
+		data_reg = SP5100_IO_PM_DATA_REG;
+		base_addr = SP5100_PM_WATCHDOG_BASE;
+	}
+
 	/* Request the IO ports used by this driver */
 	pm_iobase = SP5100_IO_PM_INDEX_REG;
-	if (!request_region(pm_iobase, SP5100_PM_IOPORTS_SIZE, "SP5100 TCO")) {
+	if (!request_region(pm_iobase, SP5100_PM_IOPORTS_SIZE, dev_name)) {
 		pr_err("I/O address 0x%04x already in use\n", pm_iobase);
 		goto exit;
 	}
 
-	/* Find the watchdog base address. */
-	outb(SP5100_PM_WATCHDOG_BASE3, SP5100_IO_PM_INDEX_REG);
-	val = inb(SP5100_IO_PM_DATA_REG);
-	outb(SP5100_PM_WATCHDOG_BASE2, SP5100_IO_PM_INDEX_REG);
-	val = val << 8 | inb(SP5100_IO_PM_DATA_REG);
-	outb(SP5100_PM_WATCHDOG_BASE1, SP5100_IO_PM_INDEX_REG);
-	val = val << 8 | inb(SP5100_IO_PM_DATA_REG);
-	outb(SP5100_PM_WATCHDOG_BASE0, SP5100_IO_PM_INDEX_REG);
-	/* Low three bits of BASE0 are reserved. */
-	val = val << 8 | (inb(SP5100_IO_PM_DATA_REG) & 0xf8);
+	/*
+	 * First, Find the watchdog timer MMIO address from indirect I/O.
+	 */
+	outb(base_addr+3, index_reg);
+	val = inb(data_reg);
+	outb(base_addr+2, index_reg);
+	val = val << 8 | inb(data_reg);
+	outb(base_addr+1, index_reg);
+	val = val << 8 | inb(data_reg);
+	outb(base_addr+0, index_reg);
+	/* Low three bits of BASE are reserved */
+	val = val << 8 | (inb(data_reg) & 0xf8);
+
+	pr_debug("Got 0x%04x from indirect I/O\n", val);
+
+	/* Check MMIO address conflict */
+	if (request_mem_region_exclusive(val, SP5100_WDT_MEM_MAP_SIZE,
+								dev_name))
+		goto setup_wdt;
+	else
+		pr_debug("MMIO address 0x%04x already in use\n", val);
+
+	/*
+	 * Secondly, Find the watchdog timer MMIO address
+	 * from SBResource_MMIO register.
+	 */
+	if (sp5100_tco_pci->revision >= 0x40) {
+		/* Read SBResource_MMIO from AcpiMmioEn(PM_Reg: 24h) */
+		outb(SB800_PM_ACPI_MMIO_EN+3, SB800_IO_PM_INDEX_REG);
+		val = inb(SB800_IO_PM_DATA_REG);
+		outb(SB800_PM_ACPI_MMIO_EN+2, SB800_IO_PM_INDEX_REG);
+		val = val << 8 | inb(SB800_IO_PM_DATA_REG);
+		outb(SB800_PM_ACPI_MMIO_EN+1, SB800_IO_PM_INDEX_REG);
+		val = val << 8 | inb(SB800_IO_PM_DATA_REG);
+		outb(SB800_PM_ACPI_MMIO_EN+0, SB800_IO_PM_INDEX_REG);
+		val = val << 8 | inb(SB800_IO_PM_DATA_REG);
+	} else {
+		/* Read SBResource_MMIO from PCI config(PCI_Reg: 9Ch) */
+		pci_read_config_dword(sp5100_tco_pci,
+				      SP5100_SB_RESOURCE_MMIO_BASE, &val);
+	}
+
+	/* The SBResource_MMIO is enabled and mapped memory space? */
+	if ((val & (SB800_ACPI_MMIO_DECODE_EN | SB800_ACPI_MMIO_SEL)) ==
+						  SB800_ACPI_MMIO_DECODE_EN) {
+		/* Clear unnecessary the low twelve bits */
+		val &= ~0xFFF;
+		/* Add the Watchdog Timer offset to base address. */
+		val += SB800_PM_WDT_MMIO_OFFSET;
+		/* Check MMIO address conflict */
+		if (request_mem_region_exclusive(val, SP5100_WDT_MEM_MAP_SIZE,
+								   dev_name)) {
+			pr_debug("Got 0x%04x from SBResource_MMIO register\n",
+				val);
+			goto setup_wdt;
+		} else
+			pr_debug("MMIO address 0x%04x already in use\n", val);
+	} else
+		pr_debug("SBResource_MMIO is disabled(0x%04x)\n", val);
+
+	/*
+	 * Lastly re-programming the watchdog timer MMIO address,
+	 * This method is a last resort...
+	 *
+	 * Before re-programming, to ensure that the watchdog timer
+	 * is disabled, disable the watchdog timer.
+	 */
+	tco_timer_disable();
+
+	if (force_addr) {
+		/*
+		 * Force the use of watchdog timer MMIO address, and aligned to
+		 * 8byte boundary.
+		 */
+		force_addr &= ~0x7;
+		val = force_addr;
+
+		pr_info("Force the use of 0x%04x as MMIO address\n", val);
+	} else {
+		/*
+		 * Get empty slot into the resource tree for watchdog timer.
+		 */
+		if (allocate_resource(&iomem_resource,
+				      &wdt_res,
+				      SP5100_WDT_MEM_MAP_SIZE,
+				      0xf0000000,
+				      0xfffffff8,
+				      0x8,
+				      NULL,
+				      NULL)) {
+			pr_err("MMIO allocation failed\n");
+			goto unreg_region;
+		}
+
+		val = resbase_phys = wdt_res.start;
+		pr_debug("Got 0x%04x from resource tree\n", val);
+	}
+
+	/* Restore to the low three bits, if chipset is SB8x0(or later) */
+	if (sp5100_tco_pci->revision >= 0x40) {
+		u8 reserved_bit;
+		reserved_bit = inb(base_addr) & 0x7;
+		val |= (u32)reserved_bit;
+	}
+
+	/* Re-programming the watchdog timer base address */
+	outb(base_addr+0, index_reg);
+	/* Low three bits of BASE are reserved */
+	outb((val >>  0) & 0xf8, data_reg);
+	outb(base_addr+1, index_reg);
+	outb((val >>  8) & 0xff, data_reg);
+	outb(base_addr+2, index_reg);
+	outb((val >> 16) & 0xff, data_reg);
+	outb(base_addr+3, index_reg);
+	outb((val >> 24) & 0xff, data_reg);
+
+	/*
+	 * Clear unnecessary the low three bits,
+	 * if chipset is SB8x0(or later)
+	 */
+	if (sp5100_tco_pci->revision >= 0x40)
+		val &= ~0x7;
 
 	if (!request_mem_region_exclusive(val, SP5100_WDT_MEM_MAP_SIZE,
-								"SP5100 TCO")) {
-		pr_err("mmio address 0x%04x already in use\n", val);
-		goto unreg_region;
+								   dev_name)) {
+		pr_err("MMIO address 0x%04x already in use\n", val);
+		goto unreg_resource;
 	}
+
+setup_wdt:
 	tcobase_phys = val;
 
 	tcobase = ioremap(val, SP5100_WDT_MEM_MAP_SIZE);
@@ -318,26 +537,18 @@ static unsigned char sp5100_tco_setupdevice(void)
 		goto unreg_mem_region;
 	}
 
-	/* Enable watchdog decode bit */
-	pci_read_config_dword(sp5100_tco_pci,
-			      SP5100_PCI_WATCHDOG_MISC_REG,
-			      &val);
-
-	val |= SP5100_PCI_WATCHDOG_DECODE_EN;
+	pr_info("Using 0x%04x for watchdog MMIO address\n", val);
 
-	pci_write_config_dword(sp5100_tco_pci,
-			       SP5100_PCI_WATCHDOG_MISC_REG,
-			       val);
+	/* Setup the watchdog timer */
+	tco_timer_enable();
 
-	/* Enable Watchdog timer and set the resolution to 1 sec. */
-	outb(SP5100_PM_WATCHDOG_CONTROL, SP5100_IO_PM_INDEX_REG);
-	val = inb(SP5100_IO_PM_DATA_REG);
-	val |= SP5100_PM_WATCHDOG_SECOND_RES;
-	val &= ~SP5100_PM_WATCHDOG_DISABLE;
-	outb(val, SP5100_IO_PM_DATA_REG);
-
-	/* Check that the watchdog action is set to reset the system. */
+	/* Check that the watchdog action is set to reset the system */
 	val = readl(SP5100_WDT_CONTROL(tcobase));
+	/*
+	 * Save WatchDogFired status, because WatchDogFired flag is
+	 * cleared here.
+	 */
+	tco_wdt_fired = val & SP5100_PM_WATCHDOG_FIRED;
 	val &= ~SP5100_PM_WATCHDOG_ACTION_RESET;
 	writel(val, SP5100_WDT_CONTROL(tcobase));
 
@@ -355,6 +566,9 @@ static unsigned char sp5100_tco_setupdevice(void)
 
 unreg_mem_region:
 	release_mem_region(tcobase_phys, SP5100_WDT_MEM_MAP_SIZE);
+unreg_resource:
+	if (resbase_phys)
+		release_resource(&wdt_res);
 unreg_region:
 	release_region(pm_iobase, SP5100_PM_IOPORTS_SIZE);
 exit:
@@ -364,23 +578,18 @@ exit:
 static int sp5100_tco_init(struct platform_device *dev)
 {
 	int ret;
-	u32 val;
+	char addr_str[16];
 
-	/* Check whether or not the hardware watchdog is there. If found, then
+	/*
+	 * Check whether or not the hardware watchdog is there. If found, then
 	 * set it up.
 	 */
 	if (!sp5100_tco_setupdevice())
 		return -ENODEV;
 
 	/* Check to see if last reboot was due to watchdog timeout */
-	pr_info("Watchdog reboot %sdetected\n",
-		readl(SP5100_WDT_CONTROL(tcobase)) & SP5100_PM_WATCHDOG_FIRED ?
-		"" : "not ");
-
-	/* Clear out the old status */
-	val = readl(SP5100_WDT_CONTROL(tcobase));
-	val &= ~SP5100_PM_WATCHDOG_FIRED;
-	writel(val, SP5100_WDT_CONTROL(tcobase));
+	pr_info("Last reboot was %striggered by watchdog.\n",
+		tco_wdt_fired ? "" : "not ");
 
 	/*
 	 * Check that the heartbeat value is within it's range.
@@ -400,14 +609,24 @@ static int sp5100_tco_init(struct platform_device *dev)
 
 	clear_bit(0, &timer_alive);
 
-	pr_info("initialized (0x%p). heartbeat=%d sec (nowayout=%d)\n",
-		tcobase, heartbeat, nowayout);
+	/* Show module parameters */
+	if (force_addr == tcobase_phys)
+		/* The force_addr is vaild */
+		sprintf(addr_str, "0x%04x", force_addr);
+	else
+		strcpy(addr_str, "none");
+
+	pr_info("initialized (0x%p). heartbeat=%d sec (nowayout=%d, "
+		"force_addr=%s)\n",
+		tcobase, heartbeat, nowayout, addr_str);
 
 	return 0;
 
 exit:
 	iounmap(tcobase);
 	release_mem_region(tcobase_phys, SP5100_WDT_MEM_MAP_SIZE);
+	if (resbase_phys)
+		release_resource(&wdt_res);
 	release_region(pm_iobase, SP5100_PM_IOPORTS_SIZE);
 	return ret;
 }
@@ -422,6 +641,8 @@ static void sp5100_tco_cleanup(void)
 	misc_deregister(&sp5100_tco_miscdev);
 	iounmap(tcobase);
 	release_mem_region(tcobase_phys, SP5100_WDT_MEM_MAP_SIZE);
+	if (resbase_phys)
+		release_resource(&wdt_res);
 	release_region(pm_iobase, SP5100_PM_IOPORTS_SIZE);
 }
 
@@ -451,7 +672,7 @@ static int __init sp5100_tco_init_module(void)
 {
 	int err;
 
-	pr_info("SP5100 TCO WatchDog Timer Driver v%s\n", TCO_VERSION);
+	pr_info("SP5100/SB800 TCO WatchDog Timer Driver v%s\n", TCO_VERSION);
 
 	err = platform_driver_register(&sp5100_tco_driver);
 	if (err)
@@ -475,13 +696,13 @@ static void __exit sp5100_tco_cleanup_module(void)
 {
 	platform_device_unregister(sp5100_tco_platform_device);
 	platform_driver_unregister(&sp5100_tco_driver);
-	pr_info("SP5100 TCO Watchdog Module Unloaded\n");
+	pr_info("SP5100/SB800 TCO Watchdog Module Unloaded\n");
 }
 
 module_init(sp5100_tco_init_module);
 module_exit(sp5100_tco_cleanup_module);
 
 MODULE_AUTHOR("Priyanka Gupta");
-MODULE_DESCRIPTION("TCO timer driver for SP5100 chipset");
+MODULE_DESCRIPTION("TCO timer driver for SP5100/SB800 chipset");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/drivers/watchdog/sp5100_tco.h b/drivers/watchdog/sp5100_tco.h
index a5a16cc..71594a0 100644
--- a/drivers/watchdog/sp5100_tco.h
+++ b/drivers/watchdog/sp5100_tco.h
@@ -9,33 +9,57 @@
 /*
  * Some address definitions for the Watchdog
  */
-
 #define SP5100_WDT_MEM_MAP_SIZE		0x08
 #define SP5100_WDT_CONTROL(base)	((base) + 0x00) /* Watchdog Control */
 #define SP5100_WDT_COUNT(base)		((base) + 0x04) /* Watchdog Count */
 
-#define SP5100_WDT_START_STOP_BIT	1
+#define SP5100_WDT_START_STOP_BIT	(1 << 0)
 #define SP5100_WDT_TRIGGER_BIT		(1 << 7)
 
-#define SP5100_PCI_WATCHDOG_MISC_REG	0x41
-#define SP5100_PCI_WATCHDOG_DECODE_EN	(1 << 3)
-
 #define SP5100_PM_IOPORTS_SIZE		0x02
 
-/* These two IO registers are hardcoded and there doesn't seem to be a way to
+/*
+ * These two IO registers are hardcoded and there doesn't seem to be a way to
  * read them from a register.
  */
+
+/*  For SP5100/SB7x0 chipset */
 #define SP5100_IO_PM_INDEX_REG		0xCD6
 #define SP5100_IO_PM_DATA_REG		0xCD7
 
+#define SP5100_SB_RESOURCE_MMIO_BASE	0x9C
+
 #define SP5100_PM_WATCHDOG_CONTROL	0x69
-#define SP5100_PM_WATCHDOG_BASE0	0x6C
-#define SP5100_PM_WATCHDOG_BASE1	0x6D
-#define SP5100_PM_WATCHDOG_BASE2	0x6E
-#define SP5100_PM_WATCHDOG_BASE3	0x6F
+#define SP5100_PM_WATCHDOG_BASE		0x6C
 
 #define SP5100_PM_WATCHDOG_FIRED	(1 << 1)
 #define SP5100_PM_WATCHDOG_ACTION_RESET	(1 << 2)
 
-#define SP5100_PM_WATCHDOG_DISABLE	1
+#define SP5100_PCI_WATCHDOG_MISC_REG	0x41
+#define SP5100_PCI_WATCHDOG_DECODE_EN	(1 << 3)
+
+#define SP5100_PM_WATCHDOG_DISABLE	(1 << 0)
 #define SP5100_PM_WATCHDOG_SECOND_RES	(3 << 1)
+
+#define SP5100_DEVNAME			"SP5100 TCO"
+
+
+/*  For SB8x0(or later) chipset */
+#define SB800_IO_PM_INDEX_REG		0xCD6
+#define SB800_IO_PM_DATA_REG		0xCD7
+
+#define SB800_PM_ACPI_MMIO_EN		0x24
+#define SB800_PM_WATCHDOG_CONTROL	0x48
+#define SB800_PM_WATCHDOG_BASE		0x48
+#define SB800_PM_WATCHDOG_CONFIG	0x4C
+
+#define SB800_PCI_WATCHDOG_DECODE_EN	(1 << 0)
+#define SB800_PM_WATCHDOG_DISABLE	(1 << 2)
+#define SB800_PM_WATCHDOG_SECOND_RES	(3 << 0)
+#define SB800_ACPI_MMIO_DECODE_EN	(1 << 0)
+#define SB800_ACPI_MMIO_SEL		(1 << 2)
+
+
+#define SB800_PM_WDT_MMIO_OFFSET	0xB00
+
+#define SB800_DEVNAME			"SB800 TCO"
diff --git a/drivers/watchdog/sp805_wdt.c b/drivers/watchdog/sp805_wdt.c
index 76c73cb..8872642 100644
--- a/drivers/watchdog/sp805_wdt.c
+++ b/drivers/watchdog/sp805_wdt.c
@@ -130,16 +130,10 @@ static int wdt_config(struct watchdog_device *wdd, bool ping)
 	int ret;
 
 	if (!ping) {
-		ret = clk_prepare(wdt->clk);
-		if (ret) {
-			dev_err(&wdt->adev->dev, "clock prepare fail");
-			return ret;
-		}
 
-		ret = clk_enable(wdt->clk);
+		ret = clk_prepare_enable(wdt->clk);
 		if (ret) {
 			dev_err(&wdt->adev->dev, "clock enable fail");
-			clk_unprepare(wdt->clk);
 			return ret;
 		}
 	}
@@ -190,8 +184,7 @@ static int wdt_disable(struct watchdog_device *wdd)
 	readl_relaxed(wdt->base + WDTLOCK);
 	spin_unlock(&wdt->lock);
 
-	clk_disable(wdt->clk);
-	clk_unprepare(wdt->clk);
+	clk_disable_unprepare(wdt->clk);
 
 	return 0;
 }
diff --git a/drivers/watchdog/twl4030_wdt.c b/drivers/watchdog/twl4030_wdt.c
index 9f54b1d..81918cf 100644
--- a/drivers/watchdog/twl4030_wdt.c
+++ b/drivers/watchdog/twl4030_wdt.c
@@ -22,26 +22,12 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/kernel.h>
-#include <linux/fs.h>
 #include <linux/watchdog.h>
 #include <linux/platform_device.h>
-#include <linux/miscdevice.h>
-#include <linux/uaccess.h>
 #include <linux/i2c/twl.h>
 
 #define TWL4030_WATCHDOG_CFG_REG_OFFS	0x3
 
-#define TWL4030_WDT_STATE_OPEN		0x1
-#define TWL4030_WDT_STATE_ACTIVE	0x8
-
-static struct platform_device *twl4030_wdt_dev;
-
-struct twl4030_wdt {
-	struct miscdevice	miscdev;
-	int			timer_margin;
-	unsigned long		state;
-};
-
 static bool nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, bool, 0);
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started "
@@ -49,175 +35,75 @@ MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started "
 
 static int twl4030_wdt_write(unsigned char val)
 {
-	return twl_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, val,
+	return twl_i2c_write_u8(TWL_MODULE_PM_RECEIVER, val,
 					TWL4030_WATCHDOG_CFG_REG_OFFS);
 }
 
-static int twl4030_wdt_enable(struct twl4030_wdt *wdt)
+static int twl4030_wdt_start(struct watchdog_device *wdt)
 {
-	return twl4030_wdt_write(wdt->timer_margin + 1);
+	return twl4030_wdt_write(wdt->timeout + 1);
 }
 
-static int twl4030_wdt_disable(struct twl4030_wdt *wdt)
+static int twl4030_wdt_stop(struct watchdog_device *wdt)
 {
 	return twl4030_wdt_write(0);
 }
 
-static int twl4030_wdt_set_timeout(struct twl4030_wdt *wdt, int timeout)
-{
-	if (timeout < 0 || timeout > 30) {
-		dev_warn(wdt->miscdev.parent,
-			"Timeout can only be in the range [0-30] seconds");
-		return -EINVAL;
-	}
-	wdt->timer_margin = timeout;
-	return twl4030_wdt_enable(wdt);
-}
-
-static ssize_t twl4030_wdt_write_fop(struct file *file,
-		const char __user *data, size_t len, loff_t *ppos)
+static int twl4030_wdt_set_timeout(struct watchdog_device *wdt,
+				   unsigned int timeout)
 {
-	struct twl4030_wdt *wdt = file->private_data;
-
-	if (len)
-		twl4030_wdt_enable(wdt);
-
-	return len;
-}
-
-static long twl4030_wdt_ioctl(struct file *file,
-		unsigned int cmd, unsigned long arg)
-{
-	void __user *argp = (void __user *)arg;
-	int __user *p = argp;
-	int new_margin;
-	struct twl4030_wdt *wdt = file->private_data;
-
-	static const struct watchdog_info twl4030_wd_ident = {
-		.identity = "TWL4030 Watchdog",
-		.options = WDIOF_SETTIMEOUT,
-		.firmware_version = 0,
-	};
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		return copy_to_user(argp, &twl4030_wd_ident,
-				sizeof(twl4030_wd_ident)) ? -EFAULT : 0;
-
-	case WDIOC_GETSTATUS:
-	case WDIOC_GETBOOTSTATUS:
-		return put_user(0, p);
-
-	case WDIOC_KEEPALIVE:
-		twl4030_wdt_enable(wdt);
-		break;
-
-	case WDIOC_SETTIMEOUT:
-		if (get_user(new_margin, p))
-			return -EFAULT;
-		if (twl4030_wdt_set_timeout(wdt, new_margin))
-			return -EINVAL;
-		return put_user(wdt->timer_margin, p);
-
-	case WDIOC_GETTIMEOUT:
-		return put_user(wdt->timer_margin, p);
-
-	default:
-		return -ENOTTY;
-	}
-
+	wdt->timeout = timeout;
 	return 0;
 }
 
-static int twl4030_wdt_open(struct inode *inode, struct file *file)
-{
-	struct twl4030_wdt *wdt = platform_get_drvdata(twl4030_wdt_dev);
-
-	/* /dev/watchdog can only be opened once */
-	if (test_and_set_bit(0, &wdt->state))
-		return -EBUSY;
-
-	wdt->state |= TWL4030_WDT_STATE_ACTIVE;
-	file->private_data = (void *) wdt;
-
-	twl4030_wdt_enable(wdt);
-	return nonseekable_open(inode, file);
-}
-
-static int twl4030_wdt_release(struct inode *inode, struct file *file)
-{
-	struct twl4030_wdt *wdt = file->private_data;
-	if (nowayout) {
-		dev_alert(wdt->miscdev.parent,
-		       "Unexpected close, watchdog still running!\n");
-		twl4030_wdt_enable(wdt);
-	} else {
-		if (twl4030_wdt_disable(wdt))
-			return -EFAULT;
-		wdt->state &= ~TWL4030_WDT_STATE_ACTIVE;
-	}
-
-	clear_bit(0, &wdt->state);
-	return 0;
-}
+static const struct watchdog_info twl4030_wdt_info = {
+	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
+	.identity = "TWL4030 Watchdog",
+};
 
-static const struct file_operations twl4030_wdt_fops = {
+static const struct watchdog_ops twl4030_wdt_ops = {
 	.owner		= THIS_MODULE,
-	.llseek		= no_llseek,
-	.open		= twl4030_wdt_open,
-	.release	= twl4030_wdt_release,
-	.unlocked_ioctl	= twl4030_wdt_ioctl,
-	.write		= twl4030_wdt_write_fop,
+	.start		= twl4030_wdt_start,
+	.stop		= twl4030_wdt_stop,
+	.set_timeout	= twl4030_wdt_set_timeout,
 };
 
 static int twl4030_wdt_probe(struct platform_device *pdev)
 {
 	int ret = 0;
-	struct twl4030_wdt *wdt;
+	struct watchdog_device *wdt;
 
-	wdt = kzalloc(sizeof(struct twl4030_wdt), GFP_KERNEL);
+	wdt = devm_kzalloc(&pdev->dev, sizeof(*wdt), GFP_KERNEL);
 	if (!wdt)
 		return -ENOMEM;
 
-	wdt->state		= 0;
-	wdt->timer_margin	= 30;
-	wdt->miscdev.parent	= &pdev->dev;
-	wdt->miscdev.fops	= &twl4030_wdt_fops;
-	wdt->miscdev.minor	= WATCHDOG_MINOR;
-	wdt->miscdev.name	= "watchdog";
+	wdt->info		= &twl4030_wdt_info;
+	wdt->ops		= &twl4030_wdt_ops;
+	wdt->status		= 0;
+	wdt->timeout		= 30;
+	wdt->min_timeout	= 1;
+	wdt->max_timeout	= 30;
 
+	watchdog_set_nowayout(wdt, nowayout);
 	platform_set_drvdata(pdev, wdt);
 
-	twl4030_wdt_dev = pdev;
+	twl4030_wdt_stop(wdt);
 
-	twl4030_wdt_disable(wdt);
-
-	ret = misc_register(&wdt->miscdev);
+	ret = watchdog_register_device(wdt);
 	if (ret) {
-		dev_err(wdt->miscdev.parent,
-			"Failed to register misc device\n");
 		platform_set_drvdata(pdev, NULL);
-		kfree(wdt);
-		twl4030_wdt_dev = NULL;
 		return ret;
 	}
+
 	return 0;
 }
 
 static int twl4030_wdt_remove(struct platform_device *pdev)
 {
-	struct twl4030_wdt *wdt = platform_get_drvdata(pdev);
-
-	if (wdt->state & TWL4030_WDT_STATE_ACTIVE)
-		if (twl4030_wdt_disable(wdt))
-			return -EFAULT;
-
-	wdt->state &= ~TWL4030_WDT_STATE_ACTIVE;
-	misc_deregister(&wdt->miscdev);
+	struct watchdog_device *wdt = platform_get_drvdata(pdev);
 
+	watchdog_unregister_device(wdt);
 	platform_set_drvdata(pdev, NULL);
-	kfree(wdt);
-	twl4030_wdt_dev = NULL;
 
 	return 0;
 }
@@ -225,18 +111,18 @@ static int twl4030_wdt_remove(struct platform_device *pdev)
 #ifdef CONFIG_PM
 static int twl4030_wdt_suspend(struct platform_device *pdev, pm_message_t state)
 {
-	struct twl4030_wdt *wdt = platform_get_drvdata(pdev);
-	if (wdt->state & TWL4030_WDT_STATE_ACTIVE)
-		return twl4030_wdt_disable(wdt);
+	struct watchdog_device *wdt = platform_get_drvdata(pdev);
+	if (watchdog_active(wdt))
+		return twl4030_wdt_stop(wdt);
 
 	return 0;
 }
 
 static int twl4030_wdt_resume(struct platform_device *pdev)
 {
-	struct twl4030_wdt *wdt = platform_get_drvdata(pdev);
-	if (wdt->state & TWL4030_WDT_STATE_ACTIVE)
-		return twl4030_wdt_enable(wdt);
+	struct watchdog_device *wdt = platform_get_drvdata(pdev);
+	if (watchdog_active(wdt))
+		return twl4030_wdt_start(wdt);
 
 	return 0;
 }
@@ -260,6 +146,5 @@ module_platform_driver(twl4030_wdt_driver);
 
 MODULE_AUTHOR("Nokia Corporation");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 MODULE_ALIAS("platform:twl4030_wdt");
 
diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
index 87490ac..3a9df2f 100644
--- a/include/linux/watchdog.h
+++ b/include/linux/watchdog.h
@@ -129,7 +129,7 @@ static inline void *watchdog_get_drvdata(struct watchdog_device *wdd)
 	return wdd->driver_data;
 }
 
-/* drivers/watchdog/core/watchdog_core.c */
+/* drivers/watchdog/watchdog_core.c */
 extern int watchdog_register_device(struct watchdog_device *);
 extern void watchdog_unregister_device(struct watchdog_device *);
 
