Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128Ab2DBLzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:55:47 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:48044 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab2DBLzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:09 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Jan Dumon <j.dumon@option.com>
Subject: [PATCH 20/69] TTY: hso, free tty_driver
Date: Mon,  2 Apr 2012 13:54:04 +0200
Message-Id: <1333367693-3244-21-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not leak tty_driver structure on each module removal. Also do
proper frees in fail paths of module_init.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Jan Dumon <j.dumon@option.com>
---
 drivers/net/usb/hso.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index abe47ad..cdc589e 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -3332,7 +3332,7 @@ static int __init hso_init(void)
 	if (result) {
 		printk(KERN_ERR "%s - tty_register_driver failed(%d)\n",
 			__func__, result);
-		return result;
+		goto err_free_tty;
 	}
 
 	/* register this module as an usb driver */
@@ -3340,13 +3340,16 @@ static int __init hso_init(void)
 	if (result) {
 		printk(KERN_ERR "Could not register hso driver? error: %d\n",
 			result);
-		/* cleanup serial interface */
-		tty_unregister_driver(tty_drv);
-		return result;
+		goto err_unreg_tty;
 	}
 
 	/* done */
 	return 0;
+err_unreg_tty:
+	tty_unregister_driver(tty_drv);
+err_free_tty:
+	put_tty_driver(tty_drv);
+	return result;
 }
 
 static void __exit hso_exit(void)
@@ -3354,6 +3357,7 @@ static void __exit hso_exit(void)
 	printk(KERN_INFO "hso: unloaded\n");
 
 	tty_unregister_driver(tty_drv);
+	put_tty_driver(tty_drv);
 	/* deregister the usb driver */
 	usb_deregister(&hso_driver);
 }
-- 
1.7.9.2


