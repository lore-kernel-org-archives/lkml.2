Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab2ITIOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 04:14:36 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:44628 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751633Ab2ITIOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 04:14:31 -0400
Date: Thu, 20 Sep 2012 10:14:29 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Toshi Kani <toshi.kani@hp.com>
Subject: [GIT PULL REQUEST] watchdog - v3.6-rc5 Fixes
Message-ID: <20120920081429.GC16482@spo001.leaseweb.com>
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

It will fix a kdump issue in hpwdt and a possible NULL dereference.

This will update the following files:

 hpwdt.c         |    3 +++
 watchdog_core.c |    3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

with these Changes:

commit b232a70a1735c004f9ee6fdf363def527b9234b6
Author: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Date:   Mon Sep 10 12:41:15 2012 +0800

    watchdog: move the dereference below the NULL test
    
    The dereference should be moved below the NULL test.
    
    spatch with a semantic match is used to found this.
    (http://coccinelle.lip6.fr/)
    
    Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 308b135e4fcc00c80c07e0e04e7afa8edf78583c
Author: Toshi Kani <toshi.kani@hp.com>
Date:   Mon Aug 27 12:52:24 2012 -0600

    hpwdt: Fix kdump issue in hpwdt
    
    kdump can be interrupted by watchdog timer when the timer is left
    activated on the crash kernel. Changed the hpwdt driver to disable
    watchdog timer at boot-time. This assures that watchdog timer is
    disabled until /dev/watchdog is opened, and prevents watchdog timer
    to be left running on the crash kernel.
    
    Signed-off-by: Toshi Kani <toshi.kani@hp.com>
    Tested-by: Lisa Mitchell <lisa.mitchell@hp.com>
    Signed-off-by: Thomas Mingarelli <Thomas.Mingarelli@hp.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Cc: stable <stable@vger.kernel.org>

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 1eff743..ae60406 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -814,6 +814,9 @@ static int __devinit hpwdt_init_one(struct pci_dev *dev,
 	hpwdt_timer_reg = pci_mem_addr + 0x70;
 	hpwdt_timer_con = pci_mem_addr + 0x72;
 
+	/* Make sure that timer is disabled until /dev/watchdog is opened */
+	hpwdt_stop();
+
 	/* Make sure that we have a valid soft_margin */
 	if (hpwdt_change_timer(soft_margin))
 		hpwdt_change_timer(DEFAULT_MARGIN);
diff --git a/drivers/watchdog/watchdog_core.c b/drivers/watchdog/watchdog_core.c
index 6aa46a9..3796434 100644
--- a/drivers/watchdog/watchdog_core.c
+++ b/drivers/watchdog/watchdog_core.c
@@ -128,11 +128,12 @@ EXPORT_SYMBOL_GPL(watchdog_register_device);
 void watchdog_unregister_device(struct watchdog_device *wdd)
 {
 	int ret;
-	int devno = wdd->cdev.dev;
+	int devno;
 
 	if (wdd == NULL)
 		return;
 
+	devno = wdd->cdev.dev;
 	ret = watchdog_dev_unregister(wdd);
 	if (ret)
 		pr_err("error unregistering /dev/watchdog (err=%d)\n", ret);
