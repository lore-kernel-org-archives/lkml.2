Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab1EQNFY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 09:05:24 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:62494 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747Ab1EQNFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 09:05:17 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6348"; a="91602519"
From: Tatyana Brokhman <tlinder@codeaurora.org>
To: greg@kroah.com
Cc: linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org, balbi@ti.com,
        ablay@codeaurora.org, Tatyana Brokhman <tlinder@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH/RESEND v10 6/7] usb:gadget: Introduce usb_generate_ss_descriptors()
Date: Tue, 17 May 2011 16:03:20 +0300
Message-Id: <1305637403-3832-7-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1305637403-3832-1-git-send-email-tlinder@codeaurora.org>
References: <1305637403-3832-1-git-send-email-tlinder@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements the usb_generate_ss_descriptors() function that is
used to automatically generate SuperSpeed descriptors for gadget drivers
that didn't provide any of their own. If a gadget driver wishes to have
the SuperSpeed descriptors generated for it, it should set the
function->generate_ss_desc flag to 1.

This patch is not to be mainlined since in the long run we want all gadget
drivers that wish to operate in SuperSpeed connection to provide their own
SupeSpeed descriptors. The purpose of this patch is to assist developers
in the early stages of their work.

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

---
 drivers/usb/gadget/composite.c |  137 +++++++++++++++++++++++++++++++++++++++-
 include/linux/usb/composite.h  |    4 +
 2 files changed, 140 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 5be5f6d..874e8cc 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -74,6 +74,127 @@ MODULE_PARM_DESC(iSerialNumber, "SerialNumber string");
 
 static char composite_manufacturer[50];
 
+/*
+ * Default endpoint companion descriptor:
+ * Bursting is not supported
+ * Streaming is not supported
+ */
+static struct usb_ss_ep_comp_descriptor default_ep_comp_desc = {
+		.bDescriptorType = USB_DT_SS_ENDPOINT_COMP,
+		.bLength = USB_DT_SS_EP_COMP_SIZE,
+		.bMaxBurst = 0,
+		.bmAttributes = 0,
+		.wBytesPerInterval = 0,
+};
+
+/**
+ * usb_generate_ss_descriptors() - Generate SuperSpeed
+ * descriptors with default values
+ * @f: pointer to usb_function to generate the descriptors for
+ *
+ * This function receives a pointer to usb_function and adds
+ * missing super speed descriptors in the ss_descriptor field
+ * according to its hs_descriptors field.
+ *
+ * This function copies f->hs_descriptors while updating the
+ * endpoint descriptor and adding endpoint companion descriptor.
+ */
+static void usb_generate_ss_descriptors(struct usb_function *f)
+{
+
+	struct usb_ss_ep_comp_descriptor *ep_comp_desc;
+	struct usb_endpoint_descriptor	*ep_desc ;
+	struct usb_descriptor_header **tmp;
+	struct usb_descriptor_header **src = f->hs_descriptors;
+	unsigned bytes;
+	unsigned n_desc;
+	void *mem;
+
+	if (!f->hs_descriptors)
+		return;
+
+	/*
+	 * Count number of EPs (in order to know how many SS_EP_COMPANION
+	 * descriptors to add), the total number of descriptors and the sum of
+	 * each descriptor bLength field in order to know how much memory to
+	 * allocate.
+	 */
+	for (bytes = 0, n_desc = 0, tmp = src; *tmp; tmp++, n_desc++) {
+		if ((*tmp)->bDescriptorType == USB_DT_ENDPOINT) {
+			bytes += default_ep_comp_desc.bLength;
+			n_desc++;
+		}
+		bytes += (*tmp)->bLength;
+	}
+
+	bytes += (n_desc + 1) * sizeof(*tmp);
+	mem = kmalloc(bytes, GFP_KERNEL);
+	if (!mem)
+		return;
+
+	/*
+	 * Fill in pointers starting at "tmp", to descriptors copied starting
+	 * at "mem" and return "ret"
+	 */
+	tmp = mem;
+	f->ss_descriptors  = mem;
+	mem += (n_desc + 1) * sizeof(*tmp);
+	while (*src) {
+		/* Copy the original descriptor */
+		memcpy(mem, *src, (*src)->bLength);
+		switch ((*src)->bDescriptorType) {
+		case USB_DT_ENDPOINT:
+			/* update ep descriptor */
+			ep_desc = (struct usb_endpoint_descriptor *)mem;
+			switch (ep_desc->bmAttributes &
+				USB_ENDPOINT_XFERTYPE_MASK) {
+			case USB_ENDPOINT_XFER_CONTROL:
+				ep_desc->wMaxPacketSize = cpu_to_le16(512);
+				ep_desc->bInterval = 0;
+				break;
+			case USB_ENDPOINT_XFER_BULK:
+				ep_desc->wMaxPacketSize = cpu_to_le16(1024);
+				ep_desc->bInterval = 0;
+				break;
+			case USB_ENDPOINT_XFER_INT:
+			case USB_ENDPOINT_XFER_ISOC:
+				break;
+			}
+			*tmp = mem;
+			tmp++;
+			mem += (*src)->bLength;
+			/* add ep companion descriptor */
+			memcpy(mem, &default_ep_comp_desc,
+			       default_ep_comp_desc.bLength);
+			*tmp = mem;
+			tmp++;
+			/* Update wBytesPerInterval for periodic endpoints */
+			ep_comp_desc = mem;
+			switch (ep_desc->bmAttributes &
+				USB_ENDPOINT_XFERTYPE_MASK) {
+			case USB_ENDPOINT_XFER_INT:
+			case USB_ENDPOINT_XFER_ISOC:
+				ep_comp_desc->wBytesPerInterval =
+					ep_desc->wMaxPacketSize;
+				break;
+			}
+			mem += default_ep_comp_desc.bLength;
+			break;
+		default:
+			*tmp = mem;
+			tmp++;
+			mem += (*src)->bLength;
+			break;
+		}
+		src++;
+	}
+	/*
+	 * The last (struct usb_descriptor_header *) in the descriptors
+	 * vector is NULL
+	 */
+	*tmp = NULL;
+}
+
 /*-------------------------------------------------------------------------*/
 /**
  * next_ep_desc() - advance to the next EP descriptor
@@ -235,6 +356,14 @@ int usb_add_function(struct usb_configuration *config,
 			list_del(&function->list);
 			function->config = NULL;
 		}
+		/*
+		 * Add SS descriptors if there aren't any. This has to be done
+		 * after the bind since we need the hs_descriptors to be set in
+		 * usb_function and some of the FDs does it in the bind.
+		 */
+		if ((gadget_is_superspeed(config->cdev->gadget)) &&
+		    (function->generate_ss_desc) && (!function->ss_descriptors))
+			usb_generate_ss_descriptors(function);
 	} else
 		value = 0;
 
