Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663Ab2GSMaQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 08:30:16 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:43421 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab2GSMaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 08:30:13 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Devendra Naga <devendra.aaru@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH] staging/sbe-2t3e3: error path cleanup in t3e3_init_channel
Date: Thu, 19 Jul 2012 18:00:01 +0530
Message-Id: <1342701001-5424-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    a) if alloc_hdlcdev fails, we are going into the free_regions,
and returning out the err (which is 0 by the prev call),
       return -ENOMEM if this function fail.

    b) setup_device also can fail, as it calls around the register_hdlc_dev which
is again a macro of the register_netdev.

       take the error from the setup_device and return it out in error condition

    c) request_irq when fails, we are freeing requested mem regions and disabling
the pci device(?) and returning err which is agian 0 here.

      take the error from request_irq and err path will take care of returning it.

as if we return 0 , at the init function, t3e3_init_card, we have a success case
and if there are two channels we call this function again, having the result of
it completely unknown.

This result in having the probe return 0, unloading the driver may (not) cause
ambigous result.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/sbe-2t3e3/module.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/sbe-2t3e3/module.c b/drivers/staging/sbe-2t3e3/module.c
index cd778b3..1a1a9be 100644
--- a/drivers/staging/sbe-2t3e3/module.c
+++ b/drivers/staging/sbe-2t3e3/module.c
@@ -66,6 +66,7 @@ static int __devinit t3e3_init_channel(struct channel *channel, struct pci_dev *
 
 	dev = alloc_hdlcdev(channel);
 	if (!dev) {
+		err = -ENOMEM;
 		printk(KERN_ERR "SBE 2T3E3" ": Out of memory\n");
 		goto free_regions;
 	}
@@ -82,7 +83,8 @@ static int __devinit t3e3_init_channel(struct channel *channel, struct pci_dev *
 	else
 		channel->h.slot = 0;
 
-	if (setup_device(dev, channel))
+	err = setup_device(dev, channel);
+	if (err)
 		goto free_regions;
 
 	pci_read_config_dword(channel->pdev, 0x40, &val); /* mask sleep mode */
@@ -92,7 +94,8 @@ static int __devinit t3e3_init_channel(struct channel *channel, struct pci_dev *
 	pci_read_config_dword(channel->pdev, PCI_COMMAND, &channel->h.command);
 	t3e3_init(channel);
 
-	if (request_irq(dev->irq, &t3e3_intr, IRQF_SHARED, dev->name, dev)) {
+	err = request_irq(dev->irq, &t3e3_intr, IRQF_SHARED, dev->name, dev);
+	if (err) {
 		printk(KERN_WARNING "%s: could not get irq: %d\n", dev->name, dev->irq);
 		goto free_regions;
 	}
-- 
1.7.0.4

