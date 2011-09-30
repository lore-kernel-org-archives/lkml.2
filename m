Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab1I3NIq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 09:08:46 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64718 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281Ab1I3NIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 09:08:45 -0400
Subject: [RFC][PATCH] pinmux: fix pinctrl_register error handling
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>, Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Sep 2011 21:08:34 +0800
Message-ID: <1317388114.3935.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If device_register fails, current code kfree pctldev multiple times.
current code calls "put_device(&pctldev->dev);kfree(pctldev);" before
and after goto out_err.

The correct fix should be:
If device_register fails, we just need to call put_device(&pctldev->dev);
Since we have "release" callback in pinctrl_type, we don't need to call
kfree(pctldev) after put_device().

If pinctrl_register_pins fails, we need to delete the successfully registerd
device from system by calling device_del().

In pinctrl_unregister(), calling device_unregister(&pctldev->dev) will
free pctldev ( by the release callback ).
We should not call kfree(pctldev) after device_unregister().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
Hi Linus,
The fix is base on my understanding of the driver-model code,
and it is untested ( only compile test), thus I add [RFC] on subject line.
Also CC Greg KH who is the maintainer of drivers/base/*.

Regards,
Axel

 drivers/pinctrl/core.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index f9263b2..28bdb74 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -559,9 +559,7 @@ struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
 	ret = device_register(&pctldev->dev);
 	if (ret != 0) {
 		pr_err("error in device registration\n");
-		put_device(&pctldev->dev);
-		kfree(pctldev);
-		goto out_err;
+		goto out_reg_dev_err;
 	}
 	dev_set_drvdata(&pctldev->dev, pctldev);
 
@@ -573,7 +571,7 @@ struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
 		pr_err("error during pin registration\n");
 		pinctrl_free_pindescs(pctldev, pctldesc->pins,
 				      pctldesc->npins);
-		goto out_err;
+		goto out_reg_pins_err;
 	}
 
 	pinctrl_init_device_debugfs(pctldev);
@@ -583,9 +581,10 @@ struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
 	pinmux_hog_maps(pctldev);
 	return pctldev;
 
-out_err:
+out_reg_pins_err:
+	device_del(&pctldev->dev);
+out_reg_dev_err:
 	put_device(&pctldev->dev);
-	kfree(pctldev);
 	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL_GPL(pinctrl_register);
@@ -606,11 +605,10 @@ void pinctrl_unregister(struct pinctrl_dev *pctldev)
 	mutex_lock(&pinctrldev_list_mutex);
 	list_del(&pctldev->node);
 	mutex_unlock(&pinctrldev_list_mutex);
-	device_unregister(&pctldev->dev);
 	/* Destroy descriptor tree */
 	pinctrl_free_pindescs(pctldev, pctldev->desc->pins,
 			      pctldev->desc->npins);
-	kfree(pctldev);
+	device_unregister(&pctldev->dev);
 }
 EXPORT_SYMBOL_GPL(pinctrl_unregister);
 
-- 
1.7.4.1



