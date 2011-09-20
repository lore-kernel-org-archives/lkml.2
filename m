Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751267Ab1ITOUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 10:20:50 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:58811 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750890Ab1ITOUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 10:20:48 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EANKeeE5tgwoK/2dsb2JhbAA5CadceYIBExwjGBccKiUDIROHeQS0CA6DSB+DCASkfA
Date: Tue, 20 Sep 2011 16:19:44 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>, John Crispin <blogic@openwrt.org>,
        Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        Hartley Sweeten <hsweeten@visionengravers.com>
Subject: [GIT PULL REQUEST] watchdog - v3.1 - Fixes
Message-ID: <20110920141944.GU11844@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please do a 
	git pull git://www.linux-watchdog.org/linux-watchdog.git master

This will update the following files:

 hpwdt.c        |    9 +++++----
 lantiq_wdt.c   |    8 ++++----
 sbc_epx_c3.c   |    2 +-
 watchdog_dev.c |   14 +++++++-------
 4 files changed, 17 insertions(+), 16 deletions(-)

with these Changes:

Author: Andi Kleen <ak@linux.intel.com>
Date:   Thu Sep 15 13:09:51 2011 -0700

    watchdog: Initconst section fixes for watchdog
    
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: John Crispin <blogic@openwrt.org>
Date:   Wed Aug 24 10:31:39 2011 +0200

    watchdog: lantiq: fix watchdogs timeout handling
    
    The enable function was using the global timeout variable for local operations.
    This resulted in the value of the global variable being corrupted, thus
    breaking the code.
    
    Signed-off-by: John Crispin <blogic@openwrt.org>
    Signed-off-by: Thomas Langer <thomas.langer@lantiq.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Cc: linux-watchdog@vger.kernel.org
    Cc: linux-mips@linux-mips.org

Author: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Date:   Tue Aug 9 22:27:26 2011 +0000

    watchdog: hpwdt: prevent multiple "NMI occurred" messages
    
    On platforms with no iCRU support don't print two, (possibly conflicting),
    "NMI occurred" messages when the firmware is unable to source the NMI.
    
    Please note that one of the enhancements to the v1.3.0 hpwdt driver is to panic and allow
    KDUMP to succeed even on NMIs that are unknown to the platform firmware.
    
    Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
    Reviewed-by: Thomas Mingarelli <thomas.mingarelli@hp.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: H Hartley Sweeten <hsweeten@visionengravers.com>
