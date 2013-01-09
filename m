Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933256Ab3AIUiX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:38:23 -0500
Received: from mail.kernel.org ([198.145.19.201]:42000 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933218Ab3AIUiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:38:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Bhupesh Sharma <bhupesh.sharma@st.com>, Felipe Balbi <balbi@ti.com>
Subject: [ 034/123] usb: gadget: uvc: fix error path in uvc_function_bind()
Date: Wed,  9 Jan 2013 12:34:33 -0800
Message-Id: <20130109201502.926951767@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit 0f9df939385527049c8062a099fbfa1479fe7ce0 upstream.

The "video->minor = -1" assigment is done in V4L2 by
video_register_device() so it is removed here.
Now. uvc_function_bind() calls in error case uvc_function_unbind() for
cleanup. The problem is that uvc_function_unbind() frees the uvc struct
and uvc_bind_config() does as well in error case of usb_add_function().
Removing kfree() in usb_add_function() would make the patch smaller but
it would look odd because the new allocated memory is not cleaned up.
However it is not guaranteed that if we call usb_add_function() we also
get to the bind function.
Therefore the patch extracts the conditional cleanup from
uvc_function_unbind() applies to uvc_function_bind().
uvc_function_unbind() now contains only the complete cleanup which is
required once everything has been registrated.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Bhupesh Sharma <bhupesh.sharma@st.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/f_uvc.c |   39 +++++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 18 deletions(-)

--- a/drivers/usb/gadget/f_uvc.c
+++ b/drivers/usb/gadget/f_uvc.c
@@ -417,7 +417,6 @@ uvc_register_video(struct uvc_device *uv
 		return -ENOMEM;
 
 	video->parent = &cdev->gadget->dev;
-	video->minor = -1;
 	video->fops = &uvc_v4l2_fops;
 	video->release = video_device_release;
 	strncpy(video->name, cdev->gadget->name, sizeof(video->name));
@@ -577,23 +576,12 @@ uvc_function_unbind(struct usb_configura
 
 	INFO(cdev, "uvc_function_unbind\n");
 
-	if (uvc->vdev) {
-		if (uvc->vdev->minor == -1)
-			video_device_release(uvc->vdev);
-		else
-			video_unregister_device(uvc->vdev);
-		uvc->vdev = NULL;
-	}
-
-	if (uvc->control_ep)
-		uvc->control_ep->driver_data = NULL;
-	if (uvc->video.ep)
-		uvc->video.ep->driver_data = NULL;
+	video_unregister_device(uvc->vdev);
+	uvc->control_ep->driver_data = NULL;
+	uvc->video.ep->driver_data = NULL;
 
-	if (uvc->control_req) {
-		usb_ep_free_request(cdev->gadget->ep0, uvc->control_req);
-		kfree(uvc->control_buf);
-	}
+	usb_ep_free_request(cdev->gadget->ep0, uvc->control_req);
+	kfree(uvc->control_buf);
 
 	kfree(f->descriptors);
 	kfree(f->hs_descriptors);
@@ -740,7 +728,22 @@ uvc_function_bind(struct usb_configurati
 	return 0;
 
 error:
-	uvc_function_unbind(c, f);
+	if (uvc->vdev)
+		video_device_release(uvc->vdev);
+
+	if (uvc->control_ep)
+		uvc->control_ep->driver_data = NULL;
+	if (uvc->video.ep)
+		uvc->video.ep->driver_data = NULL;
+
+	if (uvc->control_req) {
+		usb_ep_free_request(cdev->gadget->ep0, uvc->control_req);
+		kfree(uvc->control_buf);
+	}
+
+	kfree(f->descriptors);
+	kfree(f->hs_descriptors);
+	kfree(f->ss_descriptors);
 	return ret;
 }
 


