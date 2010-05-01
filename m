Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932925Ab0EAOig (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 10:38:36 -0400
Received: from tarap.cc.columbia.edu ([128.59.29.7]:64284 "EHLO
	tarap.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932839Ab0EAOiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 10:38:22 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>, Matt Helsley <matthltc@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Davide Libenzi <davidel@xmailserver.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH v21 080/100] c/r: checkpoint/restart eventfd
Date: Sat,  1 May 2010 10:16:02 -0400
Message-Id: <1272723382-19470-81-git-send-email-orenl@cs.columbia.edu>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
References: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Helsley <matthltc@us.ibm.com>

Save/restore eventfd files. These are anon_inodes just like epoll
but instead of a set of files to poll they are a 64-bit counter
and a flag value. Used for AIO.

[Oren Laadan] Added #ifdef's around checkpoint/restart to compile even
without CONFIG_CHECKPOINT

Changelog[v21]:
  - Add missing spin locks around eventfd checkpoint
  - Put file_ops->checkpoint under CONFIG_CHECKPOINT
Changelog[v19]:
  - Fix broken compilation for architectures that don't support c/r

Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
Acked-by: Oren Laadan <orenl@cs.columbia.edu>
Acked-by: Serge E. Hallyn <serue@us.ibm.com>
Tested-by: Serge E. Hallyn <serue@us.ibm.com>
---
 fs/checkpoint.c                |    7 +++++
 fs/eventfd.c                   |   57 ++++++++++++++++++++++++++++++++++++++++
 include/linux/checkpoint_hdr.h |    8 +++++
 include/linux/eventfd.h        |   10 +++++++
 4 files changed, 82 insertions(+), 0 deletions(-)

diff --git a/fs/checkpoint.c b/fs/checkpoint.c
index 3bfa692..e0f8a15 100644
--- a/fs/checkpoint.c
+++ b/fs/checkpoint.c
@@ -22,6 +22,7 @@
 #include <linux/deferqueue.h>
 #include <linux/checkpoint.h>
 #include <linux/eventpoll.h>
+#include <linux/eventfd.h>
 #include <net/sock.h>
 
 /**************************************************************************
@@ -639,6 +640,12 @@ static struct restore_file_ops restore_file_ops[] = {
 		.file_type = CKPT_FILE_EPOLL,
 		.restore = ep_file_restore,
 	},
+	/* eventfd */
+	{
+		.file_name = "EVENTFD",
+		.file_type = CKPT_FILE_EVENTFD,
+		.restore = eventfd_restore,
+	},
 };
 
 static void *restore_file(struct ckpt_ctx *ctx)
diff --git a/fs/eventfd.c b/fs/eventfd.c
index 6bd3f76..307beca 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -19,6 +19,7 @@
 #include <linux/module.h>
 #include <linux/kref.h>
 #include <linux/eventfd.h>
