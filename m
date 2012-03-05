Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965018Ab2CEN7y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 08:59:54 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34802 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964820Ab2CENxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:23 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>
Subject: [PATCH 65/68] TTY: pdc_cons, fix open vs pdc_console_tty_driver race
Date: Mon,  5 Mar 2012 14:52:52 +0100
Message-Id: <1330955575-26641-66-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assign the pointer to pdc_console_tty_driver (a tty_driver) earlier.
Otherwise the timer may dereference NULL.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
---
 arch/parisc/kernel/pdc_cons.c |   29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/arch/parisc/kernel/pdc_cons.c b/arch/parisc/kernel/pdc_cons.c
index 8ad0521..d14e20f 100644
--- a/arch/parisc/kernel/pdc_cons.c
+++ b/arch/parisc/kernel/pdc_cons.c
@@ -160,9 +160,7 @@ static void pdc_console_poll(unsigned long unused)
 
 static int __init pdc_console_tty_driver_init(void)
 {
-
 	int err;
-	struct tty_driver *drv;
 
 	/* Check if the console driver is still registered.
 	 * It is unregistered if the pdc console was not selected as the
@@ -184,28 +182,27 @@ static int __init pdc_console_tty_driver_init(void)
 	printk(KERN_INFO "The PDC console driver is still registered, removing CON_BOOT flag\n");
 	pdc_cons.flags &= ~CON_BOOT;
 
-	drv = alloc_tty_driver(1);
+	pdc_console_tty_driver = alloc_tty_driver(1);
 
-	if (!drv)
+	if (!pdc_console_tty_driver)
 		return -ENOMEM;
 
-	drv->driver_name = "pdc_cons";
-	drv->name = "ttyB";
-	drv->major = MUX_MAJOR;
-	drv->minor_start = 0;
-	drv->type = TTY_DRIVER_TYPE_SYSTEM;
-	drv->init_termios = tty_std_termios;
-	drv->flags = TTY_DRIVER_REAL_RAW | TTY_DRIVER_RESET_TERMIOS;
-	tty_set_operations(drv, &pdc_console_tty_ops);
-
-	err = tty_register_driver(drv);
+	pdc_console_tty_driver->driver_name = "pdc_cons";
+	pdc_console_tty_driver->name = "ttyB";
+	pdc_console_tty_driver->major = MUX_MAJOR;
+	pdc_console_tty_driver->minor_start = 0;
+	pdc_console_tty_driver->type = TTY_DRIVER_TYPE_SYSTEM;
+	pdc_console_tty_driver->init_termios = tty_std_termios;
+	pdc_console_tty_driver->flags = TTY_DRIVER_REAL_RAW |
+		TTY_DRIVER_RESET_TERMIOS;
+	tty_set_operations(pdc_console_tty_driver, &pdc_console_tty_ops);
+
+	err = tty_register_driver(pdc_console_tty_driver);
 	if (err) {
 		printk(KERN_ERR "Unable to register the PDC console TTY driver\n");
 		return err;
 	}
 
-	pdc_console_tty_driver = drv;
-
 	return 0;
 }
 
-- 
1.7.9.2


