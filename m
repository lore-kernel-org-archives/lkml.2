Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab1L0Toz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 14:44:55 -0500
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:59673 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753133Ab1L0Tow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 14:44:52 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAPgf+k5tgxv+/2dsb2JhbABCrEeBBoIgExwjGBdGJQMhE4d8BrUCE4t8BJUBkjY
Date: Tue, 27 Dec 2011 20:44:44 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Mingarelli@infomag.iguana.be, Thomas <Thomas.Mingarelli@hp.com>,
        Nick Bowler <nbowler@elliptictech.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [GIT PULL REQUEST] watchdog - v3.1-rc7 - Fixes
Message-ID: <20111227194444.GV23376@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://www.linux-watchdog.org/linux-watchdog.git

This will update the following files:

 drivers/watchdog/coh901327_wdt.c |    6 ++++--
 drivers/watchdog/hpwdt.c         |    5 ++++-
 drivers/watchdog/iTCO_wdt.c      |    6 +++---
 drivers/watchdog/sp805_wdt.c     |    2 +-
 4 files changed, 12 insertions(+), 7 deletions(-)

with these Changes:

commit 0d098587cec70048336a3809bcde8044c7e9aa08
Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Mon Dec 26 15:23:51 2011 +0100

    watchdog: iTCO_wdt.c - problems with newer hardware due to SMI clearing (part 2)
    
    Redhat Bugzilla: Bug 727875 - TCO_EN bit is disabled by TCO driver
    
    The previous patch breaks reset watchdog behaviour on the older hardware.
    It is therefor better to make sure that the behaviour for older hardware (<=ICH5 or
    6300ESB) is preserved and that the behaviour for newer hardware is changed.
    We therefor use the iTCO_version to see if we need the clearing of the SMI_TCO_EN
    bit in the SMI_EN register.
    
    So the new behaviour becomes:
    turn_SMI_watchdog_clear_off=0 -> Do not turn off SMI clearing watchdog.
    turn_SMI_watchdog_clear_off=1 -> Turn off SMI clearing watchdog when iTCO_version=1
    				 (ICHO till ICH5 + 6300ESB only)
    turn_SMI_watchdog_clear_off=2 -> Turn off SMI clearing watchdog.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit e67d668e147c3b4fec638c9e0ace04319f5ceccd
Author: Mingarelli, Thomas <Thomas.Mingarelli@hp.com>
Date:   Mon Nov 7 10:59:00 2011 +0100

    watchdog: hpwdt: Changes to handle NX secure bit in 32bit path
    
    This patch makes use of the set_memory_x() kernel API in order
    to make necessary BIOS calls to source NMIs.
    
    This is needed for SLES11 SP2 and the latest upstream kernel as it appears
    the NX Execute Disable has grown in its control.
    
    Signed-off by: Thomas Mingarelli <thomas.mingarelli@hp.com>
    Signed-off by: Wim Van Sebroeck <wim@iguana.be>
    Cc: stable@kernel.org

commit bb558dac6776386a4d6994540a009231dcf53ee1
Author: Nick Bowler <nbowler@elliptictech.com>
Date:   Mon Dec 19 11:22:36 2011 -0500

    watchdog: sp805: Fix section mismatch in ID table.
    
    The AMBA ID table is marked as __initdata, yet it is referenced by the
    driver struct which is not.  This causes a (somewhat unhelpful) section
    mismatch warning:
    
      WARNING: drivers/watchdog/sp805_wdt.o(.data+0x4c): Section mismatch in
               reference from the variable sp805_wdt_driver to the (unknown
               reference) .init.data:(unknown)
    
    Fix this by removing the annotation.
    
    Signed-off-by: Nick Bowler <nbowler@elliptictech.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 452190cb0526e9cc11b0998a600411cb9c7cd684
