Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965745Ab2C3Vu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:50:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33001 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965758Ab2C3VT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:19:56 -0400
Message-Id: <20120330194836.387542945@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:49:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Seth Forshee <seth.forshee@canonical.com>,
        Debora Velarde <debora@linux.vnet.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>,
        Tim Gardner <tim.gardner@canonical.com>
Subject: [ 063/175] TPM: Zero buffer whole after copying to userspace
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Gardner <tim.gardner@canonical.com>

commit 3ab1aff89477dafb1aaeafe8c8669114a02b7226 upstream.

Commit 3321c07ae5068568cd61ac9f4ba749006a7185c9 correctly clears the TPM
buffer if the user specified read length is >= the TPM buffer length. However,
if the user specified read length is < the TPM buffer length, then part of the
TPM buffer is left uncleared.

Reported-by: Seth Forshee <seth.forshee@canonical.com>
Cc: Debora Velarde <debora@linux.vnet.ibm.com>
Cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: Marcel Selhorst <m.selhorst@sirrix.com>
Cc: tpmdd-devel@lists.sourceforge.net
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/tpm/tpm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -1221,12 +1221,13 @@ ssize_t tpm_read(struct file *file, char
 	ret_size = atomic_read(&chip->data_pending);
 	atomic_set(&chip->data_pending, 0);
 	if (ret_size > 0) {	/* relay data */
+		ssize_t orig_ret_size = ret_size;
 		if (size < ret_size)
 			ret_size = size;
 
 		mutex_lock(&chip->buffer_mutex);
 		rc = copy_to_user(buf, chip->data_buffer, ret_size);
-		memset(chip->data_buffer, 0, ret_size);
+		memset(chip->data_buffer, 0, orig_ret_size);
 		if (rc)
 			ret_size = -EFAULT;
 


