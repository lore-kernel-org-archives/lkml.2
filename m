Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785Ab1ENGPq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 02:15:46 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:53496 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab1ENGPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 02:15:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Cj6UPpvfmjpvv0w1nZ4LIZCSU7LoML+xLtEhK1BDUCB4v+2yDOhYWmVV54K/LwUGE5
         s5t/xhw/vjfcu+loClP2Mfc1cxASab4PrlqfnJqpmjwvt5itmrLtEwk3a8Td1vhvhNmH
         Vk3eBAM2he8KAENyB3LsSCSzFEqdEOENDN+Bo=
Subject: [PATCH] mfd: Fix omap_usbhs_alloc_children error handling
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Keshava Munegowda <keshava_mgowda@ti.com>, Felipe Balbi <balbi@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 14 May 2011 14:15:36 +0800
Message-ID: <1305353736.11286.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Return proper error if omap_usbhs_alloc_child fails
2. In the case of goto err_ehci, we should call platform_device_unregister(ehci)
   instead of platform_device_put(ehci) because we have already added the
   platform device to device hierarchy.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/omap-usb-host.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 3ab9ffa..344f518 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -281,6 +281,7 @@ static int omap_usbhs_alloc_children(struct platform_device *pdev)
 
 	if (!ehci) {
 		dev_err(dev, "omap_usbhs_alloc_child failed\n");
+		ret = -ENOMEM;
 		goto err_end;
 	}
 
@@ -304,13 +305,14 @@ static int omap_usbhs_alloc_children(struct platform_device *pdev)
 		sizeof(*ohci_data), dev);
 	if (!ohci) {
 		dev_err(dev, "omap_usbhs_alloc_child failed\n");
+		ret = -ENOMEM;
 		goto err_ehci;
 	}
 
 	return 0;
 
 err_ehci:
-	platform_device_put(ehci);
+	platform_device_unregister(ehci);
 
 err_end:
 	return ret;
-- 
1.7.1



