Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013Ab1FPNcX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 09:32:23 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24131 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757955Ab1FPNcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 09:32:17 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6378"; a="98075712"
From: Tatyana Brokhman <tlinder@codeaurora.org>
To: greg@kroah.com
Cc: linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org, balbi@ti.com,
        ablay@codeaurora.org, Tatyana Brokhman <tlinder@codeaurora.org>,
        Amit Blay <ablay@qualcomm.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH/RFC 5/5] usb: Add support for streams alloc/dealloc to devio.c
Date: Thu, 16 Jun 2011 16:31:07 +0300
Message-Id: <1308231068-24038-6-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1308231068-24038-2-git-send-email-tlinder@codeaurora.org>
References: <1308231068-24038-2-git-send-email-tlinder@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow user space applications such as LIBUSB, to request
streams alloc/dealloc from HCD that implements XHCI.

Signed-off-by: Amit Blay <ablay@qualcomm.com>
Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

---
 drivers/usb/core/devio.c     |  128 +++++++++++++++++++++++++++++++++++++++++-
 include/linux/usbdevice_fs.h |    5 ++
 2 files changed, 132 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 37518df..7e73e35 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -943,6 +943,115 @@ static int proc_clearhalt(struct dev_state *ps, void __user *arg)
 	return usb_clear_halt(ps->dev, pipe);
 }
 
+static int proc_allocstreams(struct dev_state *ps, void __user *arg)
+{
+	unsigned int ep_map;
+	int ret;
+	int intf_num;
+	struct usb_interface *intf = NULL;
+	const int max_eps = 32;
+	int max_streams = 0;
+	struct usb_host_endpoint *eps[max_eps];
+	int num_eps = 0;
+	int i;
+	unsigned int ep;
+
+	if (get_user(ep_map, (unsigned int __user *)arg))
+		return -EFAULT;
+
+	for (i = 0; i < max_eps; i++) {
+		if (ep_map & (0x1 << i)) {
+			/* Convert from i to ep address */
+			if (i < 16) /* IN EP */
+				ep = i | USB_ENDPOINT_DIR_MASK;
+			else /* OUT EP */
+				ep = (i - 16);
+
+			intf_num = findintfep(ps->dev, ep);
+			if (intf_num < 0)
+				return intf_num;
+			ret = checkintf(ps, intf_num);
+			if (ret)
+				return ret;
+			intf = usb_ifnum_to_if(ps->dev, intf_num);
+			if (!intf)
+				return -ENOENT;
+
+			if (ep & USB_ENDPOINT_DIR_MASK)
+				eps[num_eps] = ps->dev->ep_in[ep &
+					USB_ENDPOINT_NUMBER_MASK];
+			else
+				eps[num_eps] = ps->dev->ep_out[ep &
+					USB_ENDPOINT_NUMBER_MASK];
+
+			if (!max_streams)
+				max_streams = USB_SS_MAX_STREAMS(
+					eps[num_eps]->ss_ep_comp.bmAttributes);
+
+			num_eps++;
+		}
+	}
+
+	if (!intf || !max_streams)
+		return -ENOENT;
+
+	ret = usb_alloc_streams(intf, eps, num_eps, max_streams, GFP_KERNEL);
+	if (ret > 0)
+		return 0;
+	return ret;
+}
+
+static int proc_freestreams(struct dev_state *ps, void __user *arg)
+{
+	unsigned int ep_map;
+	int ret;
+	int intf_num;
+	struct usb_interface *intf = NULL;
+	const int max_eps = 32;
+	struct usb_host_endpoint *eps[max_eps];
+	int num_eps = 0;
+	int i;
+	unsigned int ep;
+
+	if (get_user(ep_map, (unsigned int __user *)arg))
+		return -EFAULT;
+
+	for (i = 0; i < max_eps; i++) {
+		if (ep_map & (0x1 << i)) {
+			/* Convert from i to ep address */
+			if (i < 16) /* IN EP */
+				ep = i | USB_ENDPOINT_DIR_MASK;
+			else /* OUT EP */
+				ep = (i - 16);
+
+			intf_num = findintfep(ps->dev, ep);
+			if (intf_num < 0)
+				return intf_num;
+			ret = checkintf(ps, intf_num);
+			if (ret)
+				return ret;
+			intf = usb_ifnum_to_if(ps->dev, intf_num);
+			if (!intf)
+				return -ENOENT;
+
+			if (ep & USB_ENDPOINT_DIR_MASK)
+				eps[num_eps] = ps->dev->ep_in[ep &
+					USB_ENDPOINT_NUMBER_MASK];
+			else
+				eps[num_eps] = ps->dev->ep_out[ep &
+					USB_ENDPOINT_NUMBER_MASK];
+
+			num_eps++;
+		}
+	}
+
+	if (!intf)
+		return -ENOENT;
+
+	usb_free_streams(intf, eps, num_eps, GFP_KERNEL);
+	return 0;
+}
+
 static int proc_getdriver(struct dev_state *ps, void __user *arg)
 {
 	struct usbdevfs_getdriver gd;
@@ -1236,6 +1345,8 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
 		u |= URB_NO_INTERRUPT;
 	as->urb->transfer_flags = u;
 
+	as->urb->stream_id = (uurb->type == USBDEVFS_URB_TYPE_BULK) ?
+		uurb->stream_id : 0;
 	as->urb->transfer_buffer_length = uurb->buffer_length;
 	as->urb->setup_packet = (unsigned char *)dr;
 	as->urb->start_frame = uurb->start_frame;
@@ -1491,7 +1602,8 @@ static int get_urb32(struct usbdevfs_urb *kurb,
 	    __get_user(kurb->start_frame, &uurb->start_frame) ||
 	    __get_user(kurb->number_of_packets, &uurb->number_of_packets) ||
 	    __get_user(kurb->error_count, &uurb->error_count) ||
-	    __get_user(kurb->signr, &uurb->signr))
+	    __get_user(kurb->signr, &uurb->signr) ||
+	    __get_user(kurb->stream_id, &uurb->stream_id))
 		return -EFAULT;
 
 	if (__get_user(uptr, &uurb->buffer))
