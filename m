Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506Ab1DNISF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 04:18:05 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38929 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab1DNISC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 04:18:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=ikKFVzJlGYbzwna43XEdFYNbb8EGEdHlAdWX0B6f4ZcJdsdjfoTKg1QiRP3q4AEE4a
         lMvrFl7D5pCA6Ijc45rEn+keDlaiAgy1Tx+PgzM3FH+RSrOJzkuWfLr2SaU2Oz+7vR1y
         FcUC50JLU3ezxJ1iB53jr1E/BlfXIoQW5kFTg=
From: Liu Yuan <namei.unix@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-fbdev@vger.kernel.org (open list:FRAMEBUFFER LAYER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] video, udlfb: Fix two build warning about 'ignoring return value'
Date: Thu, 14 Apr 2011 16:17:50 +0800
Message-Id: <1302769070-21670-1-git-send-email-namei.unix@gmail.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Yuan <tailai.ly@taobao.com>

Build warning:
...
drivers/video/udlfb.c:1590: warning: ignoring return value of ‘device_create_file’, declared with attribute warn_unused_result
drivers/video/udlfb.c:1592: warning: ignoring return value of ‘device_create_bin_file’, declared with attribute warn_unused_result

So add two checks to get rid of 'em.

Signed-off-by: Liu Yuan <tailai.ly@taobao.com>
---
 drivers/video/udlfb.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/video/udlfb.c b/drivers/video/udlfb.c
index 68041d9..55d6de6 100644
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
+			goto error;
+		}
+	}
 
-	device_create_bin_file(info->dev, &edid_attr);
+	retval = device_create_bin_file(info->dev, &edid_attr);
+	if (retval) {
+		pr_err("device_create_bin_file failed %d\n", retval);
+		goto error;
+	}
 
 	pr_info("DisplayLink USB device /dev/fb%d attached. %dx%d resolution."
 			" Using %dK framebuffer memory\n", info->node,
-- 
1.7.1

