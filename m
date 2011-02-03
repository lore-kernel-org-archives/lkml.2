Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404Ab1BCNVx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 08:21:53 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43656 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756320Ab1BCNVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 08:21:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=bXxDwuuIJDIsb1E3XgitSbUPHUGSdSYOXRmbclnU5Euv+tvn+rUd7kIDF8z0KCnvV9
         Lj6w2BBXFG2+/UfC+bn+/PwGZlA6Pjv62suoSruc1FUKtFqD8XZyky+68NedcEI0sL1V
         fQm1tlxaLABaX/fdtojdMPPt0QkDFoF/Q3AtA=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        dilinger@queued.net, cjb@laptop.org, jon.nettleton@gmail.com,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH] staging: oplc_dcon: Fix compilation warning.
Date: Thu,  3 Feb 2011 14:22:08 +0100
Message-Id: <1296739328-11960-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix compilation warning:
drivers/staging/olpc_dcon/olpc_dcon.c: In function ‘dcon_probe’:
drivers/staging/olpc_dcon/olpc_dcon.c:704:21: warning: ignoring
return value of ‘device_create_file’, declared with attribute warn_unused_result

and add cleaning of created files when creation of one failed.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/olpc_dcon/olpc_dcon.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
index 56a283d..7221bb8 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -674,7 +674,7 @@ static int dcon_detect(struct i2c_client *client, struct i2c_board_info *info)
 
 static int dcon_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
-	int rc, i;
+	int rc, i, j;
 
 	if (num_registered_fb >= 1)
 		fbinfo = registered_fb[0];
@@ -700,8 +700,14 @@ static int dcon_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		goto edev;
 	}
 
-	for(i = 0; i < ARRAY_SIZE(dcon_device_files); i++)
-		device_create_file(&dcon_device->dev, &dcon_device_files[i]);
+	for(i = 0; i < ARRAY_SIZE(dcon_device_files); i++) {
+		rc = device_create_file(&dcon_device->dev,
+					&dcon_device_files[i]);
+		if (rc) {
+			dev_err(&dcon_device->dev, "Cannot create sysfs file\n");
+			goto ecreate;
+		}
+	}
 
 	/* Add the backlight device for the DCON */
 
@@ -728,6 +734,9 @@ static int dcon_probe(struct i2c_client *client, const struct i2c_device_id *id)
 
 	return 0;
 
+ ecreate:
+	for (j = 0; j < i; j++)
+		device_remove_file(&dcon_device->dev, &dcon_device_files[j]);
  edev:
 	platform_device_unregister(dcon_device);
 	dcon_device = NULL;
-- 
1.7.1

