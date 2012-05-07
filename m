Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab2EGHNN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 03:13:13 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:59054 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754614Ab2EGHNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 03:13:11 -0400
From: Bhupesh Sharma <bhupesh.sharma@st.com>
To: <laurent.pinchart@ideasonboard.com>, <linux-usb@vger.kernel.org>
Cc: <balbi@ti.com>, <linux-kernel@vger.kernel.org>,
        Bhupesh Sharma <bhupesh.sharma@st.com>
Subject: [PATCH 1/1] usb: gadget/uvc: Add support for 'USB_GADGET_DELAYED_STATUS' response for a set_intf(alt-set 1) command
Date: Mon, 7 May 2012 12:42:37 +0530
Message-ID: <65fb24c9f639ec8cedab04799bc59d43c5683a08.1336374550.git.bhupesh.sharma@st.com>
X-Mailer: git-send-email 1.6.0.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the support in UVC webcam gadget design for providing
USB_GADGET_DELAYED_STATUS in response to a set_interface(alt setting 1) command
issue by the Host.

The current UVC webcam gadget design generates a STREAMON event corresponding
to a set_interface(alt setting 1) command from the Host.
This STREAMON event will eventually be routed to a real V4L2 device.

To start video streaming, it may be required to perform some register writes to
a camera sensor device over slow external busses like I2C or SPI. So, it makes
sense to ensure that we delay the STATUS stage of the
set_interface(alt setting 1) command.

Otherwise, a lot of ISOC IN tokens sent by the Host will be replied to by
zero-length packets by the webcam device. On certain Hosts this may even lead to
ISOC URBs been cancelled from the Host side.

So, as soon as we finish doing all the "streaming" related stuff on the real
V4L2 device, we call a STREAMON ioctl on the UVC side and from here we call
the 'usb_composite_setup_continue' function to complete the status stage of
the set_interface(alt setting 1) command.

Signed-off-by: Bhupesh Sharma <bhupesh.sharma@st.com>
---
 drivers/usb/gadget/f_uvc.c    |   12 +++++++++++-
 drivers/usb/gadget/uvc.h      |    4 ++++
 drivers/usb/gadget/uvc_v4l2.c |   27 +++++++++++++++++++++++++--
 3 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/f_uvc.c b/drivers/usb/gadget/f_uvc.c
index d2569b2..6f084e3 100644
--- a/drivers/usb/gadget/f_uvc.c
+++ b/drivers/usb/gadget/f_uvc.c
@@ -209,6 +209,14 @@ uvc_function_get_alt(struct usb_function *f, unsigned interface)
 		return uvc->state == UVC_STATE_STREAMING ? 1 : 0;
 }
 
+void
+uvc_process_setup_continue(struct uvc_device *uvc)
+{
+	struct usb_composite_dev *cdev = uvc->func.config->cdev;
+
+	usb_composite_setup_continue(cdev);
+}
+
 static int
 uvc_function_set_alt(struct usb_function *f, unsigned interface, unsigned alt)
 {
@@ -271,7 +279,9 @@ uvc_function_set_alt(struct usb_function *f, unsigned interface, unsigned alt)
 		v4l2_event_queue(uvc->vdev, &v4l2_event);
 
 		uvc->state = UVC_STATE_STREAMING;
-		break;
+		uvc->vdev_is_streaming = false;
+
+		return USB_GADGET_DELAYED_STATUS;
 
 	default:
 		return -EINVAL;
diff --git a/drivers/usb/gadget/uvc.h b/drivers/usb/gadget/uvc.h
index bc78c60..56ac883 100644
--- a/drivers/usb/gadget/uvc.h
+++ b/drivers/usb/gadget/uvc.h
@@ -168,6 +168,9 @@ struct uvc_device
 	/* Events */
 	unsigned int event_length;
 	unsigned int event_setup_out : 1;
+
+	/* flags */
+	bool vdev_is_streaming;
 };
 
 static inline struct uvc_device *to_uvc(struct usb_function *f)
@@ -188,6 +191,7 @@ struct uvc_file_handle
  * Functions
  */
 
+extern void uvc_process_setup_continue(struct uvc_device *uvc);
 extern void uvc_endpoint_stream(struct uvc_device *dev);
 
 extern void uvc_function_connect(struct uvc_device *uvc);
diff --git a/drivers/usb/gadget/uvc_v4l2.c b/drivers/usb/gadget/uvc_v4l2.c
index f761bcb..379d8ac 100644
--- a/drivers/usb/gadget/uvc_v4l2.c
+++ b/drivers/usb/gadget/uvc_v4l2.c
@@ -242,7 +242,18 @@ uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if ((ret = uvc_queue_buffer(&video->queue, arg)) < 0)
 			return ret;
 
-		return uvc_video_pump(video);
+		/*
+		 * for the very first QBUF calls (until STREAMON is
+		 * called) we just need to queue the buffers and start
+		 * pumping the data to USB side only after STREAMON has
+		 * been called which is handled by the STREAMON case
+		 * below. For QBUF calls after STREAMON, we need to pump
+		 * the data to the USB side here itself.
+		 */
+		if (uvc->vdev_is_streaming)
+			return uvc_video_pump(video);
+
+		return 0;
 
 	case VIDIOC_DQBUF:
 		return uvc_dequeue_buffer(&video->queue, arg,
@@ -255,7 +266,19 @@ uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (*type != video->queue.type)
 			return -EINVAL;
 
-		return uvc_video_enable(video, 1);
+		ret = uvc_video_enable(video, 1);
+		if (ret < 0)
+			return ret;
+
+		/*
+		 * since the real video device has now started streaming
+		 * its safe now to complete the status phase of the
+		 * set_interface (alt setting 1)
+		 */
+		uvc_process_setup_continue(uvc);
+		uvc->vdev_is_streaming = true;
+
+		return 0;
 	}
 
 	case VIDIOC_STREAMOFF:
-- 
1.7.2.2

