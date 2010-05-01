Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933398Ab0EAOqy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 10:46:54 -0400
Received: from tarap.cc.columbia.edu ([128.59.29.7]:64026 "EHLO
	tarap.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968Ab0EAOgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 10:36:00 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>, Matt Helsley <matthltc@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, linux-fsdevel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Subject: [PATCH v21 063/100] c/r: restore file->f_cred
Date: Sat,  1 May 2010 10:15:45 -0400
Message-Id: <1272723382-19470-64-git-send-email-orenl@cs.columbia.edu>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
References: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Serge E. Hallyn <serue@us.ibm.com>

Restore a file's f_cred.  This is set to the cred of the task doing
the open, so often it will be the same as that of the restarted task.

Changelog[v1]:
  - [Nathan Lynch] discard const from struct cred * where appropriate

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Acked-by: Oren Laadan <orenl@cs.columbia.edu>
Cc: linux-fsdevel@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>
---
 fs/checkpoint.c                |   21 ++++++++++++++++++---
 include/linux/checkpoint_hdr.h |    2 +-
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/fs/checkpoint.c b/fs/checkpoint.c
index 874be00..783c920 100644
--- a/fs/checkpoint.c
+++ b/fs/checkpoint.c
@@ -148,14 +148,21 @@ static int scan_fds(struct files_struct *files, int **fdtable)
 int checkpoint_file_common(struct ckpt_ctx *ctx, struct file *file,
 			   struct ckpt_hdr_file *h)
 {
+	struct cred *f_cred = (struct cred *) file->f_cred;
+
 	h->f_flags = file->f_flags;
 	h->f_mode = file->f_mode;
 	h->f_pos = file->f_pos;
 	h->f_version = file->f_version;
 
-	ckpt_debug("file %s", file->f_dentry->d_name.name);
+	h->f_credref = checkpoint_obj(ctx, f_cred, CKPT_OBJ_CRED);
+	if (h->f_credref < 0)
+		return h->f_credref;
+
+	ckpt_debug("file %s credref %d", file->f_dentry->d_name.name,
+		h->f_credref);
 
-	/* FIX: need also file->uid, file->gid, file->f_owner, etc */
+	/* FIX: need also file->f_owner, etc */
 
 	return 0;
 }
@@ -516,8 +523,16 @@ int restore_file_common(struct ckpt_ctx *ctx, struct file *file,
 	fmode_t new_mode = file->f_mode;
 	fmode_t saved_mode = (__force fmode_t) h->f_mode;
 	int ret;
+	struct cred *cred;
+
+	/* FIX: need to restore owner etc */
 
-	/* FIX: need to restore uid, gid, owner etc */
+	/* restore the cred */
+	cred = ckpt_obj_fetch(ctx, h->f_credref, CKPT_OBJ_CRED);
+	if (IS_ERR(cred))
+		return PTR_ERR(cred);
+	put_cred(file->f_cred);
+	file->f_cred = get_cred(cred);
 
 	/* safe to set 1st arg (fd) to 0, as command is F_SETFL */
 	ret = vfs_fcntl(0, F_SETFL, h->f_flags & CKPT_SETFL_MASK, file);
diff --git a/include/linux/checkpoint_hdr.h b/include/linux/checkpoint_hdr.h
index 8598eb5..261badb 100644
--- a/include/linux/checkpoint_hdr.h
+++ b/include/linux/checkpoint_hdr.h
@@ -437,7 +437,7 @@ struct ckpt_hdr_file {
 	__u32 f_type;
 	__u32 f_mode;
 	__u32 f_flags;
-	__u32 _padding;
+	__s32 f_credref;
 	__u64 f_pos;
 	__u64 f_version;
 } __attribute__((aligned(8)));
-- 
1.6.3.3