@@ -1341,12 +1470,18 @@ composite_unbind(struct usb_gadget *gadget)
 			f = list_first_entry(&c->functions,
 					struct usb_function, list);
 			list_del(&f->list);
+			/*
+			 * Free memory for SS descriptors if they were
+			 * automaticaly generated
+			 */
+			if (f->generate_ss_desc)
+				usb_free_descriptors(f->ss_descriptors);
 			if (f->unbind) {
 				DBG(cdev, "unbind function '%s'/%p\n",
 						f->name, f);
 				f->unbind(c, f);
-				/* may free memory for "f" */
 			}
+			/* may free memory for "f" */
 		}
 		list_del(&c->list);
 		if (c->unbind) {
diff --git a/include/linux/usb/composite.h b/include/linux/usb/composite.h
index 511bc2a..4e28b2f 100644
--- a/include/linux/usb/composite.h
+++ b/include/linux/usb/composite.h
@@ -65,6 +65,8 @@ struct usb_configuration;
  *	default values while working in superspeed mode. If this
  *	pointer is null after initiation, the function will not
  *	be available at super speed.
+ * @generate_ss_desc: This flag is used by the FD to indicate that it wishes
+ *	SS descriptors to be automatically generated for it.
  * @config: assigned when @usb_add_function() is called; this is the
  *	configuration with which this function is associated.
  * @bind: Before the gadget can register, all of its functions bind() to the
@@ -118,6 +120,8 @@ struct usb_function {
 	struct usb_descriptor_header	**hs_descriptors;
 	struct usb_descriptor_header	**ss_descriptors;
 
+	unsigned			generate_ss_desc:1;
+
 	struct usb_configuration	*config;
 
 	/* REVISIT:  bind() functions can be marked __init, which
-- 
1.7.3.3

--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
