Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200Ab2HOU21 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:28:27 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62849 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756457Ab2HOTuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:50:04 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Peter Huewe <huewe.external.infineon@googlemail.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 050/165] TPM: Zero buffer after copying to userspace
Date: Wed, 15 Aug 2012 15:46:34 -0400
Message-ID: <1345060109-9187-51-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <huewe.external.infineon@googlemail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 3321c07ae5068568cd61ac9f4ba749006a7185c9 upstream.

Since the buffer might contain security related data it might be a good idea to
zero the buffer after we have copied it to userspace.

This got assigned CVE-2011-1162.

Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/char/tpm/tpm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index f39e5ee..9fe4683 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -1031,6 +1031,7 @@ ssize_t tpm_read(struct file *file, char __user *buf,
 {
 	struct tpm_chip *chip = file->private_data;
 	ssize_t ret_size;
+	int rc;
 
 	del_singleshot_timer_sync(&chip->user_read_timer);
 	flush_scheduled_work();
@@ -1041,8 +1042,11 @@ ssize_t tpm_read(struct file *file, char __user *buf,
 			ret_size = size;
 
 		mutex_lock(&chip->buffer_mutex);
-		if (copy_to_user(buf, chip->data_buffer, ret_size))
+		rc = copy_to_user(buf, chip->data_buffer, ret_size);
+		memset(chip->data_buffer, 0, ret_size);
+		if (rc)
 			ret_size = -EFAULT;
+
 		mutex_unlock(&chip->buffer_mutex);
 	}
 
-- 
1.7.12.rc2

