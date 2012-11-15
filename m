Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993298Ab2KOEXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:23:40 -0500
Received: from mail.kernel.org ([198.145.19.201]:49737 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993146Ab2KOEMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:12:33 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Dave Airlie <airlied@redhat.com>
Subject: [ 17/57] drm/udl: fix stride issues scanning out stride != width*bpp
Date: Wed, 14 Nov 2012 20:11:25 -0800
Message-Id: <20121115040934.277156928@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040933.223998671@linuxfoundation.org>
References: <20121115040933.223998671@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 3916e1d71b62b120888aa50bcc8d9a6200fc19a7 upstream.

When buffer sharing with the i915 and using a 1680x1050 monitor,
the i915 gives is a 6912 buffer for the 6720 width, the code doesn't
render this properly as it uses one value to set the base address for
reading from the vmap and for where to start on the device.

This fixes it by calculating the values correctly for the device and
for the pixmap. No idea how I haven't seen this before now.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/udl/udl_drv.h      |    2 +-
 drivers/gpu/drm/udl/udl_fb.c       |   12 +++++++-----
 drivers/gpu/drm/udl/udl_transfer.c |    5 +++--
 3 files changed, 11 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/udl/udl_drv.h
+++ b/drivers/gpu/drm/udl/udl_drv.h
@@ -103,7 +103,7 @@ udl_fb_user_fb_create(struct drm_device
 
 int udl_render_hline(struct drm_device *dev, int bpp, struct urb **urb_ptr,
 		     const char *front, char **urb_buf_ptr,
-		     u32 byte_offset, u32 byte_width,
+		     u32 byte_offset, u32 device_byte_offset, u32 byte_width,
 		     int *ident_ptr, int *sent_ptr);
 
 int udl_dumb_create(struct drm_file *file_priv,
--- a/drivers/gpu/drm/udl/udl_fb.c
+++ b/drivers/gpu/drm/udl/udl_fb.c
@@ -114,9 +114,10 @@ static void udlfb_dpy_deferred_io(struct
 	list_for_each_entry(cur, &fbdefio->pagelist, lru) {
 
 		if (udl_render_hline(dev, (ufbdev->ufb.base.bits_per_pixel / 8),
-				  &urb, (char *) info->fix.smem_start,
-				  &cmd, cur->index << PAGE_SHIFT,
-				  PAGE_SIZE, &bytes_identical, &bytes_sent))
+				     &urb, (char *) info->fix.smem_start,
+				     &cmd, cur->index << PAGE_SHIFT,
+				     cur->index << PAGE_SHIFT,
+				     PAGE_SIZE, &bytes_identical, &bytes_sent))
 			goto error;
 		bytes_rendered += PAGE_SIZE;
 	}
@@ -178,10 +179,11 @@ int udl_handle_damage(struct udl_framebu
 	for (i = y; i < y + height ; i++) {
 		const int line_offset = fb->base.pitches[0] * i;
 		const int byte_offset = line_offset + (x * bpp);
-
+		const int dev_byte_offset = (fb->base.width * bpp * i) + (x * bpp);
 		if (udl_render_hline(dev, bpp, &urb,
 				     (char *) fb->obj->vmapping,
-				     &cmd, byte_offset, width * bpp,
+				     &cmd, byte_offset, dev_byte_offset,
+				     width * bpp,
 				     &bytes_identical, &bytes_sent))
 			goto error;
 	}
--- a/drivers/gpu/drm/udl/udl_transfer.c
+++ b/drivers/gpu/drm/udl/udl_transfer.c
@@ -213,11 +213,12 @@ static void udl_compress_hline16(
  */
 int udl_render_hline(struct drm_device *dev, int bpp, struct urb **urb_ptr,
 		     const char *front, char **urb_buf_ptr,
-		     u32 byte_offset, u32 byte_width,
+		     u32 byte_offset, u32 device_byte_offset,
+		     u32 byte_width,
 		     int *ident_ptr, int *sent_ptr)
 {
 	const u8 *line_start, *line_end, *next_pixel;
-	u32 base16 = 0 + (byte_offset / bpp) * 2;
+	u32 base16 = 0 + (device_byte_offset / bpp) * 2;
 	struct urb *urb = *urb_ptr;
 	u8 *cmd = *urb_buf_ptr;
 	u8 *cmd_end = (u8 *) urb->transfer_buffer + urb->transfer_buffer_length;


