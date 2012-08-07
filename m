Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226Ab2HGUCc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 16:02:32 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:36550 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756447Ab2HGT7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 15:59:45 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        J Freyensee <james_p_freyensee@linux.intel.com>
Subject: [PATCH 10/41] misc: pti, fix tty_port count
Date: Tue,  7 Aug 2012 21:47:35 +0200
Message-Id: <1344368886-24033-11-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
References: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We now have *one* tty_port for both TTYs. How this was supposed to
work? Change it to have a tty_port for each of TTYs.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: J Freyensee <james_p_freyensee@linux.intel.com>
---
 drivers/misc/pti.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/misc/pti.c b/drivers/misc/pti.c
index 90de855..fe76f9d 100644
--- a/drivers/misc/pti.c
+++ b/drivers/misc/pti.c
@@ -60,7 +60,7 @@ struct pti_tty {
 };
 
 struct pti_dev {
-	struct tty_port port;
+	struct tty_port port[PTITTY_MINOR_NUM];
 	unsigned long pti_addr;
 	unsigned long aperture_base;
 	void __iomem *pti_ioaddr;
@@ -427,7 +427,7 @@ static int pti_tty_driver_open(struct tty_struct *tty, struct file *filp)
 	 * also removes a locking requirement for the actual write
 	 * procedure.
 	 */
-	return tty_port_open(&drv_data->port, tty, filp);
+	return tty_port_open(&drv_data->port[tty->index], tty, filp);
 }
 
 /**
@@ -443,7 +443,7 @@ static int pti_tty_driver_open(struct tty_struct *tty, struct file *filp)
  */
 static void pti_tty_driver_close(struct tty_struct *tty, struct file *filp)
 {
-	tty_port_close(&drv_data->port, tty, filp);
+	tty_port_close(&drv_data->port[tty->index], tty, filp);
 }
 
 /**
@@ -799,6 +799,7 @@ static const struct tty_port_operations tty_port_ops = {
 static int __devinit pti_pci_probe(struct pci_dev *pdev,
 		const struct pci_device_id *ent)
 {
+	unsigned int a;
 	int retval = -EINVAL;
 	int pci_bar = 1;
 
@@ -850,11 +851,13 @@ static int __devinit pti_pci_probe(struct pci_dev *pdev,
 
 	pci_set_drvdata(pdev, drv_data);
 
-	tty_port_init(&drv_data->port);
-	drv_data->port.ops = &tty_port_ops;
+	for (a = 0; a < PTITTY_MINOR_NUM; a++) {
+		struct tty_port *port = &drv_data->port[a];
+		tty_port_init(port);
+		port->ops = &tty_port_ops;
 
-	tty_register_device(pti_tty_driver, 0, &pdev->dev);
-	tty_register_device(pti_tty_driver, 1, &pdev->dev);
+		tty_register_device(pti_tty_driver, a, &pdev->dev);
+	}
 
 	register_console(&pti_console);
 
-- 
1.7.10.4


