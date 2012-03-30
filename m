Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936292Ab2C3Vhu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:37:50 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41405 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966107Ab2C3VcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:32:19 -0400
X-Sasl-enc: DspvMlfCUmA06I20BMqk3vguNOojgxqwmp0rxTMkvbeM 1333143138
X-Mailbox-Line: From gregkh@linuxfoundation.org Fri Mar 30 12:48:58 2012
Message-Id: <20120330194858.191250727@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:51:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Keith Packard <keithp@keithp.com>,
        Petr Tesarik <kernel@tesarici.cz>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Dave Airlie <airlied@redhat.com>, Bojan Smojver <bojan@rexursive.com>,
        Andreas Hartmann <andihartmann@01019freenet.de>
Subject: [ 159/175] drm/i915: suspend fbdev device around suspend/hibernate
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 3fa016a0b5c5237e9c387fc3249592b2cb5391c6 upstream.

Looking at hibernate overwriting I though it looked like a cursor,
so I tracked down this missing piece to stop the cursor blink
timer. I've no idea if this is sufficient to fix the hibernate
problems people are seeing, but please test it.

Both radeon and nouveau have done this for a long time.

I've run this personally all night hib/resume cycles with no fails.

Reviewed-by: Keith Packard <keithp@keithp.com>
Reported-by: Petr Tesarik <kernel@tesarici.cz>
Reported-by: Stanislaw Gruszka <sgruszka@redhat.com>
Reported-by: Lots of misc segfaults after hibernate across the world.
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=37142
Tested-by: Dave Airlie <airlied@redhat.com>
Tested-by: Bojan Smojver <bojan@rexursive.com>
Tested-by: Andreas Hartmann <andihartmann@01019freenet.de>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_drv.c  |    7 +++++++
 drivers/gpu/drm/i915/intel_drv.h |    2 +-
 drivers/gpu/drm/i915/intel_fb.c  |   10 ++++++++++
 3 files changed, 18 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -442,6 +442,10 @@ static int i915_drm_freeze(struct drm_de
 	/* Modeset on resume, not lid events */
 	dev_priv->modeset_on_lid = 0;
 
+	console_lock();
+	intel_fbdev_set_suspend(dev, 1);
+	console_unlock();
+
 	return 0;
 }
 
@@ -514,6 +518,9 @@ static int i915_drm_thaw(struct drm_devi
 
 	dev_priv->modeset_on_lid = 0;
 
+	console_lock();
+	intel_fbdev_set_suspend(dev, 0);
+	console_unlock();
 	return error;
 }
 
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -381,7 +381,7 @@ extern int intel_framebuffer_init(struct
 				  struct drm_i915_gem_object *obj);
 extern int intel_fbdev_init(struct drm_device *dev);
 extern void intel_fbdev_fini(struct drm_device *dev);
-
+extern void intel_fbdev_set_suspend(struct drm_device *dev, int state);
 extern void intel_prepare_page_flip(struct drm_device *dev, int plane);
 extern void intel_finish_page_flip(struct drm_device *dev, int pipe);
 extern void intel_finish_page_flip_plane(struct drm_device *dev, int plane);
--- a/drivers/gpu/drm/i915/intel_fb.c
+++ b/drivers/gpu/drm/i915/intel_fb.c
@@ -258,6 +258,16 @@ void intel_fbdev_fini(struct drm_device
 	kfree(dev_priv->fbdev);
 	dev_priv->fbdev = NULL;
 }
+
+void intel_fbdev_set_suspend(struct drm_device *dev, int state)
+{
+	drm_i915_private_t *dev_priv = dev->dev_private;
+	if (!dev_priv->fbdev)
+		return;
+
+	fb_set_suspend(dev_priv->fbdev->helper.fbdev, state);
+}
+
 MODULE_LICENSE("GPL and additional rights");
 
 void intel_fb_output_poll_changed(struct drm_device *dev)


