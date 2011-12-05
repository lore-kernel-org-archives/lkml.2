Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab1LEIX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 03:23:29 -0500
Received: from www.linutronix.de ([62.245.132.108]:53925 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab1LEIX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 03:23:27 -0500
Date: Mon, 5 Dec 2011 09:23:26 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Shimrit Malichi <smalichi@codeaurora.org>
Cc: Tatyana Brokhman <tlinder@codeaurora.org>,
        "open list:USB GADGET/PERIPH..." <linux-usb@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, target-devel@vger.kernel.org
Subject: Re: [RFC] UASP on target (was: [RFC/PATCH v4 1/3] uas: MS UAS
 Gadget driver - Infrastructure)
Message-ID: <20111205082326.GA2734@linutronix.de>
References: <1323028390-12846-1-git-send-email-smalichi@codeaurora.org>
 <20111205082047.GA2423@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20111205082047.GA2423@linutronix.de>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Andrzej Siewior | 2011-12-05 09:20:47 [+0100]:

>* Shimrit Malichi | 2011-12-04 21:53:09 [+0200]:
>
>>This patch implements the infrastructure for the UAS gadget driver.
>>The UAS gadget driver registers as a second configuration of the MS
>>gadet driver.
>hch said to use target framework and you haven't done so. This is what I
>have so far. It is not yet complete. What I need to do is:
>- wire up command processing (currently here)
>- wire up data processing
>- check it works => post v1
>- wire up command tagging => v2
>- remove hard codings and fix whatever people complained about.

diff --git a/drivers/target/Kconfig b/drivers/target/Kconfig
index e66fcc7..64d3204 100644
--- a/drivers/target/Kconfig
+++ b/drivers/target/Kconfig
@@ -50,3 +50,4 @@ source "drivers/target/tcm_qla2xxx/Kconfig"
 source "drivers/target/tcm_vhost/Kconfig"
 
 endif
+source "drivers/target/uasp/Kconfig"
diff --git a/drivers/target/Makefile b/drivers/target/Makefile
index 1945dba..b1135d5 100644
--- a/drivers/target/Makefile
+++ b/drivers/target/Makefile
@@ -28,3 +28,4 @@ obj-$(CONFIG_TCM_FC)		+= tcm_fc/
 obj-$(CONFIG_ISCSI_TARGET)	+= iscsi/
 obj-$(CONFIG_TCM_QLA2XXX)	+= tcm_qla2xxx/
 obj-$(CONFIG_TCM_VHOST)		+= tcm_vhost/
+obj-$(CONFIG_TARGET_UASP)	+= uasp/
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index f7cb64f..127496a 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -162,6 +162,13 @@ static struct config_group *target_core_register_fabric(
 				" tcm_loop.ko: %d\n", ret);
 			return ERR_PTR(-EINVAL);
 		}
+	} else if (!strncmp(name, "uasp", 4)) {
+		ret = request_module("tcm_uasp");
+		if (ret < 0) {
+			pr_err("request_module() failed for"
+				" tcm_loop.ko: %d\n", ret);
+			return ERR_PTR(-EINVAL);
+		}
 	}
 
 	tf = target_core_get_fabric(name);
