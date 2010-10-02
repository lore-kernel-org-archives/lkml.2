Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892Ab0JBPMY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 11:12:24 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47735 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755727Ab0JBPMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 11:12:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=bcMQwGqVBhMwYuCeyGgXd/baCn8rAvT8tJXeuXzPEb/4F+iAoLivB8n4dg6l6qmdqG
         PBM9N/MFDWFuejNZt+puEKT9xj7b/710fmIKoXhRukNuF9dxU7gfgkoz42ouIjHZdEKm
         QT43cRW0msqY0XGkmLKFmRGAz3duQFRufksi4=
From: Rahul Ruikar <rahul.ruikar@gmail.com>
To: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rahul Ruikar <rahul.ruikar@gmail.com>
Subject: [RESEND/PATCH] usb: gadget: dummy_hcd: Fix error path
Date: Sat,  2 Oct 2010 20:41:47 +0530
Message-Id: <1286032307-3350-1-git-send-email-rahul.ruikar@gmail.com>
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

