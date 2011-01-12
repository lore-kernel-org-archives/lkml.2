Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab1ALIlH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 03:41:07 -0500
Received: from verro.fugedabout.it ([78.46.95.7]:32917 "EHLO
	verro.fugedabout.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab1ALIlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 03:41:04 -0500
From: "Fabio M. Di Nitto" <fabbione@fabbione.net>
To: Randy Dunlap <rdunlap@xenotime.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Daid Miller <davem@davemloft.net>,
        "Fabio M. Di Nitto" <fdinitto@redhat.com>,
        "Fabio M. Di Nitto" <fabbione@fabbione.net>
Subject: [PATCH] console: allow to retain boot console via boot option keep_bootcon
Date: Wed, 12 Jan 2011 09:40:24 +0100
Message-Id: <1294821624-24544-1-git-send-email-fabbione@fabbione.net>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio M. Di Nitto <fdinitto@redhat.com>

On some architectures, the boot process involves de-registering the boot
console (early boot), initialize drivers and then re-register the console.

This mechanism introduces a window in which no printk can happen on the console
and messages are buffered and then printed once the new console is available.

If a kernel crashes during this window, all it's left on the boot console
is "console [foo] enabled, bootconsole disabled" making debug of the crash
rather 'interesting'.

By adding "keep_bootcon" option, do not unregister the boot console, that
will allow to printk everything that is happening up to the crash.

The option is clearly meant only for debugging purposes as it introduces lots
of duplicated info printed on console, but will make bug report from users
easier as it doesn't require a kernel build just to figure out where we crash.

Signed-off-by: Fabio M. Di Nitto <fabbione@fabbione.net>
Acked-by: David S. Miller <davem@davemloft.net>
---
 Documentation/kernel-parameters.txt |    6 ++++++
 kernel/printk.c                     |   16 +++++++++++++++-
 2 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index ed3708f..824642c 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -869,6 +869,12 @@ and is between 256 and 4096 characters. It is defined in the file
 			       If specified, z/VM IUCV HVC accepts connections
 			       from listed z/VM user IDs only.
 
+	keep_bootcon	[KNL]
+			Do not unregister boot console at start. This is only
+			useful for debugging when something happens in the window
+			between unregistering the boot console and initializing
+			the real console.
+
 	i2c_bus=	[HW] Override the default board specific I2C bus speed
 			     or register an additional I2C bus that is not
 			     registered from board initialization code.
diff --git a/kernel/printk.c b/kernel/printk.c
index f64b899..c952eb2 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1221,6 +1221,18 @@ void console_start(struct console *console)
 }
 EXPORT_SYMBOL(console_start);
 
+static int __read_mostly keep_bootcon;
+
+static int __init keep_bootcon_setup(char *str)
+{
+	keep_bootcon = 1;
+	printk(KERN_INFO "debug: skip boot console de-registration.\n");
+
+	return 0;
+}
+
+early_param("keep_bootcon", keep_bootcon_setup);
+
 /*
  * The console driver calls this routine during kernel initialization
  * to register the console printing procedure with printk() and to
@@ -1368,7 +1380,9 @@ void register_console(struct console *newcon)
 	 * users know there might be something in the kernel's log buffer that
 	 * went to the bootconsole (that they do not see on the real console)
 	 */
-	if (bcon && ((newcon->flags & (CON_CONSDEV | CON_BOOT)) == CON_CONSDEV)) {
+	if (bcon &&
+	    ((newcon->flags & (CON_CONSDEV | CON_BOOT)) == CON_CONSDEV) &&
+	    !keep_bootcon) {
 		/* we need to iterate through twice, to make sure we print
 		 * everything out, before we unregister the console(s)
 		 */
-- 
1.7.3.4

