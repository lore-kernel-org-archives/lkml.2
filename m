Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761526Ab0GTUft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 16:35:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:38628 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755406Ab0GTUfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 16:35:45 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, dhowells@redhat.com, sfrench@samba.org,
        anton@samba.org, swhiteho@redhat.com, airlied@linux.ie,
        dri-devel@lists.freedesktop.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/7] drm: use workqueue instead of slow-work
Date: Tue, 20 Jul 2010 22:35:01 +0200
Message-Id: <1279658102-20069-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1279658102-20069-1-git-send-email-tj@kernel.org>
References: <1279658102-20069-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 20 Jul 2010 20:35:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Workqueue can now handle high concurrency.  Convert drm_crtc_helper to
use system_nrt_wq instead of slow-work.  The conversion is mostly
straight forward.  One difference is that drm_helper_hpd_irq_event()
no longer blocks and can be called from any context.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
---
 drivers/gpu/drm/drm_crtc_helper.c |   29 ++++++++++-------------------
 include/drm/drm_crtc.h            |    3 +--
 2 files changed, 11 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/drm_crtc_helper.c b/drivers/gpu/drm/drm_crtc_helper.c
index 9b2a541..7fa3380 100644
--- a/drivers/gpu/drm/drm_crtc_helper.c
+++ b/drivers/gpu/drm/drm_crtc_helper.c
@@ -808,13 +808,11 @@ int drm_helper_resume_force_mode(struct drm_device *dev)
 }
 EXPORT_SYMBOL(drm_helper_resume_force_mode);
 
-static struct slow_work_ops output_poll_ops;
-
 #define DRM_OUTPUT_POLL_PERIOD (10*HZ)
-static void output_poll_execute(struct slow_work *work)
+static void output_poll_execute(struct work_struct *work)
 {
-	struct delayed_slow_work *delayed_work = container_of(work, struct delayed_slow_work, work);
-	struct drm_device *dev = container_of(delayed_work, struct drm_device, mode_config.output_poll_slow_work);
+	struct delayed_work *delayed_work = to_delayed_work(work);
+	struct drm_device *dev = container_of(delayed_work, struct drm_device, mode_config.output_poll_work);
 	struct drm_connector *connector;
 	enum drm_connector_status old_status, status;
 	bool repoll = false, changed = false;
@@ -854,7 +852,7 @@ static void output_poll_execute(struct slow_work *work)
 	}
 
 	if (repoll) {
-		ret = delayed_slow_work_enqueue(delayed_work, DRM_OUTPUT_POLL_PERIOD);
+		ret = queue_delayed_work(system_nrt_wq, delayed_work, DRM_OUTPUT_POLL_PERIOD);
 		if (ret)
 			DRM_ERROR("delayed enqueue failed %d\n", ret);
 	}
@@ -864,7 +862,7 @@ void drm_kms_helper_poll_disable(struct drm_device *dev)
 {
 	if (!dev->mode_config.poll_enabled)
 		return;
-	delayed_slow_work_cancel(&dev->mode_config.output_poll_slow_work);
+	cancel_delayed_work_sync(&dev->mode_config.output_poll_work);
 }
 EXPORT_SYMBOL(drm_kms_helper_poll_disable);
 
@@ -880,7 +878,7 @@ void drm_kms_helper_poll_enable(struct drm_device *dev)
 	}
 
 	if (poll) {
-		ret = delayed_slow_work_enqueue(&dev->mode_config.output_poll_slow_work, DRM_OUTPUT_POLL_PERIOD);
+		ret = queue_delayed_work(system_nrt_wq, &dev->mode_config.output_poll_work, DRM_OUTPUT_POLL_PERIOD);
 		if (ret)
 			DRM_ERROR("delayed enqueue failed %d\n", ret);
 	}
@@ -889,9 +887,7 @@ EXPORT_SYMBOL(drm_kms_helper_poll_enable);
 
 void drm_kms_helper_poll_init(struct drm_device *dev)
 {
-	slow_work_register_user(THIS_MODULE);
-	delayed_slow_work_init(&dev->mode_config.output_poll_slow_work,
-			       &output_poll_ops);
+	INIT_DELAYED_WORK(&dev->mode_config.output_poll_work, output_poll_execute);
 	dev->mode_config.poll_enabled = true;
 
 	drm_kms_helper_poll_enable(dev);
@@ -901,7 +897,6 @@ EXPORT_SYMBOL(drm_kms_helper_poll_init);
 void drm_kms_helper_poll_fini(struct drm_device *dev)
 {
 	drm_kms_helper_poll_disable(dev);
-	slow_work_unregister_user(THIS_MODULE);
 }
 EXPORT_SYMBOL(drm_kms_helper_poll_fini);
 
@@ -909,12 +904,8 @@ void drm_helper_hpd_irq_event(struct drm_device *dev)
 {
 	if (!dev->mode_config.poll_enabled)
 		return;
-	delayed_slow_work_cancel(&dev->mode_config.output_poll_slow_work);
-	/* schedule a slow work asap */
-	delayed_slow_work_enqueue(&dev->mode_config.output_poll_slow_work, 0);
+	/* kill timer and schedule immediate execution, this doesn't block */
+	cancel_delayed_work(&dev->mode_config.output_poll_work);
+	queue_delayed_work(system_nrt_wq, &dev->mode_config.output_poll_work, 0);
 }
 EXPORT_SYMBOL(drm_helper_hpd_irq_event);
-
-static struct slow_work_ops output_poll_ops = {
-	.execute = output_poll_execute,
-};
diff --git a/include/drm/drm_crtc.h b/include/drm/drm_crtc.h
index 93a1a31..c707270 100644
--- a/include/drm/drm_crtc.h
+++ b/include/drm/drm_crtc.h
@@ -31,7 +31,6 @@
 #include <linux/idr.h>
 
 #include <linux/fb.h>
-#include <linux/slow-work.h>
 
 struct drm_device;
 struct drm_mode_set;
@@ -595,7 +594,7 @@ struct drm_mode_config {
 
 	/* output poll support */
 	bool poll_enabled;
-	struct delayed_slow_work output_poll_slow_work;
+	struct delayed_work output_poll_work;
 
 	/* pointers to standard properties */
 	struct list_head property_blob_list;
-- 
1.6.4.2

