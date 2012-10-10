Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab2JJSBN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 14:01:13 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:48605 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755697Ab2JJSBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 14:01:10 -0400
Date: Wed, 10 Oct 2012 13:00:33 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net, Kent Yoder <key@linux.vnet.ibm.com>,
        Peter Huewe <peter.huewe@infineon.com>
Subject: [PULL] Updates to tpm_write() error checking
Message-ID: <20121010180033.GC5013@ennui.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12101018-5112-0000-0000-00000D4E4CEB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

The following changes since commit bf5308344527d015ac9a6d2bda4ad4d40fd7d943:

  Merge tag 'v3.6-rc7' into next (2012-09-28 13:37:32 +1000)

are available in the git repository at:


  git://github.com/shpedoikal/linux.git tpmdd-next-v3.6

for you to fetch changes up to abce9ac292e13da367bbd22c1f7669f988d931ac:

  tpm: Propagate error from tpm_transmit to fix a timeout hang (2012-10-10 11:34:31 -0500)

----------------------------------------------------------------
Peter Huewe (1):
      tpm: Propagate error from tpm_transmit to fix a timeout hang

 drivers/char/tpm/tpm.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index 6724615..4caef33 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -1182,17 +1182,20 @@ ssize_t tpm_write(struct file *file, const char __user *buf,
 		  size_t size, loff_t *off)
 {
 	struct tpm_chip *chip = file->private_data;
-	size_t in_size = size, out_size;
+	size_t in_size = size;
+	ssize_t out_size;
 
 	/* cannot perform a write until the read has cleared
-	   either via tpm_read or a user_read_timer timeout */
-	while (atomic_read(&chip->data_pending) != 0)
-		msleep(TPM_TIMEOUT);
-
-	mutex_lock(&chip->buffer_mutex);
+	   either via tpm_read or a user_read_timer timeout.
+	   This also prevents splitted buffered writes from blocking here.
+	*/
+	if (atomic_read(&chip->data_pending) != 0)
+		return -EBUSY;
 
 	if (in_size > TPM_BUFSIZE)
-		in_size = TPM_BUFSIZE;
+		return -E2BIG;
+
+	mutex_lock(&chip->buffer_mutex);
 
 	if (copy_from_user
 	    (chip->data_buffer, (void __user *) buf, in_size)) {
@@ -1202,6 +1205,10 @@ ssize_t tpm_write(struct file *file, const char __user *buf,
 
 	/* atomic tpm command send and result receive */
 	out_size = tpm_transmit(chip, chip->data_buffer, TPM_BUFSIZE);
+	if (out_size < 0) {
+		mutex_unlock(&chip->buffer_mutex);
+		return out_size;
+	}
 
 	atomic_set(&chip->data_pending, out_size);
 	mutex_unlock(&chip->buffer_mutex);

