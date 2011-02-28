Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab1B1Xsy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 18:48:54 -0500
Received: from a-pb-sasl-sd.pobox.com ([64.74.157.62]:55276 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663Ab1B1XsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 18:48:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:date:message-id:in-reply-to:references; q=dns; s=sasl; b=
	XaVUTt44W6M978Gin6kCiZdakPxVcNrGHrEy/p7R2NWBelLUyvuqji7GY65NfN66
	drL8d0W/nGOt9TQpJiCmlAMK1JQm+528nGUkoSaH//PSLK8oVLTRFB31/5znyp/q
	0OlalMP35EIRgKsKQmdwqYRdvy3RrKcIN65vaOChcr8=
From: ntl@pobox.com
To: linux-kernel@vger.kernel.org
Cc: containers@lists.linux-foundation.org, Oren Laadan <orenl@cs.columbia.edu>,
        Nathan Lynch <ntl@pobox.com>
Subject: [PATCH 04/10] Introduce vfs_fcntl() helper
Date: Mon, 28 Feb 2011 17:40:26 -0600
Message-Id: <1298936432-29607-5-git-send-email-ntl@pobox.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1298936432-29607-1-git-send-email-ntl@pobox.com>
References: <1298936432-29607-1-git-send-email-ntl@pobox.com>
X-Pobox-Relay-ID: 60B5A8F0-4394-11E0-A95C-AF401E47CF6F-04752483!a-pb-sasl-sd.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nathan Lynch <ntl@pobox.com>

When restoring process state from a checkpoint image, it will be
necessary to restore file status flags; add vfs_fcntl() for this
purpose.

Based on original code by Oren Laadan.

Signed-off-by: Oren Laadan <orenl@cs.columbia.edu>
[ntl: extracted from "c/r: checkpoint and restart open file descriptors"]
Signed-off-by: Nathan Lynch <ntl@pobox.com>
---
 fs/fcntl.c         |   21 +++++++++++++--------
 include/linux/fs.h |    2 ++
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index ecc8b39..8e797b7 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -426,6 +426,18 @@ static long do_fcntl(int fd, unsigned int cmd, unsigned long arg,
 	return err;
 }
 
+int vfs_fcntl(int fd, unsigned int cmd, unsigned long arg, struct file *filp)
+{
+	int err;
+
+	err = security_file_fcntl(filp, cmd, arg);
+	if (err)
+		goto out;
+	err = do_fcntl(fd, cmd, arg, filp);
+ out:
+	return err;
+}
+
 SYSCALL_DEFINE3(fcntl, unsigned int, fd, unsigned int, cmd, unsigned long, arg)
 {	
 	struct file *filp;
@@ -435,14 +447,7 @@ SYSCALL_DEFINE3(fcntl, unsigned int, fd, unsigned int, cmd, unsigned long, arg)
 	if (!filp)
 		goto out;
 
-	err = security_file_fcntl(filp, cmd, arg);
-	if (err) {
-		fput(filp);
-		return err;
-	}
-
-	err = do_fcntl(fd, cmd, arg, filp);
-
+	err = vfs_fcntl(fd, cmd, arg, filp);
  	fput(filp);
 out:
 	return err;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 315ded4..175bb75 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1112,6 +1112,8 @@ struct file_lock {
 
 #include <linux/fcntl.h>
 
+extern int vfs_fcntl(int fd, unsigned cmd, unsigned long arg, struct file *fp);
+
 extern void send_sigio(struct fown_struct *fown, int fd, int band);
 
 #ifdef CONFIG_FILE_LOCKING
-- 
1.7.4

