Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759383Ab2HHXI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 19:08:56 -0400
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:33823 "EHLO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758800Ab2HHXIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 19:08:04 -0400
From: Fernando Guzman Lugo <fernando.lugo@ti.com>
To: <ohad@wizery.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Cc: Fernando Guzman Lugo <fernando.lugo@ti.com>
Subject: [PATCH 2/3] remoteproc: recover a remoteproc when it has crashed
Date: Wed,  8 Aug 2012 18:07:43 -0500
Message-Id: <1344467264-5128-3-git-send-email-fernando.lugo@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1344467264-5128-1-git-send-email-fernando.lugo@ti.com>
References: <1344467264-5128-1-git-send-email-fernando.lugo@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is introducing rproc_trigger_recover function which is in
charge of recovering the rproc. One way to recover the rproc after a crash
is resetting all its virtio devices. Doing that, all rpmsg drivers are
restored along with the rpmsg devices and that also causes the reset of
the remoteproc making the rpmsg communication with the remoteproc
functional again. So far, rproc_trigger_recover function is only resetting
all virtio devices, if in the future other rproc features are introduced
and need to be reset too, rproc_trigger_recover function should take care
of that.

Signed-off-by: Fernando Guzman Lugo <fernando.lugo@ti.com>
---
 drivers/remoteproc/remoteproc_core.c     |   28 +++++++++++++++++++++++++++-
 drivers/remoteproc/remoteproc_internal.h |    1 +
 2 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 3a6f1a1..c879069 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -882,6 +882,32 @@ out:
 }
 
 /**
+ * rproc_trigger_recover() - recover a remoteproc
+ * @rproc: the remote processor
+ *
+ * The recovery is done by reseting all the virtio devices, that way all the
+ * rpmsg drivers will be reseted along with the remote processor making the
+ * remoteproc functional again.
+ *
+ * This function can sleep, so that it cannot be called from atomic context.
+ */
+int rproc_trigger_recover(struct rproc *rproc)
+{
+	struct rproc_vdev *rvdev, *rvtmp;
+
+	dev_err(&rproc->dev, "recovering %s\n", rproc->name);
+
+	/* clean up remote vdev entries */
+	list_for_each_entry_safe(rvdev, rvtmp, &rproc->rvdevs, node)
+		rproc_remove_virtio_dev(rvdev);
+
+	/* run rproc_fw_config_virtio to create vdevs again */
+	return request_firmware_nowait(THIS_MODULE, FW_ACTION_HOTPLUG,
+			rproc->firmware, &rproc->dev, GFP_KERNEL,
+			rproc, rproc_fw_config_virtio);
+}
+
+/**
  * rproc_crash_handler_work() - handle a crash
  *
  * This function needs to handle everything related to a crash, like cpu
@@ -906,7 +932,7 @@ static void rproc_crash_handler_work(struct work_struct *work)
 		++rproc->crash_cnt, rproc->name);
 	mutex_unlock(&rproc->lock);
 
-	/* TODO: handle crash */
+	rproc_trigger_recover(rproc);
 }
 
 /**
diff --git a/drivers/remoteproc/remoteproc_internal.h b/drivers/remoteproc/remoteproc_internal.h
index a690ebe..d9c0730 100644
--- a/drivers/remoteproc/remoteproc_internal.h
+++ b/drivers/remoteproc/remoteproc_internal.h
@@ -63,6 +63,7 @@ void rproc_free_vring(struct rproc_vring *rvring);
 int rproc_alloc_vring(struct rproc_vdev *rvdev, int i);
 
 void *rproc_da_to_va(struct rproc *rproc, u64 da, int len);
+int rproc_trigger_recover(struct rproc *rproc);
 
 static inline
 int rproc_fw_sanity_check(struct rproc *rproc, const struct firmware *fw)
-- 
1.7.1

