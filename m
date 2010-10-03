Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab0JCOKq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 10:10:46 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34829 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab0JCOKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 10:10:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=bJbQrHzK5T/+Hfj8opqll1Rec62bVk+XqRciBiWe7d7ZaaL3yr2ODxBCobKjzCVM2J
         rpX3ge484DcNYrwADWeeqmqrKEBdijQtKuDOVzbYFU4o/juYC5V3Qj+2MRaDCfJUWQJU
         ej9lS2YkYEEpjG9ALtA3f0hdU7/+iHE1v6UjM=
From: Rahul Ruikar <rahul.ruikar@gmail.com>
To: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Dan Carpenter <error27@gmail.com>,
        nm127@freemail.hu
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rahul Ruikar <rahul.ruikar@gmail.com>
Subject: [PATCH] usb: gadget: goku_udc: Fix error path
Date: Sun,  3 Oct 2010 19:40:16 +0530
Message-Id: <1286115016-2759-1-git-send-email-rahul.ruikar@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

call put_device() when device_register() fails.

Signed-off-by: Rahul Ruikar <rahul.ruikar@gmail.com>
---
 drivers/usb/gadget/goku_udc.c |    7 ++++++-
 drivers/usb/gadget/goku_udc.h |    3 ++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/goku_udc.c b/drivers/usb/gadget/goku_udc.c
index 1088d08..080779b 100644
--- a/drivers/usb/gadget/goku_udc.c
+++ b/drivers/usb/gadget/goku_udc.c
@@ -1847,8 +1847,13 @@ static int goku_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* done */
 	the_controller = dev;
 	retval = device_register(&dev->gadget.dev);
-	if (retval == 0)
+	if (retval != 0) {
+		dev_reg_status = 2;
+		goto done;
+	} else {
+		dev_reg_status = 1;
 		return 0;
+	}
 
 done:
 	if (dev)
diff --git a/drivers/usb/gadget/goku_udc.h b/drivers/usb/gadget/goku_udc.h
index 566cb23..c27b9e2 100644
--- a/drivers/usb/gadget/goku_udc.h
+++ b/drivers/usb/gadget/goku_udc.h
@@ -251,7 +251,8 @@ struct goku_udc {
 					got_region:1,
 					req_config:1,
 					configured:1,
-					enabled:1;
+					enabled:1,
+					dev_reg_status:2;
 
 	/* pci state used to access those endpoints */
 	struct pci_dev			*pdev;
-- 
1.7.2.3

