Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758888Ab0EZJ4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 05:56:10 -0400
Received: from mail-pz0-f176.google.com ([209.85.222.176]:45954 "EHLO
	mail-pz0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab0EZJ4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 05:56:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=bTUY1IfL2JPMKx2hAiDwdy1uKwgUxQzNQvInna5kvhK2/GLp1pQ73f9F6HPh7rDxOn
         9CLJTglUsehmWyV2qfPse1ZRN7Lm90TDN2Rfh/+IP9z8J8IuOAHoQ43dGE0erqzIi7Pa
         oQrhZfBsBqPntEA6CCpZGNRQYiuj85sPQGuDM=
From: Changli Gao <xiaosuo@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH 1/3] splice: check f_mode for seekable file
Date: Wed, 26 May 2010 17:55:15 +0800
Message-Id: <1274867715-2936-1-git-send-email-xiaosuo@gmail.com>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

check f_mode for seekable file

As a seekable file is allowed without a llseek function, so the old way isn't
work any more.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
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