@@ -1795,6 +1907,20 @@ static long usbdev_do_ioctl(struct file *file, unsigned int cmd,
 			inode->i_mtime = CURRENT_TIME;
 		break;
 
+	case USBDEVFS_ALLOC_STREAMS:
+		snoop(&dev->dev, "%s: ALLOC_STREAMS\n", __func__);
+		ret = proc_allocstreams(ps, p);
+		if (ret >= 0)
+			inode->i_mtime = CURRENT_TIME;
+		break;
+
+	case USBDEVFS_FREE_STREAMS:
+		snoop(&dev->dev, "%s: FREE_STREAMS\n", __func__);
+		ret = proc_freestreams(ps, p);
+		if (ret >= 0)
+			inode->i_mtime = CURRENT_TIME;
+		break;
+
 	case USBDEVFS_GETDRIVER:
 		snoop(&dev->dev, "%s: GETDRIVER\n", __func__);
 		ret = proc_getdriver(ps, p);
diff --git a/include/linux/usbdevice_fs.h b/include/linux/usbdevice_fs.h
index 15591d2..133c216 100644
--- a/include/linux/usbdevice_fs.h
+++ b/include/linux/usbdevice_fs.h
@@ -108,6 +108,7 @@ struct usbdevfs_urb {
 				  or 0 if none should be sent. */
 	void __user *usercontext;
 	struct usbdevfs_iso_packet_desc iso_frame_desc[0];
+	unsigned int stream_id;
 };
 
 /* ioctls for talking directly to drivers */
@@ -165,6 +166,7 @@ struct usbdevfs_urb32 {
 	compat_uint_t signr;
 	compat_caddr_t usercontext; /* unused */
 	struct usbdevfs_iso_packet_desc iso_frame_desc[0];
+	compat_uint_t stream_id;
 };
 
 struct usbdevfs_ioctl32 {
@@ -204,4 +206,7 @@ struct usbdevfs_ioctl32 {
 #define USBDEVFS_CONNECT           _IO('U', 23)
 #define USBDEVFS_CLAIM_PORT        _IOR('U', 24, unsigned int)
 #define USBDEVFS_RELEASE_PORT      _IOR('U', 25, unsigned int)
+#define USBDEVFS_ALLOC_STREAMS     _IOR('U', 26, unsigned int)
+#define USBDEVFS_FREE_STREAMS      _IOR('U', 27, unsigned int)
+
 #endif /* _LINUX_USBDEVICE_FS_H */
-- 
1.7.3.3

--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
