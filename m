Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933585Ab1ERShf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 14:37:35 -0400
Received: from [138.40.68.24] ([138.40.68.24]:52705 "EHLO optosun2.city.ac.uk"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S933460Ab1ERSha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 14:37:30 -0400
From: "J. Ali Harlow" <ali@optosun7.city.ac.uk>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: devel@linuxdriverproject.org, Manuel Gebele <forensixs@gmx.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] comedi vmk80xx: support comedi auto-configuration
Date: Wed, 18 May 2011 19:18:56 +0100
Message-Id: <1305742736-19434-6-git-send-email-ali@avrc.city.ac.uk>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for automatically associating a vmk8055 device with a
comedi device (previously the user had to use comedi_num_legacy_minors
to reserve device slots and then associate them with vmk8055 devices
using comedi_config).
Tested on multiple K8055s, but not on K8061s.

Signed-off-by: J. Ali Harlow <ali@avrc.city.ac.uk>
---
 drivers/staging/comedi/drivers/vmk80xx.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/vmk80xx.c b/drivers/staging/comedi/drivers/vmk80xx.c
index 04c085f..3d13ca6 100644
--- a/drivers/staging/comedi/drivers/vmk80xx.c
+++ b/drivers/staging/comedi/drivers/vmk80xx.c
@@ -64,6 +64,8 @@ Changelog:
 
 #include "../comedidev.h"
 
+#define BOARDNAME "vmk80xx"
+
 MODULE_AUTHOR("Manuel Gebele <forensixs@gmx.de>");
 MODULE_DESCRIPTION("Velleman USB Board Low-Level Driver");
 MODULE_SUPPORTED_DEVICE("K8055/K8061 aka VM110/VM140");
@@ -1480,6 +1482,8 @@ static int vmk80xx_probe(struct usb_interface *intf,
 
 	mutex_unlock(&glb_mutex);
 
+	comedi_usb_auto_config(dev->udev, BOARDNAME);
+
 	return 0;
 error:
 	mutex_unlock(&glb_mutex);
@@ -1496,6 +1500,8 @@ static void vmk80xx_disconnect(struct usb_interface *intf)
 	if (!dev)
 		return;
 
+	comedi_usb_auto_unconfig(dev->udev);
+
 	mutex_lock(&glb_mutex);
 	down(&dev->limit_sem);
 
@@ -1533,10 +1539,16 @@ static struct comedi_driver driver_vmk80xx = {
 
 static int __init vmk80xx_init(void)
 {
+	int retval;
+
 	printk(KERN_INFO "vmk80xx: version 0.8.01 "
 	       "Manuel Gebele <forensixs@gmx.de>\n");
-	usb_register(&vmk80xx_driver);
-	return comedi_driver_register(&driver_vmk80xx);
+
+	retval = comedi_driver_register(&driver_vmk80xx);
+	if (retval < 0)
+		return retval;
+
+	return usb_register(&vmk80xx_driver);
 }
 
 static void __exit vmk80xx_exit(void)
-- 
1.7.4.1

