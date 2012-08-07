Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555Ab2HGT7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 15:59:51 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:36544 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab2HGT7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 15:59:44 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        J Freyensee <james_p_freyensee@linux.intel.com>
Subject: [PATCH 11/41] misc: pti, use tty_port_register_device
Date: Tue,  7 Aug 2012 21:47:36 +0200
Message-Id: <1344368886-24033-12-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
References: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So now we have enough of tty_ports, so we can signal the TTY layer to
use them by tty_port_register_device.

The upside is that we look like we can introduce tty_port_easy_open
and put it directly as tty_operations->open to drivers doing nothing
in open and using tty_port_register_device. Because the easy open can
obtain a tty_port rather easily from a tty now. Heh, what a nice
by-product.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: J Freyensee <james_p_freyensee@linux.intel.com>
---
 drivers/misc/pti.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/pti.c b/drivers/misc/pti.c
index fe76f9d..4999b34 100644
--- a/drivers/misc/pti.c
+++ b/drivers/misc/pti.c
@@ -427,7 +427,7 @@ static int pti_tty_driver_open(struct tty_struct *tty, struct file *filp)
 	 * also removes a locking requirement for the actual write
 	 * procedure.
 	 */
-	return tty_port_open(&drv_data->port[tty->index], tty, filp);
+	return tty_port_open(tty->port, tty, filp);
 }
 
 /**
@@ -443,7 +443,7 @@ static int pti_tty_driver_open(struct tty_struct *tty, struct file *filp)
  */
 static void pti_tty_driver_close(struct tty_struct *tty, struct file *filp)
 {
-	tty_port_close(&drv_data->port[tty->index], tty, filp);
+	tty_port_close(tty->port, tty, filp);
 }
 
 /**
@@ -856,7 +856,7 @@ static int __devinit pti_pci_probe(struct pci_dev *pdev,
 		tty_port_init(port);
 		port->ops = &tty_port_ops;
 
-		tty_register_device(pti_tty_driver, a, &pdev->dev);
+		tty_port_register_device(port, pti_tty_driver, a, &pdev->dev);
 	}
 
 	register_console(&pti_console);
-- 
1.7.10.4


