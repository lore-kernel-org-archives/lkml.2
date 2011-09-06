Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964Ab1IFVF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 17:05:27 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:50369 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499Ab1IFVFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 17:05:20 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-127.messagelabs.com!1315342899!30695338!299
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] vt/suspend: cleanup #if defined uglyness and fix compile error
Date: Tue, 6 Sep 2011 14:04:04 -0700
User-Agent: KMail/1.9.9
CC: <linux-pm@lists.linux-foundation.org>, <arnd@arndb.de>,
        <akpm@linux-foundation.org>, <gregkh@suse.de>, <pavel@ucw.cz>,
        <rjw@sisk.pl>, <len.brown@intel.com>, <art@ified.ca>, <jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109061404.10301.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce the config option CONFIG_VT_CONSOLE_SLEEP in order to cleanup
the #if defined ugliness for the vt suspend support functions. Note that
CONFIG_VT_CONSOLE is already dependant on CONFIG_VT.

The function pm_set_vt_switch is actually dependant on CONFIG_VT and not
CONFIG_PM_SLEEP. This fixes a compile error when CONFIG_PM_SLEEP is
not set:

drivers/tty/vt/vt_ioctl.c:1794: error: redefinition of 'pm_set_vt_switch'
include/linux/suspend.h:17: error: previous definition of 'pm_set_vt_switch' was here

Also, remove the incorrect path from the comment in console.c.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Arnd Bergmann <arnd@arnd.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <len.brown@intel.com>
Cc: Arthur Taylor <art@ified.ca>
Cc: Jiri Slaby <jslaby@suse.cz>

---

This is a revised version of the patch "vt_ioctl.c: fix compile error with
pm_set_vt_switch()" that I sent last week.  Alan Cox asked if the #if uglies
could be moved into the header to keep the code clean. Arnd Bergmann then
submitted a revised patch that did this.  This now includes Arnd's fix and along
with the addition of CONFIG_VT_CONSOLE_SLEEP.

diff --git a/drivers/tty/Kconfig b/drivers/tty/Kconfig
index f1ea59b..565fe0f 100644
--- a/drivers/tty/Kconfig
+++ b/drivers/tty/Kconfig
@@ -60,6 +60,10 @@ config VT_CONSOLE
 
 	  If unsure, say Y.
 
+config VT_CONSOLE_SLEEP
+	def_bool y
+	depends on VT_CONSOLE && PM_SLEEP
+
 config HW_CONSOLE
 	bool
 	depends on VT && !S390 && !UML
diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 46f3548..c3da030 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -8,15 +8,18 @@
 #include <linux/mm.h>
 #include <asm/errno.h>
 
-#if defined(CONFIG_PM_SLEEP) && defined(CONFIG_VT) && defined(CONFIG_VT_CONSOLE)
+#if defined(CONFIG_VT)
 extern void pm_set_vt_switch(int);
-extern int pm_prepare_console(void);
-extern void pm_restore_console(void);
 #else
 static inline void pm_set_vt_switch(int do_switch)
 {
 }
+#endif
 
+#if defined(CONFIG_VT_CONSOLE_SLEEP)
+extern int pm_prepare_console(void);
+extern void pm_restore_console(void);
+#else
 static inline int pm_prepare_console(void)
 {
 	return 0;
diff --git a/kernel/power/Makefile b/kernel/power/Makefile
index ad6bdd8..07e0e28 100644
--- a/kernel/power/Makefile
+++ b/kernel/power/Makefile
@@ -2,7 +2,7 @@
 ccflags-$(CONFIG_PM_DEBUG)	:= -DDEBUG
 
 obj-$(CONFIG_PM)		+= main.o qos.o
-obj-$(CONFIG_PM_SLEEP)		+= console.o
+obj-$(CONFIG_VT_CONSOLE_SLEEP)	+= console.o
 obj-$(CONFIG_FREEZER)		+= process.o
 obj-$(CONFIG_SUSPEND)		+= suspend.o
 obj-$(CONFIG_PM_TEST_SUSPEND)	+= suspend_test.o
diff --git a/kernel/power/console.c b/kernel/power/console.c
index 218e5af..b1dc456 100644
--- a/kernel/power/console.c
+++ b/kernel/power/console.c
@@ -1,5 +1,5 @@
 /*
- * drivers/power/process.c - Functions for saving/restoring console.
+ * Functions for saving/restoring console.
  *
  * Originally from swsusp.
  */
@@ -10,7 +10,6 @@
 #include <linux/module.h>
 #include "power.h"
 
-#if defined(CONFIG_VT) && defined(CONFIG_VT_CONSOLE)
 #define SUSPEND_CONSOLE	(MAX_NR_CONSOLES-1)
 
 static int orig_fgconsole, orig_kmsg;
@@ -32,4 +31,3 @@ void pm_restore_console(void)
 		vt_kmsg_redirect(orig_kmsg);
 	}
 }
-#endif
