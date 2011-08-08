Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474Ab1HHJQI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 05:16:08 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:54638 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab1HHJQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 05:16:07 -0400
Subject: [PATCH 2/3] platform-drivers-x86: asus-wmi: fix resource leak in
 asus_wmi_led_exit
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Corentin Chary <corentincj@iksaif.net>, Matthew Garrett <mjg@redhat.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
In-Reply-To: <1312794859.21052.2.camel@phoenix>
References: <1312794859.21052.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Aug 2011 17:16:01 +0800
Message-ID: <1312794961.21052.4.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes wrong test for successful registered led_classdev,
and also fixes a leak due to missing led_classdev_unregister call
for asus->kbd_led in asus_wmi_led_exit.

device_create returns &struct device pointer on success, or ERR_PTR() on error.
Thus if led_classdev_register fails, led_cdev->dev is always not NULL.

Thus to unregister a successful registered led_classdev, we should check
(!IS_ERR_OR_NULL(asus->tpd_led.dev)) instead of (asus->tpd_led.dev).

we use IS_ERR_OR_NULL instead of IS_ERR because if we havn't call
led_classdev_register, the led_cdev->dev is NULL.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/platform/x86/asus-wmi.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 95cba9e..d1049ee 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -453,7 +453,9 @@ static enum led_brightness kbd_led_get(struct led_classdev *led_cdev)
 
 static void asus_wmi_led_exit(struct asus_wmi *asus)
 {
-	if (asus->tpd_led.dev)
+	if (!IS_ERR_OR_NULL(asus->kbd_led.dev))
+		led_classdev_unregister(&asus->kbd_led);
+	if (!IS_ERR_OR_NULL(asus->tpd_led.dev))
 		led_classdev_unregister(&asus->tpd_led);
 	if (asus->led_workqueue)
 		destroy_workqueue(asus->led_workqueue);
-- 
1.7.4.1



