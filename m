Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967Ab0DIWLq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 18:11:46 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:58401 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751223Ab0DIWLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 18:11:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=i7spad3PPUw3VX8JmjCvEdKpjSwSSB5oHhAbmPkKGyS4g0otHYdiWynZ9IwTk3zT13DHRnDKkG/Dc8XG41CliIe8ecA1v6/5rPqtkjM/1yXw9zlpUH48N9RhVcc7ke1a;
Date: Fri, 9 Apr 2010 15:11:48 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@gmail.com>, James Simmons <jsimmons@infradead.org>
Subject: [PATCH] drm: add locked variant of drm_fb_helper_force_kernel_mode
Message-ID: <20100409151148.4312e5cb@virtuousgeek.org>
In-Reply-To: <20100409151050.74ef6dcd@virtuousgeek.org>
References: <20100409151050.74ef6dcd@virtuousgeek.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Needed for panic and kdb, since we need to avoid taking the mode_config
mutex.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/gpu/drm/drm_fb_helper.c |   42 +++++++++++++++++++++++++++++++++-----
 1 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 6929f5b..962eadb 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -242,18 +242,22 @@ static int drm_fb_helper_parse_command_line(struct drm_fb_helper *fb_helper)
 	return 0;
 }
 
-bool drm_fb_helper_force_kernel_mode(void)
+bool drm_fb_helper_force_kernel_mode_locked(void)
 {
 	int i = 0;
 	bool ret, error = false;
 	struct drm_fb_helper *helper;
-
-	if (list_empty(&kernel_fb_helper_list))
-		return false;
+	struct drm_mode_set *mode_set;
+	struct drm_crtc *crtc;
 
 	list_for_each_entry(helper, &kernel_fb_helper_list, kernel_fb_list) {
 		for (i = 0; i < helper->crtc_count; i++) {
-			struct drm_mode_set *mode_set = &helper->crtc_info[i].mode_set;
+			mode_set = &helper->crtc_info[i].mode_set;
+			crtc = helper->crtc_info[i].mode_set.crtc;
+
+			if (!crtc->enabled)
+				continue;
+
 			ret = drm_crtc_helper_set_config(mode_set);
 			if (ret)
 				error = true;
@@ -262,11 +266,37 @@ bool drm_fb_helper_force_kernel_mode(void)
 	return error;
 }
 
+bool drm_fb_helper_force_kernel_mode(void)
+{
+	bool ret;
+	struct drm_device *dev;
+	struct drm_fb_helper *helper;
+	struct drm_mode_set *mode_set;
+
+	if (list_empty(&kernel_fb_helper_list)) {
+		DRM_DEBUG_KMS("no fb helper list??\n");
+		return false;
+	}
+
+	/* Get the DRM device */
+	helper = list_first_entry(&kernel_fb_helper_list,
+				  struct drm_fb_helper,
+				  kernel_fb_list);
+	mode_set = &helper->crtc_info[0].mode_set;
+	dev = mode_set->crtc->dev;
+
+	mutex_lock(&dev->mode_config.mutex);
+	ret = drm_fb_helper_force_kernel_mode_locked();
+	mutex_unlock(&dev->mode_config.mutex);
+
+	return ret;
+}
+
 int drm_fb_helper_panic(struct notifier_block *n, unsigned long ununsed,
 			void *panic_str)
 {
 	DRM_ERROR("panic occurred, switching back to text console\n");
-	return drm_fb_helper_force_kernel_mode();
+	drm_fb_helper_force_kernel_mode_locked();
 	return 0;
 }
 EXPORT_SYMBOL(drm_fb_helper_panic);
-- 
1.6.6.1


