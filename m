Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400Ab2HGT5F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 15:57:05 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:49897 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab2HGT5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 15:57:01 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        J Freyensee <james_p_freyensee@linux.intel.com>
Subject: [PATCH 08/41] misc: pti, do the opposite of ->probe in ->remove
Date: Tue,  7 Aug 2012 21:47:33 +0200
Message-Id: <1344368886-24033-9-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
References: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, probe initializes some parts. Then, some of them are
unwound in ->remove, some in module_exit. Let us do the opposite of
whole ->probe in ->remove.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: J Freyensee <james_p_freyensee@linux.intel.com>
---
 drivers/misc/pti.c |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/misc/pti.c b/drivers/misc/pti.c
index 4a24421..be6e679 100644
--- a/drivers/misc/pti.c
+++ b/drivers/misc/pti.c
@@ -874,11 +874,18 @@ static void __devexit pti_pci_remove(struct pci_dev *pdev)
 {
 	struct pti_dev *drv_data = pci_get_drvdata(pdev);
 
+	unregister_console(&pti_console);
+
+	tty_unregister_device(pti_tty_driver, 0);
+	tty_unregister_device(pti_tty_driver, 1);
+
 	iounmap(drv_data->pti_ioaddr);
 	pci_set_drvdata(pdev, NULL);
 	kfree(drv_data);
 	pci_release_region(pdev, 1);
 	pci_disable_device(pdev);
+
+	misc_deregister(&pti_char_driver);
 }
 
 static struct pci_driver pti_pci_driver = {
@@ -959,9 +966,6 @@ static void __exit pti_exit(void)
 {
 	int retval;
 
-	tty_unregister_device(pti_tty_driver, 0);
-	tty_unregister_device(pti_tty_driver, 1);
-
 	retval = tty_unregister_driver(pti_tty_driver);
 	if (retval) {
 		pr_err("%s(%d): TTY unregistration failed of pti driver\n",
@@ -971,17 +975,6 @@ static void __exit pti_exit(void)
 	}
 
 	pci_unregister_driver(&pti_pci_driver);
-
-	retval = misc_deregister(&pti_char_driver);
-	if (retval) {
-		pr_err("%s(%d): CHAR unregistration failed of pti driver\n",
-			__func__, __LINE__);
-		pr_err("%s(%d): Error value returned: %d\n",
-			__func__, __LINE__, retval);
-	}
-
-	unregister_console(&pti_console);
-	return;
 }
 
 module_init(pti_init);
-- 
1.7.10.4


