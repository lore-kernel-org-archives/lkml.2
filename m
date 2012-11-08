Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab2KHCNm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 21:13:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:1478 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753379Ab2KHCNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 21:13:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,735,1344236400"; 
   d="scan'208";a="216600325"
Subject: [PATCH V3] firmware loader: Fix the race FW_STATUS_DONE is
 followed by class_timeout
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: ming.lei@canonical.com
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <1352306744.15558.1608.camel@cliu38-desktop-build>
References: <1352306744.15558.1608.camel@cliu38-desktop-build>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Nov 2012 19:14:40 +0800
Message-ID: <1352373280.15558.1615.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There is a race as below when calling request_firmware():
CPU1                                   CPU2
write 0 > loading
mutex_lock(&fw_lock)
...
set_bit FW_STATUS_DONE                 class_timeout is coming
                                       set_bit FW_STATUS_ABORT
complete_all &completion
...
mutex_unlock(&fw_lock)

In this time, the bit FW_STATUS_DONE and FW_STATUS_ABORT are set,
and request_firmware() will return failure due to condition in
_request_firmware_load():
	if (!buf->size || test_bit(FW_STATUS_ABORT, &buf->status))
		retval = -ENOENT;

But from the above scenerio, it should be a successful requesting.
So we need judge if the bit FW_STATUS_DONE is already set before
calling fw_load_abort() in timeout function.

As Ming's proposal, we need change the timer into sched_work to
benefit from using &fw_lock mutex also.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 drivers/base/firmware_class.c |   24 ++++++++++++++++--------
 1 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 8945f4e..b44ed35 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -143,7 +143,7 @@ struct fw_cache_entry {
 };
 
 struct firmware_priv {
-	struct timer_list timeout;
+	struct delayed_work timeout_work;
 	bool nowait;
 	struct device dev;
 	struct firmware_buf *buf;
@@ -667,11 +667,18 @@ static struct bin_attribute firmware_attr_data = {
 	.write = firmware_data_write,
 };
 
-static void firmware_class_timeout(u_long data)
+static void firmware_class_timeout_work(struct work_struct *work)
 {
-	struct firmware_priv *fw_priv = (struct firmware_priv *) data;
+	struct firmware_priv *fw_priv = container_of(work,
+			struct firmware_priv, timeout_work.work);
 
+	mutex_lock(&fw_lock);
+	if (test_bit(FW_STATUS_DONE, &(fw_priv->buf->status))) {
+		mutex_unlock(&fw_lock);
+		return;
+	}
 	fw_load_abort(fw_priv);
+	mutex_unlock(&fw_lock);
 }
 
 static struct firmware_priv *
@@ -690,8 +697,8 @@ fw_create_instance(struct firmware *firmware, const char *fw_name,
 
 	fw_priv->nowait = nowait;
 	fw_priv->fw = firmware;
-	setup_timer(&fw_priv->timeout,
-		    firmware_class_timeout, (u_long) fw_priv);
+	INIT_DELAYED_WORK(&fw_priv->timeout_work,
+		firmware_class_timeout_work);
 
 	f_dev = &fw_priv->dev;
 
@@ -858,7 +865,9 @@ static int _request_firmware_load(struct firmware_priv *fw_priv, bool uevent,
 		dev_dbg(f_dev->parent, "firmware: direct-loading"
 			" firmware %s\n", buf->fw_id);
 
+		mutex_lock(&fw_lock);
 		set_bit(FW_STATUS_DONE, &buf->status);
+		mutex_unlock(&fw_lock);
 		complete_all(&buf->completion);
 		direct_load = 1;
 		goto handle_fw;
@@ -894,15 +903,14 @@ static int _request_firmware_load(struct firmware_priv *fw_priv, bool uevent,
 		dev_set_uevent_suppress(f_dev, false);
 		dev_dbg(f_dev, "firmware: requesting %s\n", buf->fw_id);
 		if (timeout != MAX_SCHEDULE_TIMEOUT)
-			mod_timer(&fw_priv->timeout,
-				  round_jiffies_up(jiffies + timeout));
+			schedule_delayed_work(&fw_priv->timeout_work, timeout);
 
 		kobject_uevent(&fw_priv->dev.kobj, KOBJ_ADD);
 	}
 
 	wait_for_completion(&buf->completion);
 
-	del_timer_sync(&fw_priv->timeout);
+	cancel_delayed_work_sync(&fw_priv->timeout_work);
 
 handle_fw:
 	mutex_lock(&fw_lock);
-- 
1.7.0.4



