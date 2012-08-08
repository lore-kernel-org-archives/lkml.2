Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932584Ab2HHJKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 05:10:53 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:51730 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752505Ab2HHJKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 05:10:52 -0400
X-Greylist: delayed 1752 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Aug 2012 05:10:51 EDT
From: Vladimir Gratinskiy <gratinskiy@ispras.ru>
To: "Chao Xie" <chao.xie@marvell.com>
Cc: Vladimir Gratinskiy <gratinskiy@ispras.ru>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@ispras.ru
Subject: [PATCH 2/2] usb_gadget: Use GFP_ATOMIC in dma_pool_alloc().
Date: Wed,  8 Aug 2012 12:42:45 +0400
Message-Id: <1344415365-10528-1-git-send-email-gratinskiy@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling memory allocation function from the context of interrupt:
request_irq(udc->irq, mv_udc_irq, IRQF_SHARED, driver_name, udc);
Function
mv_udc_irq(..) calls:
irq_process_tr_complete(..) that calls:
handle_setup_packet(..) that calls:
ch9setaddress(..) that calls:
udc_prime_status(..) that calls:
req_to_dtd(..) that calls:
build_dtd(..) that calls:
dma_pool_alloc(udc->dtd_pool, GFP_KERNEL, dma).
In the case of GFP_KERNEL flag, function execution can be preempted,
because a greater number of operations to find and allocate memory
blocks is executed.

The patch change GFP_KERNEL flag to GFP_ATOMIC.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Vladimir Gratinskiy <gratinskiy@ispras.ru>
---
 drivers/usb/gadget/mv_udc_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/mv_udc_core.c b/drivers/usb/gadget/mv_udc_core.c
index 75db2c3..ba91f7c 100644
--- a/drivers/usb/gadget/mv_udc_core.c
+++ b/drivers/usb/gadget/mv_udc_core.c
@@ -375,7 +375,7 @@ static struct mv_dtd *build_dtd(struct mv_req *req, unsigned *length,
 	 * Be careful that no _GFP_HIGHMEM is set,
 	 * or we can not use dma_to_virt
 	 */
-	dtd = dma_pool_alloc(udc->dtd_pool, GFP_KERNEL, dma);
+	dtd = dma_pool_alloc(udc->dtd_pool, GFP_ATOMIC, dma);
 	if (dtd == NULL)
 		return dtd;
 
-- 
1.7.9.5

