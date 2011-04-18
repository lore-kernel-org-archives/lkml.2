Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab1DRKoz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 06:44:55 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59581 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252Ab1DRKot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 06:44:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=d2MyixYtIo1CQGIF6nTI1ROjfAckkYAnS41k3Ks9DpqbPAbBXb9XVa1nc74LhvchVO
         OxC929RJsC/jNqeFabRstBObJsueypdjKB9E+pGOzFxs3CLKL485h5Mib7KSLWfHxJCB
         bC1aArY8OPZlbDdILxCtamn+w5m1LYTpiqC8E=
From: Liu Yuan <namei.unix@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-fbdev@vger.kernel.org (open list:FRAMEBUFFER LAYER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] video, udlfb: Fix two build warnings about 'ignoring return value'
Date: Mon, 18 Apr 2011 18:44:38 +0800
Message-Id: <1303123478-9059-1-git-send-email-namei.unix@gmail.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Yuan <tailai.ly@taobao.com>

build warning:

...
drivers/video/udlfb.c:1590: warning: ignoring return value of ‘device_create_file’, declared with attribute warn_unused_result
drivers/video/udlfb.c:1592: warning: ignoring return value of ‘device_create_bin_file’, declared with attribute warn_unused_result
...

So add two checks to get rid of 'em.

Signed-off-by: Liu Yuan <tailai.ly@taobao.com>
---
 drivers/video/udlfb.c |   19 ++++++++++++++++---
 1 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/video/udlfb.c b/drivers/video/udlfb.c
index 68041d9..1baa802 100644
--- a/drivers/video/udlfb.c
+++ b/drivers/video/udlfb.c
@@ -1586,10 +1586,19 @@ static int dlfb_usb_probe(struct usb_interface *interface,
 		goto error;
 	}
 
-	for (i = 0; i < ARRAY_SIZE(fb_device_attrs); i++)
-		device_create_file(info->dev, &fb_device_attrs[i]);
+	for (i = 0; i < ARRAY_SIZE(fb_device_attrs); i++) {
+		retval = device_create_file(info->dev, &fb_device_attrs[i]);
+		if (retval) {
+			pr_err("device_create_file failed %d\n", retval);
+			goto err_del_attrs;
+		}
+	}
 
-	device_create_bin_file(info->dev, &edid_attr);
+	retval = device_create_bin_file(info->dev, &edid_attr);
+	if (retval) {
+		pr_err("device_create_bin_file failed %d\n", retval);
+		goto err_del_attrs;
+	}
 
 	pr_info("DisplayLink USB device /dev/fb%d attached. %dx%d resolution."
 			" Using %dK framebuffer memory\n", info->node,
@@ -1598,6 +1607,10 @@ static int dlfb_usb_probe(struct usb_interface *interface,
 			info->fix.smem_len * 2 : info->fix.smem_len) >> 10);
 	return 0;
 
+err_del_attrs:
+	for (i -= 1; i >= 0; i--)
+		device_remove_file(info->dev, &fb_device_attrs[i]);
+
 error:
 	if (dev) {
 
-- 
1.7.1

