Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932862Ab3AIUgy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:36:54 -0500
Received: from mail.kernel.org ([198.145.19.201]:41143 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932778Ab3AIUgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:36:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        liu chuansheng <chuansheng.liu@intel.com>,
        Ming Lei <ming.lei@canonical.com>
Subject: [ 002/123] firmware loader: Fix the race FW_STATUS_DONE is followed by class_timeout
Date: Wed,  9 Jan 2013 12:34:01 -0800
Message-Id: <20130109201458.708495445@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuansheng Liu <chuansheng.liu@intel.com>

commit ce2fcbd99cef580623116bb33531dbc3e6f690b0 upstream.

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
Acked-by: Ming Lei <ming.lei@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/firmware_class.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

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
@@ -667,11 +667,18 @@ static struct bin_attribute firmware_att
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
@@ -690,8 +697,8 @@ fw_create_instance(struct firmware *firm
 
 	fw_priv->nowait = nowait;
 	fw_priv->fw = firmware;
-	setup_timer(&fw_priv->timeout,
-		    firmware_class_timeout, (u_long) fw_priv);
+	INIT_DELAYED_WORK(&fw_priv->timeout_work,
+		firmware_class_timeout_work);
 
 	f_dev = &fw_priv->dev;
 
@@ -858,7 +865,9 @@ static int _request_firmware_load(struct
 		dev_dbg(f_dev->parent, "firmware: direct-loading"
 			" firmware %s\n", buf->fw_id);
 
+		mutex_lock(&fw_lock);
 		set_bit(FW_STATUS_DONE, &buf->status);
+		mutex_unlock(&fw_lock);
 		complete_all(&buf->completion);
 		direct_load = 1;
 		goto handle_fw;
@@ -894,15 +903,14 @@ static int _request_firmware_load(struct
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


