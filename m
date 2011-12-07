Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933420Ab1LGQVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:21:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33885 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933384Ab1LGQVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:21:44 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:15 2011
Message-Id: <20111207161215.272114271@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:11:08 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Xi Wang <xi.wang@gmail.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [006/104] drm: integer overflow in drm_mode_dirtyfb_ioctl()
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xi Wang <xi.wang@gmail.com>

commit a5cd335165e31db9dbab636fd29895d41da55dd2 upstream.

There is a potential integer overflow in drm_mode_dirtyfb_ioctl()
if userspace passes in a large num_clips.  The call to kmalloc would
allocate a small buffer, and the call to fb->funcs->dirty may result
in a memory corruption.

Reported-by: Haogang Chen <haogangchen@gmail.com>
Signed-off-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/drm_crtc.c |    4 ++++
 include/drm/drm_mode.h     |    2 ++
 2 files changed, 6 insertions(+)

--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -1868,6 +1868,10 @@ int drm_mode_dirtyfb_ioctl(struct drm_de
 	}
 
 	if (num_clips && clips_ptr) {
+		if (num_clips < 0 || num_clips > DRM_MODE_FB_DIRTY_MAX_CLIPS) {
+			ret = -EINVAL;
+			goto out_err1;
+		}
 		clips = kzalloc(num_clips * sizeof(*clips), GFP_KERNEL);
 		if (!clips) {
 			ret = -ENOMEM;
--- a/include/drm/drm_mode.h
+++ b/include/drm/drm_mode.h
@@ -233,6 +233,8 @@ struct drm_mode_fb_cmd {
 #define DRM_MODE_FB_DIRTY_ANNOTATE_FILL 0x02
 #define DRM_MODE_FB_DIRTY_FLAGS         0x03
 
+#define DRM_MODE_FB_DIRTY_MAX_CLIPS     256
+
 /*
  * Mark a region of a framebuffer as dirty.
  *


