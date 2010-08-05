Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934632Ab0HEW1W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:27:22 -0400
Received: from kroah.org ([198.145.64.141]:37852 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934589Ab0HEWZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:25:07 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Feng Tang <feng.tang@intel.com>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 64/67] hsu: call PCI pm hooks in suspend/resume function
Date: Thu,  5 Aug 2010 15:23:31 -0700
Message-Id: <1281047014-23429-64-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213528.GA13794@kroah.com>
References: <20100805213528.GA13794@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

Also add check for dma controller or the uart ports.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/mfd.c |   31 ++++++++++++++++++++++---------
 1 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/serial/mfd.c b/drivers/serial/mfd.c
index f5e7569..bc9af50 100644
--- a/drivers/serial/mfd.c
+++ b/drivers/serial/mfd.c
@@ -1217,25 +1217,38 @@ static struct uart_driver serial_hsu_reg = {
 #ifdef CONFIG_PM
 static int serial_hsu_suspend(struct pci_dev *pdev, pm_message_t state)
 {
+	void *priv = pci_get_drvdata(pdev);
 	struct uart_hsu_port *up;
 
-	up = pci_get_drvdata(pdev);
-	if (!up)
-		return 0;
-
-	uart_suspend_port(&serial_hsu_reg, &up->port);
+	/* Make sure this is not the internal dma controller */
+	if (priv && (pdev->device != 0x081E)) {
+		up = priv;
+		uart_suspend_port(&serial_hsu_reg, &up->port);
+	}
 
+	pci_save_state(pdev);
+	pci_set_power_state(pdev, pci_choose_state(pdev, state));
         return 0;
 }
 
 static int serial_hsu_resume(struct pci_dev *pdev)
 {
+	void *priv = pci_get_drvdata(pdev);
 	struct uart_hsu_port *up;
+	int ret;
 
-	up = pci_get_drvdata(pdev);
-	if (!up)
-		return 0;
-	uart_resume_port(&serial_hsu_reg, &up->port);
+	pci_set_power_state(pdev, PCI_D0);
+	pci_restore_state(pdev);
+
+	ret = pci_enable_device(pdev);
+	if (ret)
+		dev_warn(&pdev->dev,
+			"HSU: can't re-enable device, try to continue\n");
+
+	if (priv && (pdev->device != 0x081E)) {
+		up = priv;
+		uart_resume_port(&serial_hsu_reg, &up->port);
+	}
 	return 0;
 }
 #else
-- 
1.7.2

