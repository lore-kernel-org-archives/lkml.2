Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934062Ab0JSNlK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 09:41:10 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54942 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933717Ab0JSNlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 09:41:09 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6140"; a="58491313"
From: Tatyana Brokhman <tlinder@codeaurora.org>
To: linux-usb@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Tatyana Brokhman <tlinder@codeaurora.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/2] usb: dummy_hcd code simplification
Date: Tue, 19 Oct 2010 15:40:39 +0200
Message-Id: <1287495641-22802-1-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Take handling of the control requests out from dummy_timer to a different
function.

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>
---
 drivers/usb/gadget/dummy_hcd.c |  250 +++++++++++++++++++++-------------------
 1 files changed, 134 insertions(+), 116 deletions(-)

diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
index dc65462..ff93fea 100644
--- a/drivers/usb/gadget/dummy_hcd.c
+++ b/drivers/usb/gadget/dummy_hcd.c
@@ -1195,6 +1195,138 @@ static struct dummy_ep *find_endpoint (struct dummy *dum, u8 address)
 #define Ep_Request	(USB_TYPE_STANDARD | USB_RECIP_ENDPOINT)
 #define Ep_InRequest	(Ep_Request | USB_DIR_IN)
 
+
+/**
+ * handle_control_request() - handles all control transferes
+ *
+ * @dum - pointer to dummy (the_controller)
+ * @urb - the urb request to handle
+ * @status - pointer to request handling status
+ *
+ * Return 0 - if the request was handled
+ *	  1 - if the request wasn't handles
+ *	  error code on error
+ */
+static int handle_control_request(struct dummy *dum, struct urb *urb,
+				  struct usb_ctrlrequest setup,
+				  int *status)
+{
+	struct dummy_ep		*ep2;
+	int			ret_val = 1;
+	unsigned	w_index;
+	unsigned	w_value;
+
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
@@ -1297,14 +1429,8 @@ restart:
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
@@ -1326,117 +1452,9 @@ restart:
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
+			value = handle_control_request(dum, urb, setup,
+						       &status);
 
 			/* gadget driver handles all other requests.  block
 			 * until setup() returns; no reentrancy issues etc.
-- 
1.6.3.3

--
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
