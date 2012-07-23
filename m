Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab2GWRuO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 13:50:14 -0400
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:19975
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754493Ab2GWRuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 13:50:12 -0400
X-Forefront-Antispam-Report: CIP:157.55.49.13;KIP:(null);UIP:(null);IPV:NLI;H:SN2PRD0802HT003.namprd08.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: PS0(zzzz1202hzz8275bhz2fh2a8h668h839hd24he5bhf0ah107ah)
From: Rupesh Gujare <rgujare@ozmodevices.com>
To: <devel@driverdev.osuosl.org>
CC: <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>
Subject: [PATCH 1/5] staging: ozwpan: buffer frame if urb not available.
Date: Mon, 23 Jul 2012 18:49:43 +0100
Message-ID: <1343065787-7616-2-git-send-email-rgujare@ozmodevices.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1343065787-7616-1-git-send-email-rgujare@ozmodevices.com>
References: <1343065787-7616-1-git-send-email-rgujare@ozmodevices.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [81.149.82.179]
X-OriginatorOrg: ozmodevices.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For interrupt end point buffer frames, if urb is not available
& give back as soon as urb is received from usb core.

Signed-off-by: Rupesh Gujare <rgujare@ozmodevices.com>
---
 drivers/staging/ozwpan/ozhcd.c |   67 +++++++++++++++++++++++++++++++++++++--
 1 files changed, 63 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index 251f07c..617bfed 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -417,6 +417,44 @@ static void oz_ep_free(struct oz_port *port, struct oz_endpoint *ep)
 /*------------------------------------------------------------------------------
  * Context: softirq
  */
+void oz_complete_buffered_urb(struct oz_port *port, struct oz_endpoint *ep,
+			struct urb *urb)
+{
+	u8 data_len, available_space, copy_len;
+
+	memcpy(&data_len, &ep->buffer[ep->out_ix], sizeof(u8));
+	if (data_len <= urb->transfer_buffer_length)
+		available_space = data_len;
+	else
+		available_space = urb->transfer_buffer_length;
+
+	if (++ep->out_ix == ep->buffer_size)
+		ep->out_ix = 0;
+	copy_len = ep->buffer_size - ep->out_ix;
+	if (copy_len >= available_space)
+		copy_len = available_space;
+	memcpy(urb->transfer_buffer, &ep->buffer[ep->out_ix], copy_len);
+
+	if (copy_len < available_space) {
+		memcpy((urb->transfer_buffer + copy_len), ep->buffer,
+						(available_space - copy_len));
+		ep->out_ix = available_space - copy_len;
+	} else {
+		ep->out_ix += copy_len;
+	}
+	urb->actual_length = available_space;
+	if (ep->out_ix == ep->buffer_size)
+		ep->out_ix = 0;
+
+	ep->buffered_units--;
+	oz_trace("Trying to give back buffered frame of size=%d\n",
+						available_space);
+	oz_complete_urb(port->ozhcd->hcd, urb, 0, 0);
+}
+
+/*------------------------------------------------------------------------------
+ * Context: softirq
+ */
 static int oz_enqueue_ep_urb(struct oz_port *port, u8 ep_addr, int in_dir,
 			struct urb *urb, u8 req_id)
 {
@@ -452,6 +490,18 @@ static int oz_enqueue_ep_urb(struct oz_port *port, u8 ep_addr, int in_dir,
 		ep = port->in_ep[ep_addr];
 	else
 		ep = port->out_ep[ep_addr];
+
+	/*For interrupt endpoint check for buffered data
+	* & complete urb
+	*/
+	if (((ep->attrib & USB_ENDPOINT_XFERTYPE_MASK) == USB_ENDPOINT_XFER_INT)
+						 && ep->buffered_units > 0) {
+		oz_free_urb_link(urbl);
+		spin_unlock_bh(&port->ozhcd->hcd_lock);
+		oz_complete_buffered_urb(port, ep, urb);
+		return 0;
+	}
+
 	if (ep && port->hpd) {
 		list_add_tail(&urbl->link, &ep->urb_list);
 		if (!in_dir && ep_addr && (ep->credit < 0)) {
@@ -961,6 +1011,9 @@ void oz_hcd_data_ind(void *hport, u8 endpoint, u8 *data, int data_len)
 			urb->actual_length = copy_len;
 			oz_complete_urb(port->ozhcd->hcd, urb, 0, 0);
 			return;
+		} else {
+			oz_trace("buffering frame as URB is not available\n");
+			oz_hcd_buffer_data(ep, data, data_len);
 		}
 		break;
 	case USB_ENDPOINT_XFER_ISOC:
@@ -1167,10 +1220,16 @@ static int oz_build_endpoints_for_interface(struct usb_hcd *hcd,
 		int buffer_size = 0;
 
 		oz_trace("%d bEndpointAddress = %x\n", i, ep_addr);
-		if ((ep_addr & USB_ENDPOINT_DIR_MASK) &&
-			((hep->desc.bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
-			== USB_ENDPOINT_XFER_ISOC)) {
-			buffer_size = 24*1024;
+		if (ep_addr & USB_ENDPOINT_DIR_MASK) {
+			switch (hep->desc.bmAttributes &
+						USB_ENDPOINT_XFERTYPE_MASK) {
+			case USB_ENDPOINT_XFER_ISOC:
+				buffer_size = 24*1024;
+				break;
+			case USB_ENDPOINT_XFER_INT:
+				buffer_size = 128;
+				break;
+			}
 		}
 
 		ep = oz_ep_alloc(mem_flags, buffer_size);
-- 
1.7.5.4


