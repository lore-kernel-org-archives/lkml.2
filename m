Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269Ab0LNN4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 08:56:52 -0500
Received: from mail.atmel.fr ([81.80.104.162]:37932 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759278Ab0LNN4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 08:56:51 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: gregkh@suse.de, linux-usb@vger.kernel.org, dbrownell@users.sourceforge.net
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rob Emanuele <rje@crystalfontz.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] AT91: usb gadget: fix freeing irq in _udc_remove()
Date: Tue, 14 Dec 2010 16:05:39 +0100
Message-Id: <1292339139-26212-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <AANLkTimV2ENcWajrrMQ2Too4pf=XBfLczJ9HehNt4V_8@mail.gmail.com>
References: <AANLkTimV2ENcWajrrMQ2Too4pf=XBfLczJ9HehNt4V_8@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Emanuele <rje@crystalfontz.com>

Add a free_irq() call on vbus gpio when we remove udc so that the
vbus irq is properly released.

Signed-off-by: Rob Emanuele <rje@crystalfontz.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/usb/gadget/atmel_usba_udc.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
index 717ff65..e7c65a4 100644
--- a/drivers/usb/gadget/atmel_usba_udc.c
+++ b/drivers/usb/gadget/atmel_usba_udc.c
@@ -2057,8 +2057,10 @@ static int __exit usba_udc_remove(struct platform_device *pdev)
 		usba_ep_cleanup_debugfs(&usba_ep[i]);
 	usba_cleanup_debugfs(udc);
 
-	if (gpio_is_valid(udc->vbus_pin))
+	if (gpio_is_valid(udc->vbus_pin)) {
+		free_irq(gpio_to_irq(udc->vbus_pin), udc);
 		gpio_free(udc->vbus_pin);
+	}
 
 	free_irq(udc->irq, udc);
 	kfree(usba_ep);
-- 
1.7.3

