Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672Ab1HBI1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 04:27:44 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:41288 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752085Ab1HBI1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 04:27:39 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EADK0N05tgyMH/2dsb2JhbABCp194ggE/GBdGDRgDIRMJh2UCwSUOhVVfBJxmhns
Date: Tue, 2 Aug 2011 10:27:37 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        David Engraf <david.engraf@sysgo.com>,
        Paul Mundt <lethal@linux-sh.org>, Mart Gerrits <mart1987@gmail.com>,
        Josh Boyer <jwboyer@redhat.com>
Subject: [GIT PULL REQUEST] watchdog - Fixes
Message-ID: <20110802082737.GA7843@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-watchdog.git

This will update the following files:

 drivers/watchdog/Kconfig  |    3 ---
 drivers/watchdog/nv_tco.c |    8 ++++++++
 drivers/watchdog/shwdt.c  |    2 +-
 3 files changed, 9 insertions(+), 4 deletions(-)

with these Changes:

Author: Josh Boyer <jwboyer@redhat.com>
Date:   Sat Jul 30 10:18:48 2011 -0400

    watchdog: Cleanup WATCHDOG_CORE help text
    
    The newly added WATCHDOG_CORE option is a bool, but the help text suggests
    it can be built as a module.  Fix it up.
    
    Signed-off-by: Josh Boyer <jwboyer@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Mart Gerrits <mart1987@gmail.com>
Date:   Sat Jul 30 16:59:12 2011 +0200

    watchdog: Fix POST failure on ASUS P5N32-E SLI and similar boards
    
    At present the module does not unset the NO_REBOOT bit upon shutdown, this
    causes the BIOS to fail the POST once and reset. During the next boot it
    displays the following error message:
    
    ***** Warning: System BOOT Fail *****
    Your system last boot fail or POST interrupted.
    Please enter setup to load default and reboot again.
    Press F1 to continue, DEL to enter SETUP
    
    With this patch the NO_REBOOT flag will be unset on shutdown and thus stop
    this failure from occurring.
    
    Tested on 'ASUS P5N32-E SLI with BIOS revision 1801' and
              'ASUS P5N32-E SLI PLUS with BIOS revision 1502'.
    
    Signed-off-by: Mart Gerrits <mart1987@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: David Engraf <david.engraf@sysgo.com>
Date:   Wed Jul 20 15:03:39 2011 +0200

    watchdog: shwdt: fix usage of mod_timer
    
    Fix the usage of mod_timer() and make the driver usable. mod_timer() must
    be called with an absolute timeout in jiffies. The old implementation
    used a relative timeout thus the hardware watchdog was never triggered.
    
    Signed-off-by: David Engraf <david.engraf@sysgo.com>
    Signed-off-by: Paul Mundt <lethal@linux-sh.org>
    Signed-off-by: Wim Van sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Cc: stable <stable@kernel.org>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index f441726..86b0735 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -36,9 +36,6 @@ config WATCHDOG_CORE
 	  and gives them the /dev/watchdog interface (and later also the
 	  sysfs interface).
 
-	  To compile this driver as a module, choose M here: the module will
-	  be called watchdog.
-
 config WATCHDOG_NOWAYOUT
 	bool "Disable watchdog shutdown on close"
 	help
diff --git a/drivers/watchdog/nv_tco.c b/drivers/watchdog/nv_tco.c
index afa78a5..809f41c 100644
--- a/drivers/watchdog/nv_tco.c
+++ b/drivers/watchdog/nv_tco.c
@@ -458,7 +458,15 @@ static int __devexit nv_tco_remove(struct platform_device *dev)
 
 static void nv_tco_shutdown(struct platform_device *dev)
 {
+	u32 val;
+
 	tco_timer_stop();
+
+	/* Some BIOSes fail the POST (once) if the NO_REBOOT flag is not
+	 * unset during shutdown. */
+	pci_read_config_dword(tco_pci, MCP51_SMBUS_SETUP_B, &val);
+	val &= ~MCP51_SMBUS_SETUP_B_TCO_REBOOT;
+	pci_write_config_dword(tco_pci, MCP51_SMBUS_SETUP_B, val);
 }
 
 static struct platform_driver nv_tco_driver = {
diff --git a/drivers/watchdog/shwdt.c b/drivers/watchdog/shwdt.c
index db84f23..a267dc0 100644
--- a/drivers/watchdog/shwdt.c
+++ b/drivers/watchdog/shwdt.c
@@ -64,7 +64,7 @@
  * misses its deadline, the kernel timer will allow the WDT to overflow.
  */
 static int clock_division_ratio = WTCSR_CKS_4096;
-#define next_ping_period(cks)	msecs_to_jiffies(cks - 4)
+#define next_ping_period(cks)	(jiffies + msecs_to_jiffies(cks - 4))
 
 static const struct watchdog_info sh_wdt_info;
 static struct platform_device *sh_wdt_dev;
