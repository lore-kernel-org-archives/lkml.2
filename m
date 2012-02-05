Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab2BEWmc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:42:32 -0500
Received: from 1wt.eu ([62.212.114.60]:61946 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872Ab2BEW0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:30 -0500
Message-Id: <20120205220951.334100926@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:33 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>, Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 44/91] TPM: Zero buffer after copying to userspace
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

commit 3321c07ae5068568cd61ac9f4ba749006a7185c9 upstream.

Since the buffer might contain security related data it might be a good idea to
zero the buffer after we have copied it to userspace.

This got assigned CVE-2011-1162.

Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/tpm/tpm.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

Index: longterm-2.6.27/drivers/char/tpm/tpm.c
===================================================================
--- longterm-2.6.27.orig/drivers/char/tpm/tpm.c	2012-02-05 22:34:40.951915689 +0100
+++ longterm-2.6.27/drivers/char/tpm/tpm.c	2012-02-05 22:34:41.090914667 +0100
@@ -1069,6 +1069,7 @@
 {
 	struct tpm_chip *chip = file->private_data;
 	ssize_t ret_size;
+	int rc;
 
 	del_singleshot_timer_sync(&chip->user_read_timer);
 	flush_scheduled_work();
@@ -1079,8 +1080,11 @@
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
 


