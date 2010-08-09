Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791Ab0HIUTc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 16:19:32 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:56398 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754599Ab0HIUTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 16:19:31 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        kernel-janitors@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kulikov Vasiliy <segooon@gmail.com>
Subject: [PATCH 1/1] Char: mxser, call pci_disable_device from probe/remove
Date: Mon,  9 Aug 2010 22:19:25 +0200
Message-Id: <1281385165-8620-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <4C6062BA.4070009@gmail.com>
References: <4C6062BA.4070009@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vasiliy found that pci_disable_device is not called on fail paths in
mxser_probe. Actually, it is called from nowhere in the driver.

There are three changes needed:
1) don't use pseudo-generic mxser_release_res. Let's use it only from
   ISA paths from now on. All the pci stuff is moved to probe and
   remove PCI-related functions.
2) reorder fail-paths in the probe function so that it makes sense and
   we can call them from the sequential code naturally (the further we
   are the earlier label we go to).
3) add pci_disable_device both to mxser_probe and mxser_remove.

There is a nit of adding CONFIG_PCI ifdef to mxser_remove. it is
because this driver supports ISA-only compilations and it would choke
up on the newly added calls now.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/char/mxser.c |   47 ++++++++++++++++++++++-------------------------
 1 files changed, 22 insertions(+), 25 deletions(-)

diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
index 3fc89da..8723f72 100644
--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -2339,20 +2339,11 @@ struct tty_port_operations mxser_port_ops = {
  * The MOXA Smartio/Industio serial driver boot-time initialization code!
  */
 
-static void mxser_release_res(struct mxser_board *brd, struct pci_dev *pdev,
-		unsigned int irq)
+static void mxser_release_ISA_res(struct mxser_board *brd);
 {
-	if (irq)
-		free_irq(brd->irq, brd);
-	if (pdev != NULL) {	/* PCI */
-#ifdef CONFIG_PCI
-		pci_release_region(pdev, 2);
-		pci_release_region(pdev, 3);
-#endif
-	} else {
-		release_region(brd->ports[0].ioaddr, 8 * brd->info->nports);
-		release_region(brd->vector, 1);
-	}
+	free_irq(brd->irq, brd);
+	release_region(brd->ports[0].ioaddr, 8 * brd->info->nports);
+	release_region(brd->vector, 1);
 }
 
 static int __devinit mxser_initbrd(struct mxser_board *brd,
@@ -2397,13 +2388,11 @@ static int __devinit mxser_initbrd(struct mxser_board *brd,
 
 	retval = request_irq(brd->irq, mxser_interrupt, IRQF_SHARED, "mxser",
 			brd);
-	if (retval) {
+	if (retval)
 		printk(KERN_ERR "Board %s: Request irq failed, IRQ (%d) may "
 			"conflict with another device.\n",
 			brd->info->name, brd->irq);
-		/* We hold resources, we need to release them. */
-		mxser_release_res(brd, pdev, 0);
-	}
+
 	return retval;
 }
 
@@ -2555,7 +2544,7 @@ static int __devinit mxser_probe(struct pci_dev *pdev,
 	ioaddress = pci_resource_start(pdev, 2);
 	retval = pci_request_region(pdev, 2, "mxser(IO)");
 	if (retval)
-		goto err;
+		goto err_dis;
 
 	brd->info = &mxser_cards[ent->driver_data];
 	for (i = 0; i < brd->info->nports; i++)
@@ -2565,7 +2554,7 @@ static int __devinit mxser_probe(struct pci_dev *pdev,
 	ioaddress = pci_resource_start(pdev, 3);
 	retval = pci_request_region(pdev, 3, "mxser(vector)");
 	if (retval)
-		goto err_relio;
+		goto err_zero;
 	brd->vector = ioaddress;
 
 	/* irq */
@@ -2608,7 +2597,7 @@ static int __devinit mxser_probe(struct pci_dev *pdev,
 	/* mxser_initbrd will hook ISR. */
 	retval = mxser_initbrd(brd, pdev);
 	if (retval)
-		goto err_null;
+		goto err_rel3;
 
 	for (i = 0; i < brd->info->nports; i++)
 		tty_register_device(mxvar_sdriver, brd->idx + i, &pdev->dev);
@@ -2616,10 +2605,13 @@ static int __devinit mxser_probe(struct pci_dev *pdev,
 	pci_set_drvdata(pdev, brd);
 
 	return 0;
-err_relio:
-	pci_release_region(pdev, 2);
-err_null:
+err_rel3:
+	pci_release_region(pdev, 3);
+err_zero:
 	brd->info = NULL;
+	pci_release_region(pdev, 2);
+err_dis:
+	pci_disable_device(pdev);
 err:
 	return retval;
 #else
@@ -2629,14 +2621,19 @@ err:
 
 static void __devexit mxser_remove(struct pci_dev *pdev)
 {
+#ifdef CONFIG_PCI
 	struct mxser_board *brd = pci_get_drvdata(pdev);
 	unsigned int i;
 
 	for (i = 0; i < brd->info->nports; i++)
 		tty_unregister_device(mxvar_sdriver, brd->idx + i);
 
-	mxser_release_res(brd, pdev, 1);
+	free_irq(pdev->irq);
+	pci_release_region(pdev, 2);
+	pci_release_region(pdev, 3);
+	pci_disable_device(pdev);
 	brd->info = NULL;
+#endif
 }
 
 static struct pci_driver mxser_driver = {
@@ -2741,7 +2738,7 @@ static void __exit mxser_module_exit(void)
 
 	for (i = 0; i < MXSER_BOARDS; i++)
 		if (mxser_boards[i].info != NULL)
-			mxser_release_res(&mxser_boards[i], NULL, 1);
+			mxser_release_ISA_res(&mxser_boards[i]);
 }
 
 module_init(mxser_module_init);
-- 
1.7.2.1


