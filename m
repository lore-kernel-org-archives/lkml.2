Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030862Ab2I1THR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:07:17 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35065 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030823Ab2I1THL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:07:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Richard Zhao <richard.zhao@freescale.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [ 253/262] usb: chipidea: cleanup dma_pool if udc_start() fails
Date: Fri, 28 Sep 2012 11:53:02 -0700
Message-Id: <20120928183028.404193291@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit ad6b1b97fe8504957d017cd6e4168cac8903d3f3 upstream.

If udc_start() fails the qh_pool dma-pool cannot be closed because
it's still in use. This patch factors out the dma_pool_free() loop
into destroy_eps() and calls it in the error path of udc_start(),
too.

Reviewed-by: Richard Zhao <richard.zhao@freescale.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[mkl: backport to v3.5]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>

---
 drivers/usb/chipidea/udc.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -1500,6 +1500,17 @@ static int init_eps(struct ci13xxx *udc)
 	return retval;
 }
 
+static void destroy_eps(struct ci13xxx *udc)
+{
+	int i;
+
+	for (i = 0; i < udc->hw_ep_max; i++) {
+		struct ci13xxx_ep *mEp = &udc->ci13xxx_ep[i];
+
+		dma_pool_free(udc->qh_pool, mEp->qh.ptr, mEp->qh.dma);
+	}
+}
+
 /**
  * ci13xxx_start: register a gadget driver
  * @gadget: our gadget
@@ -1709,7 +1720,7 @@ static int udc_start(struct ci13xxx *udc
 	if (udc->udc_driver->flags & CI13XXX_REQUIRE_TRANSCEIVER) {
 		if (udc->transceiver == NULL) {
 			retval = -ENODEV;
-			goto free_pools;
+			goto destroy_eps;
 		}
 	}
 
@@ -1759,6 +1770,8 @@ unreg_device:
 put_transceiver:
 	if (udc->transceiver)
 		usb_put_transceiver(udc->transceiver);
+destroy_eps:
+	destroy_eps(udc);
 free_pools:
 	dma_pool_destroy(udc->td_pool);
 free_qh_pool:
@@ -1773,18 +1786,12 @@ free_qh_pool:
  */
 static void udc_stop(struct ci13xxx *udc)
 {
-	int i;
-
 	if (udc == NULL)
 		return;
 
 	usb_del_gadget_udc(&udc->gadget);
 
-	for (i = 0; i < udc->hw_ep_max; i++) {
-		struct ci13xxx_ep *mEp = &udc->ci13xxx_ep[i];
-
-		dma_pool_free(udc->qh_pool, mEp->qh.ptr, mEp->qh.dma);
-	}
+	destroy_eps(udc);
 
 	dma_pool_destroy(udc->td_pool);
 	dma_pool_destroy(udc->qh_pool);


