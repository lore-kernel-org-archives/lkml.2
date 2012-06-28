Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab2F1Srf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 14:47:35 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:45250 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755557Ab2F1Sre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 14:47:34 -0400
Date: Thu, 28 Jun 2012 20:47:32 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Thomas Mingarelli <Thomas.Mingarelli@hp.com>,
        Jan Beulich <JBeulich@suse.com>, Guenter Roeck <linux@roeck-us.net>
Subject: [GIT PULL REQUEST] watchdog - v3.5-rc4 Fixes
Message-ID: <20120628184731.GK735@spo001.leaseweb.com>
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

It will fix:
* the WDIOC_GETSTATUS return value
* the unregister of all NMI events on exit
* the loading of the iTCO_wdt driver after the conversion to the lpc_ich mfd model.

This will update the following files:

 hpwdt.c        |    4 +++-
 iTCO_wdt.c     |    1 +
 watchdog_dev.c |    2 +-
 3 files changed, 5 insertions(+), 2 deletions(-)

with these Changes:

commit 8b9468d496abd357cc797b27a79d4402f5e0e94d
Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Tue Jun 26 20:07:21 2012 +0200

    watchdog: core: fix WDIOC_GETSTATUS return value
    
    In commit 7a87982420e5e126bfefeb42232d1fd92052794e we added
    a wrapper for the WDIOC_GETSTATUS ioctl call. The code results
    however in a different behaviour: it returns an error if the
    driver doesn't support the status operation. This is not
    according to the API that says that when we don't support
    the status operation, that we just should return a 0 value.
    Only when the device isn't there anymore, we should return an
    error.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit a089361cf5f1d6a5295aa5385238bd044998e1e9
Author: Mingarelli, Thomas <Thomas.Mingarelli@hp.com>
Date:   Tue Jun 26 10:27:00 2012 +0200

    watchdog: hpwdt: Unregister NMI events on exit.
    
    This patch is to unregister for NMI events upon exit. Also we are now
    making the default setting for allow_kdump enabled.
    
    Signed-off-by: Thomas Mingarelli <thomas.mingarelli@hp.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit e5de32e3ec9d4d5a355659760d5045b80c0a05d8
Author: Jan Beulich <JBeulich@suse.com>
Date:   Fri Jun 22 16:41:00 2012 +0100

    watchdog: iTCO_wdt: add platform driver module alias
    
    The recent conversion of iTCO_wdt resulted in the driver no longer
    getting loaded automatically, since it no longer has a
    MODULE_DEVICE_TABLE() included. As the lpc_ich driver now creates a
    platform device, auto-loading can easily be done by having a respective
    module alias in place.
    
    Signed-off-by: Jan Beulich <jbeulich@suse.com>
    Cc: Aaron Sierra <asierra@xes-inc.com>
    Acked-by: Guenter Roeck <linux@roeck-us.net>
    Cc: Samuel Ortiz <sameo@linux.intel.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 2b76381..1eff743 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -146,7 +146,7 @@ struct cmn_registers {
 }  __attribute__((packed));
 
 static unsigned int hpwdt_nmi_decoding;
-static unsigned int allow_kdump;
+static unsigned int allow_kdump = 1;
 static unsigned int is_icru;
 static DEFINE_SPINLOCK(rom_lock);
 static void *cru_rom_addr;
@@ -756,6 +756,8 @@ error:
 static void hpwdt_exit_nmi_decoding(void)
 {
 	unregister_nmi_handler(NMI_UNKNOWN, "hpwdt");
+	unregister_nmi_handler(NMI_SERR, "hpwdt");
+	unregister_nmi_handler(NMI_IO_CHECK, "hpwdt");
 	if (cru_rom_addr)
 		iounmap(cru_rom_addr);
 }
diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index bc47e90..9c2c27c 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -699,3 +699,4 @@ MODULE_DESCRIPTION("Intel TCO WatchDog Timer Driver");
 MODULE_VERSION(DRV_VERSION);
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+MODULE_ALIAS("platform:" DRV_NAME);
diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index 672d169..ef8edec 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -349,7 +349,7 @@ static long watchdog_ioctl(struct file *file, unsigned int cmd,
 			sizeof(struct watchdog_info)) ? -EFAULT : 0;
 	case WDIOC_GETSTATUS:
 		err = watchdog_get_status(wdd, &val);
-		if (err)
+		if (err == -ENODEV)
 			return err;
 		return put_user(val, p);
 	case WDIOC_GETBOOTSTATUS:
