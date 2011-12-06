Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab1LFStj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 13:49:39 -0500
Received: from mail.tpi.com ([70.99.223.143]:2239 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553Ab1LFSte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 13:49:34 -0500
X-Greylist: delayed 1195 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Dec 2011 13:49:34 EST
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Seth Forshee <seth.forshee@canonical.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        Debora Velarde <debora@linux.vnet.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>,
        tpmdd-devel@lists.sourceforge.net, stable@vger.kernel.org
Subject: [PATCH 2/3] TPM: Close data_pending and data_buffer races
Date: Tue,  6 Dec 2011 11:29:21 -0700
Message-Id: <1323196162-2717-3-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323196162-2717-1-git-send-email-tim.gardner@canonical.com>
References: <1323196162-2717-1-git-send-email-tim.gardner@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a race betwen tpm_read() and tpm_write where both chip->data_pending
and chip->data_buffer can be changed by tpm_write() when tpm_read()
clears chip->data_pending, but before tpm_read() grabs the mutex.

Protect changes to chip->data_pending and chip->data_buffer by expanding
the scope of chip->buffer_mutex.

Reported-by: Seth Forshee <seth.forshee@canonical.com>
Cc: Debora Velarde <debora@linux.vnet.ibm.com>
Cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: Marcel Selhorst <m.selhorst@sirrix.com>
Cc: tpmdd-devel@lists.sourceforge.net
Cc: stable@vger.kernel.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/char/tpm/tpm.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index b366b34..70bf9e5 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -1074,12 +1074,15 @@ ssize_t tpm_write(struct file *file, const char __user *buf,
 	struct tpm_chip *chip = file->private_data;
 	size_t in_size = size, out_size;
 
+	mutex_lock(&chip->buffer_mutex);
+
 	/* cannot perform a write until the read has cleared
 	   either via tpm_read or a user_read_timer timeout */
-	while (atomic_read(&chip->data_pending) != 0)
+	while (atomic_read(&chip->data_pending) != 0) {
+		mutex_unlock(&chip->buffer_mutex);
 		msleep(TPM_TIMEOUT);
-
-	mutex_lock(&chip->buffer_mutex);
+		mutex_lock(&chip->buffer_mutex);
+	}
 
 	if (in_size > TPM_BUFSIZE)
 		in_size = TPM_BUFSIZE;
@@ -1112,22 +1115,20 @@ ssize_t tpm_read(struct file *file, char __user *buf,
 
 	del_singleshot_timer_sync(&chip->user_read_timer);
 	flush_work_sync(&chip->work);
-	ret_size = atomic_read(&chip->data_pending);
-	atomic_set(&chip->data_pending, 0);
+	mutex_lock(&chip->buffer_mutex);
+	ret_size = atomic_xchg(&chip->data_pending, 0);
 	if (ret_size > 0) {	/* relay data */
 		ssize_t orig_ret_size = ret_size;
 		if (size < ret_size)
 			ret_size = size;
 
-		mutex_lock(&chip->buffer_mutex);
 		rc = copy_to_user(buf, chip->data_buffer, ret_size);
 		memset(chip->data_buffer, 0, orig_ret_size);
 		if (rc)
 			ret_size = -EFAULT;
-
-		mutex_unlock(&chip->buffer_mutex);
 	}
 
+	mutex_unlock(&chip->buffer_mutex);
 	return ret_size;
 }
 EXPORT_SYMBOL_GPL(tpm_read);
-- 
1.7.0.4

