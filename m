Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260Ab1ACN4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 08:56:20 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60593 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026Ab1ACNuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 08:50:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=a5IdEjIMoH6XzmCvkaVBBkJgszkw27kXJOhgUallDotLczVTDYS6vNPaIIXyPtDMai
         mfSRwfCYvUATd5Awfc9szriQp9X9JRyZ1X1BdJnjAdd6hBeT3I+rACy5SK9p3lFDur+X
         Y6wQNlpy40OUXfbdDT8GgRS6OzvjN/UUo+HiM=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 09/32] drm/radeon: use system_wq instead of dev_priv->wq
Date: Mon,  3 Jan 2011 14:49:32 +0100
Message-Id: <1294062595-30097-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1294062595-30097-1-git-send-email-tj@kernel.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With cmwq, there's no reason for radeon to use a dedicated workqueue.
Drop dev_priv->wq and use system_wq instead.

Because radeon_driver_irq_uninstall_kms() may be called from
unsleepable context, the work items can't be flushed from there.
Instead, init and flush from radeon_irq_kms_init/fini().

While at it, simplify canceling/flushing of rdev->pm.dynpm_idle_work.
Always initialize and sync cancel instead of being unnecessarily smart
about it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
---
Only compile tested.  Please feel free to take it into the subsystem
tree or simply ack - I'll route it through the wq tree.

Thanks.

 drivers/gpu/drm/radeon/evergreen.c      |    2 +-
 drivers/gpu/drm/radeon/r100.c           |    2 +-
 drivers/gpu/drm/radeon/r600.c           |    2 +-
 drivers/gpu/drm/radeon/radeon.h         |    1 -
 drivers/gpu/drm/radeon/radeon_device.c  |    6 ----
 drivers/gpu/drm/radeon/radeon_irq_kms.c |    5 ++-
 drivers/gpu/drm/radeon/radeon_pm.c      |   47 ++++++++++--------------------
 drivers/gpu/drm/radeon/rs600.c          |    2 +-
 8 files changed, 23 insertions(+), 44 deletions(-)

diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index 7b337c3..6540adb 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -2516,7 +2516,7 @@ restart_ih:
 	if (wptr != rdev->ih.wptr)
 		goto restart_ih;
 	if (queue_hotplug)
-		queue_work(rdev->wq, &rdev->hotplug_work);
+		schedule_work(&rdev->hotplug_work);
 	rdev->ih.rptr = rptr;
 	WREG32(IH_RB_RPTR, rdev->ih.rptr);
 	spin_unlock_irqrestore(&rdev->ih.lock, flags);
diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index 8e10aa9..1d15748 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -622,7 +622,7 @@ int r100_irq_process(struct radeon_device *rdev)
 	/* reset gui idle ack.  the status bit is broken */
 	rdev->irq.gui_idle_acked = false;
 	if (queue_hotplug)
