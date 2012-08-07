Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411Ab2HGTzW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 15:55:22 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:49866 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756262Ab2HGTzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 15:55:20 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 27/41] TTY: synclink_cs, sanitize fail paths
Date: Tue,  7 Aug 2012 21:47:52 +0200
Message-Id: <1344368886-24033-28-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
References: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We will need to change the order of tty and pcmcia drivers
initializations (see the reason later in this series). And the fail
path handling is currently performed in a separate function that as
well takes care of proper deinitialization in module_exit. It is hard
to read and will need to be adjusted by our changes anyway. Instead,
get rid of this helper function and do the fail paths handling
directly in the init function. (And move the body of the function to
module_exit.)

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/char/pcmcia/synclink_cs.c |   41 +++++++++++++------------------------
 1 file changed, 14 insertions(+), 27 deletions(-)

diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index d0cbd29..0606586 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -2798,23 +2798,6 @@ static const struct tty_operations mgslpc_ops = {
 	.proc_fops = &mgslpc_proc_fops,
 };
 
-static void synclink_cs_cleanup(void)
-{
-	int rc;
-
-	while(mgslpc_device_list)
-		mgslpc_remove_device(mgslpc_device_list);
-
-	if (serial_driver) {
-		if ((rc = tty_unregister_driver(serial_driver)))
-			printk("%s(%d) failed to unregister tty driver err=%d\n",
-			       __FILE__,__LINE__,rc);
-		put_tty_driver(serial_driver);
-	}
-
-	pcmcia_unregister_driver(&mgslpc_driver);
-}
-
 static int __init synclink_cs_init(void)
 {
     int rc;
@@ -2830,7 +2813,7 @@ static int __init synclink_cs_init(void)
     serial_driver = alloc_tty_driver(MAX_DEVICE_COUNT);
     if (!serial_driver) {
 	    rc = -ENOMEM;
-	    goto error;
+	    goto err_pcmcia_drv;
     }
 
     /* Initialize the tty_driver structure */
@@ -2850,25 +2833,29 @@ static int __init synclink_cs_init(void)
     if ((rc = tty_register_driver(serial_driver)) < 0) {
 	    printk("%s(%d):Couldn't register serial driver\n",
 		   __FILE__,__LINE__);
-	    put_tty_driver(serial_driver);
-	    serial_driver = NULL;
-	    goto error;
+	    goto err_put_tty;
     }
 
     printk("%s %s, tty major#%d\n",
 	   driver_name, driver_version,
 	   serial_driver->major);
 
-    return 0;
-
-error:
-    synclink_cs_cleanup();
-    return rc;
+	return 0;
+err_put_tty:
+	put_tty_driver(serial_driver);
+err_pcmcia_drv:
+	pcmcia_unregister_driver(&mgslpc_driver);
+	return rc;
 }
 
 static void __exit synclink_cs_exit(void)
 {
-	synclink_cs_cleanup();
+	while (mgslpc_device_list)
+		mgslpc_remove_device(mgslpc_device_list);
+
+	tty_unregister_driver(serial_driver);
+	put_tty_driver(serial_driver);
+	pcmcia_unregister_driver(&mgslpc_driver);
 }
 
 module_init(synclink_cs_init);
-- 
1.7.10.4