+#include <linux/checkpoint.h>
 
 struct eventfd_ctx {
 	struct kref kref;
@@ -288,11 +289,67 @@ static ssize_t eventfd_write(struct file *file, const char __user *buf, size_t c
 	return res;
 }
 
+#ifdef CONFIG_CHECKPOINT
+static int eventfd_checkpoint(struct ckpt_ctx *ckpt_ctx, struct file *file)
+{
+	struct eventfd_ctx *ctx;
+	struct ckpt_hdr_file_eventfd *h;
+	int ret = -ENOMEM;
+
+	h = ckpt_hdr_get_type(ckpt_ctx, sizeof(*h), CKPT_HDR_FILE);
+	if (!h)
+		return -ENOMEM;
+	h->common.f_type = CKPT_FILE_EVENTFD;
+	ret = checkpoint_file_common(ckpt_ctx, file, &h->common);
+	if (ret < 0)
+		goto out;
+	ctx = file->private_data;
+	spin_lock_irq(&ctx->wqh.lock);
+	h->count = ctx->count;
+	h->flags = ctx->flags;
+	spin_unlock_irq(&ctx->wqh.lock);
+	ret = ckpt_write_obj(ckpt_ctx, &h->common.h);
+out:
+	ckpt_hdr_put(ckpt_ctx, h);
+	return ret;
+}
+
+struct file *eventfd_restore(struct ckpt_ctx *ckpt_ctx,
+			     struct ckpt_hdr_file *ptr)
+{
+	struct ckpt_hdr_file_eventfd *h = (struct ckpt_hdr_file_eventfd *) ptr;
+	struct file *evfile;
+	int evfd, ret;
+
+	/* Already know type == CKPT_HDR_FILE and f_type == CKPT_FILE_EVENTFD */
+	if (h->common.h.len != sizeof(*h))
+		return ERR_PTR(-EINVAL);
+
+	evfd = sys_eventfd2(h->count, h->flags);
+	if (evfd < 0)
+		return ERR_PTR(evfd);
+	evfile = fget(evfd);
+	sys_close(evfd);
+	if (!evfile)
+		return ERR_PTR(-EBUSY);
+
+	ret = restore_file_common(ckpt_ctx, evfile, &h->common);
+	if (ret < 0) {
+		fput(evfile);
+		return ERR_PTR(ret);
+	}
+	return evfile;
+}
+#endif
+
 static const struct file_operations eventfd_fops = {
 	.release	= eventfd_release,
 	.poll		= eventfd_poll,
 	.read		= eventfd_read,
 	.write		= eventfd_write,
+#ifdef CONFIG_CHECKPOINT
+	.checkpoint     = eventfd_checkpoint,
+#endif
 };
 
 /**
diff --git a/include/linux/checkpoint_hdr.h b/include/linux/checkpoint_hdr.h
index 21540d7..e89fbf9 100644
--- a/include/linux/checkpoint_hdr.h
+++ b/include/linux/checkpoint_hdr.h
@@ -489,6 +489,8 @@ enum file_type {
 #define CKPT_FILE_TTY CKPT_FILE_TTY
 	CKPT_FILE_EPOLL,
 #define CKPT_FILE_EPOLL CKPT_FILE_EPOLL
+	CKPT_FILE_EVENTFD,
+#define CKPT_FILE_EVENTFD CKPT_FILE_EVENTFD
 	CKPT_FILE_MAX
 #define CKPT_FILE_MAX CKPT_FILE_MAX
 };
@@ -513,6 +515,12 @@ struct ckpt_hdr_file_pipe {
 	__s32 pipe_objref;
 } __attribute__((aligned(8)));
 
+struct ckpt_hdr_file_eventfd {
+	struct ckpt_hdr_file common;
+	__u64 count;
+	__u32 flags;
+} __attribute__((aligned(8)));
+
 /* socket */
 struct ckpt_hdr_socket {
 	struct ckpt_hdr h;
diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
index 91bb4f2..e8238cc 100644
--- a/include/linux/eventfd.h
+++ b/include/linux/eventfd.h
@@ -39,6 +39,14 @@ ssize_t eventfd_ctx_read(struct eventfd_ctx *ctx, int no_wait, __u64 *cnt);
 int eventfd_ctx_remove_wait_queue(struct eventfd_ctx *ctx, wait_queue_t *wait,
 				  __u64 *cnt);
 
+#ifdef CONFIG_CHECKPOINT
+struct ckpt_ctx;
+struct ckpt_hdr_file;
+
+struct file *eventfd_restore(struct ckpt_ctx *ckpt_ctx,
+			     struct ckpt_hdr_file *ptr);
+#endif
+
 #else /* CONFIG_EVENTFD */
 
 /*
@@ -77,6 +85,8 @@ static inline int eventfd_ctx_remove_wait_queue(struct eventfd_ctx *ctx,
 	return -ENOSYS;
 }
 
+#define eventfd_restore NULL
+
 #endif
 
 #endif /* _LINUX_EVENTFD_H */
-- 
1.6.3.3

