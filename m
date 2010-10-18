Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822Ab0JRPEn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 11:04:43 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:63069 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388Ab0JRPEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 11:04:41 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6139"; a="58249773"
From: Tatyana Brokhman <tlinder@codeaurora.org>
To: linux-usb@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Tatyana Brokhman <tlinder@codeaurora.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org
Subject: [RFC/PATCH v2 2/3] usb: dummy_hcd code simplification
Date: Mon, 18 Oct 2010 17:04:25 +0200
Message-Id: <1287414267-26499-1-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Take handling of the control requests out from dummy_timer to a different
function.

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>
---
 drivers/usb/gadget/dummy_hcd.c |  284 ++++++++++++++++++++++++----------------
 1 files changed, 168 insertions(+), 116 deletions(-)

diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
index dc65462..7640e06 100644
--- a/drivers/usb/gadget/dummy_hcd.c
+++ b/drivers/usb/gadget/dummy_hcd.c
@@ -1195,6 +1195,173 @@ static struct dummy_ep *find_endpoint (struct dummy *dum, u8 address)
 #define Ep_Request	(USB_TYPE_STANDARD | USB_RECIP_ENDPOINT)
 #define Ep_InRequest	(Ep_Request | USB_DIR_IN)
 
+
+/**
+ * This function handles all control transferes
+ *
+ * @param dum - pointer to dummy (the_controller)
+ * @param urb - the urb request to handle
+ * @param status - pointer to request handling status
+ * @param master - pointer to the dummy master this request was
+ *		 received for
+ */
+static int handle_control_request(struct dummy *dum, struct urb *urb,
+				  int *status)
+{
+	struct usb_ctrlrequest setup;
+	struct dummy_ep		*ep2;
+	int			ret_val = 1;
+	unsigned	w_index;
+	unsigned	w_value;
+
+	setup = *(struct usb_ctrlrequest *) urb->setup_packet;
+	w_index = le16_to_cpu(setup.wIndex);
+	w_value = le16_to_cpu(setup.wValue);
+	switch (setup.bRequest) {
+	case USB_REQ_SET_ADDRESS:
+		if (setup.bRequestType != Dev_Request)
+			break;
+		dum->address = w_value;
+		*status = 0;
+		dev_dbg(udc_dev(dum), "set_address = %d\n",
+				w_value);
+		ret_val = 0;
+		break;
+	case USB_REQ_SET_FEATURE:
+		if (setup.bRequestType == Dev_Request) {
+			ret_val = 0;
+			switch (w_value) {
+			case USB_DEVICE_REMOTE_WAKEUP:
+				break;
+			case USB_DEVICE_B_HNP_ENABLE:
+				dum->gadget.b_hnp_enable = 1;
+				break;
+			case USB_DEVICE_A_HNP_SUPPORT:
+				dum->gadget.a_hnp_support = 1;
+				break;
+			case USB_DEVICE_A_ALT_HNP_SUPPORT:
+				dum->gadget.a_alt_hnp_support = 1;
+				break;
+			case USB_DEVICE_U1_ENABLE:
+				if (dum->gadget.speed == USB_SPEED_SUPER)
+					w_value = USB_DEV_STAT_U1_ENABLED;
+				else
+					ret_val = -EOPNOTSUPP;
+				break;
+			case USB_DEVICE_U2_ENABLE:
+				if (dum->gadget.speed == USB_SPEED_SUPER)
+					w_value = USB_DEV_STAT_U2_ENABLED;
+				else
+					ret_val = -EOPNOTSUPP;
+				break;
+			case USB_DEVICE_LTM_ENABLE:
+				if (dum->gadget.speed == USB_SPEED_SUPER)
+					w_value = USB_DEV_STAT_LTM_ENABLED;
+				else
+					ret_val = -EOPNOTSUPP;
+				break;
+			default:
+				ret_val = -EOPNOTSUPP;
+			}
+			if (ret_val == 0) {
+				dum->devstatus |= (1 << w_value);
+				*status = 0;
+			}
+		} else if (setup.bRequestType == Ep_Request) {
+			/* endpoint halt */
+			ep2 = find_endpoint(dum, w_index);
+			if (!ep2 || ep2->ep.name == ep0name) {
+				ret_val = -EOPNOTSUPP;
+				break;
+			}
+			ep2->halted = 1;
+			ret_val = 0;
+			*status = 0;
+		}
+		break;
+	case USB_REQ_CLEAR_FEATURE:
+		if (setup.bRequestType == Dev_Request) {
+			ret_val = 0;
+			switch (w_value) {
+			case USB_DEVICE_REMOTE_WAKEUP:
+				w_value = USB_DEVICE_REMOTE_WAKEUP;
+				break;
+			case USB_DEVICE_U1_ENABLE:
+				if (dum->gadget.speed == USB_SPEED_SUPER)
+					w_value = USB_DEV_STAT_U1_ENABLED;
+				else
+					ret_val = -EOPNOTSUPP;
+				break;
+			case USB_DEVICE_U2_ENABLE:
+				if (dum->gadget.speed == USB_SPEED_SUPER)
+					w_value = USB_DEV_STAT_U2_ENABLED;
+				else
+					ret_val = -EOPNOTSUPP;
+				break;
+			case USB_DEVICE_LTM_ENABLE:
+				if (dum->gadget.speed == USB_SPEED_SUPER)
+					w_value = USB_DEV_STAT_LTM_ENABLED;
+				else
+					ret_val = -EOPNOTSUPP;
+				break;
+			default:
+				ret_val = -EOPNOTSUPP;
+				break;
+			}
+			if (ret_val == 0) {
+				dum->devstatus &= ~(1 << w_value);
+				*status = 0;
+			}
+		} else if (setup.bRequestType == Ep_Request) {
+			/* endpoint halt */
+			ep2 = find_endpoint(dum, w_index);
+			if (!ep2) {
+				ret_val = -EOPNOTSUPP;
+				break;
+			}
+			if (!ep2->wedged)
+				ep2->halted = 0;
+			ret_val = 0;
+			*status = 0;
+		}
+		break;
+	case USB_REQ_GET_STATUS:
+		if (setup.bRequestType == Dev_InRequest
+				|| setup.bRequestType == Intf_InRequest
+				|| setup.bRequestType == Ep_InRequest) {
+			char *buf;
+			/*
+			 * device: remote wakeup, selfpowered
+			 * interface: nothing
+			 * endpoint: halt
+			 */
+			buf = (char *)urb->transfer_buffer;
+			if (urb->transfer_buffer_length > 0) {
+				if (setup.bRequestType == Ep_InRequest) {
+					ep2 = find_endpoint(dum, w_index);
+					if (!ep2) {
+						ret_val = -EOPNOTSUPP;
+						break;
+					}
+					buf[0] = ep2->halted;
+				} else if (setup.bRequestType ==
+					   Dev_InRequest) {
+					buf[0] = (u8)dum->devstatus;
+				} else
+					buf[0] = 0;
+			}
+			if (urb->transfer_buffer_length > 1)
+				buf[1] = 0;
+			urb->actual_length = min_t(u32, 2,
+				urb->transfer_buffer_length);
+			ret_val = 0;
+			*status = 0;
+		}
+		break;
+	}
+	return ret_val;
+}
+
 /* drive both sides of the transfers; looks like irq handlers to
  * both drivers except the callbacks aren't in_irq().
  */
