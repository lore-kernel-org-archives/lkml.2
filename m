Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935783Ab2C3VMV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:12:21 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64808 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935766Ab2C3VMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:12:14 -0400
Message-Id: <20120330194848.585514642@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:49:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Bernie Thompson <bernie@plugable.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [ 067/149] udlfb: remove sysfs framebuffer device with USB .disconnect()
In-Reply-To: <20120330195823.GA31857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kay Sievers <kay.sievers@vrfy.org>

commit ce880cb860f36694d2cdebfac9e6ae18176fe4c4 upstream.

The USB graphics card driver delays the unregistering of the framebuffer
device to a workqueue, which breaks the userspace visible remove uevent
sequence. Recent userspace tools started to support USB graphics card
hotplug out-of-the-box and rely on proper events sent by the kernel.

The framebuffer device is a direct child of the USB interface which is
removed immediately after the USB .disconnect() callback. But the fb device
in /sys stays around until its final cleanup, at a time where all the parent
devices have been removed already.

To work around that, we remove the sysfs fb device directly in the USB
.disconnect() callback and leave only the cleanup of the internal fb
data to the delayed work.

Before:
 add      /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2 (usb)
 add      /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2:1.0 (usb)
 add      /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2:1.0/graphics/fb0 (graphics)
 remove   /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2:1.0 (usb)
 remove   /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2 (usb)
 remove   /2-1.2:1.0/graphics/fb0 (graphics)

After:
 add      /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2 (usb)
 add      /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2:1.0 (usb)
 add      /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2:1.0/graphics/fb1 (graphics)
 remove   /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2:1.0/graphics/fb1 (graphics)
 remove   /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2:1.0 (usb)
 remove   /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2 (usb)

Tested-by: Bernie Thompson <bernie@plugable.com>
Acked-by: Bernie Thompson <bernie@plugable.com>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/fbmem.c |   18 +++++++++++++++++-
 drivers/video/udlfb.c |    2 +-
 include/linux/fb.h    |    1 +
 3 files changed, 19 insertions(+), 2 deletions(-)

--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1651,6 +1651,7 @@ static int do_unregister_framebuffer(str
 	if (ret)
 		return -EINVAL;
 
+	unlink_framebuffer(fb_info);
 	if (fb_info->pixmap.addr &&
 	    (fb_info->pixmap.flags & FB_PIXMAP_DEFAULT))
 		kfree(fb_info->pixmap.addr);
@@ -1658,7 +1659,6 @@ static int do_unregister_framebuffer(str
 	registered_fb[i] = NULL;
 	num_registered_fb--;
 	fb_cleanup_device(fb_info);
-	device_destroy(fb_class, MKDEV(FB_MAJOR, i));
 	event.info = fb_info;
 	fb_notifier_call_chain(FB_EVENT_FB_UNREGISTERED, &event);
 
@@ -1667,6 +1667,22 @@ static int do_unregister_framebuffer(str
 	return 0;
 }
 
+int unlink_framebuffer(struct fb_info *fb_info)
+{
+	int i;
+
+	i = fb_info->node;
+	if (i < 0 || i >= FB_MAX || registered_fb[i] != fb_info)
+		return -EINVAL;
+
+	if (fb_info->dev) {
+		device_destroy(fb_class, MKDEV(FB_MAJOR, i));
+		fb_info->dev = NULL;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(unlink_framebuffer);
+
 void remove_conflicting_framebuffers(struct apertures_struct *a,
 				     const char *name, bool primary)
 {
--- a/drivers/video/udlfb.c
+++ b/drivers/video/udlfb.c
@@ -1739,7 +1739,7 @@ static void dlfb_usb_disconnect(struct u
 	for (i = 0; i < ARRAY_SIZE(fb_device_attrs); i++)
 		device_remove_file(info->dev, &fb_device_attrs[i]);
 	device_remove_bin_file(info->dev, &edid_attr);
-
+	unlink_framebuffer(info);
 	usb_set_intfdata(interface, NULL);
 
 	/* if clients still have us open, will be freed on last close */
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -997,6 +997,7 @@ extern ssize_t fb_sys_write(struct fb_in
 /* drivers/video/fbmem.c */
 extern int register_framebuffer(struct fb_info *fb_info);
 extern int unregister_framebuffer(struct fb_info *fb_info);
+extern int unlink_framebuffer(struct fb_info *fb_info);
 extern void remove_conflicting_framebuffers(struct apertures_struct *a,
 				const char *name, bool primary);
 extern int fb_prepare_logo(struct fb_info *fb_info, int rotate);


