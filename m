Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544Ab2LMPCe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:02:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44167 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085Ab2LMODe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:03:34 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Airlie <airlied@redhat.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 046/241] drm/udl: fix stride issues scanning out stride != width*bpp
Date: Thu, 13 Dec 2012 11:56:51 -0200
Message-Id: <1355407206-17100-47-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/udl/udl_drv.h      |    2 +-
 drivers/gpu/drm/udl/udl_fb.c       |   12 +++++++-----
 drivers/gpu/drm/udl/udl_transfer.c |    5 +++--
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/udl/udl_drv.h b/drivers/gpu/drm/udl/udl_drv.h
index fccd361..87aa5f5 100644
--- a/drivers/gpu/drm/udl/udl_drv.h
+++ b/drivers/gpu/drm/udl/udl_drv.h
@@ -104,7 +104,7 @@ udl_fb_user_fb_create(struct drm_device *dev,
 
 int udl_render_hline(struct drm_device *dev, int bpp, struct urb **urb_ptr,
 		     const char *front, char **urb_buf_ptr,
-		     u32 byte_offset, u32 byte_width,
+		     u32 byte_offset, u32 device_byte_offset, u32 byte_width,
 		     int *ident_ptr, int *sent_ptr);
 
 int udl_dumb_create(struct drm_file *file_priv,
diff --git a/drivers/gpu/drm/udl/udl_fb.c b/drivers/gpu/drm/udl/udl_fb.c
index ce9a611..6f6ca50 100644
--- a/drivers/gpu/drm/udl/udl_fb.c
+++ b/drivers/gpu/drm/udl/udl_fb.c
@@ -114,9 +114,10 @@ static void udlfb_dpy_deferred_io(struct fb_info *info,
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
@@ -187,10 +188,11 @@ int udl_handle_damage(struct udl_framebuffer *fb, int x, int y,
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
diff --git a/drivers/gpu/drm/udl/udl_transfer.c b/drivers/gpu/drm/udl/udl_transfer.c
index b9320e2..fc11344 100644
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
-- 
1.7.9.5

