Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab2LXIOt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 03:14:49 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:26547 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960Ab2LXIOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 03:14:30 -0500
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
Subject: [PATCH 1/4] signalfd: add ability to return siginfo in a raw format
Date: Mon, 24 Dec 2012 12:13:24 +0400
Message-Id: <1356336807-5517-2-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1356336807-5517-1-git-send-email-avagin@openvz.org>
References: <1356336807-5517-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

signalfd should be called with the flag SFD_RAW for that.

signalfd_siginfo is not full for siginfo with a negative si_code.
copy_siginfo_to_user() is copied a full siginfo to user-space, if
si_code is negative.  signalfd_copyinfo() doesn't do that and can't be
expanded, because it has not compatiable format with siginfo_t.

Another problem is that a constant __SI_* is removed from si_code.
It's not a problem for ussual applications, because they expect
a defined type of siginfo (internal logic).
When we want to dump pending signals, we can't predict a type of
siginfo, so we should get it from kernel.

This fuctionality is required for checkpointing pending signals.

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
 fs/signalfd.c                 | 31 +++++++++++++++++++++++++++++--
 include/uapi/linux/signalfd.h |  1 +
 2 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/fs/signalfd.c b/fs/signalfd.c
index b534869..95f1444 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -73,6 +73,21 @@ static unsigned int signalfd_poll(struct file *file, poll_table *wait)
 	return events;
 }
 
+static int signalfd_copy_raw_info(struct signalfd_siginfo __user *siginfo,
+					siginfo_t *kinfo)
+{
+	siginfo_t *uinfo = (siginfo_t *) siginfo;
+	int err;
+
+	BUILD_BUG_ON(sizeof(siginfo_t) != sizeof(struct signalfd_siginfo));
+
+	err = __clear_user(uinfo, sizeof(*uinfo));
+	err |= copy_siginfo_to_user(uinfo, kinfo);
+	err |= __put_user(kinfo->si_code, &uinfo->si_code);
+
+	return err ? -EFAULT: sizeof(*uinfo);
+}
+
 /*
  * Copied from copy_siginfo_to_user() in kernel/signal.c
  */
@@ -205,6 +220,7 @@ static ssize_t signalfd_read(struct file *file, char __user *buf, size_t count,
 	struct signalfd_ctx *ctx = file->private_data;
 	struct signalfd_siginfo __user *siginfo;
 	int nonblock = file->f_flags & O_NONBLOCK;
+	bool raw = file->f_flags & SFD_RAW;
 	ssize_t ret, total = 0;
 	siginfo_t info;
 
@@ -217,9 +233,15 @@ static ssize_t signalfd_read(struct file *file, char __user *buf, size_t count,
 		ret = signalfd_dequeue(ctx, &info, nonblock);
 		if (unlikely(ret <= 0))
 			break;
-		ret = signalfd_copyinfo(siginfo, &info);
+
+		if (raw)
+			ret = signalfd_copy_raw_info(siginfo, &info);
+		else
+			ret = signalfd_copyinfo(siginfo, &info);
+
 		if (ret < 0)
 			break;
+
 		siginfo++;
 		total += ret;
 		nonblock = 1;
@@ -262,7 +284,7 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sigset_t __user *, user_mask,
 	BUILD_BUG_ON(SFD_CLOEXEC != O_CLOEXEC);
 	BUILD_BUG_ON(SFD_NONBLOCK != O_NONBLOCK);
 
-	if (flags & ~(SFD_CLOEXEC | SFD_NONBLOCK))
+	if (flags & ~(SFD_CLOEXEC | SFD_NONBLOCK | SFD_RAW))
 		return -EINVAL;
 
 	if (sizemask != sizeof(sigset_t) ||
@@ -286,6 +308,11 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sigset_t __user *, user_mask,
 				       O_RDWR | (flags & (O_CLOEXEC | O_NONBLOCK)));
 		if (ufd < 0)
 			kfree(ctx);
+		else if (flags & SFD_RAW) {
+			struct fd f = fdget(ufd);
+			f.file->f_flags |= flags & SFD_RAW;
+			fdput(f);
+		}
 	} else {
 		struct fd f = fdget(ufd);
 		if (!f.file)
diff --git a/include/uapi/linux/signalfd.h b/include/uapi/linux/signalfd.h
index 492c6de..bc31849 100644
--- a/include/uapi/linux/signalfd.h
+++ b/include/uapi/linux/signalfd.h
@@ -15,6 +15,7 @@
 /* Flags for signalfd4.  */
 #define SFD_CLOEXEC O_CLOEXEC
 #define SFD_NONBLOCK O_NONBLOCK
+#define SFD_RAW O_DIRECT
 
 struct signalfd_siginfo {
 	__u32 ssi_signo;
-- 
1.7.11.7

