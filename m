Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042Ab2HNGr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 02:47:56 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:49644 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751863Ab2HNGrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 02:47:48 -0400
X-IronPort-AV: E=Sophos;i="4.77,764,1336341600"; 
   d="scan'208";a="169831632"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kernel-janitors@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] drivers/usb/wusbcore/wa-hc.c: fix error return code
Date: Tue, 14 Aug 2012 08:47:36 +0200
Message-Id: <1344926858-1162-4-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1344926858-1162-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1344926858-1162-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Convert a 0 error return code to a negative one, as returned elsewhere in the
function.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier ret;
expression e,e1,e2,e3,e4,x;
@@

(
if (\(ret != 0\|ret < 0\) || ...) { ... return ...; }
|
ret = 0
)
... when != ret = e1
*x = \(kmalloc\|kzalloc\|kcalloc\|devm_kzalloc\|ioremap\|ioremap_nocache\|devm_ioremap\|devm_ioremap_nocache\)(...);
... when != x = e2
    when != ret = e3
*if (x == NULL || ...)
{
  ... when != ret = e4
*  return ret;
}
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/usb/wusbcore/wa-hc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/wusbcore/wa-hc.c b/drivers/usb/wusbcore/wa-hc.c
index 9e4a924..a09b65e 100644
--- a/drivers/usb/wusbcore/wa-hc.c
+++ b/drivers/usb/wusbcore/wa-hc.c
@@ -46,8 +46,10 @@ int wa_create(struct wahc *wa, struct usb_interface *iface)
 	wa->dto_epd = &iface->cur_altsetting->endpoint[2].desc;
 	wa->xfer_result_size = usb_endpoint_maxp(wa->dti_epd);
 	wa->xfer_result = kmalloc(wa->xfer_result_size, GFP_KERNEL);
-	if (wa->xfer_result == NULL)
+	if (wa->xfer_result == NULL) {
+		result = -ENOMEM;
 		goto error_xfer_result_alloc;
+	}
 	result = wa_nep_create(wa, iface);
 	if (result < 0) {
 		dev_err(dev, "WA-CDS: can't initialize notif endpoint: %d\n",

