Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983Ab0HIVzW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 17:55:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:52226 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755325Ab0HIVzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 17:55:20 -0400
Message-ID: <4C607916.80803@kernel.org>
Date: Mon, 09 Aug 2010 23:54:30 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>, namhyung@gmail.com,
        w41ter@gmail.com, Markus Trippelsdorf <markus@trippelsdorf.de>,
        David Airlie <airlied@linux.ie>
Subject: [GIT PULL] workqueue: fixes for v2.6.36
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 09 Aug 2010 21:54:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Please pull from the following branch to receive workqueue fixes for
v2.6.36.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-linus

The branch contains three patches.  One is major and the other are
minor.

workqueue is now initialized during early_init and thus relies on
workqueue_cpu_callback() being called for non boot cpus during boot.
However, the cpu callback was registered as hotcpu_notifier and didn't
get called if CONFIG_CPU_HOTPLUG was disabled.  This is fixed by
changing it to cpu_notifier.

One of the minor two adds missing __percpu notation and the other
removes spurious warning messages caused by incorrect conversion from
slow-work to wq.

Thanks.

Namhyung Kim (1):
      workqueue: add missing __percpu markup in kernel/workqueue.c

Tejun Heo (2):
      workqueue: workqueue_cpu_callback() should be cpu_notifier instead of hotcpu_notifier
      drm: fix fallouts from slow-work -> wq conversion

 drivers/gpu/drm/drm_crtc_helper.c |   16 ++++------------
 kernel/workqueue.c                |    4 ++--
 2 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/drm_crtc_helper.c b/drivers/gpu/drm/drm_crtc_helper.c
index 4598130..b9e4dbf 100644
--- a/drivers/gpu/drm/drm_crtc_helper.c
+++ b/drivers/gpu/drm/drm_crtc_helper.c
@@ -839,7 +839,6 @@ static void output_poll_execute(struct work_struct *work)
 	struct drm_connector *connector;
 	enum drm_connector_status old_status, status;
 	bool repoll = false, changed = false;
-	int ret;

 	mutex_lock(&dev->mode_config.mutex);
 	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
@@ -874,11 +873,8 @@ static void output_poll_execute(struct work_struct *work)
 			dev->mode_config.funcs->output_poll_changed(dev);
 	}

-	if (repoll) {
-		ret = queue_delayed_work(system_nrt_wq, delayed_work, DRM_OUTPUT_POLL_PERIOD);
-		if (ret)
-			DRM_ERROR("delayed enqueue failed %d\n", ret);
-	}
+	if (repoll)
+		queue_delayed_work(system_nrt_wq, delayed_work, DRM_OUTPUT_POLL_PERIOD);
 }

 void drm_kms_helper_poll_disable(struct drm_device *dev)
@@ -893,18 +889,14 @@ void drm_kms_helper_poll_enable(struct drm_device *dev)
 {
 	bool poll = false;
 	struct drm_connector *connector;
-	int ret;

 	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
 		if (connector->polled)
 			poll = true;
 	}

-	if (poll) {
-		ret = queue_delayed_work(system_nrt_wq, &dev->mode_config.output_poll_work, DRM_OUTPUT_POLL_PERIOD);
-		if (ret)
-			DRM_ERROR("delayed enqueue failed %d\n", ret);
-	}
+	if (poll)
+		queue_delayed_work(system_nrt_wq, &dev->mode_config.output_poll_work, DRM_OUTPUT_POLL_PERIOD);
 }
 EXPORT_SYMBOL(drm_kms_helper_poll_enable);

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 9ca34cd..2994a0e 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2568,7 +2568,7 @@ EXPORT_SYMBOL(schedule_delayed_work_on);
 int schedule_on_each_cpu(work_func_t func)
 {
 	int cpu;
-	struct work_struct *works;
+	struct work_struct __percpu *works;

 	works = alloc_percpu(struct work_struct);
 	if (!works)
@@ -3527,7 +3527,7 @@ static int __init init_workqueues(void)
 	unsigned int cpu;
 	int i;

-	hotcpu_notifier(workqueue_cpu_callback, CPU_PRI_WORKQUEUE);
+	cpu_notifier(workqueue_cpu_callback, CPU_PRI_WORKQUEUE);

 	/* initialize gcwqs */
 	for_each_gcwq_cpu(cpu) {
