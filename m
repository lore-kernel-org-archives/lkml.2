Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933451Ab1I1Wtj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:49:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54932 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933424Ab1I1Wt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:49:29 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:45 2011
Message-Id: <20110928220145.699470650@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:02:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>
Subject: [193/244] TPM: Zero buffer after copying to userspace
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Peter Huewe <huewe.external.infineon@googlemail.com>

commit 3321c07ae5068568cd61ac9f4ba749006a7185c9 upstream.

Since the buffer might contain security related data it might be a good idea to
zero the buffer after we have copied it to userspace.

This got assigned CVE-2011-1162.

Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/tpm/tpm.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -1055,6 +1055,7 @@ ssize_t tpm_read(struct file *file, char
 {
 	struct tpm_chip *chip = file->private_data;
 	ssize_t ret_size;
+	int rc;
 
 	del_singleshot_timer_sync(&chip->user_read_timer);
 	flush_work_sync(&chip->work);
@@ -1065,8 +1066,11 @@ ssize_t tpm_read(struct file *file, char
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
 


