Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036Ab0JGELL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 00:11:11 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:56877 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab0JGELK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 00:11:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=iub4cNSFeENgxj5ImM2xUvPCeEcApZ0707MxoXzt33V1lsvfzhHxshl6K584cwsChO
         7SceiOUN+W61BW9izmWBzfj3vtgrikKSaiCsMP8vQ4prmDcgT/YLGqEb50w2dmlpaXcZ
         WXbsLsqWff44G7vlPrXosU3x1+ijYn9ZT8Phs=
From: Rahul Ruikar <rahul.ruikar@gmail.com>
To: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rahul Ruikar <rahul.ruikar@gmail.com>
Subject: [RESEND/PATCH] usb: gadget: dummy_hcd: Fix error path
Date: Thu,  7 Oct 2010 09:40:45 +0530
Message-Id: <1286424645-2899-1-git-send-email-rahul.ruikar@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In function dummy_udc_probe()
call put_device() when device_register() fails.
also usb_get_hcd() put before device_register() after review comment
from Alan Stern.

Signed-off-by: Rahul Ruikar <rahul.ruikar@gmail.com>
---
 drivers/usb/gadget/dummy_hcd.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
index dc65462..9b30483 100644
--- a/drivers/usb/gadget/dummy_hcd.c
+++ b/drivers/usb/gadget/dummy_hcd.c
@@ -874,6 +874,8 @@ static int dummy_udc_probe (struct platform_device *pdev)
 	struct dummy	*dum = the_controller;
 	int		rc;
 
+	usb_get_hcd(dummy_to_hcd(dum));
+
 	dum->gadget.name = gadget_name;
 	dum->gadget.ops = &dummy_ops;
 	dum->gadget.is_dualspeed = 1;
@@ -885,10 +887,10 @@ static int dummy_udc_probe (struct platform_device *pdev)
 	dum->gadget.dev.parent = &pdev->dev;
 	dum->gadget.dev.release = dummy_gadget_release;
 	rc = device_register (&dum->gadget.dev);
-	if (rc < 0)
+	if (rc < 0) {
+		put_device(&dum->gadget.dev);
 		return rc;
-
-	usb_get_hcd (dummy_to_hcd (dum));
+	}
 
 	platform_set_drvdata (pdev, dum);
 	rc = device_create_file (&dum->gadget.dev, &dev_attr_function);
-- 
1.7.2.3