Date:   Wed Aug 3 15:38:20 2011 -0700

    watchdog: WatchDog Timer Driver Core - use passed watchdog_device
    
    Use the passed watchdog_device instead of the static global variable when
    testing and setting the status in watchdog_ping, watchdog_start, and
    watchdog_stop.  Note that the callers of these functions are actually
    passing the static global variable.
    
    Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 410fba4..809cbda 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -494,15 +494,16 @@ static int hpwdt_pretimeout(struct notifier_block *nb, unsigned long ulReason,
 		asminline_call(&cmn_regs, cru_rom_addr);
 	die_nmi_called = 1;
 	spin_unlock_irqrestore(&rom_lock, rom_pl);
+
+	if (allow_kdump)
+		hpwdt_stop();
+
 	if (!is_icru) {
 		if (cmn_regs.u1.ral == 0) {
-			printk(KERN_WARNING "hpwdt: An NMI occurred, "
+			panic("An NMI occurred, "
 				"but unable to determine source.\n");
 		}
 	}
-
-	if (allow_kdump)
-		hpwdt_stop();
 	panic("An NMI occurred, please see the Integrated "
 		"Management Log for details.\n");
 
diff --git a/drivers/watchdog/lantiq_wdt.c b/drivers/watchdog/lantiq_wdt.c
index 7d82ada..102aed0 100644
--- a/drivers/watchdog/lantiq_wdt.c
+++ b/drivers/watchdog/lantiq_wdt.c
@@ -51,16 +51,16 @@ static int ltq_wdt_ok_to_close;
 static void
 ltq_wdt_enable(void)
 {
-	ltq_wdt_timeout = ltq_wdt_timeout *
+	unsigned long int timeout = ltq_wdt_timeout *
 			(ltq_io_region_clk_rate / LTQ_WDT_DIVIDER) + 0x1000;
-	if (ltq_wdt_timeout > LTQ_MAX_TIMEOUT)
-		ltq_wdt_timeout = LTQ_MAX_TIMEOUT;
+	if (timeout > LTQ_MAX_TIMEOUT)
+		timeout = LTQ_MAX_TIMEOUT;
 
 	/* write the first password magic */
 	ltq_w32(LTQ_WDT_PW1, ltq_wdt_membase + LTQ_WDT_CR);
 	/* write the second magic plus the configuration and new timeout */
 	ltq_w32(LTQ_WDT_SR_EN | LTQ_WDT_SR_PWD | LTQ_WDT_SR_CLKDIV |
-		LTQ_WDT_PW2 | ltq_wdt_timeout, ltq_wdt_membase + LTQ_WDT_CR);
+		LTQ_WDT_PW2 | timeout, ltq_wdt_membase + LTQ_WDT_CR);
 }
 
 static void
diff --git a/drivers/watchdog/sbc_epx_c3.c b/drivers/watchdog/sbc_epx_c3.c
index 3066a51..eaca366 100644
--- a/drivers/watchdog/sbc_epx_c3.c
+++ b/drivers/watchdog/sbc_epx_c3.c
@@ -173,7 +173,7 @@ static struct notifier_block epx_c3_notifier = {
 	.notifier_call = epx_c3_notify_sys,
 };
 
-static const char banner[] __initdata = KERN_INFO PFX
+static const char banner[] __initconst = KERN_INFO PFX
 	"Hardware Watchdog Timer for Winsystems EPX-C3 SBC: 0.1\n";
 
 static int __init watchdog_init(void)
diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index d33520d..1199da0 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -59,7 +59,7 @@ static struct watchdog_device *wdd;
 
 static int watchdog_ping(struct watchdog_device *wddev)
 {
-	if (test_bit(WDOG_ACTIVE, &wdd->status)) {
+	if (test_bit(WDOG_ACTIVE, &wddev->status)) {
 		if (wddev->ops->ping)
 			return wddev->ops->ping(wddev);  /* ping the watchdog */
 		else
@@ -81,12 +81,12 @@ static int watchdog_start(struct watchdog_device *wddev)
 {
 	int err;
 
-	if (!test_bit(WDOG_ACTIVE, &wdd->status)) {
+	if (!test_bit(WDOG_ACTIVE, &wddev->status)) {
 		err = wddev->ops->start(wddev);
 		if (err < 0)
 			return err;
 
-		set_bit(WDOG_ACTIVE, &wdd->status);
+		set_bit(WDOG_ACTIVE, &wddev->status);
 	}
 	return 0;
 }
@@ -105,18 +105,18 @@ static int watchdog_stop(struct watchdog_device *wddev)
 {
 	int err = -EBUSY;
 
-	if (test_bit(WDOG_NO_WAY_OUT, &wdd->status)) {
+	if (test_bit(WDOG_NO_WAY_OUT, &wddev->status)) {
 		pr_info("%s: nowayout prevents watchdog to be stopped!\n",
-							wdd->info->identity);
+							wddev->info->identity);
 		return err;
 	}
 
-	if (test_bit(WDOG_ACTIVE, &wdd->status)) {
+	if (test_bit(WDOG_ACTIVE, &wddev->status)) {
 		err = wddev->ops->stop(wddev);
 		if (err < 0)
 			return err;
 
-		clear_bit(WDOG_ACTIVE, &wdd->status);
+		clear_bit(WDOG_ACTIVE, &wddev->status);
 	}
 	return 0;
 }