@@ -1297,14 +1464,8 @@ restart:
 		if (ep == &dum->ep [0] && ep->setup_stage) {
 			struct usb_ctrlrequest		setup;
 			int				value = 1;
-			struct dummy_ep			*ep2;
-			unsigned			w_index;
-			unsigned			w_value;
 
 			setup = *(struct usb_ctrlrequest*) urb->setup_packet;
-			w_index = le16_to_cpu(setup.wIndex);
-			w_value = le16_to_cpu(setup.wValue);
-
 			/* paranoia, in case of stale queued data */
 			list_for_each_entry (req, &ep->queue, queue) {
 				list_del_init (&req->queue);
@@ -1326,117 +1487,8 @@ restart:
 			ep->last_io = jiffies;
 			ep->setup_stage = 0;
 			ep->halted = 0;
-			switch (setup.bRequest) {
-			case USB_REQ_SET_ADDRESS:
-				if (setup.bRequestType != Dev_Request)
-					break;
-				dum->address = w_value;
-				status = 0;
-				dev_dbg (udc_dev(dum), "set_address = %d\n",
-						w_value);
-				value = 0;
-				break;
-			case USB_REQ_SET_FEATURE:
-				if (setup.bRequestType == Dev_Request) {
-					value = 0;
-					switch (w_value) {
-					case USB_DEVICE_REMOTE_WAKEUP:
-						break;
-					case USB_DEVICE_B_HNP_ENABLE:
-						dum->gadget.b_hnp_enable = 1;
-						break;
-					case USB_DEVICE_A_HNP_SUPPORT:
-						dum->gadget.a_hnp_support = 1;
-						break;
-					case USB_DEVICE_A_ALT_HNP_SUPPORT:
-						dum->gadget.a_alt_hnp_support
-							= 1;
-						break;
-					default:
-						value = -EOPNOTSUPP;
-					}
-					if (value == 0) {
-						dum->devstatus |=
-							(1 << w_value);
-						status = 0;
-					}
 
-				} else if (setup.bRequestType == Ep_Request) {
-					// endpoint halt
-					ep2 = find_endpoint (dum, w_index);
-					if (!ep2 || ep2->ep.name == ep0name) {
-						value = -EOPNOTSUPP;
-						break;
-					}
-					ep2->halted = 1;
-					value = 0;
-					status = 0;
-				}
-				break;
-			case USB_REQ_CLEAR_FEATURE:
-				if (setup.bRequestType == Dev_Request) {
-					switch (w_value) {
-					case USB_DEVICE_REMOTE_WAKEUP:
-						dum->devstatus &= ~(1 <<
-							USB_DEVICE_REMOTE_WAKEUP);
-						value = 0;
-						status = 0;
-						break;
-					default:
-						value = -EOPNOTSUPP;
-						break;
-					}
-				} else if (setup.bRequestType == Ep_Request) {
-					// endpoint halt
-					ep2 = find_endpoint (dum, w_index);
-					if (!ep2) {
-						value = -EOPNOTSUPP;
-						break;
-					}
-					if (!ep2->wedged)
-						ep2->halted = 0;
-					value = 0;
-					status = 0;
-				}
-				break;
-			case USB_REQ_GET_STATUS:
-				if (setup.bRequestType == Dev_InRequest
-						|| setup.bRequestType
-							== Intf_InRequest
-						|| setup.bRequestType
-							== Ep_InRequest
-						) {
-					char *buf;
-
-					// device: remote wakeup, selfpowered
-					// interface: nothing
-					// endpoint: halt
-					buf = (char *)urb->transfer_buffer;
-					if (urb->transfer_buffer_length > 0) {
-						if (setup.bRequestType ==
-								Ep_InRequest) {
-	ep2 = find_endpoint (dum, w_index);
-	if (!ep2) {
-		value = -EOPNOTSUPP;
-		break;
-	}
-	buf [0] = ep2->halted;
-						} else if (setup.bRequestType ==
-								Dev_InRequest) {
-							buf [0] = (u8)
-								dum->devstatus;
-						} else
-							buf [0] = 0;
-					}
-					if (urb->transfer_buffer_length > 1)
-						buf [1] = 0;
-					urb->actual_length = min_t(u32, 2,
-						urb->transfer_buffer_length);
-					value = 0;
-					status = 0;
-				}
-				break;
-			}
+			value = handle_control_request(dum, urb, &status);
 
 			/* gadget driver handles all other requests.  block
 			 * until setup() returns; no reentrancy issues etc.
-- 
1.6.3.3

--
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
