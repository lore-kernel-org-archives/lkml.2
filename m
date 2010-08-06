Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935833Ab0HFTw5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:52:57 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40042 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935082Ab0HFTwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:52:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=a67CRsX296s5fC7uaoMqxh3FCKxaQCVYPvuFo1peS2MYDyy76GZSC+oJYhBFmolcgW
         +XJurKNj4c9KRvFQf1TWz0dgEExPGxXEohiBEQgLhq7/4Ov9ZX4vO0VXhVaVAy5g4pmt
         GI1Fv0FJhJ3+m/nrape7ydmTG1La+AEmChf3M=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
        Komuro <komurojun-mbn@nifty.com>, Wolfram Sang <w.sang@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 11/18] pcmcia: pd6729: call disable_pci_device() if pci_probe() failed
Date: Fri,  6 Aug 2010 23:52:44 +0400
Message-Id: <1281124366-13716-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver should call disable_pci_device() if it returns from pci_probe()
with error. Also it must not be called if pci_request_region() fails as
it means that somebody uses device resources and rules the device.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/pcmcia/pd6729.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pcmcia/pd6729.c b/drivers/pcmcia/pd6729.c
index b8a869a..1858c3a 100644
--- a/drivers/pcmcia/pd6729.c
+++ b/drivers/pcmcia/pd6729.c
@@ -646,7 +646,7 @@ static int __devinit pd6729_pci_probe(struct pci_dev *dev,
 	if (!pci_resource_start(dev, 0)) {
 		dev_warn(&dev->dev, "refusing to load the driver as the "
 			"io_base is NULL.\n");
-		goto err_out_free_mem;
+		goto err_out_disable;
 	}
 
 	dev_info(&dev->dev, "Cirrus PD6729 PCI to PCMCIA Bridge at 0x%llx "
@@ -666,7 +666,7 @@ static int __devinit pd6729_pci_probe(struct pci_dev *dev,
 	ret = pci_request_regions(dev, "pd6729");
 	if (ret) {
 		dev_warn(&dev->dev, "pci request region failed.\n");
-		goto err_out_disable;
+		goto err_out_free_mem;
 	}
 
 	if (dev->irq == NO_IRQ)
-- 
1.7.0.4

