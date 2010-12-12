Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab0LLSjk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 13:39:40 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:42245 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455Ab0LLSjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 13:39:39 -0500
Date: Sun, 12 Dec 2010 12:39:22 -0600
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: [PATCH] [correction] load fbcon from drm_kms_helper
Message-ID: <20101212183921.GA25744@spacedout.fries.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.7 (SpacedOut.fries.net [127.0.0.1]); Sun, 12 Dec 2010 12:39:23 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kconfig says fbcon is required by drm_kms_helper.  If radeon, fbcon,
and drm_kms_helper are all modules, radeon is auto loaded (by PCI id?),
drm_kms_helper is loaded because of the module dependency, but fbcon
isn't loaded leaving the console unusable.  Since fbcon is required
and there isn't an explicit module dependency, request the module
to be loaded from drm_kms_helper.

Signed-off-by: David Fries <david@fries.net>
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
---
The last patch had a typo 'namue', mental reminder, test again after
running checkpatch.pl.

This solves compiling CONFIG_FB=m and being left with a blank screen
because the radeon module is automatically loaded, but fbcon isn't.
If radeon had to be manually loaded, then it would be the user's fault
for
not loading fbcon as well, but as radeon is being loaded
automatically,
there isn't much a user can do from console to even fix it.  More bug
details from here,
https://bugzilla.kernel.org/show_bug.cgi?id=16221

Does this look like a reasonable solution?  Should it bother checking
find_module first?

 drivers/gpu/drm/drm_fb_helper.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index d2849e4..41e3c3c 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -1530,3 +1530,24 @@ bool drm_fb_helper_hotplug_event(struct drm_fb_helper *fb_helper)
 }
 EXPORT_SYMBOL(drm_fb_helper_hotplug_event);
 
+/* The Kconfig DRM_KMS_HELPER selects FRAMEBUFFER_CONSOLE (if !EMBEDDED)
+ * but the module doesn't depend on any fb console symbols.  At least
+ * attempt to load fbcon to avoid leaving the system without a usable console.
+ */
+#if defined(CONFIG_FRAMEBUFFER_CONSOLE_MODULE) && !defined(CONFIG_EMBEDDED)
+static int __init drm_fb_helper_modinit(void)
+{
+	const char *name = "fbcon";
+	struct module *fbcon;
+
+	mutex_lock(&module_mutex);
+	fbcon = find_module(name);
+	mutex_unlock(&module_mutex);
+
+	if (!fbcon)
+		request_module_nowait(name);
+	return 0;
+}
+
+module_init(drm_fb_helper_modinit);
+#endif
-- 
1.7.2.3

