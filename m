Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946473Ab2CPXnm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:43:42 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39045 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946385Ab2CPXlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:41:23 -0400
Message-Id: <20120316233813.738454903@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 16 Mar 2012 16:38:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Guenter Roeck <linux@roeck-us.net>,
        Jean Delvare <khali@linux-fr.org>
Subject: [ 35/41] hwmon: (w83627ehf) Fix memory leak in probe function
In-Reply-To: <20120316233829.GA14022@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit 32260d94408c553dca4ce54104edf79941a27536 upstream.

The driver probe function leaked memory if creating the cpu0_vid attribute file
failed. Fix by converting the driver to use devm_kzalloc.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/w83627ehf.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/hwmon/w83627ehf.c
+++ b/drivers/hwmon/w83627ehf.c
@@ -2004,7 +2004,8 @@ static int __devinit w83627ehf_probe(str
 		goto exit;
 	}
 
-	data = kzalloc(sizeof(struct w83627ehf_data), GFP_KERNEL);
+	data = devm_kzalloc(&pdev->dev, sizeof(struct w83627ehf_data),
+			    GFP_KERNEL);
 	if (!data) {
 		err = -ENOMEM;
 		goto exit_release;
@@ -2498,9 +2499,8 @@ static int __devinit w83627ehf_probe(str
 
 exit_remove:
 	w83627ehf_device_remove_files(dev);
-	kfree(data);
-	platform_set_drvdata(pdev, NULL);
 exit_release:
+	platform_set_drvdata(pdev, NULL);
 	release_region(res->start, IOREGION_LENGTH);
 exit:
 	return err;
@@ -2514,7 +2514,6 @@ static int __devexit w83627ehf_remove(st
 	w83627ehf_device_remove_files(&pdev->dev);
 	release_region(data->addr, IOREGION_LENGTH);
 	platform_set_drvdata(pdev, NULL);
-	kfree(data);
 
 	return 0;
 }


