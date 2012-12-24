Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab2LXIOo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 03:14:44 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:42448 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977Ab2LXIOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 03:14:31 -0500
From: Andrey Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: criu@openvz.org, linux-fsdevel@vger.kernel.org,
        Andrey Vagin <avagin@openvz.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [PATCH 3/4] signalfd: add ability to choose a private or shared queue
Date: Mon, 24 Dec 2012 12:13:26 +0400
Message-Id: <1356336807-5517-4-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1356336807-5517-1-git-send-email-avagin@openvz.org>
References: <1356336807-5517-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is added two flags SFD_GROUP and SFD_SHARED.
SFD_SHARED - read signals from a shared queue
SFD_PRIVATE - read signals from a private queue

Without this flags or with both flags signals are read from both queues.

This functionality is requered for dumping pending signals.

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
CC: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 fs/signalfd.c                 | 25 +++++++++++++++++++------
 include/uapi/linux/signalfd.h |  2 ++
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/fs/signalfd.c b/fs/signalfd.c
index 95f1444..a35aeda 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -170,13 +170,13 @@ static int signalfd_copyinfo(struct signalfd_siginfo __user *uinfo,
 }
 
 static ssize_t signalfd_dequeue(struct signalfd_ctx *ctx, siginfo_t *info,
-				int nonblock)
+				int nonblock, int queue)
 {
 	ssize_t ret;
 	DECLARE_WAITQUEUE(wait, current);
 
 	spin_lock_irq(&current->sighand->siglock);
-	ret = dequeue_signal(current, &ctx->sigmask, info);
+	ret = do_dequeue_signal(current, &ctx->sigmask, info, queue);
 	switch (ret) {
 	case 0:
 		if (!nonblock)
@@ -223,14 +223,21 @@ static ssize_t signalfd_read(struct file *file, char __user *buf, size_t count,
 	bool raw = file->f_flags & SFD_RAW;
 	ssize_t ret, total = 0;
 	siginfo_t info;
+	int queue = 0;
 
 	count /= sizeof(struct signalfd_siginfo);
 	if (!count)
 		return -EINVAL;
 
+	if (file->f_flags & SFD_GROUP)
+		queue++;
+
+	if (file->f_flags & SFD_PRIVATE)
+		queue--;
+
 	siginfo = (struct signalfd_siginfo __user *) buf;
 	do {
-		ret = signalfd_dequeue(ctx, &info, nonblock);
+		ret = signalfd_dequeue(ctx, &info, nonblock, queue);
 		if (unlikely(ret <= 0))
 			break;
 
@@ -274,6 +281,8 @@ static const struct file_operations signalfd_fops = {
 	.llseek		= noop_llseek,
 };
 
+#define SIGNAFD_FLAGS (SFD_RAW | SFD_GROUP | SFD_PRIVATE)
+
 SYSCALL_DEFINE4(signalfd4, int, ufd, sigset_t __user *, user_mask,
 		size_t, sizemask, int, flags)
 {
@@ -284,7 +293,7 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sigset_t __user *, user_mask,
 	BUILD_BUG_ON(SFD_CLOEXEC != O_CLOEXEC);
 	BUILD_BUG_ON(SFD_NONBLOCK != O_NONBLOCK);
 
-	if (flags & ~(SFD_CLOEXEC | SFD_NONBLOCK | SFD_RAW))
+	if (flags & ~(SFD_CLOEXEC | SFD_NONBLOCK | SIGNAFD_FLAGS))
 		return -EINVAL;
 
 	if (sizemask != sizeof(sigset_t) ||
@@ -308,9 +317,9 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sigset_t __user *, user_mask,
 				       O_RDWR | (flags & (O_CLOEXEC | O_NONBLOCK)));
 		if (ufd < 0)
 			kfree(ctx);
-		else if (flags & SFD_RAW) {
+		else if (flags & SIGNAFD_FLAGS) {
 			struct fd f = fdget(ufd);
-			f.file->f_flags |= flags & SFD_RAW;
+			f.file->f_flags |= flags & SIGNAFD_FLAGS;
 			fdput(f);
 		}
 	} else {
@@ -322,6 +331,10 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sigset_t __user *, user_mask,
 			fdput(f);
 			return -EINVAL;
 		}
+
+		f.file->f_flags = (f.file->f_flags & ~SIGNAFD_FLAGS) |
+						(flags & SIGNAFD_FLAGS);
+
 		spin_lock_irq(&current->sighand->siglock);
 		ctx->sigmask = sigmask;
 		spin_unlock_irq(&current->sighand->siglock);
diff --git a/include/uapi/linux/signalfd.h b/include/uapi/linux/signalfd.h
index bc31849..9421321 100644
--- a/include/uapi/linux/signalfd.h
+++ b/include/uapi/linux/signalfd.h
@@ -16,6 +16,8 @@
 #define SFD_CLOEXEC O_CLOEXEC
 #define SFD_NONBLOCK O_NONBLOCK
 #define SFD_RAW O_DIRECT
+#define SFD_GROUP O_DIRECTORY
+#define SFD_PRIVATE O_EXCL
 
 struct signalfd_siginfo {
 	__u32 ssi_signo;
-- 
1.7.11.7

