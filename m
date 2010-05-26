Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab0EZOoK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 10:44:10 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56402 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab0EZOoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 10:44:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=gNv4J+B39b6mmknn2SARqia2uDAi5aDufZo8fvR5FkMqqBQDHibd5pyzJ+HNtu5cyB
         Cwf3U1F3AXIdpCM3MpLnyiK13C15WhURs+VLs8EGMBJ08FMFdJl9SOgdE0e7iqIEgR4a
         f7BOy69f2nUC/JYPazFJosqoAiTR15SRyBDUA=
From: Changli Gao <xiaosuo@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH v2 resend 1/4] splice: check f_mode for seekable file
Date: Wed, 26 May 2010 22:43:13 +0800
Message-Id: <1274884993-15624-1-git-send-email-xiaosuo@gmail.com>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

check f_mode for seekable file

As a seekable file is allowed without a llseek function, so the old way isn't
work any more.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
Acked-by: Miklos Szeredi <mszeredi@suse.cz>
----
 fs/splice.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)
diff --git a/fs/splice.c b/fs/splice.c
index 9313b61..9e52de5 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1321,8 +1321,7 @@ static long do_splice(struct file *in, loff_t __user *off_in,
 		if (off_in)
 			return -ESPIPE;
 		if (off_out) {
-			if (!out->f_op || !out->f_op->llseek ||
-			    out->f_op->llseek == no_llseek)
+			if (!(out->f_mode & FMODE_PWRITE))
 				return -EINVAL;
 			if (copy_from_user(&offset, off_out, sizeof(loff_t)))
 				return -EFAULT;
@@ -1342,8 +1341,7 @@ static long do_splice(struct file *in, loff_t __user *off_in,
 		if (off_out)
 			return -ESPIPE;
 		if (off_in) {
-			if (!in->f_op || !in->f_op->llseek ||
-			    in->f_op->llseek == no_llseek)
+			if (!(in->f_mode & FMODE_PREAD))
 				return -EINVAL;
 			if (copy_from_user(&offset, off_in, sizeof(loff_t)))
 				return -EFAULT;
