Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab0D0SYW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 14:24:22 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:62010 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752538Ab0D0SYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 14:24:21 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAPrG1ktbstaU/2dsb2JhbACcTXLCAw2CSoI3BA
Date: Tue, 27 Apr 2010 20:24:18 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Anton Vorontsov <avorontsov@mvista.com>,
       Denis Turischev <denis@compulab.co.il>,
       Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [WATCHDOG] fixes for v2.6.34-rc5
Message-ID: <20100427182418.GT15728@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

 drivers/watchdog/booke_wdt.c      |    2 +-
 drivers/watchdog/sb_wdog.c        |    4 ++--
 drivers/watchdog/sbc_fitpc2_wdt.c |   14 +++++++-------
 3 files changed, 10 insertions(+), 10 deletions(-)

with these Changes:

Author: Anton Vorontsov <avorontsov@mvista.com>
Date:   Mon Apr 26 15:59:53 2010 -0700

    watchdog: booke_wdt: fix build - unconstify watchdog_info
    
    commit 42747d712de56cf2087b702d2ad90af114c53138 ("[WATCHDOG] watchdog_info
    constify") introduced the following build failure:
    
       CC      booke_wdt.o
     booke_wdt.c: In function 'booke_wdt_init':
     booke_wdt.c:220: error: assignment of read-only variable 'ident'
    
    Fix this by removing 'const' qualifier from watchdog_info struct.
    
    Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Cc: Kumar Gala <galak@kernel.crashing.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Author: Denis Turischev <denis@compulab.co.il>
Date:   Thu Apr 22 19:54:20 2010 +0300

    watchdog: sbc_fitpc2_wdt: fixed "scheduling while atomic" bug.
    
    spinlock need to be replaced by mutex because of sleep functions
    inside wdt_send_data.
    
    Signed-off-by: Denis Turischev <denis@compulab.co.il>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Denis Turischev <denis@compulab.co.il>
Date:   Thu Apr 22 19:50:03 2010 +0300

    watchdog: sbc_fitpc2_wdt: fixed I/O operations order
    
    There are fitpc2 compatible boards that hang with existent i/o
    operations order. Solution is to switch between writing to data
    and command ports.
    
    Signed-off-by: Denis Turischev <denis@compulab.co.il>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Guenter Roeck <guenter.roeck@ericsson.com>
Date:   Mon Apr 19 08:37:11 2010 -0700

    Watchdog: sb_wdog.c: Fix sibyte watchdog initialization
    
    Watchdog configuration register and timer count register were interchanged,
    causing wrong values to be written into both registers.
    This caused watchdog triggered resets even if the watchdog was reset in time.
    
    Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
    Acked-by: Ralf Baechle <ralf@linux-mips.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/booke_wdt.c b/drivers/watchdog/booke_wdt.c
index 500d383..801ead1 100644
--- a/drivers/watchdog/booke_wdt.c
+++ b/drivers/watchdog/booke_wdt.c
@@ -121,7 +121,7 @@ static ssize_t booke_wdt_write(struct file *file, const char __user *buf,
 	return count;
 }
 
-static const struct watchdog_info ident = {
+static struct watchdog_info ident = {
 	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
 	.identity = "PowerPC Book-E Watchdog",
 };
diff --git a/drivers/watchdog/sb_wdog.c b/drivers/watchdog/sb_wdog.c
index c8eadd4..88c83aa 100644
--- a/drivers/watchdog/sb_wdog.c
+++ b/drivers/watchdog/sb_wdog.c
@@ -67,8 +67,8 @@ static DEFINE_SPINLOCK(sbwd_lock);
 void sbwdog_set(char __iomem *wdog, unsigned long t)
 {
 	spin_lock(&sbwd_lock);
-	__raw_writeb(0, wdog - 0x10);
-	__raw_writeq(t & 0x7fffffUL, wdog);
+	__raw_writeb(0, wdog);
+	__raw_writeq(t & 0x7fffffUL, wdog - 0x10);
 	spin_unlock(&sbwd_lock);
 }
 
diff --git a/drivers/watchdog/sbc_fitpc2_wdt.c b/drivers/watchdog/sbc_fitpc2_wdt.c
index 8d44c9b..c7d67e9 100644
--- a/drivers/watchdog/sbc_fitpc2_wdt.c
+++ b/drivers/watchdog/sbc_fitpc2_wdt.c
@@ -30,7 +30,7 @@
 static int nowayout = WATCHDOG_NOWAYOUT;
 static unsigned int margin = 60;	/* (secs) Default is 1 minute */
 static unsigned long wdt_status;
-static DEFINE_SPINLOCK(wdt_lock);
+static DEFINE_MUTEX(wdt_lock);
 
 #define WDT_IN_USE		0
 #define WDT_OK_TO_CLOSE		1
@@ -45,26 +45,26 @@ static DEFINE_SPINLOCK(wdt_lock);
 
 static void wdt_send_data(unsigned char command, unsigned char data)
 {
-	outb(command, COMMAND_PORT);
-	msleep(100);
 	outb(data, DATA_PORT);
 	msleep(200);
+	outb(command, COMMAND_PORT);
+	msleep(100);
 }
 
 static void wdt_enable(void)
 {
-	spin_lock(&wdt_lock);
+	mutex_lock(&wdt_lock);
 	wdt_send_data(IFACE_ON_COMMAND, 1);
 	wdt_send_data(REBOOT_COMMAND, margin);
-	spin_unlock(&wdt_lock);
+	mutex_unlock(&wdt_lock);
 }
 
 static void wdt_disable(void)
 {
-	spin_lock(&wdt_lock);
+	mutex_lock(&wdt_lock);
 	wdt_send_data(IFACE_ON_COMMAND, 0);
 	wdt_send_data(REBOOT_COMMAND, 0);
-	spin_unlock(&wdt_lock);
+	mutex_unlock(&wdt_lock);
 }
 
 static int fitpc2_wdt_open(struct inode *inode, struct file *file)
