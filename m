Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935075Ab2JaIFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 04:05:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56674 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934972Ab2JaIFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 04:05:37 -0400
From: Xiaotian Feng <xtfeng@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Xiaotian Feng <xtfeng@gmail.com>, Xiaotian Feng <dannyfeng@tencent.com>,
        Li Yang <leoli@freescale.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 2/3] usb: gadget: fsl_qe_udc: do not use tasklet_disable before tasklet_kill
Date: Wed, 31 Oct 2012 16:06:00 +0800
Message-Id: <1351670761-26749-2-git-send-email-xtfeng@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351670761-26749-1-git-send-email-xtfeng@gmail.com>
References: <1351670761-26749-1-git-send-email-xtfeng@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If tasklet_disable() is called before related tasklet handled,
tasklet_kill will never be finished. tasklet_kill is enough.

Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>
Cc: Li Yang <leoli@freescale.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
---
 drivers/usb/gadget/fsl_qe_udc.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/fsl_qe_udc.c b/drivers/usb/gadget/fsl_qe_udc.c
index b09452d..4ad3b82 100644
--- a/drivers/usb/gadget/fsl_qe_udc.c
+++ b/drivers/usb/gadget/fsl_qe_udc.c
@@ -2661,7 +2661,7 @@ static int __devexit qe_udc_remove(struct platform_device *ofdev)
 	usb_del_gadget_udc(&udc->gadget);
 
 	udc->done = &done;
-	tasklet_disable(&udc->rx_tasklet);
+	tasklet_kill(&udc->rx_tasklet);
 
 	if (udc->nullmap) {
 		dma_unmap_single(udc->gadget.dev.parent,
@@ -2698,8 +2698,6 @@ static int __devexit qe_udc_remove(struct platform_device *ofdev)
 	free_irq(udc->usb_irq, udc);
 	irq_dispose_mapping(udc->usb_irq);
 
-	tasklet_kill(&udc->rx_tasklet);
-
 	iounmap(udc->usb_regs);
 
 	device_unregister(&udc->gadget.dev);
-- 
1.7.9.5

