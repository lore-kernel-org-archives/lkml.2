Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab2AWQ6G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 11:58:06 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33633 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab2AWQ6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 11:58:03 -0500
Date: Mon, 23 Jan 2012 11:57:52 -0500
From: Jerome Glisse <j.glisse@gmail.com>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>, dri-devel@lists.freedesktop.org
Subject: Re: [3.3-rc1]radeon 0000:07:00.0: GPU lockup CP stall for more than
 10000msec
Message-ID: <20120123165752.GA1980@homer.localdomain>
References: <CAPVoSvSXMvRb=1itu9DjF+s=6zfAChvUxS-x=b8EV9kOZinNpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="82I3+IH0IqGh5yIs"
Content-Disposition: inline
In-Reply-To: <CAPVoSvSXMvRb=1itu9DjF+s=6zfAChvUxS-x=b8EV9kOZinNpA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 21, 2012 at 08:03:37PM +0100, Torsten Kaiser wrote:
> After updating to kernel 3.3-rc1 I have experienced a lockup of my GPU.
> I left my KDE desktop running until the screensaver turned off the
> monitors. But on key presses it would not turn back on. Ctrl+Alt+F1 to
> switch to another virtual console also did not work.
> Alt+SysRq magic still worked, so I was able to force the syslog to
> disk and restart the system.
> 

Can you test if attached patch help your case ?

Of course it would be best if we did not lockup in the first place.

Cheers,
Jerome

--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-drm-radeon-avoid-deadlock-if-GPU-lockup-is-detected-.patch"

>From 84e7f3d46d2a4ac226343e195b806820accdf2fe Mon Sep 17 00:00:00 2001
From: Jerome Glisse <jglisse@redhat.com>
Date: Mon, 23 Jan 2012 11:52:15 -0500
Subject: [PATCH] drm/radeon: avoid deadlock if GPU lockup is detected in
 ib_pool_get

If GPU lockup is detected in ib_pool get we are holding the ib_pool
mutex that will be needed by the GPU reset code. As ib_pool code is
safe to be reentrant from GPU reset code we should not block if we
are trying to get the ib pool lock on the behalf of the same userspace
caller, thus use the radeon_mutex_lock helper.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/radeon/radeon.h        |   84 ++++++++++++++++----------------
 drivers/gpu/drm/radeon/radeon_device.c |    2 +-
 drivers/gpu/drm/radeon/radeon_ring.c   |   24 +++++-----
 3 files changed, 55 insertions(+), 55 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 73e05cb..1668ec1 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -157,6 +157,47 @@ bool radeon_get_bios(struct radeon_device *rdev);
 
 
 /*
+ * Mutex which allows recursive locking from the same process.
+ */
+struct radeon_mutex {
+	struct mutex		mutex;
+	struct task_struct	*owner;
+	int			level;
+};
+
+static inline void radeon_mutex_init(struct radeon_mutex *mutex)
+{
+	mutex_init(&mutex->mutex);
+	mutex->owner = NULL;
+	mutex->level = 0;
+}
+
+static inline void radeon_mutex_lock(struct radeon_mutex *mutex)
+{
+	if (mutex_trylock(&mutex->mutex)) {
+		/* The mutex was unlocked before, so it's ours now */
+		mutex->owner = current;
+	} else if (mutex->owner != current) {
+		/* Another process locked the mutex, take it */
+		mutex_lock(&mutex->mutex);
+		mutex->owner = current;
+	}
+	/* Otherwise the mutex was already locked by this process */
+
+	mutex->level++;
+}
+
+static inline void radeon_mutex_unlock(struct radeon_mutex *mutex)
+{
+	if (--mutex->level > 0)
+		return;
+
+	mutex->owner = NULL;
+	mutex_unlock(&mutex->mutex);
+}
+
+
+/*
  * Dummy page
  */
 struct radeon_dummy_page {
@@ -598,7 +639,7 @@ struct radeon_ib {
  * mutex protects scheduled_ibs, ready, alloc_bm
  */
 struct radeon_ib_pool {
-	struct mutex			mutex;
+	struct radeon_mutex		mutex;
 	struct radeon_sa_manager	sa_manager;
 	struct radeon_ib		ibs[RADEON_IB_POOL_SIZE];
 	bool				ready;
@@ -1355,47 +1396,6 @@ struct r600_vram_scratch {
 
 
 /*
- * Mutex which allows recursive locking from the same process.
- */
-struct radeon_mutex {
-	struct mutex		mutex;
-	struct task_struct	*owner;
-	int			level;
-};
-
-static inline void radeon_mutex_init(struct radeon_mutex *mutex)
-{
-	mutex_init(&mutex->mutex);
-	mutex->owner = NULL;
-	mutex->level = 0;
-}
-
-static inline void radeon_mutex_lock(struct radeon_mutex *mutex)
-{
-	if (mutex_trylock(&mutex->mutex)) {
-		/* The mutex was unlocked before, so it's ours now */
-		mutex->owner = current;
-	} else if (mutex->owner != current) {
-		/* Another process locked the mutex, take it */
-		mutex_lock(&mutex->mutex);
-		mutex->owner = current;
-	}
-	/* Otherwise the mutex was already locked by this process */
-
-	mutex->level++;
-}
-
-static inline void radeon_mutex_unlock(struct radeon_mutex *mutex)
-{
-	if (--mutex->level > 0)
-		return;
-
-	mutex->owner = NULL;
-	mutex_unlock(&mutex->mutex);
-}
-
-
-/*
  * Core structure, functions and helpers.
  */
 typedef uint32_t (*radeon_rreg_t)(struct radeon_device*, uint32_t);
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 0afb13b..df0c4c9 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -720,7 +720,7 @@ int radeon_device_init(struct radeon_device *rdev,
 	/* mutex initialization are all done here so we
 	 * can recall function without having locking issues */
 	radeon_mutex_init(&rdev->cs_mutex);
-	mutex_init(&rdev->ib_pool.mutex);
+	radeon_mutex_init(&rdev->ib_pool.mutex);
 	for (i = 0; i < RADEON_NUM_RINGS; ++i)
 		mutex_init(&rdev->ring[i].mutex);
 	mutex_init(&rdev->dc_hw_i2c_mutex);
diff --git a/drivers/gpu/drm/radeon/radeon_ring.c b/drivers/gpu/drm/radeon/radeon_ring.c
index e8bc709..9af5317 100644
--- a/drivers/gpu/drm/radeon/radeon_ring.c
+++ b/drivers/gpu/drm/radeon/radeon_ring.c
@@ -109,12 +109,12 @@ int radeon_ib_get(struct radeon_device *rdev, int ring,
 		return r;
 	}
 
-	mutex_lock(&rdev->ib_pool.mutex);
+	radeon_mutex_lock(&rdev->ib_pool.mutex);
 	idx = rdev->ib_pool.head_id;
 retry:
 	if (cretry > 5) {
 		dev_err(rdev->dev, "failed to get an ib after 5 retry\n");
-		mutex_unlock(&rdev->ib_pool.mutex);
+		radeon_mutex_unlock(&rdev->ib_pool.mutex);
 		radeon_fence_unref(&fence);
 		return -ENOMEM;
 	}
@@ -139,7 +139,7 @@ retry:
 				 */
 				rdev->ib_pool.head_id = (1 + idx);
 				rdev->ib_pool.head_id &= (RADEON_IB_POOL_SIZE - 1);
-				mutex_unlock(&rdev->ib_pool.mutex);
+				radeon_mutex_unlock(&rdev->ib_pool.mutex);
 				return 0;
 			}
 		}
@@ -158,7 +158,7 @@ retry:
 		}
 		idx = (idx + 1) & (RADEON_IB_POOL_SIZE - 1);
 	}
-	mutex_unlock(&rdev->ib_pool.mutex);
+	radeon_mutex_unlock(&rdev->ib_pool.mutex);
 	radeon_fence_unref(&fence);
 	return r;
 }
