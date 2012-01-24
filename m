Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932735Ab2AXCru (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:47:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50541 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932713Ab2AXCrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:47:43 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:30 2012
Message-Id: <20120124023930.482183636@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:34:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Haogang Chen <haogangchen@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [074/129] [media] uvcvideo: Fix integer overflow in uvc_ioctl_ctrl_map()
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1836
Lines: 53

From: Haogang Chen <haogangchen@gmail.com>

commit 806e23e95f94a27ee445022d724060b9b45cb64a upstream.

There is a potential integer overflow in uvc_ioctl_ctrl_map(). When a
large xmap->menu_count is passed from the userspace, the subsequent call
to kmalloc() will allocate a buffer smaller than expected.
map->menu_count and map->menu_info would later be used in a loop (e.g.
in uvc_query_v4l2_ctrl), which leads to out-of-bound access.

The patch checks the ioctl argument and returns -EINVAL for zero or too
large values in xmap->menu_count.

Signed-off-by: Haogang Chen <haogangchen@gmail.com>
[laurent.pinchart@ideasonboard.com Prevent excessive memory consumption]
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/uvc/uvc_v4l2.c |    9 +++++++++
 drivers/media/video/uvc/uvcvideo.h |    1 +
 2 files changed, 10 insertions(+)

--- a/drivers/media/video/uvc/uvc_v4l2.c
+++ b/drivers/media/video/uvc/uvc_v4l2.c
@@ -58,6 +58,15 @@ static int uvc_ioctl_ctrl_map(struct uvc
 		break;
 
 	case V4L2_CTRL_TYPE_MENU:
+		/* Prevent excessive memory consumption, as well as integer
+		 * overflows.
+		 */
+		if (xmap->menu_count == 0 ||
+		    xmap->menu_count > UVC_MAX_CONTROL_MENU_ENTRIES) {
+			ret = -EINVAL;
+			goto done;
+		}
+
 		size = xmap->menu_count * sizeof(*map->menu_info);
 		map->menu_info = kmalloc(size, GFP_KERNEL);
 		if (map->menu_info == NULL) {
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -113,6 +113,7 @@
 
 /* Maximum allowed number of control mappings per device */
 #define UVC_MAX_CONTROL_MAPPINGS	1024
+#define UVC_MAX_CONTROL_MENU_ENTRIES	32
 
 /* Devices quirks */
 #define UVC_QUIRK_STATUS_INTERVAL	0x00000001