-		queue_work(rdev->wq, &rdev->hotplug_work);
+		schedule_work(&rdev->hotplug_work);
 	if (rdev->msi_enabled) {
 		switch (rdev->family) {
 		case CHIP_RS400:
diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index 9c92db7..f927cd4 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -3419,7 +3419,7 @@ restart_ih:
 	if (wptr != rdev->ih.wptr)
 		goto restart_ih;
 	if (queue_hotplug)
-		queue_work(rdev->wq, &rdev->hotplug_work);
+		schedule_work(&rdev->hotplug_work);
 	rdev->ih.rptr = rptr;
 	WREG32(IH_RB_RPTR, rdev->ih.rptr);
 	spin_unlock_irqrestore(&rdev->ih.lock, flags);
diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 3a70957..ba233a8 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -1095,7 +1095,6 @@ struct radeon_device {
 	struct r700_vram_scratch vram_scratch;
 	int msi_enabled; /* msi enabled */
 	struct r600_ih ih; /* r6/700 interrupt ring */
-	struct workqueue_struct *wq;
 	struct work_struct hotplug_work;
 	int num_crtc; /* number of crtcs */
 	struct mutex dc_hw_i2c_mutex; /* display controller hw i2c mutex */
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 501966a..4bc0012 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -704,11 +704,6 @@ int radeon_device_init(struct radeon_device *rdev,
 	init_waitqueue_head(&rdev->irq.vblank_queue);
 	init_waitqueue_head(&rdev->irq.idle_queue);
 
-	/* setup workqueue */
-	rdev->wq = create_workqueue("radeon");
-	if (rdev->wq == NULL)
-		return -ENOMEM;
-
 	/* Set asic functions */
 	r = radeon_asic_init(rdev);
 	if (r)
@@ -806,7 +801,6 @@ void radeon_device_fini(struct radeon_device *rdev)
 	/* evict vram memory */
 	radeon_bo_evict_vram(rdev);
 	radeon_fini(rdev);
-	destroy_workqueue(rdev->wq);
 	vga_switcheroo_unregister_client(rdev->pdev);
 	vga_client_register(rdev->pdev, NULL, NULL, NULL);
 	if (rdev->rio_mem)
diff --git a/drivers/gpu/drm/radeon/radeon_irq_kms.c b/drivers/gpu/drm/radeon/radeon_irq_kms.c
index a108c7e..33b9d21 100644
--- a/drivers/gpu/drm/radeon/radeon_irq_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_irq_kms.c
@@ -64,8 +64,6 @@ void radeon_driver_irq_preinstall_kms(struct drm_device *dev)
 	struct radeon_device *rdev = dev->dev_private;
 	unsigned i;
 
-	INIT_WORK(&rdev->hotplug_work, radeon_hotplug_work_func);
-
 	/* Disable *all* interrupts */
 	rdev->irq.sw_int = false;
 	rdev->irq.gui_idle = false;
@@ -110,6 +108,8 @@ int radeon_irq_kms_init(struct radeon_device *rdev)
 {
 	int r = 0;
 
+	INIT_WORK(&rdev->hotplug_work, radeon_hotplug_work_func);
+
 	spin_lock_init(&rdev->irq.sw_lock);
 	r = drm_vblank_init(rdev->ddev, rdev->num_crtc);
 	if (r) {
@@ -148,6 +148,7 @@ void radeon_irq_kms_fini(struct radeon_device *rdev)
 		if (rdev->msi_enabled)
 			pci_disable_msi(rdev->pdev);
 	}
+	flush_work_sync(&rdev->hotplug_work);
 }
 
 void radeon_irq_kms_sw_irq_get(struct radeon_device *rdev)
diff --git a/drivers/gpu/drm/radeon/radeon_pm.c b/drivers/gpu/drm/radeon/radeon_pm.c
index 8c9b2ef..845f295 100644
--- a/drivers/gpu/drm/radeon/radeon_pm.c
+++ b/drivers/gpu/drm/radeon/radeon_pm.c
@@ -405,20 +405,13 @@ static ssize_t radeon_set_pm_method(struct device *dev,
 		rdev->pm.dynpm_planned_action = DYNPM_ACTION_DEFAULT;
 		mutex_unlock(&rdev->pm.mutex);
 	} else if (strncmp("profile", buf, strlen("profile")) == 0) {
-		bool flush_wq = false;
-
 		mutex_lock(&rdev->pm.mutex);
-		if (rdev->pm.pm_method == PM_METHOD_DYNPM) {
-			cancel_delayed_work(&rdev->pm.dynpm_idle_work);
-			flush_wq = true;
-		}
 		/* disable dynpm */
 		rdev->pm.dynpm_state = DYNPM_STATE_DISABLED;
 		rdev->pm.dynpm_planned_action = DYNPM_ACTION_NONE;
 		rdev->pm.pm_method = PM_METHOD_PROFILE;
 		mutex_unlock(&rdev->pm.mutex);
-		if (flush_wq)
-			flush_workqueue(rdev->wq);
+		cancel_delayed_work_sync(&rdev->pm.dynpm_idle_work);
 	} else {
 		DRM_ERROR("invalid power method!\n");
 		goto fail;
@@ -520,18 +513,14 @@ static void radeon_hwmon_fini(struct radeon_device *rdev)
 
 void radeon_pm_suspend(struct radeon_device *rdev)
 {
-	bool flush_wq = false;
-
 	mutex_lock(&rdev->pm.mutex);
 	if (rdev->pm.pm_method == PM_METHOD_DYNPM) {
-		cancel_delayed_work(&rdev->pm.dynpm_idle_work);
 		if (rdev->pm.dynpm_state == DYNPM_STATE_ACTIVE)
 			rdev->pm.dynpm_state = DYNPM_STATE_SUSPENDED;
-		flush_wq = true;
 	}
 	mutex_unlock(&rdev->pm.mutex);
-	if (flush_wq)
-		flush_workqueue(rdev->wq);
+
+	cancel_delayed_work_sync(&rdev->pm.dynpm_idle_work);
 }
 
 void radeon_pm_resume(struct radeon_device *rdev)
@@ -546,8 +535,8 @@ void radeon_pm_resume(struct radeon_device *rdev)
 	if (rdev->pm.pm_method == PM_METHOD_DYNPM
 	    && rdev->pm.dynpm_state == DYNPM_STATE_SUSPENDED) {
 		rdev->pm.dynpm_state = DYNPM_STATE_ACTIVE;
-		queue_delayed_work(rdev->wq, &rdev->pm.dynpm_idle_work,
-					msecs_to_jiffies(RADEON_IDLE_LOOP_MS));
+		schedule_delayed_work(&rdev->pm.dynpm_idle_work,
+				      msecs_to_jiffies(RADEON_IDLE_LOOP_MS));
 	}
 	mutex_unlock(&rdev->pm.mutex);
 	radeon_pm_compute_clocks(rdev);
@@ -581,6 +570,9 @@ int radeon_pm_init(struct radeon_device *rdev)
 	ret = radeon_hwmon_init(rdev);
 	if (ret)
 		return ret;
+
+	INIT_DELAYED_WORK(&rdev->pm.dynpm_idle_work, radeon_dynpm_idle_work_handler);
+
 	if (rdev->pm.num_power_states > 1) {
 		/* where's the best place to put these? */
 		ret = device_create_file(rdev->dev, &dev_attr_power_profile);
@@ -594,8 +586,6 @@ int radeon_pm_init(struct radeon_device *rdev)
 		rdev->acpi_nb.notifier_call = radeon_acpi_event;
 		register_acpi_notifier(&rdev->acpi_nb);
 #endif
-		INIT_DELAYED_WORK(&rdev->pm.dynpm_idle_work, radeon_dynpm_idle_work_handler);
-
 		if (radeon_debugfs_pm_init(rdev)) {
 			DRM_ERROR("Failed to register debugfs file for PM!\n");
 		}
@@ -609,25 +599,20 @@ int radeon_pm_init(struct radeon_device *rdev)
 void radeon_pm_fini(struct radeon_device *rdev)
 {
 	if (rdev->pm.num_power_states > 1) {
-		bool flush_wq = false;
-
 		mutex_lock(&rdev->pm.mutex);
 		if (rdev->pm.pm_method == PM_METHOD_PROFILE) {
 			rdev->pm.profile = PM_PROFILE_DEFAULT;
 			radeon_pm_update_profile(rdev);
 			radeon_pm_set_clocks(rdev);
 		} else if (rdev->pm.pm_method == PM_METHOD_DYNPM) {
-			/* cancel work */
-			cancel_delayed_work(&rdev->pm.dynpm_idle_work);
-			flush_wq = true;
 			/* reset default clocks */
 			rdev->pm.dynpm_state = DYNPM_STATE_DISABLED;
 			rdev->pm.dynpm_planned_action = DYNPM_ACTION_DEFAULT;
 			radeon_pm_set_clocks(rdev);
 		}
 		mutex_unlock(&rdev->pm.mutex);
-		if (flush_wq)
-			flush_workqueue(rdev->wq);
+
+		cancel_delayed_work_sync(&rdev->pm.dynpm_idle_work);
 
 		device_remove_file(rdev->dev, &dev_attr_power_profile);
 		device_remove_file(rdev->dev, &dev_attr_power_method);
@@ -686,12 +671,12 @@ void radeon_pm_compute_clocks(struct radeon_device *rdev)
 					radeon_pm_get_dynpm_state(rdev);
 					radeon_pm_set_clocks(rdev);
 
-					queue_delayed_work(rdev->wq, &rdev->pm.dynpm_idle_work,
-							   msecs_to_jiffies(RADEON_IDLE_LOOP_MS));
+					schedule_delayed_work(&rdev->pm.dynpm_idle_work,
+							      msecs_to_jiffies(RADEON_IDLE_LOOP_MS));
 				} else if (rdev->pm.dynpm_state == DYNPM_STATE_PAUSED) {
 					rdev->pm.dynpm_state = DYNPM_STATE_ACTIVE;
-					queue_delayed_work(rdev->wq, &rdev->pm.dynpm_idle_work,
-							   msecs_to_jiffies(RADEON_IDLE_LOOP_MS));
+					schedule_delayed_work(&rdev->pm.dynpm_idle_work,
+							      msecs_to_jiffies(RADEON_IDLE_LOOP_MS));
 					DRM_DEBUG_DRIVER("radeon: dynamic power management activated\n");
 				}
 			} else { /* count == 0 */
@@ -796,8 +781,8 @@ static void radeon_dynpm_idle_work_handler(struct work_struct *work)
 			radeon_pm_set_clocks(rdev);
 		}
 
-		queue_delayed_work(rdev->wq, &rdev->pm.dynpm_idle_work,
-					msecs_to_jiffies(RADEON_IDLE_LOOP_MS));
+		schedule_delayed_work(&rdev->pm.dynpm_idle_work,
+				      msecs_to_jiffies(RADEON_IDLE_LOOP_MS));
 	}
 	mutex_unlock(&rdev->pm.mutex);
 	ttm_bo_unlock_delayed_workqueue(&rdev->mman.bdev, resched);
diff --git a/drivers/gpu/drm/radeon/rs600.c b/drivers/gpu/drm/radeon/rs600.c
index f1c6e02..2d707d4 100644
--- a/drivers/gpu/drm/radeon/rs600.c
+++ b/drivers/gpu/drm/radeon/rs600.c
@@ -634,7 +634,7 @@ int rs600_irq_process(struct radeon_device *rdev)
 	/* reset gui idle ack.  the status bit is broken */
 	rdev->irq.gui_idle_acked = false;
 	if (queue_hotplug)
-		queue_work(rdev->wq, &rdev->hotplug_work);
+		schedule_work(&rdev->hotplug_work);
 	if (rdev->msi_enabled) {
 		switch (rdev->family) {
 		case CHIP_RS600:
-- 
1.7.1