@@ -171,12 +171,12 @@ void radeon_ib_free(struct radeon_device *rdev, struct radeon_ib **ib)
 	if (tmp == NULL) {
 		return;
 	}
-	mutex_lock(&rdev->ib_pool.mutex);
+	radeon_mutex_lock(&rdev->ib_pool.mutex);
 	if (tmp->fence && !tmp->fence->emitted) {
 		radeon_sa_bo_free(rdev, &tmp->sa_bo);
 		radeon_fence_unref(&tmp->fence);
 	}
-	mutex_unlock(&rdev->ib_pool.mutex);
+	radeon_mutex_unlock(&rdev->ib_pool.mutex);
 }
 
 int radeon_ib_schedule(struct radeon_device *rdev, struct radeon_ib *ib)
@@ -206,9 +206,9 @@ int radeon_ib_pool_init(struct radeon_device *rdev)
 {
 	int i, r;
 
-	mutex_lock(&rdev->ib_pool.mutex);
+	radeon_mutex_lock(&rdev->ib_pool.mutex);
 	if (rdev->ib_pool.ready) {
-		mutex_unlock(&rdev->ib_pool.mutex);
+		radeon_mutex_unlock(&rdev->ib_pool.mutex);
 		return 0;
 	}
 
@@ -216,7 +216,7 @@ int radeon_ib_pool_init(struct radeon_device *rdev)
 				      RADEON_IB_POOL_SIZE*64*1024,
 				      RADEON_GEM_DOMAIN_GTT);
 	if (r) {
-		mutex_unlock(&rdev->ib_pool.mutex);
+		radeon_mutex_unlock(&rdev->ib_pool.mutex);
 		return r;
 	}
 
@@ -236,7 +236,7 @@ int radeon_ib_pool_init(struct radeon_device *rdev)
 	if (radeon_debugfs_ring_init(rdev)) {
 		DRM_ERROR("Failed to register debugfs file for rings !\n");
 	}
-	mutex_unlock(&rdev->ib_pool.mutex);
+	radeon_mutex_unlock(&rdev->ib_pool.mutex);
 	return 0;
 }
 
@@ -244,7 +244,7 @@ void radeon_ib_pool_fini(struct radeon_device *rdev)
 {
 	unsigned i;
 
-	mutex_lock(&rdev->ib_pool.mutex);
+	radeon_mutex_lock(&rdev->ib_pool.mutex);
 	if (rdev->ib_pool.ready) {
 		for (i = 0; i < RADEON_IB_POOL_SIZE; i++) {
 			radeon_sa_bo_free(rdev, &rdev->ib_pool.ibs[i].sa_bo);
@@ -253,7 +253,7 @@ void radeon_ib_pool_fini(struct radeon_device *rdev)
 		radeon_sa_bo_manager_fini(rdev, &rdev->ib_pool.sa_manager);
 		rdev->ib_pool.ready = false;
 	}
-	mutex_unlock(&rdev->ib_pool.mutex);
+	radeon_mutex_unlock(&rdev->ib_pool.mutex);
 }
 
 int radeon_ib_pool_start(struct radeon_device *rdev)
-- 
1.7.6.4


--82I3+IH0IqGh5yIs--
