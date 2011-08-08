Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192Ab1HHJR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 05:17:26 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63749 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab1HHJRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 05:17:24 -0400
Subject: [PATCH 3/3] platform-drivers-x86: asus-laptop: fix wrong test for
 successful registered led_classdev
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Corentin Chary <corentincj@iksaif.net>, Matthew Garrett <mjg@redhat.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
In-Reply-To: <1312794859.21052.2.camel@phoenix>
References: <1312794859.21052.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Aug 2011 17:17:18 +0800
Message-ID: <1312795038.21052.6.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_create returns &struct device pointer on success, or ERR_PTR() on error.
Thus if led_classdev_register fails, led_cdev->dev is always not NULL.

Thus to unregister a successful registered led_classdev, we should check
IS_ERR_OR_NULL macro for led_cdev->dev instead of checking if led_cdev->dev
is NULL or not.

we use IS_ERR_OR_NULL instead of IS_ERR because if we havn't call
led_classdev_register, the led_cdev->dev is NULL.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/platform/x86/asus-laptop.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index fa6d7ec..0e071fa 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -430,17 +430,17 @@ static enum led_brightness asus_kled_cdev_get(struct led_classdev *led_cdev)
 
 static void asus_led_exit(struct asus_laptop *asus)
 {
-	if (asus->mled.led.dev)
+	if (!IS_ERR_OR_NULL(asus->mled.led.dev))
 		led_classdev_unregister(&asus->mled.led);
-	if (asus->tled.led.dev)
+	if (!IS_ERR_OR_NULL(asus->tled.led.dev))
 		led_classdev_unregister(&asus->tled.led);
-	if (asus->pled.led.dev)
+	if (!IS_ERR_OR_NULL(asus->pled.led.dev))
 		led_classdev_unregister(&asus->pled.led);
-	if (asus->rled.led.dev)
+	if (!IS_ERR_OR_NULL(asus->rled.led.dev))
 		led_classdev_unregister(&asus->rled.led);
-	if (asus->gled.led.dev)
+	if (!IS_ERR_OR_NULL(asus->gled.led.dev))
 		led_classdev_unregister(&asus->gled.led);
-	if (asus->kled.led.dev)
+	if (!IS_ERR_OR_NULL(asus->kled.led.dev))
 		led_classdev_unregister(&asus->kled.led);
 	if (asus->led_workqueue) {
 		destroy_workqueue(asus->led_workqueue);
-- 
1.7.4.1



