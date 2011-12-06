Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab1LFSth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 13:49:37 -0500
Received: from mail.tpi.com ([70.99.223.143]:2240 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669Ab1LFSte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 13:49:34 -0500
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Seth Forshee <seth.forshee@canonical.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        Debora Velarde <debora@linux.vnet.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>,
        tpmdd-devel@lists.sourceforge.net
Subject: [PATCH 3/3] TPM: data_pending is no longer atomic
Date: Tue,  6 Dec 2011 11:29:22 -0700
Message-Id: <1323196162-2717-4-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323196162-2717-1-git-send-email-tim.gardner@canonical.com>
References: <1323196162-2717-1-git-send-email-tim.gardner@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that data_pending is fully protected by a mutex, it no longer
needs to be atomic.

Reported-by: Seth Forshee <seth.forshee@canonical.com>
Cc: Debora Velarde <debora@linux.vnet.ibm.com>
Cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: Marcel Selhorst <m.selhorst@sirrix.com>
Cc: tpmdd-devel@lists.sourceforge.net
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/char/tpm/tpm.c |   16 ++++++++--------
 drivers/char/tpm/tpm.h |    2 +-
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index 70bf9e5..6ac164f 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -342,7 +342,7 @@ static void timeout_work(struct work_struct *work)
 	struct tpm_chip *chip = container_of(work, struct tpm_chip, work);
 
 	mutex_lock(&chip->buffer_mutex);
-	atomic_set(&chip->data_pending, 0);
+	chip->data_pending = 0;
 	memset(chip->data_buffer, 0, TPM_BUFSIZE);
 	mutex_unlock(&chip->buffer_mutex);
 }
@@ -1043,7 +1043,7 @@ int tpm_open(struct inode *inode, struct file *file)
 		return -ENOMEM;
 	}
 
-	atomic_set(&chip->data_pending, 0);
+	chip->data_pending = 0;
 
 	file->private_data = chip;
 	return 0;
@@ -1060,7 +1060,7 @@ int tpm_release(struct inode *inode, struct file *file)
 	del_singleshot_timer_sync(&chip->user_read_timer);
 	flush_work_sync(&chip->work);
 	file->private_data = NULL;
-	atomic_set(&chip->data_pending, 0);
+	chip->data_pending = 0;
 	kfree(chip->data_buffer);
 	clear_bit(0, &chip->is_open);
 	put_device(chip->dev);
@@ -1078,7 +1078,7 @@ ssize_t tpm_write(struct file *file, const char __user *buf,
 
 	/* cannot perform a write until the read has cleared
 	   either via tpm_read or a user_read_timer timeout */
-	while (atomic_read(&chip->data_pending) != 0) {
+	while (chip->data_pending != 0) {
 		mutex_unlock(&chip->buffer_mutex);
 		msleep(TPM_TIMEOUT);
 		mutex_lock(&chip->buffer_mutex);
@@ -1096,7 +1096,7 @@ ssize_t tpm_write(struct file *file, const char __user *buf,
 	/* atomic tpm command send and result receive */
 	out_size = tpm_transmit(chip, chip->data_buffer, TPM_BUFSIZE);
 
-	atomic_set(&chip->data_pending, out_size);
+	chip->data_pending = out_size;
 	mutex_unlock(&chip->buffer_mutex);
 
 	/* Set a timeout by which the reader must come claim the result */
@@ -1116,18 +1116,18 @@ ssize_t tpm_read(struct file *file, char __user *buf,
 	del_singleshot_timer_sync(&chip->user_read_timer);
 	flush_work_sync(&chip->work);
 	mutex_lock(&chip->buffer_mutex);
-	ret_size = atomic_xchg(&chip->data_pending, 0);
+	ret_size = chip->data_pending;
 	if (ret_size > 0) {	/* relay data */
-		ssize_t orig_ret_size = ret_size;
 		if (size < ret_size)
 			ret_size = size;
 
 		rc = copy_to_user(buf, chip->data_buffer, ret_size);
-		memset(chip->data_buffer, 0, orig_ret_size);
+		memset(chip->data_buffer, 0, chip->data_pending);
 		if (rc)
 			ret_size = -EFAULT;
 	}
 
+	chip->data_pending = 0;
 	mutex_unlock(&chip->buffer_mutex);
 	return ret_size;
 }
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 9c4163c..6ee8064 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -103,7 +103,7 @@ struct tpm_chip {
 
 	/* Data passed to and from the tpm via the read/write calls */
 	u8 *data_buffer;
-	atomic_t data_pending;
+	size_t data_pending;
 	struct mutex buffer_mutex;
 
 	struct timer_list user_read_timer;	/* user needs to claim result */
-- 
1.7.0.4