Author: Linus Walleij <linus.walleij@linaro.org>
Date:   Mon Oct 3 10:52:58 2011 +0200

    watchdog: move coh901327 state holders
    
    The state holders used in the PM path of the drivers report as
    unused variables when compiling without CONFIG_PM so let's
    move them inside CONFIG_PM.
    
    Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/coh901327_wdt.c b/drivers/watchdog/coh901327_wdt.c
index 03f449a..5b89f7d 100644
--- a/drivers/watchdog/coh901327_wdt.c
+++ b/drivers/watchdog/coh901327_wdt.c
@@ -76,8 +76,6 @@ static int irq;
 static void __iomem *virtbase;
 static unsigned long coh901327_users;
 static unsigned long boot_status;
-static u16 wdogenablestore;
-static u16 irqmaskstore;
 static struct device *parent;
 
 /*
@@ -461,6 +459,10 @@ out:
 }
 
 #ifdef CONFIG_PM
+
+static u16 wdogenablestore;
+static u16 irqmaskstore;
+
 static int coh901327_suspend(struct platform_device *pdev, pm_message_t state)
 {
 	irqmaskstore = readw(virtbase + U300_WDOG_IMR) & 0x0001U;
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 3774c9b..8464ea1 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -231,6 +231,7 @@ static int __devinit cru_detect(unsigned long map_entry,
 
 	cmn_regs.u1.reax = CRU_BIOS_SIGNATURE_VALUE;
 
+	set_memory_x((unsigned long)bios32_entrypoint, (2 * PAGE_SIZE));
 	asminline_call(&cmn_regs, bios32_entrypoint);
 
 	if (cmn_regs.u1.ral != 0) {
@@ -248,8 +249,10 @@ static int __devinit cru_detect(unsigned long map_entry,
 		if ((physical_bios_base + physical_bios_offset)) {
 			cru_rom_addr =
 				ioremap(cru_physical_address, cru_length);
-			if (cru_rom_addr)
+			if (cru_rom_addr) {
+				set_memory_x((unsigned long)cru_rom_addr, cru_length);
 				retval = 0;
+			}
 		}
 
 		printk(KERN_DEBUG "hpwdt: CRU Base Address:   0x%lx\n",
diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index ba6ad66..99796c5 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -384,10 +384,10 @@ MODULE_PARM_DESC(nowayout,
 	"Watchdog cannot be stopped once started (default="
 				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
-static int turn_SMI_watchdog_clear_off = 0;
+static int turn_SMI_watchdog_clear_off = 1;
 module_param(turn_SMI_watchdog_clear_off, int, 0);
 MODULE_PARM_DESC(turn_SMI_watchdog_clear_off,
-	"Turn off SMI clearing watchdog (default=0)");
+	"Turn off SMI clearing watchdog (depends on TCO-version)(default=1)");
 
 /*
  * Some TCO specific functions
@@ -813,7 +813,7 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 		ret = -EIO;
 		goto out_unmap;
 	}
-	if (turn_SMI_watchdog_clear_off) {
+	if (turn_SMI_watchdog_clear_off >= iTCO_wdt_private.iTCO_version) {
 		/* Bit 13: TCO_EN -> 0 = Disables TCO logic generating an SMI# */
 		val32 = inl(SMI_EN);
 		val32 &= 0xffffdfff;	/* Turn off SMI clearing watchdog */
diff --git a/drivers/watchdog/sp805_wdt.c b/drivers/watchdog/sp805_wdt.c
index cc2cfbe..bfaf9bb 100644
--- a/drivers/watchdog/sp805_wdt.c
+++ b/drivers/watchdog/sp805_wdt.c
@@ -351,7 +351,7 @@ static int __devexit sp805_wdt_remove(struct amba_device *adev)
 	return 0;
 }
 
-static struct amba_id sp805_wdt_ids[] __initdata = {
+static struct amba_id sp805_wdt_ids[] = {
 	{
 		.id	= 0x00141805,
 		.mask	= 0x00ffffff,
