Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031Ab1HHJOc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 05:14:32 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63873 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab1HHJO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 05:14:28 -0400
Subject: [PATCH 1/3] platform-drivers-x86: eeepc-laptop: fix wrong test for
 successful registered led_classdev
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Corentin Chary <corentincj@iksaif.net>, Matthew Garrett <mjg@redhat.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Aug 2011 17:14:19 +0800
Message-ID: <1312794859.21052.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_create returns &struct device pointer on success, or ERR_PTR() on error.
Thus if led_classdev_register fails, led_cdev->dev is always not NULL.

If IS_ERR(eeepc->tpd_led.dev) is ture, it means led_classdev_register fails.
If (asus->tpd_led.dev) is NULL, it means we call eeepc_led_exit before
calling led_classdev_register for &eeepc->tpd_led.

We only want to call led_classdev_unregister for sucessfully registered
led_classdev, then we should check (!IS_ERR_OR_NULL(eeepc->tpd_led.dev)).

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/platform/x86/eeepc-laptop.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index 1c45d92..29a216a 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -568,7 +568,7 @@ static int eeepc_led_init(struct eeepc_laptop *eeepc)
 
 static void eeepc_led_exit(struct eeepc_laptop *eeepc)
 {
-	if (eeepc->tpd_led.dev)
+	if (!IS_ERR_OR_NULL(eeepc->tpd_led.dev))
 		led_classdev_unregister(&eeepc->tpd_led);
 	if (eeepc->led_workqueue)
 		destroy_workqueue(eeepc->led_workqueue);
-- 
1.7.4.1



