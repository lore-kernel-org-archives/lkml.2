Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625Ab2JSCxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:53:48 -0400
Received: from mail.kernel.org ([198.145.19.201]:52559 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965052Ab2JSCtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:49:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Peter Huewe <peter.huewe@infineon.com>,
        Kent Yoder <key@linux.vnet.ibm.com>
Subject: [ 66/76] tpm: Propagate error from tpm_transmit to fix a timeout hang
Date: Thu, 18 Oct 2012 19:47:30 -0700
Message-Id: <20121019024400.747115973@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024350.087156547@linuxfoundation.org>
References: <20121019024350.087156547@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Huewe <peter.huewe@infineon.com>

commit abce9ac292e13da367bbd22c1f7669f988d931ac upstream.

tpm_write calls tpm_transmit without checking the return value and
assigns the return value unconditionally to chip->pending_data, even if
it's an error value.
This causes three bugs.

So if we write to /dev/tpm0 with a tpm_param_size bigger than
TPM_BUFSIZE=0x1000 (e.g. 0x100a)
and a bufsize also bigger than TPM_BUFSIZE (e.g. 0x100a)
tpm_transmit returns -E2BIG which is assigned to chip->pending_data as
-7, but tpm_write returns that TPM_BUFSIZE bytes have been successfully
been written to the TPM, altough this is not true (bug #1).

As we did write more than than TPM_BUFSIZE bytes but tpm_write reports
that only TPM_BUFSIZE bytes have been written the vfs tries to write
the remaining bytes (in this case 10 bytes) to the tpm device driver via
tpm_write which then blocks at

 /* cannot perform a write until the read has cleared
 either via tpm_read or a user_read_timer timeout */
 while (atomic_read(&chip->data_pending) != 0)
	 msleep(TPM_TIMEOUT);

for 60 seconds, since data_pending is -7 and nobody is able to
read it (since tpm_read luckily checks if data_pending is greater than
0) (#bug 2).

After that the remaining bytes are written to the TPM which are
interpreted by the tpm as a normal command. (bug #3)
So if the last bytes of the command stream happen to be a e.g.
tpm_force_clear this gets accidentally sent to the TPM.

This patch fixes all three bugs, by propagating the error code of
tpm_write and returning -E2BIG if the input buffer is too big,
since the response from the tpm for a truncated value is bogus anyway.
Moreover it returns -EBUSY to userspace if there is a response ready to be
read.

Signed-off-by: Peter Huewe <peter.huewe@infineon.com>
Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/tpm/tpm.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -1186,17 +1186,20 @@ ssize_t tpm_write(struct file *file, con
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
@@ -1206,6 +1209,10 @@ ssize_t tpm_write(struct file *file, con
 
 	/* atomic tpm command send and result receive */
 	out_size = tpm_transmit(chip, chip->data_buffer, TPM_BUFSIZE);
+	if (out_size < 0) {
+		mutex_unlock(&chip->buffer_mutex);
+		return out_size;
+	}
 
 	atomic_set(&chip->data_pending, out_size);
 	mutex_unlock(&chip->buffer_mutex);


