Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759620Ab0LNQvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 11:51:33 -0500
Received: from mail.atmel.fr ([81.80.104.162]:39140 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759259Ab0LNQvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 11:51:32 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: gregkh@suse.de, linux-usb@vger.kernel.org, dbrownell@users.sourceforge.net
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rob Emanuele <rje@crystalfontz.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v2] USB: atmel_usba_udc: fix freeing irq in usba_udc_remove()
Date: Tue, 14 Dec 2010 19:00:30 +0100
Message-Id: <1292349630-3610-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <636999.52551.qm@web180309.mail.gq1.yahoo.com>
References: <636999.52551.qm@web180309.mail.gq1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Emanuele <rje@crystalfontz.com>

Add a free_irq() call on vbus gpio when we remove udc so that the
vbus irq is properly released.

Signed-off-by: Rob Emanuele <rje@crystalfontz.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
David,

I modified $SUBJECT to be more explicit about which driver is modified.
Hope that makes sense now...

Bye,

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