diff --git a/drivers/target/uasp/Kconfig b/drivers/target/uasp/Kconfig
new file mode 100644
index 0000000..0d48a58
--- /dev/null
+++ b/drivers/target/uasp/Kconfig
@@ -0,0 +1,6 @@
+config TARGET_UASP
+	tristate "UASP fabric module"
+	depends on TARGET_CORE && CONFIGFS_FS
+	depends on USB_GADGET
+	---help---
+	Say Y here to enable the UASP fabric module
diff --git a/drivers/target/uasp/Makefile b/drivers/target/uasp/Makefile
new file mode 100644
index 0000000..25883ab
--- /dev/null
+++ b/drivers/target/uasp/Makefile
@@ -0,0 +1,5 @@
+CFLAGS_gadget.o			:= -I$(srctree)/drivers/usb/gadget
+tcm_uasp-objs			:= uasp_fabric.o \
+					gadget.o \
+					   uasp_configfs.o
+obj-$(CONFIG_TARGET_UASP)	+= tcm_uasp.o
diff --git a/drivers/target/uasp/gadget.c b/drivers/target/uasp/gadget.c
new file mode 100644
index 0000000..a1ad056
--- /dev/null
+++ b/drivers/target/uasp/gadget.c
@@ -0,0 +1,541 @@
+
+#include <linux/kernel.h>
+#include <linux/usb/ch9.h>
+#include <linux/usb/composite.h>
+#include <linux/usb/gadget.h>
+#include <linux/usb/storage.h>
+
+#include "gadget.h"
+#include "gadget_ops.h"
+#include "uasp_configfs.h"
+
+#include "usbstring.c"
+#include "epautoconf.c"
+#include "config.c"
+#include "composite.c"
+
+#define UAS_G_STR_MANUFACTOR	1
+#define UAS_G_STR_PRODUCT	2
+#define UAS_G_STR_SERIAL	3
+#define UAS_G_STR_CONFIG	4
+#define UAS_G_STR_INTERFACE	5
+
+#define UASP_SS_EP_COMP_NUM_STREAMS 4
+
+struct f_uas {
+	struct usb_function     function;
+	u16			iface;
+	struct usb_ep		*ep_in;
+	struct usb_ep		*ep_out;
+	struct usb_ep		*ep_status;
+	struct usb_ep		*ep_cmd;
+
+	struct usb_request	*req_in;
+	struct usb_request	*req_out;
+	struct usb_request	*req_status;
+	struct usb_request	*req_cmd;
+
+	void			*cmd_buff;
+	u32			flags;
+#define UASP_ACTIVE		(1 << 0)
+#define UASP_SS_MODE		(1 << 1)
+};
+
+static struct usb_interface_descriptor uasp_intf_desc = {
+	.bLength =		sizeof uasp_intf_desc,
+	.bDescriptorType =	USB_DT_INTERFACE,
+	.bNumEndpoints =	4,
+	.bInterfaceClass =	USB_CLASS_MASS_STORAGE,
+	.bInterfaceSubClass =	USB_SC_SCSI,
+	.bInterfaceProtocol =	USB_PR_UAS,
+	.iInterface =		UAS_G_STR_INTERFACE,
+};
+
+static struct usb_endpoint_descriptor uasp_bulk_in_desc = {
+	.bLength =		USB_DT_ENDPOINT_SIZE,
+	.bDescriptorType =	USB_DT_ENDPOINT,
+	.bEndpointAddress =	USB_DIR_IN,
+	.bmAttributes =		USB_ENDPOINT_XFER_BULK,
+	.wMaxPacketSize =	cpu_to_le16(512),
+};
+
+static struct usb_pipe_usage_descriptor uasp_bulk_in_pipe_usg_desc = {
+	.bLength =		sizeof uasp_bulk_in_pipe_usg_desc,
+	.bDescriptorType =	USB_DT_PIPE_USAGE,
+	.bPipeID =		PIPE_ID_DATA_IN,
+};
+
+static struct usb_endpoint_descriptor uasp_ss_bulk_in_desc = {
+	.bLength =		USB_DT_ENDPOINT_SIZE,
+	.bDescriptorType =	USB_DT_ENDPOINT,
+	.bEndpointAddress =	USB_DIR_IN,
+	.bmAttributes =		USB_ENDPOINT_XFER_BULK,
+	.wMaxPacketSize =	cpu_to_le16(1024),
+};
+
+static struct usb_ss_ep_comp_descriptor uasp_bulk_in_ep_comp_desc = {
+	.bLength =		sizeof uasp_bulk_in_ep_comp_desc,
+	.bDescriptorType =	USB_DT_SS_ENDPOINT_COMP,
+	.bMaxBurst =		0, /*
+				    * Doesn't support burst. Maybe update later?
+				    * Should it be HW dependent?
+				    */
+	.bmAttributes =		UASP_SS_EP_COMP_NUM_STREAMS,
+	.wBytesPerInterval =	0,
+};
+
+static struct usb_endpoint_descriptor uasp_bulk_out_desc = {
+	.bLength =		USB_DT_ENDPOINT_SIZE,
+	.bDescriptorType =	USB_DT_ENDPOINT,
+	.bEndpointAddress =	USB_DIR_OUT,
+	.bmAttributes =		USB_ENDPOINT_XFER_BULK,
+	.wMaxPacketSize =	cpu_to_le16(512),
+};
+
+static struct usb_pipe_usage_descriptor uasp_bulk_out_pipe_usg_desc = {
+	.bLength =		sizeof uasp_bulk_out_pipe_usg_desc,
+	.bDescriptorType =	USB_DT_PIPE_USAGE,
+	.bPipeID =		PIPE_ID_DATA_OUT,
+	.Reserved =		0,
+};
+
+static struct usb_endpoint_descriptor uasp_ss_bulk_out_desc = {
+	.bLength =		USB_DT_ENDPOINT_SIZE,
+	.bDescriptorType =	USB_DT_ENDPOINT,
+	.bEndpointAddress =	USB_DIR_OUT,
+	.bmAttributes =		USB_ENDPOINT_XFER_BULK,
+	.wMaxPacketSize =	cpu_to_le16(0x400),
+};
+
+static struct usb_ss_ep_comp_descriptor uasp_bulk_out_ep_comp_desc = {
+	.bLength =		sizeof uasp_bulk_out_ep_comp_desc,
+	.bDescriptorType =	USB_DT_SS_ENDPOINT_COMP,
+	.bmAttributes =		UASP_SS_EP_COMP_NUM_STREAMS,
+};
+
+static struct usb_endpoint_descriptor uasp_status_in_desc = {
+	.bLength =		USB_DT_ENDPOINT_SIZE,
+	.bDescriptorType =	USB_DT_ENDPOINT,
+	.bEndpointAddress =	USB_DIR_IN,
+	.bmAttributes =		USB_ENDPOINT_XFER_BULK,
+	.wMaxPacketSize =	cpu_to_le16(512),
+};
+
+static struct usb_pipe_usage_descriptor uasp_status_in_pipe_usg_desc = {
+	.bLength =		sizeof uasp_status_in_pipe_usg_desc,
+	.bDescriptorType =	USB_DT_PIPE_USAGE,
+	.bPipeID =		PIPE_ID_STS,
+};
+
+static struct usb_endpoint_descriptor uasp_ss_status_in_desc = {
+	.bLength =		USB_DT_ENDPOINT_SIZE,
+	.bDescriptorType =	USB_DT_ENDPOINT,
+	.bEndpointAddress =	USB_DIR_IN,
+	.bmAttributes =		USB_ENDPOINT_XFER_BULK,
+	.wMaxPacketSize =	cpu_to_le16(1024),
+};
+
+static struct usb_ss_ep_comp_descriptor uasp_status_in_ep_comp_desc = {
+	.bLength =		sizeof uasp_status_in_ep_comp_desc,
+	.bDescriptorType =	USB_DT_SS_ENDPOINT_COMP,
+	.bmAttributes =		UASP_SS_EP_COMP_NUM_STREAMS,
+};
+
+static struct usb_endpoint_descriptor uasp_command_out_desc = {
+	.bLength =		USB_DT_ENDPOINT_SIZE,
+	.bDescriptorType =	USB_DT_ENDPOINT,
+	.bEndpointAddress =	USB_DIR_OUT,
+	.bmAttributes =		USB_ENDPOINT_XFER_BULK,
+	.wMaxPacketSize =	cpu_to_le16(512),
+};
+
+static struct usb_pipe_usage_descriptor uasp_command_out_pipe_usg_desc = {
+	.bLength =		sizeof uasp_command_out_pipe_usg_desc,
+	.bDescriptorType =	USB_DT_PIPE_USAGE,
+	.bPipeID =		PIPE_ID_CMD,
+};
+
+static struct usb_endpoint_descriptor uasp_ss_command_out_desc = {
+	.bLength =		USB_DT_ENDPOINT_SIZE,
+	.bDescriptorType =	USB_DT_ENDPOINT,
+	.bEndpointAddress =	USB_DIR_OUT,
+	.bmAttributes =		USB_ENDPOINT_XFER_BULK,
+	.wMaxPacketSize =	cpu_to_le16(1024),
+};
+
+static struct usb_ss_ep_comp_descriptor uasp_command_out_ep_comp_desc = {
+	.bLength =		sizeof uasp_command_out_ep_comp_desc,
+	.bDescriptorType =	USB_DT_SS_ENDPOINT_COMP,
+};
+
+static struct usb_descriptor_header *uasp_hs_function_desc[] = {
+	(struct usb_descriptor_header *) &uasp_intf_desc,
+	(struct usb_descriptor_header *) &uasp_bulk_in_desc,
+	(struct usb_descriptor_header *) &uasp_bulk_in_pipe_usg_desc,
+	(struct usb_descriptor_header *) &uasp_bulk_out_desc,
+	(struct usb_descriptor_header *) &uasp_bulk_out_pipe_usg_desc,
+	(struct usb_descriptor_header *) &uasp_status_in_desc,
+	(struct usb_descriptor_header *) &uasp_status_in_pipe_usg_desc,
+	(struct usb_descriptor_header *) &uasp_command_out_desc,
+	(struct usb_descriptor_header *) &uasp_command_out_pipe_usg_desc,
+	NULL,
+};
+
+static struct usb_descriptor_header *uasp_ss_function_desc[] = {
+	(struct usb_descriptor_header *) &uasp_intf_desc,
+	(struct usb_descriptor_header *) &uasp_ss_bulk_in_desc,
+	(struct usb_descriptor_header *) &uasp_bulk_in_ep_comp_desc,
+	(struct usb_descriptor_header *) &uasp_bulk_in_pipe_usg_desc,
+	(struct usb_descriptor_header *) &uasp_ss_bulk_out_desc,
+	(struct usb_descriptor_header *) &uasp_bulk_out_ep_comp_desc,
+	(struct usb_descriptor_header *) &uasp_bulk_out_pipe_usg_desc,
+	(struct usb_descriptor_header *) &uasp_ss_status_in_desc,
+	(struct usb_descriptor_header *) &uasp_status_in_ep_comp_desc,
+	(struct usb_descriptor_header *) &uasp_status_in_pipe_usg_desc,
+	(struct usb_descriptor_header *) &uasp_ss_command_out_desc,
+	(struct usb_descriptor_header *) &uasp_command_out_ep_comp_desc,
+	(struct usb_descriptor_header *) &uasp_command_out_pipe_usg_desc,
+	NULL,
+};
+
+#define UAS_VENDOR_ID	0x0525	/* NetChip */
+#define UAS_PRODUCT_ID	0xa4a5	/* Linux-USB File-backed Storage Gadget */
+
+static struct usb_device_descriptor uas_device_desc = {
+	.bLength =              sizeof uas_device_desc,
+	.bDescriptorType =      USB_DT_DEVICE,
+	.bcdUSB =               cpu_to_le16(0x0200),
+	.bDeviceClass =         USB_CLASS_PER_INTERFACE,
+	.idVendor =             cpu_to_le16(UAS_VENDOR_ID),
+	.idProduct =            cpu_to_le16(UAS_PRODUCT_ID),
+	.bNumConfigurations =   1,
+};
+
+static struct usb_string	uas_us_strings[] = {
+	{ UAS_G_STR_MANUFACTOR,	"UAS Manufactor"},
+	{ UAS_G_STR_PRODUCT,	"UAS Product"},
+	{ UAS_G_STR_SERIAL,	"UAS Serial"},
+	{ UAS_G_STR_CONFIG,	"UAS Config"},
+	{ UAS_G_STR_INTERFACE,	"UAS Interface"},
+	{ },
+};
+
+static struct usb_gadget_strings uas_stringtab = {
+	.language = 0x0409,
+	.strings = uas_us_strings,
+};
+
+static struct usb_gadget_strings *uas_strings[] = {
+	&uas_stringtab,
+	NULL,
+};
+
+static int guas_unbind(struct usb_composite_dev *cdev)
+{
+	printk(KERN_ERR "%s()\n", __func__);
+	return 0;
+}
+
+static struct usb_configuration uasp_config_driver = {
+	.label                  = "Linux UASP Storage",
+	.bConfigurationValue    = 1,
+	.bmAttributes           = USB_CONFIG_ATT_SELFPOWER,
+};
+
+static struct f_uas *to_f_uas(struct usb_function *f)
+{
+	return container_of(f, struct f_uas, function);
+}
+
+static void give_back_ep(struct usb_ep **pep)
+{
+	struct usb_ep *ep = *pep;
+	if (!ep)
+		return;
+	ep->driver_data = NULL;
+}
+
+static int uasp_bind(struct usb_configuration *c, struct usb_function *f)
+{
+	struct f_uas		*fu = to_f_uas(f);
+	struct usb_gadget	*gadget = c->cdev->gadget;
+	struct usb_ep		*ep;
+	int			iface;
+
+	printk(KERN_ERR "%s(%d) %p, g%p\n", __func__, __LINE__, fu, gadget);
+
+	iface = usb_interface_id(c, f);
+	if (iface < 0)
+		return iface;
+
+	uasp_intf_desc.bInterfaceNumber = iface;
+	fu->iface = iface;
+	ep = usb_ep_autoconfig_ss(gadget, &uasp_ss_bulk_in_desc,
+			&uasp_bulk_in_ep_comp_desc);
+	if (!ep)
+		goto ep_fail;
+
+	ep->driver_data = fu;
+	fu->ep_in = ep;
+
+	ep = usb_ep_autoconfig_ss(gadget, &uasp_ss_bulk_out_desc,
+			&uasp_bulk_out_ep_comp_desc);
+	if (!ep)
+		goto ep_fail;
+	ep->driver_data = fu;
+	fu->ep_out = ep;
+
+	ep = usb_ep_autoconfig_ss(gadget, &uasp_ss_status_in_desc,
+			&uasp_status_in_ep_comp_desc);
+	if (!ep)
+		goto ep_fail;
+	ep->driver_data = fu;
+	fu->ep_status = ep;
+
+	ep = usb_ep_autoconfig_ss(gadget, &uasp_ss_command_out_desc,
+			&uasp_command_out_ep_comp_desc);
+	if (!ep)
+		goto ep_fail;
+	ep->driver_data = fu;
+	fu->ep_cmd = ep;
+
+	/* Assume endpoint addresses are the same for both speeds */
+	uasp_bulk_in_desc.bEndpointAddress =
+		uasp_ss_bulk_in_desc.bEndpointAddress;
+	uasp_bulk_out_desc.bEndpointAddress =
+		uasp_ss_bulk_out_desc.bEndpointAddress;
+	uasp_status_in_desc.bEndpointAddress =
+		uasp_ss_status_in_desc.bEndpointAddress;
+	uasp_command_out_desc.bEndpointAddress =
+		uasp_ss_command_out_desc.bEndpointAddress;
+	f->ss_descriptors = uasp_ss_function_desc;
+	return 0;
+ep_fail:
+	pr_err("Can't claim all required eps\n");
+
+	give_back_ep(&fu->ep_in);
+	give_back_ep(&fu->ep_out);
+	give_back_ep(&fu->ep_status);
+	give_back_ep(&fu->ep_cmd);
+	return -ENOTSUPP;
+}
+
+static void uasp_unbind(struct usb_configuration *c, struct usb_function *f)
+{
+	struct f_uas *fu = to_f_uas(f);
+
+	printk(KERN_ERR "%s(%d) %p\n", __func__, __LINE__, fu);
+	kfree(fu);
+}
+
+static void uasp_cleanup_old_alt(struct f_uas *fu)
+{
+	if (!(fu->flags & UASP_ACTIVE))
+		return;
+	fu->flags = 0;
+
+	usb_ep_disable(fu->ep_in);
+	usb_ep_disable(fu->ep_out);
+	usb_ep_disable(fu->ep_status);
+	usb_ep_disable(fu->ep_cmd);
+
+	usb_ep_free_request(fu->ep_in, fu->req_in);
+	usb_ep_free_request(fu->ep_out, fu->req_out);
+	usb_ep_free_request(fu->ep_status, fu->req_status);
+	usb_ep_free_request(fu->ep_cmd, fu->req_cmd);
+
+	fu->req_in = NULL;
+	fu->req_out = NULL;
+	fu->req_status = NULL;
+	fu->req_cmd = NULL;
+
+	kfree(fu->cmd_buff);
+	fu->cmd_buff = NULL;
+}
+
+static void guas_cmd_complete(struct usb_ep *ep, struct usb_request *req)
+{
+	printk(KERN_ERR "Tada %d\n", req->status);
+
+	if (req->status < 0) {
+		pr_err("%s() bad status\n", __func__);
+		return;
+	}
+
+	printk(KERN_ERR "%s() transfered %d bytes\n", __func__, req->actual);
+	print_hex_dump(KERN_ERR, "", DUMP_PREFIX_OFFSET,
+			16, 1,
+			req->buf, req->actual, false);
+}
+
+static int uasp_set_alt(struct usb_function *f, unsigned intf, unsigned alt)
+{
+	struct f_uas *fu = to_f_uas(f);
+	struct usb_gadget *gadget = f->config->cdev->gadget;
+	int ret;
+
+	printk(KERN_ERR "%s(%d) %d %d | %p %p\n", __func__, __LINE__, intf, alt,
+			fu, gadget);
+	uasp_cleanup_old_alt(fu);
+
+	if (gadget->speed == USB_SPEED_SUPER)
+			fu->flags |= UASP_SS_MODE;
+
+	config_ep_by_speed(gadget, f, fu->ep_in);
+	ret = usb_ep_enable(fu->ep_in);
+	if (ret)
+		goto err_b_in;
+
+	config_ep_by_speed(gadget, f, fu->ep_out);
+	ret = usb_ep_enable(fu->ep_out);
+	if (ret)
+		goto err_b_out;
+
+	config_ep_by_speed(gadget, f, fu->ep_cmd);
+	ret = usb_ep_enable(fu->ep_cmd);
+	if (ret)
+		goto err_cmd;
+	config_ep_by_speed(gadget, f, fu->ep_status);
+	ret = usb_ep_enable(fu->ep_status);
+	if (ret)
+		goto err_status;
+
+	ret = -ENOMEM;
+	fu->req_in = usb_ep_alloc_request(fu->ep_in, GFP_ATOMIC);
+	if (!fu->req_in)
+		goto err_req_bi;
+
+	fu->req_out = usb_ep_alloc_request(fu->ep_out, GFP_ATOMIC);
+	if (!fu->req_out)
+		goto err_req_bo;
+
+	fu->req_status = usb_ep_alloc_request(fu->ep_status, GFP_ATOMIC);
+	if (!fu->req_status)
+		goto err_req_status;
+
+	fu->req_cmd = usb_ep_alloc_request(fu->ep_cmd, GFP_ATOMIC);
+	if (!fu->req_cmd)
+		goto err_req_cmd;
+
+	fu->cmd_buff = kmalloc(fu->ep_cmd->maxpacket, GFP_ATOMIC);
+	if (!fu->cmd_buff)
+		goto err_cmd_buf;
+
+	fu->req_cmd->complete = guas_cmd_complete;
+	fu->req_cmd->buf = fu->cmd_buff;
+	fu->req_cmd->length = fu->ep_cmd->maxpacket;
+
+	ret = usb_ep_queue(fu->ep_cmd, fu->req_cmd, GFP_ATOMIC);
+	if (ret)
+		goto err_enqueue;
+
+	fu->flags |= UASP_ACTIVE;
+	return 0;
+
+err_enqueue:
+	kfree(fu->cmd_buff);
+	fu->cmd_buff = NULL;
+err_cmd_buf:
+	usb_ep_free_request(fu->ep_cmd, fu->req_cmd);
+	fu->req_cmd = NULL;
+err_req_cmd:
+	usb_ep_free_request(fu->ep_status, fu->req_status);
+	fu->req_status = NULL;
+err_req_status:
+	usb_ep_free_request(fu->ep_out, fu->req_out);
+	fu->req_out = NULL;
+err_req_bo:
+	usb_ep_free_request(fu->ep_in, fu->req_in);
+	fu->req_in = NULL;
+err_req_bi:
+	usb_ep_disable(fu->ep_status);
+err_status:
+	usb_ep_disable(fu->ep_cmd);
+err_cmd:
+	usb_ep_disable(fu->ep_out);
+err_b_out:
+	usb_ep_disable(fu->ep_in);
+err_b_in:
+	fu->flags = 0;
+	return ret;
+}
+
+static void uasp_disable(struct usb_function *f)
+{
+	struct f_uas *fu = to_f_uas(f);
+
+	printk(KERN_ERR "%s(%d) %p\n", __func__, __LINE__, fu);
+	uasp_cleanup_old_alt(fu);
+}
+
+static int uas_cfg_bind(struct usb_configuration *c)
+{
+	struct f_uas *fu;
+	int ret;
+
+	fu = kzalloc(sizeof *fu, GFP_KERNEL);
+	if (!fu)
+		return -ENOMEM;
+	fu->function.name = "UASP Function";
+	fu->function.descriptors = uasp_hs_function_desc;
+	fu->function.hs_descriptors = uasp_hs_function_desc;
+	fu->function.bind = uasp_bind;
+	fu->function.unbind = uasp_unbind;
+	fu->function.set_alt = uasp_set_alt;
+	fu->function.disable = uasp_disable;
+
+	ret = usb_add_function(c, &fu->function);
+	if (ret)
+		goto err;
+	return 0;
+err:
+	kfree(fu);
+	return ret;
+}
+
+static int guas_bind(struct usb_composite_dev *cdev)
+{
+	int ret;
+
+	ret = usb_add_config(cdev, &uasp_config_driver,
+			uas_cfg_bind);
+	return 0;
+}
+
+static struct usb_composite_driver uas_driver = {
+	.name           = "g_uas",
+	.dev            = &uas_device_desc,
+	.strings        = uas_strings,
+	.max_speed      = USB_SPEED_SUPER,
+	.unbind         = guas_unbind,
+};
+
+int gadget_attach(void)
+{
+	pr_err("%s(%d)\n", __func__, __LINE__);
+	return usb_composite_probe(&uas_driver, guas_bind);
+}
+
+void gadget_detach(void)
+{
+	usb_composite_unregister(&uas_driver);
+}
+
+static int __init guas_init(void)
+{
+	int ret;
+
+	ret = uasp_register_configfs();
+	return ret;
+}
+module_init(guas_init);
+
+static void __exit guas_exit(void)
+{
+	uasp_deregister_configfs();
+}
+module_exit(guas_exit);
+
+MODULE_AUTHOR("Sebastian Andrzej Siewior <bigeasy@linutronix.de>");
+MODULE_DESCRIPTION("UAS faabric");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/target/uasp/gadget.h b/drivers/target/uasp/gadget.h
new file mode 100644
index 0000000..fe3ccc1
--- /dev/null
+++ b/drivers/target/uasp/gadget.h
@@ -0,0 +1,17 @@
+#ifndef __GTARGET_UAS_H__
+#define __GTARGET_UAS_H__
+
+struct usb_pipe_usage_descriptor {
+	__u8  bLength;
+	__u8  bDescriptorType;
+
+	__u8  bPipeID;
+	/* Pipe ID defenitions: Table 9 from UAS spec*/
+#define PIPE_ID_CMD             0x01    /* Command pipe */
+#define PIPE_ID_STS             0x02    /* Status pipe */
+#define PIPE_ID_DATA_IN         0x03    /* Data-in piep */
+#define PIPE_ID_DATA_OUT        0x04    /* Data-out pipe */
+	__u8  Reserved;
+} __attribute__((__packed__));
+
+#endif
diff --git a/drivers/target/uasp/gadget_ops.h b/drivers/target/uasp/gadget_ops.h
new file mode 100644
index 0000000..109bc08
--- /dev/null
+++ b/drivers/target/uasp/gadget_ops.h
@@ -0,0 +1,7 @@
+#ifndef __GADGET_OPS_H__
+#define __GADGET_OPS_H__
+
+int gadget_attach(void);
+void gadget_detach(void);
+
+#endif
diff --git a/drivers/target/uasp/uasp_base.h b/drivers/target/uasp/uasp_base.h
new file mode 100644
index 0000000..b7a400a
--- /dev/null
+++ b/drivers/target/uasp/uasp_base.h
@@ -0,0 +1,32 @@
+#define UASP_VERSION  "v0.1"
+#define UASP_NAMELEN 32
+
+struct uasp_nacl {
+	/* Binary World Wide unique Port Name for SAS Initiator port */
+	u64 iport_wwpn;
+	/* ASCII formatted WWPN for Sas Initiator port */
+	char iport_name[UASP_NAMELEN];
+	/* Returned by uasp_make_nodeacl() */
+	struct se_node_acl se_node_acl;
+};
+
+struct uasp_tpg {
+	/* SAS port target portal group tag for TCM */
+	u16 tport_tpgt;
+	/* Pointer back to uasp_tport */
+	struct uasp_tport *tport;
+	/* Returned by uasp_make_tpg() */
+	struct se_portal_group se_tpg;
+	u32 gadget_connect;
+};
+
+struct uasp_tport {
+	/* SCSI protocol the tport is providing */
+	u8 tport_proto_id;
+	/* Binary World Wide unique Port Name for SAS Target port */
+	u64 tport_wwpn;
+	/* ASCII formatted WWPN for SAS Target port */
+	char tport_name[UASP_NAMELEN];
+	/* Returned by uasp_make_tport() */
+	struct se_wwn tport_wwn;
+};
diff --git a/drivers/target/uasp/uasp_configfs.c b/drivers/target/uasp/uasp_configfs.c
new file mode 100644
index 0000000..7f6b280
--- /dev/null
+++ b/drivers/target/uasp/uasp_configfs.c
@@ -0,0 +1,333 @@
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/version.h>
+#include <generated/utsrelease.h>
+#include <linux/utsname.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/kthread.h>
+#include <linux/types.h>
+#include <linux/string.h>
+#include <linux/configfs.h>
+#include <linux/ctype.h>
+#include <asm/unaligned.h>
+
+#include <target/target_core_base.h>
+#include <target/target_core_fabric.h>
+#include <target/target_core_fabric_configfs.h>
+#include <target/target_core_configfs.h>
+#include <target/configfs_macros.h>
+
+#include "uasp_base.h"
+#include "uasp_fabric.h"
+#include "gadget_ops.h"
+
+/* Local pointer to allocated TCM configfs fabric module */
+struct target_fabric_configfs *uasp_fabric_configfs;
+
+static const char *uasp_check_wwn(const char *name)
+{
+	const char *n;
+	unsigned int len;
+
+	n = strstr(name, "naa.");
+	if (!n)
+		return NULL;
+	n += 4;
+	len = strlen(n);
+	if (len == 0 || len > UASP_NAMELEN - 1)
+		return NULL;
+	return n;
+}
+
+static struct se_node_acl *uasp_make_nodeacl(
+	struct se_portal_group *se_tpg,
+	struct config_group *group,
+	const char *name)
+{
+	struct se_node_acl *se_nacl, *se_nacl_new;
+	struct uasp_nacl *nacl;
+	u64 wwpn = 0;
+	u32 nexus_depth;
+	const char *wnn_name;
+
+	wnn_name = uasp_check_wwn(name);
+	if (!wnn_name)
+		return ERR_PTR(-EINVAL);
+	se_nacl_new = uasp_alloc_fabric_acl(se_tpg);
+	if (!(se_nacl_new))
+		return ERR_PTR(-ENOMEM);
+//#warning FIXME: Hardcoded nexus depth in uasp_make_nodeacl()
+	nexus_depth = 1;
+	/*
+	 * se_nacl_new may be released by core_tpg_add_initiator_node_acl()
+	 * when converting a NodeACL from demo mode -> explict
+	 */
+	se_nacl = core_tpg_add_initiator_node_acl(se_tpg, se_nacl_new,
+				name, nexus_depth);
+	if (IS_ERR(se_nacl)) {
+		uasp_release_fabric_acl(se_tpg, se_nacl_new);
+		return se_nacl;
+	}
+	/*
+	 * Locate our struct uasp_nacl and set the FC Nport WWPN
+	 */
+	nacl = container_of(se_nacl, struct uasp_nacl, se_node_acl);
+	nacl->iport_wwpn = wwpn;
+	snprintf(nacl->iport_name, sizeof(nacl->iport_name), "%s", name);
+	return se_nacl;
+}
+
+static void uasp_drop_nodeacl(struct se_node_acl *se_acl)
+{
+	struct uasp_nacl *nacl = container_of(se_acl,
+				struct uasp_nacl, se_node_acl);
+	core_tpg_del_initiator_node_acl(se_acl->se_tpg, se_acl, 1);
+	kfree(nacl);
+}
+
+static struct se_portal_group *uasp_make_tpg(
+	struct se_wwn *wwn,
+	struct config_group *group,
+	const char *name)
+{
+	struct uasp_tport*tport = container_of(wwn,
+			struct uasp_tport, tport_wwn);
+
+	struct uasp_tpg *tpg;
+	unsigned long tpgt;
+	int ret;
+
+	if (strstr(name, "tpgt_") != name)
+		return ERR_PTR(-EINVAL);
+	if (strict_strtoul(name + 5, 10, &tpgt) || tpgt > UINT_MAX)
+		return ERR_PTR(-EINVAL);
+
+	tpg = kzalloc(sizeof(struct uasp_tpg), GFP_KERNEL);
+	if (!tpg) {
+		printk(KERN_ERR "Unable to allocate struct uasp_tpg");
+		return ERR_PTR(-ENOMEM);
+	}
+	tpg->tport = tport;
+	tpg->tport_tpgt = tpgt;
+
+	ret = core_tpg_register(&uasp_fabric_configfs->tf_ops, wwn,
+				&tpg->se_tpg, tpg,
+				TRANSPORT_TPG_TYPE_NORMAL);
+	if (ret < 0) {
+		kfree(tpg);
+		return NULL;
+	}
+	return &tpg->se_tpg;
+}
+
+static void uasp_drop_tpg(struct se_portal_group *se_tpg)
+{
+	struct uasp_tpg *tpg = container_of(se_tpg,
+				struct uasp_tpg, se_tpg);
+
+	core_tpg_deregister(se_tpg);
+	kfree(tpg);
+}
+
+static struct se_wwn *uasp_make_tport(
+	struct target_fabric_configfs *tf,
+	struct config_group *group,
+	const char *name)
+{
+	struct uasp_tport *tport;
+	const char *wnn_name;
+	u64 wwpn = 0;
+
+	wnn_name = uasp_check_wwn(name);
+	if (!wnn_name)
+		return ERR_PTR(-EINVAL);
+
+	tport = kzalloc(sizeof(struct uasp_tport), GFP_KERNEL);
+	if (!(tport)) {
+		printk(KERN_ERR "Unable to allocate struct uasp_tport");
+		return ERR_PTR(-ENOMEM);
+	}
+	tport->tport_wwpn = wwpn;
+	snprintf(tport->tport_name, sizeof(tport->tport_name), wnn_name);
+	return &tport->tport_wwn;
+}
+
+static void uasp_drop_tport(struct se_wwn *wwn)
+{
+	struct uasp_tport *tport = container_of(wwn,
+				struct uasp_tport, tport_wwn);
+	kfree(tport);
+}
+
+static ssize_t uasp_wwn_show_attr_version(
+	struct target_fabric_configfs *tf,
+	char *page)
+{
+	return sprintf(page, "UASP fabric module %s on %s/%s"
+		"on "UTS_RELEASE"\n", UASP_VERSION, utsname()->sysname,
+		utsname()->machine);
+}
+
+TF_WWN_ATTR_RO(uasp, version);
+
+static struct configfs_attribute *uasp_wwn_attrs[] = {
+	&uasp_wwn_version.attr,
+	NULL,
+};
+
+static ssize_t tcm_uasp_tpg_show_gadget_connect(
+		struct se_portal_group *se_tpg,
+		char *page)
+{
+	struct uasp_tpg  *tpg = container_of(se_tpg, struct uasp_tpg, se_tpg);
+
+	return snprintf(page, PAGE_SIZE, "%u\n", tpg->gadget_connect);
+}
+
+static ssize_t tcm_uasp_tpg_store_gadget_connect(
+		struct se_portal_group *se_tpg,
+		const char *page,
+		size_t count)
+{
+	struct uasp_tpg  *tpg = container_of(se_tpg, struct uasp_tpg, se_tpg);
+	unsigned int op;
+	ssize_t ret = count;
+
+	op = simple_strtoul(page, NULL, 0);
+	if (op > 1)
+		return -EINVAL;
+
+	if (op && tpg->gadget_connect)
+		goto out;
+	if (!op && !tpg->gadget_connect)
+		goto out;
+
+	if (op) {
+		ret = gadget_attach();
+		if (ret)
+			goto out;
+		ret = count;
+	} else {
+		gadget_detach();
+	}
+	tpg->gadget_connect = op;
+out:
+	return ret;
+}
+
+TF_TPG_BASE_ATTR(tcm_uasp, gadget_connect, S_IRUGO | S_IWUSR);
+
+static struct configfs_attribute *uasp_base_attrs[] = {
+	&tcm_uasp_tpg_gadget_connect.attr,
+	NULL,
+};
+
+static struct target_core_fabric_ops uasp_ops = {
+	.get_fabric_name		= uasp_get_fabric_name,
+	.get_fabric_proto_ident		= uasp_get_fabric_proto_ident,
+	.tpg_get_wwn			= uasp_get_fabric_wwn,
+	.tpg_get_tag			= uasp_get_tag,
+	.tpg_get_default_depth		= uasp_get_default_depth,
+	.tpg_get_pr_transport_id	= uasp_get_pr_transport_id,
+	.tpg_get_pr_transport_id_len	= uasp_get_pr_transport_id_len,
+	.tpg_parse_pr_out_transport_id	= uasp_parse_pr_out_transport_id,
+	.tpg_check_demo_mode		= uasp_check_false,
+	.tpg_check_demo_mode_cache	= uasp_check_true,
+	.tpg_check_demo_mode_write_protect = uasp_check_true,
+	.tpg_check_prod_mode_write_protect = uasp_check_false,
+	.tpg_alloc_fabric_acl		= uasp_alloc_fabric_acl,
+	.tpg_release_fabric_acl		= uasp_release_fabric_acl,
+	.tpg_get_inst_index		= uasp_tpg_get_inst_index,
+	.release_cmd			= uasp_release_cmd,
+	.shutdown_session		= uasp_shutdown_session,
+	.close_session			= uasp_close_session,
+	.stop_session			= uasp_stop_session,
+	.fall_back_to_erl0		= uasp_reset_nexus,
+	.sess_logged_in			= uasp_sess_logged_in,
+	.sess_get_index			= uasp_sess_get_index,
+	.sess_get_initiator_sid		= NULL,
+	.write_pending			= uasp_write_pending,
+	.write_pending_status		= uasp_write_pending_status,
+	.set_default_node_attributes	= uasp_set_default_node_attrs,
+	.get_task_tag			= uasp_get_task_tag,
+	.get_cmd_state			= uasp_get_cmd_state,
+	.queue_data_in			= uasp_queue_data_in,
+	.queue_status			= uasp_queue_status,
+	.queue_tm_rsp			= uasp_queue_tm_rsp,
+	.get_fabric_sense_len		= uasp_get_fabric_sense_len,
+	.set_fabric_sense_len		= uasp_set_fabric_sense_len,
+	.is_state_remove		= uasp_is_state_remove,
+	/*
+	 * Setup function pointers for generic logic in target_core_fabric_configfs.c
+	 */
+	.fabric_make_wwn		= uasp_make_tport,
+	.fabric_drop_wwn		= uasp_drop_tport,
+	.fabric_make_tpg		= uasp_make_tpg,
+	.fabric_drop_tpg		= uasp_drop_tpg,
+	.fabric_post_link		= NULL,
+	.fabric_pre_unlink		= NULL,
+	.fabric_make_np			= NULL,
+	.fabric_drop_np			= NULL,
+	.fabric_make_nodeacl		= uasp_make_nodeacl,
+	.fabric_drop_nodeacl		= uasp_drop_nodeacl,
+};
+
+int uasp_register_configfs(void)
+{
+	struct target_fabric_configfs *fabric;
+	int ret;
+
+	printk(KERN_INFO "UASP fabric module %s on %s/%s"
+		" on "UTS_RELEASE"\n",UASP_VERSION, utsname()->sysname,
+		utsname()->machine);
+	/*
+	 * Register the top level struct config_item_type with TCM core
+	 */
+	fabric = target_fabric_configfs_init(THIS_MODULE, "uasp");
+	if (!(fabric)) {
+		printk(KERN_ERR "target_fabric_configfs_init() failed\n");
+		return -ENOMEM;
+	}
+	/*
+	 * Setup fabric->tf_ops from our local uasp_ops
+	 */
+	fabric->tf_ops = uasp_ops;
+	/*
+	 * Setup default attribute lists for various fabric->tf_cit_tmpl
+	 */
+	TF_CIT_TMPL(fabric)->tfc_wwn_cit.ct_attrs = uasp_wwn_attrs;
+	TF_CIT_TMPL(fabric)->tfc_tpg_base_cit.ct_attrs = uasp_base_attrs;
+	TF_CIT_TMPL(fabric)->tfc_tpg_attrib_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(fabric)->tfc_tpg_param_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(fabric)->tfc_tpg_np_base_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_base_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_attrib_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_auth_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_param_cit.ct_attrs = NULL;
+	/*
+	 * Register the fabric for use within TCM
+	 */
+	ret = target_fabric_configfs_register(fabric);
+	if (ret < 0) {
+		printk(KERN_ERR "target_fabric_configfs_register() failed"
+				" for UASP\n");
+		return ret;
+	}
+	/*
+	 * Setup our local pointer to *fabric
+	 */
+	uasp_fabric_configfs = fabric;
+	printk(KERN_INFO "UASP[0] - Set fabric -> uasp_fabric_configfs\n");
+	return 0;
+};
+
+void uasp_deregister_configfs(void)
+{
+	if (!(uasp_fabric_configfs))
+		return;
+
+	target_fabric_configfs_deregister(uasp_fabric_configfs);
+	uasp_fabric_configfs = NULL;
+	printk(KERN_INFO "UASP[0] - Cleared uasp_fabric_configfs\n");
+};
diff --git a/drivers/target/uasp/uasp_configfs.h b/drivers/target/uasp/uasp_configfs.h
new file mode 100644
index 0000000..646c096
--- /dev/null
+++ b/drivers/target/uasp/uasp_configfs.h
@@ -0,0 +1,7 @@
+#ifndef __UASP_CONFIGFS_H_
+#define __UASP_CONFIGFS_H_
+
+int uasp_register_configfs(void);
+void uasp_deregister_configfs(void);
+
+#endif
diff --git a/drivers/target/uasp/uasp_fabric.c b/drivers/target/uasp/uasp_fabric.c
new file mode 100644
index 0000000..304c934
--- /dev/null
+++ b/drivers/target/uasp/uasp_fabric.c
@@ -0,0 +1,287 @@
+#include <linux/slab.h>
+#include <linux/kthread.h>
+#include <linux/types.h>
+#include <linux/list.h>
+#include <linux/types.h>
+#include <linux/string.h>
+#include <linux/ctype.h>
+#include <asm/unaligned.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/libfc.h>
+
+#include <target/target_core_base.h>
+#include <target/target_core_fabric.h>
+#include <target/target_core_configfs.h>
+
+#include "uasp_base.h"
+#include "uasp_fabric.h"
+
+int uasp_check_true(struct se_portal_group *se_tpg)
+{
+	printk(KERN_ERR "%s(%d)\n", __func__, __LINE__);
+	return 1;
+}
+
+int uasp_check_false(struct se_portal_group *se_tpg)
+{
+	printk(KERN_ERR "%s(%d)\n", __func__, __LINE__);
+	return 0;
+}
+
+char *uasp_get_fabric_name(void)
+{
+	printk(KERN_ERR "%s(%d)\n", __func__, __LINE__);
+	return "uasp";
+}
+
+u8 uasp_get_fabric_proto_ident(struct se_portal_group *se_tpg)
+{
+	struct uasp_tpg *tpg = container_of(se_tpg,
+				struct uasp_tpg, se_tpg);
+	struct uasp_tport *tport = tpg->tport;
+	u8 proto_id;
+
+	switch (tport->tport_proto_id) {
+	case SCSI_PROTOCOL_SAS:
+	default:
+		proto_id = sas_get_fabric_proto_ident(se_tpg);
+		break;
+	}
+
+	printk(KERN_ERR "%s(%d)\n", __func__, __LINE__);
+	return proto_id;
+}
+
+char *uasp_get_fabric_wwn(struct se_portal_group *se_tpg)
+{
+	struct uasp_tpg *tpg = container_of(se_tpg,
+				struct uasp_tpg, se_tpg);
+	struct uasp_tport *tport = tpg->tport;
+
+	printk(KERN_ERR "%s(%d) '%s'\n", __func__, __LINE__, tport->tport_name);
+	return &tport->tport_name[0];
+}
+
+u16 uasp_get_tag(struct se_portal_group *se_tpg)
+{
+	struct uasp_tpg *tpg = container_of(se_tpg,
+				struct uasp_tpg, se_tpg);
+	printk(KERN_ERR "%s(%d) %d\n", __func__, __LINE__, tpg->tport_tpgt);
+	return tpg->tport_tpgt;
+}
+
+u32 uasp_get_default_depth(struct se_portal_group *se_tpg)
+{
+	printk(KERN_ERR "%s(%d)\n", __func__, __LINE__);
+	return 1;
+}
+
+u32 uasp_get_pr_transport_id(
+	struct se_portal_group *se_tpg,
+	struct se_node_acl *se_nacl,
+	struct t10_pr_registration *pr_reg,
+	int *format_code,
+	unsigned char *buf)
+{
+	struct uasp_tpg *tpg = container_of(se_tpg,
+				struct uasp_tpg, se_tpg);
+	struct uasp_tport *tport = tpg->tport;
+	int ret = 0;
+
+	switch (tport->tport_proto_id) {
+	case SCSI_PROTOCOL_SAS:
+	default:
+		ret = sas_get_pr_transport_id(se_tpg, se_nacl, pr_reg,
+					format_code, buf);
+		break;
+	}
+
+	printk(KERN_ERR "%s(%d)\n", __func__, __LINE__);
+	return ret;
+}
+
+u32 uasp_get_pr_transport_id_len(
+	struct se_portal_group *se_tpg,
+	struct se_node_acl *se_nacl,
+	struct t10_pr_registration *pr_reg,
+	int *format_code)
+{
+	struct uasp_tpg *tpg = container_of(se_tpg,
+				struct uasp_tpg, se_tpg);
+	struct uasp_tport *tport = tpg->tport;
+	int ret = 0;
+
+	switch (tport->tport_proto_id) {
+	case SCSI_PROTOCOL_SAS:
+	default:
+		ret = sas_get_pr_transport_id_len(se_tpg, se_nacl, pr_reg,
+					format_code);
+		break;
+	}
+
+	printk(KERN_ERR "%s(%d)\n", __func__, __LINE__);
+	return ret;
+}
+
+char *uasp_parse_pr_out_transport_id(
+	struct se_portal_group *se_tpg,
+	const char *buf,
+	u32 *out_tid_len,
+	char **port_nexus_ptr)
+{
+	struct uasp_tpg *tpg = container_of(se_tpg,
+				struct uasp_tpg, se_tpg);
+	struct uasp_tport *tport = tpg->tport;
+	char *tid = NULL;
+
+	switch (tport->tport_proto_id) {
+	case SCSI_PROTOCOL_SAS:
+	default:
+		tid = sas_parse_pr_out_transport_id(se_tpg, buf, out_tid_len,
+					port_nexus_ptr);
+	}
+
+	printk(KERN_ERR "%s(%d)\n", __func__, __LINE__);
+	return tid;
+}
+
+struct se_node_acl *uasp_alloc_fabric_acl(struct se_portal_group *se_tpg)
+{
+	struct uasp_nacl *nacl;
+
+	nacl = kzalloc(sizeof(struct uasp_nacl), GFP_KERNEL);
+	if (!(nacl)) {
+		printk(KERN_ERR "Unable to alocate struct uasp_nacl\n");
+		return NULL;
+	}
+
+	printk(KERN_ERR "%s(%d)\n", __func__, __LINE__);
+	return &nacl->se_node_acl;
+}
+
+void uasp_release_fabric_acl(
+	struct se_portal_group *se_tpg,
+	struct se_node_acl *se_nacl)
+{
+	struct uasp_nacl *nacl = container_of(se_nacl,
+			struct uasp_nacl, se_node_acl);
+	printk(KERN_ERR "%s(%d)\n", __func__, __LINE__);
+	kfree(nacl);
+}
+
+u32 uasp_tpg_get_inst_index(struct se_portal_group *se_tpg)
+{
+	printk(KERN_ERR "%s(%d)\n", __func__, __LINE__);
+	return 1;
+}
+
+void uasp_release_cmd(struct se_cmd *se_cmd)
+{
+	printk(KERN_ERR "%s(%d)\n", __func__, __LINE__);
+	return;
+}
+
+int uasp_shutdown_session(struct se_session *se_sess)
+{
+	printk(KERN_ERR "%s(%d)\n", __func__, __LINE__);
+	return 0;
+}
+
+void uasp_close_session(struct se_session *se_sess)
+{
+	printk(KERN_ERR "%s(%d)\n", __func__, __LINE__);
+	return;
+}
+
+void uasp_stop_session(struct se_session *se_sess, int sess_sleep , int conn_sleep)
+{
+	printk(KERN_ERR "%s(%d)\n", __func__, __LINE__);
+	return;
+}
+
+void uasp_reset_nexus(struct se_session *se_sess)
+{
+	printk(KERN_ERR "%s(%d)\n", __func__, __LINE__);
+	return;
+}
+
+int uasp_sess_logged_in(struct se_session *se_sess)
+{
+	printk(KERN_ERR "%s(%d)\n", __func__, __LINE__);
+	return 0;
+}
+
+u32 uasp_sess_get_index(struct se_session *se_sess)
+{
+	printk(KERN_ERR "%s(%d)\n", __func__, __LINE__);
+	return 0;
+}
+
+int uasp_write_pending(struct se_cmd *se_cmd)
+{
+	printk(KERN_ERR "%s(%d)\n", __func__, __LINE__);
+	return 0;
+}
+
+int uasp_write_pending_status(struct se_cmd *se_cmd)
+{
+	printk(KERN_ERR "%s(%d)\n", __func__, __LINE__);
+	return 0;
+}
+
+void uasp_set_default_node_attrs(struct se_node_acl *nacl)
+{
+	printk(KERN_ERR "%s(%d)\n", __func__, __LINE__);
+	return;
+}
+
+u32 uasp_get_task_tag(struct se_cmd *se_cmd)
+{
+	printk(KERN_ERR "%s(%d)\n", __func__, __LINE__);
+	return 0;
+}
+
+int uasp_get_cmd_state(struct se_cmd *se_cmd)
+{
+	printk(KERN_ERR "%s(%d)\n", __func__, __LINE__);
+	return 0;
+}
+
+int uasp_queue_data_in(struct se_cmd *se_cmd)
+{
+	printk(KERN_ERR "%s(%d)\n", __func__, __LINE__);
+	return 0;
+}
+
+int uasp_queue_status(struct se_cmd *se_cmd)
+{
+	printk(KERN_ERR "%s(%d)\n", __func__, __LINE__);
+	return 0;
+}
+
+int uasp_queue_tm_rsp(struct se_cmd *se_cmd)
+{
+	printk(KERN_ERR "%s(%d)\n", __func__, __LINE__);
+	return 0;
+}
+
+u16 uasp_set_fabric_sense_len(struct se_cmd *se_cmd, u32 sense_length)
+{
+	printk(KERN_ERR "%s(%d)\n", __func__, __LINE__);
+	return 0;
+}
+
+u16 uasp_get_fabric_sense_len(void)
+{
+	printk(KERN_ERR "%s(%d)\n", __func__, __LINE__);
+	return 0;
+}
+
+int uasp_is_state_remove(struct se_cmd *se_cmd)
+{
+	printk(KERN_ERR "%s(%d)\n", __func__, __LINE__);
+	return 0;
+}
diff --git a/drivers/target/uasp/uasp_fabric.h b/drivers/target/uasp/uasp_fabric.h
new file mode 100644
index 0000000..cf5a300
--- /dev/null
+++ b/drivers/target/uasp/uasp_fabric.h
@@ -0,0 +1,37 @@
+int uasp_check_true(struct se_portal_group *);
+int uasp_check_false(struct se_portal_group *);
+char *uasp_get_fabric_name(void);
+u8 uasp_get_fabric_proto_ident(struct se_portal_group *);
+char *uasp_get_fabric_wwn(struct se_portal_group *);
+u16 uasp_get_tag(struct se_portal_group *);
+u32 uasp_get_default_depth(struct se_portal_group *);
+u32 uasp_get_pr_transport_id(struct se_portal_group *,
+			struct se_node_acl *, struct t10_pr_registration *,
+			int *, unsigned char *);
+u32 uasp_get_pr_transport_id_len(struct se_portal_group *,
+			struct se_node_acl *, struct t10_pr_registration *,
+			int *);
+char *uasp_parse_pr_out_transport_id(struct se_portal_group *,
+			const char *, u32 *, char **);
+struct se_node_acl *uasp_alloc_fabric_acl(struct se_portal_group *);
+void uasp_release_fabric_acl(struct se_portal_group *,
+			struct se_node_acl *);
+u32 uasp_tpg_get_inst_index(struct se_portal_group *);
+void uasp_release_cmd(struct se_cmd *);
+int uasp_shutdown_session(struct se_session *);
+void uasp_close_session(struct se_session *);
+void uasp_stop_session(struct se_session *, int, int);
+void uasp_reset_nexus(struct se_session *);
+int uasp_sess_logged_in(struct se_session *);
+u32 uasp_sess_get_index(struct se_session *);
+int uasp_write_pending(struct se_cmd *);
+int uasp_write_pending_status(struct se_cmd *);
+void uasp_set_default_node_attrs(struct se_node_acl *);
+u32 uasp_get_task_tag(struct se_cmd *);
+int uasp_get_cmd_state(struct se_cmd *);
+int uasp_queue_data_in(struct se_cmd *);
+int uasp_queue_status(struct se_cmd *);
+int uasp_queue_tm_rsp(struct se_cmd *);
+u16 uasp_set_fabric_sense_len(struct se_cmd *, u32);
+u16 uasp_get_fabric_sense_len(void);
+int uasp_is_state_remove(struct se_cmd *);
diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 5a084b9..84fb67a 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -774,6 +774,9 @@ config USB_MASS_STORAGE
 	  Say "y" to link the driver statically, or "m" to build
 	  a dynamically linked module called "g_mass_storage".
 
+comment "You need to go to the target framework for UASP support"
+	depends on TARGET_UASP=n
+
 config USB_G_SERIAL
 	tristate "Serial Gadget (with CDC ACM and CDC OBEX support)"
 	help

Sebastian
