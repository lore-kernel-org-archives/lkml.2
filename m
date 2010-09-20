Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757765Ab0ITXnZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 19:43:25 -0400
Received: from kroah.org ([198.145.64.141]:48460 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755257Ab0ITXnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 19:43:23 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Feng Tang <feng.tang@intel.com>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/2] serial: mfd: fix bug in serial_hsu_remove()
Date: Mon, 20 Sep 2010 16:43:19 -0700
Message-Id: <1285026199-2380-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100920234209.GB7672@kroah.com>
References: <20100920234209.GB7672@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

Medfield HSU driver deal with 4 pci devices(3 uart ports + 1 dma controller),
so in pci remove func, we need handle them differently

Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/mfd.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/serial/mfd.c b/drivers/serial/mfd.c
index bc9af50..324c385 100644
--- a/drivers/serial/mfd.c
+++ b/drivers/serial/mfd.c
@@ -1423,7 +1423,6 @@ static void hsu_global_init(void)
 	}
 
 	phsu = hsu;
-
 	hsu_debugfs_init(hsu);
 	return;
 
@@ -1435,18 +1434,20 @@ err_free_region:
 
 static void serial_hsu_remove(struct pci_dev *pdev)
 {
-	struct hsu_port *hsu;
-	int i;
+	void *priv = pci_get_drvdata(pdev);
+	struct uart_hsu_port *up;
 
-	hsu = pci_get_drvdata(pdev);
-	if (!hsu)
+	if (!priv)
 		return;
 
-	for (i = 0; i < 3; i++)
-		uart_remove_one_port(&serial_hsu_reg, &hsu->port[i].port);
+	/* For port 0/1/2, priv is the address of uart_hsu_port */
+	if (pdev->device != 0x081E) {
+		up = priv;
+		uart_remove_one_port(&serial_hsu_reg, &up->port);
+	}
 
 	pci_set_drvdata(pdev, NULL);
-	free_irq(hsu->irq, hsu);
+	free_irq(pdev->irq, priv);
 	pci_disable_device(pdev);
 }
 
-- 
1.7.2

