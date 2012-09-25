Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab2IYM4Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 08:56:16 -0400
Received: from mail.ispras.ru ([83.149.199.43]:59899 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753808Ab2IYM4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 08:56:15 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Krzysztof Halasa <khc@pm.waw.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] staging: sbe-2t3e3: fix error handling in t3e3_init_channel()
Date: Tue, 25 Sep 2012 16:56:02 +0400
Message-Id: <1348577762-25503-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

t3e3_init_channel() incorrectly handles errors in several places:
it returns zero and does not deallocate all required resources.
The patch fixes that places.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/staging/sbe-2t3e3/module.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/sbe-2t3e3/module.c b/drivers/staging/sbe-2t3e3/module.c
index cd778b3..8adb178 100644
--- a/drivers/staging/sbe-2t3e3/module.c
+++ b/drivers/staging/sbe-2t3e3/module.c
@@ -67,6 +67,7 @@ static int __devinit t3e3_init_channel(struct channel *channel, struct pci_dev *
 	dev = alloc_hdlcdev(channel);
 	if (!dev) {
 		printk(KERN_ERR "SBE 2T3E3" ": Out of memory\n");
+		err = -ENOMEM;
 		goto free_regions;
 	}
 
@@ -82,8 +83,9 @@ static int __devinit t3e3_init_channel(struct channel *channel, struct pci_dev *
 	else
 		channel->h.slot = 0;
 
-	if (setup_device(dev, channel))
-		goto free_regions;
+	err = setup_device(dev, channel);
+	if (err)
+		goto free_dev;
 
 	pci_read_config_dword(channel->pdev, 0x40, &val); /* mask sleep mode */
 	pci_write_config_dword(channel->pdev, 0x40, val & 0x3FFFFFFF);
@@ -92,14 +94,19 @@ static int __devinit t3e3_init_channel(struct channel *channel, struct pci_dev *
 	pci_read_config_dword(channel->pdev, PCI_COMMAND, &channel->h.command);
 	t3e3_init(channel);
 
-	if (request_irq(dev->irq, &t3e3_intr, IRQF_SHARED, dev->name, dev)) {
+	err = request_irq(dev->irq, &t3e3_intr, IRQF_SHARED, dev->name, dev);
+	if (err) {
 		printk(KERN_WARNING "%s: could not get irq: %d\n", dev->name, dev->irq);
-		goto free_regions;
+		goto unregister_dev;
 	}
 
 	pci_set_drvdata(pdev, channel);
 	return 0;
 
+unregister_dev:
+	unregister_hdlc_device(dev);
+free_dev:
+	free_netdev(dev);
 free_regions:
 	pci_release_regions(pdev);
 disable:
-- 
1.7.9.5

