Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab2ALCcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 21:32:47 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53261 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab2ALCco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 21:32:44 -0500
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH 1/6 v2] usb/gadget/pch_udc: Fix disconnect issue
Date: Thu, 12 Jan 2012 11:27:05 +0900
Message-Id: <1326335230-32469-1-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ISSUE:
When the driver notifies a gadget of a disconnect event, a system rarely freezes.

CAUSE:
When the driver calls dev->driver->disconnect(), it is not calling spinlock().

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
V2: Divide into 6 patches
---
 drivers/usb/gadget/pch_udc.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/pch_udc.c b/drivers/usb/gadget/pch_udc.c
index f222659..a4f8b08 100644
--- a/drivers/usb/gadget/pch_udc.c
+++ b/drivers/usb/gadget/pch_udc.c
@@ -2340,8 +2340,11 @@ static void pch_udc_svc_ur_interrupt(struct pch_udc_dev *dev)
 		/* Complete request queue */
 		empty_req_queue(ep);
 	}
-	if (dev->driver && dev->driver->disconnect)
+	if (dev->driver && dev->driver->disconnect) {
+		spin_unlock(&dev->lock);
 		dev->driver->disconnect(&dev->gadget);
+		spin_lock(&dev->lock);
+	}
 }
 
 /**
-- 
1.7.4.4

