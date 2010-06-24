Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab0FXJ47 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 05:56:59 -0400
Received: from smtp1.extricom.com ([212.235.17.194]:55692 "HELO
	smtp.extricom.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with SMTP id S1754565Ab0FXJ45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 05:56:57 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Jun 2010 05:56:56 EDT
Message-ID: <4C232B13.5000706@extricom.com>
Date: Thu, 24 Jun 2010 12:53:23 +0300
From: Eran Liberty <liberty@extricom.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: LKML <linux-kernel@vger.kernel.org>, galak@kernel.crashing.org
Subject: [PATCH] gainfar.c : skb_over_panic (kernel-2.6.32.15)
Content-Type: multipart/mixed;
 boundary="------------030703000907050303010204"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030703000907050303010204
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Fix possible skb_over_panic event in Freescale's "gianfar" driver. 

The skb_over_panic occurs due to calling skb_put() within 
gfar_clean_rx_ring(). This happens if (and only if) shortly prior to the 
event and a few lined above the skb_put(), an skb was queued back to the 
priv->rx_recycle queue due to RXBD_LAST or RXBD_ERR status.
The skb is queued without properly re-setting its state.

The patch properly reset the skb state.

I have tested this patch on MPC8548 based product and asserted it avoided the skb_over_panic event.

Signed-off-by: Eran Liberty <liberty@extricom.com>

---






--------------030703000907050303010204
Content-Type: text/x-diff;
 name="gianfar_skb_over_panic.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gianfar_skb_over_panic.patch"

---
 drivers/net/gianfar.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/drivers/net/gianfar.c
+++ b/drivers/net/gianfar.c
@@ -1854,14 +1854,9 @@
 			if (unlikely(!newskb))
 				newskb = skb;
 			else if (skb) {
-				/*
-				 * We need to reset ->data to what it
-				 * was before gfar_new_skb() re-aligned
-				 * it to an RXBUF_ALIGNMENT boundary
-				 * before we put the skb back on the
-				 * recycle list.
-				 */
 				skb->data = skb->head + NET_SKB_PAD;
+				skb->len = 0;
+				skb_reset_tail_pointer(skb);
 				__skb_queue_head(&priv->rx_recycle, skb);
 			}
 		} else {

--------------030703000907050303010204--
