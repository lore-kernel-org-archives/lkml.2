Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab1CNKxP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 06:53:15 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:33865 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751721Ab1CNKxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 06:53:11 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAE2PfU1R8CBx/2dsb2JhbACmBni/SQ2FVQSTQg
Date: Mon, 14 Mar 2011 11:53:08 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
        Dan Carpenter <error27@gmail.com>, Axel Lin <axel.lin@gmail.com>,
        Thomas Mingarelli <Thomas.Mingarelli@hp.com>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Subject: [GIT PULL REQUEST] watchdog - v2.6.38-rc8
Message-ID: <20110314105308.GA14752@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 drivers/watchdog/cpwd.c         |    2 +-
 drivers/watchdog/hpwdt.c        |    4 ++--
 drivers/watchdog/sch311x_wdt.c  |    2 +-
 drivers/watchdog/w83697ug_wdt.c |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

with these Changes:

Author: Axel Lin <axel.lin@gmail.com>
Date:   Wed Mar 2 11:49:44 2011 +0800

    watchdog: hpwdt: eliminate section mismatch warning
    
    hpwdt_init_nmi_decoding() is called in hpwdt_init_one error handling,
    thus remove the  __devexit annotation of hpwdt_exit_nmi_decoding().
    
    This patch fixes below warning:
    
    WARNING: drivers/watchdog/hpwdt.o(.devinit.text+0x36f): Section mismatch in reference from the function hpwdt_init_one() to the function .devexit.text:hpwdt_exit_nmi_decoding()
    The function __devinit hpwdt_init_one() references
    a function __devexit hpwdt_exit_nmi_decoding().
    This is often seen when error handling in the init function
    uses functionality in the exit path.
    The fix is often to remove the __devexit annotation of
    hpwdt_exit_nmi_decoding() so it may be used outside an exit section.
    
    Signed-off-by: Axel Lin <axel.lin@gmail.com>
    Acked-by: Thomas Mingarelli <Thomas.Mingarelli@hp.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Mon Feb 21 19:28:58 2011 +0000

    watchdog: w83697ug_wdt: Fix set bit 0 to activate GPIO2
    
    outb_p(c || 0x01, WDT_EFDR); -> || should be |
    
    Reported-By: Toralf Förster <toralf.foerster@gmx.de>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Dan Carpenter <error27@gmail.com>
Date:   Wed Feb 23 23:26:01 2011 +0300

    watchdog: sch311x_wdt: fix printk condition
    
    "==" has higher precedence than "&".  Since
    if (sch311x_sio_inb(sio_config_port, 0x30) & (0x01 == 0)) is always
    false the message is never printed.
    
    Signed-off-by: Dan Carpenter <error27@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Mon Feb 21 19:09:40 2011 +0000

    watchdog: sch311x_wdt: Fix LDN active check
    
    if (sch311x_sio_inb(sio_config_port, 0x30) && 0x01 == 0) -> && should be &
    
    Reported-By: Toralf Förster <toralf.foerster@gmx.de>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Mon Feb 21 10:52:43 2011 +0000

    watchdog: cpwd: Fix buffer-overflow
    
    cppcheck-1.47 reports:
    [drivers/watchdog/cpwd.c:650]: (error) Buffer access out-of-bounds: p.devs
    
    The source code is
    	for (i = 0; i < 4; i++) {
    		misc_deregister(&p->devs[i].misc);
    
    where devs is defined as WD_NUMDEVS big and WD_NUMDEVS is equal to 3.
    So the 4 should be a 3 or WD_NUMDEVS.
    
    Reported-By: David Binderman
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/cpwd.c b/drivers/watchdog/cpwd.c
index eca855a..3de4ba0 100644
--- a/drivers/watchdog/cpwd.c
+++ b/drivers/watchdog/cpwd.c
@@ -646,7 +646,7 @@ static int __devexit cpwd_remove(struct platform_device *op)
 	struct cpwd *p = dev_get_drvdata(&op->dev);
 	int i;
 
-	for (i = 0; i < 4; i++) {
+	for (i = 0; i < WD_NUMDEVS; i++) {
 		misc_deregister(&p->devs[i].misc);
 
 		if (!p->enabled) {
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 24b966d..204a560 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -710,7 +710,7 @@ static int __devinit hpwdt_init_nmi_decoding(struct pci_dev *dev)
 	return 0;
 }
 
-static void __devexit hpwdt_exit_nmi_decoding(void)
+static void hpwdt_exit_nmi_decoding(void)
 {
 	unregister_die_notifier(&die_notifier);
 	if (cru_rom_addr)
@@ -726,7 +726,7 @@ static int __devinit hpwdt_init_nmi_decoding(struct pci_dev *dev)
 	return 0;
 }
 
-static void __devexit hpwdt_exit_nmi_decoding(void)
+static void hpwdt_exit_nmi_decoding(void)
 {
 }
 #endif /* CONFIG_HPWDT_NMI_DECODING */
diff --git a/drivers/watchdog/sch311x_wdt.c b/drivers/watchdog/sch311x_wdt.c
index 0461858..b61ab1c 100644
--- a/drivers/watchdog/sch311x_wdt.c
+++ b/drivers/watchdog/sch311x_wdt.c
@@ -508,7 +508,7 @@ static int __init sch311x_detect(int sio_config_port, unsigned short *addr)
 	sch311x_sio_outb(sio_config_port, 0x07, 0x0a);
 
 	/* Check if Logical Device Register is currently active */
-	if (sch311x_sio_inb(sio_config_port, 0x30) && 0x01 == 0)
+	if ((sch311x_sio_inb(sio_config_port, 0x30) & 0x01) == 0)
 		printk(KERN_INFO PFX "Seems that LDN 0x0a is not active...\n");
 
 	/* Get the base address of the runtime registers */
diff --git a/drivers/watchdog/w83697ug_wdt.c b/drivers/watchdog/w83697ug_wdt.c
index a6c12de..df2a64d 100644
--- a/drivers/watchdog/w83697ug_wdt.c
+++ b/drivers/watchdog/w83697ug_wdt.c
@@ -109,7 +109,7 @@ static int w83697ug_select_wd_register(void)
 	outb_p(0x08, WDT_EFDR); /* select logical device 8 (GPIO2) */
 	outb_p(0x30, WDT_EFER); /* select CR30 */
 	c = inb_p(WDT_EFDR);
-	outb_p(c || 0x01, WDT_EFDR); /* set bit 0 to activate GPIO2 */
+	outb_p(c | 0x01, WDT_EFDR); /* set bit 0 to activate GPIO2 */
 
 	return 0;
 }
