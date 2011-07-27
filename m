Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800Ab1G0WJI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 18:09:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:36473 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755427Ab1G0VsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:48:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,278,1309762800"; 
   d="scan'208";a="30900399"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: balbi@ti.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [18/99] usb: gadget: rndis: don't test against req->length
Message-Id: <20110727214816.A07372403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:48:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Felipe Balbi <balbi@ti.com>

commit 472b91274a6c6857877b5caddb875dcb5ecdfcb8 upstream.

composite.c always sets req->length to zero
and expects function driver's setup handlers
to return the amount of bytes to be used
on req->length. If we test against req->length
w_length will always be greater than req->length
thus making us always stall that particular
SEND_ENCAPSULATED_COMMAND request.

Tested against a Windows XP SP3.

Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/gadget/f_rndis.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6.35.y/drivers/usb/gadget/f_rndis.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/gadget/f_rndis.c
+++ linux-2.6.35.y/drivers/usb/gadget/f_rndis.c
@@ -420,8 +420,7 @@ rndis_setup(struct usb_function *f, cons
 	 */
 	case ((USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE) << 8)
 			| USB_CDC_SEND_ENCAPSULATED_COMMAND:
-		if (w_length > req->length || w_value
-				|| w_index != rndis->ctrl_id)
+		if (w_value || w_index != rndis->ctrl_id)
 			goto invalid;
 		/* read the request; process it later */
 		value = w_length;
