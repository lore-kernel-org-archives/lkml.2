Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485Ab2HGT6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 15:58:24 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:49935 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756466Ab2HGT6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 15:58:21 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 28/41] TTY: synclink_cs, use dynamic tty devices
Date: Tue,  7 Aug 2012 21:47:53 +0200
Message-Id: <1344368886-24033-29-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
References: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows us to provide the tty layer with information about
tty_port for each link. And it also allows us to get rid of the
remove_device loop in synclink_cs_exit because we had to reorder
pcmcia and tty driver registration in init. This was because we need
to have serial_driver initialized when calling
tty_port_register_device from pcmcia ->probe.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/char/pcmcia/synclink_cs.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index 0606586..ce277f7 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -2731,6 +2731,8 @@ static void mgslpc_add_device(MGSLPC_INFO *info)
 #if SYNCLINK_GENERIC_HDLC
 	hdlcdev_init(info);
 #endif
+	tty_port_register_device(&info->port, serial_driver, info->line,
+			&info->p_dev.dev);
 }
 
 static void mgslpc_remove_device(MGSLPC_INFO *remove_info)
@@ -2744,6 +2746,7 @@ static void mgslpc_remove_device(MGSLPC_INFO *remove_info)
 				last->next_device = info->next_device;
 			else
 				mgslpc_device_list = info->next_device;
+			tty_unregister_device(serial_driver, info->line);
 #if SYNCLINK_GENERIC_HDLC
 			hdlcdev_exit(info);
 #endif
@@ -2807,13 +2810,12 @@ static int __init synclink_cs_init(void)
 	    BREAKPOINT();
     }
 
-    if ((rc = pcmcia_register_driver(&mgslpc_driver)) < 0)
-	    return rc;
-
-    serial_driver = alloc_tty_driver(MAX_DEVICE_COUNT);
+    serial_driver = tty_alloc_driver(MAX_DEVICE_COUNT,
+		    TTY_DRIVER_REAL_RAW |
+		    TTY_DRIVER_DYNAMIC_DEV);
     if (!serial_driver) {
 	    rc = -ENOMEM;
-	    goto err_pcmcia_drv;
+	    goto err;
     }
 
     /* Initialize the tty_driver structure */
@@ -2827,7 +2829,6 @@ static int __init synclink_cs_init(void)
     serial_driver->init_termios = tty_std_termios;
     serial_driver->init_termios.c_cflag =
 	    B9600 | CS8 | CREAD | HUPCL | CLOCAL;
-    serial_driver->flags = TTY_DRIVER_REAL_RAW;
     tty_set_operations(serial_driver, &mgslpc_ops);
 
     if ((rc = tty_register_driver(serial_driver)) < 0) {
@@ -2836,26 +2837,28 @@ static int __init synclink_cs_init(void)
 	    goto err_put_tty;
     }
 
+	rc = pcmcia_register_driver(&mgslpc_driver);
+	if (rc < 0)
+		goto err_unreg_tty;
+
     printk("%s %s, tty major#%d\n",
 	   driver_name, driver_version,
 	   serial_driver->major);
 
 	return 0;
+err_unreg_tty:
+	tty_unregister_driver(serial_driver);
 err_put_tty:
 	put_tty_driver(serial_driver);
-err_pcmcia_drv:
-	pcmcia_unregister_driver(&mgslpc_driver);
+err:
 	return rc;
 }
 
 static void __exit synclink_cs_exit(void)
 {
-	while (mgslpc_device_list)
-		mgslpc_remove_device(mgslpc_device_list);
-
+	pcmcia_unregister_driver(&mgslpc_driver);
 	tty_unregister_driver(serial_driver);
 	put_tty_driver(serial_driver);
-	pcmcia_unregister_driver(&mgslpc_driver);
 }
 
 module_init(synclink_cs_init);
-- 
1.7.10.4


