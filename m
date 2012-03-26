Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932667Ab2CZPJ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 11:09:29 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39173 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932519Ab2CZPJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 11:09:28 -0400
Date: Mon, 26 Mar 2012 19:09:24 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>, Oleg Nesterov <oleg@redhat.com>
Subject: [rfc] fcntl: Add F_GETOWNER_UIDS option
Message-ID: <20120326150924.GG19395@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

I would like to get opinions on this proposal.
What do you think? Is there some security check
I'm missing?

---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: fcntl: Add F_GETOWNER_UIDS option

When we restore file descriptors we would like
them to look exactly as they were at dumping time.

With help of fcntl it's almost possible, the missing
snippet is file owners UIDs.

To be able to read their values the F_GETOWNER_UIDS
is introduced.

This option is valid iif CONFIG_CHECKPOINT_RESTORE
is turned on, otherwise returning -EINVAL.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 fs/fcntl.c                  |   33 +++++++++++++++++++++++++++++++++
 include/asm-generic/fcntl.h |    4 ++++
 security/selinux/hooks.c    |    1 +
 3 files changed, 38 insertions(+)

Index: linux-2.6.git/fs/fcntl.c
===================================================================
--- linux-2.6.git.orig/fs/fcntl.c
+++ linux-2.6.git/fs/fcntl.c
@@ -20,6 +20,7 @@
 #include <linux/signal.h>
 #include <linux/rcupdate.h>
 #include <linux/pid_namespace.h>
+#include <linux/user_namespace.h>
 
 #include <asm/poll.h>
 #include <asm/siginfo.h>
@@ -340,6 +341,35 @@ static int f_getown_ex(struct file *filp
 	return ret;
 }
 
+#ifdef CONFIG_CHECKPOINT_RESTORE
+static int f_getowner_uids(struct file *filp, unsigned long arg)
+{
+	struct user_namespace *user_ns = current_user_ns();
+	const struct cred *cred = current_cred();
+	uid_t * __user dst = (void * __user)arg;
+	uid_t src[2];
+	int err;
+
+	read_lock(&filp->f_owner.lock);
+	src[0] = filp->f_owner.uid;
+	src[1] = filp->f_owner.euid;
+	read_unlock(&filp->f_owner.lock);
+
+	src[0] = user_ns_map_uid(user_ns, cred, src[0]);
+	src[1] = user_ns_map_uid(user_ns, cred, src[1]);
+
+	err  = put_user(src[0], &dst[0]);
+	err |= put_user(src[1], &dst[1]);
+
+	return err;
+}
+#else
+static int f_getowner_uids(struct file *filp, unsigned long arg)
+{
+	return -EINVAL;
+}
+#endif
+
 static long do_fcntl(int fd, unsigned int cmd, unsigned long arg,
 		struct file *filp)
 {
@@ -396,6 +426,9 @@ static long do_fcntl(int fd, unsigned in
 	case F_SETOWN_EX:
 		err = f_setown_ex(filp, arg);
 		break;
+	case F_GETOWNER_UIDS:
+		err = f_getowner_uids(filp, arg);
+		break;
 	case F_GETSIG:
 		err = filp->f_owner.signum;
 		break;
Index: linux-2.6.git/include/asm-generic/fcntl.h
===================================================================
--- linux-2.6.git.orig/include/asm-generic/fcntl.h
+++ linux-2.6.git/include/asm-generic/fcntl.h
@@ -120,6 +120,10 @@
 #define F_GETOWN_EX	16
 #endif
 
+#ifndef F_GETOWNER_UIDS
+#define F_GETOWNER_UIDS	17
+#endif
+
 #define F_OWNER_TID	0
 #define F_OWNER_PID	1
 #define F_OWNER_PGRP	2
Index: linux-2.6.git/security/selinux/hooks.c
===================================================================
--- linux-2.6.git.orig/security/selinux/hooks.c
+++ linux-2.6.git/security/selinux/hooks.c
@@ -3138,6 +3138,7 @@ static int selinux_file_fcntl(struct fil
 	case F_GETFL:
 	case F_GETOWN:
 	case F_GETSIG:
+	case F_GETOWNER_UIDS:
 		/* Just check FD__USE permission */
 		err = file_has_perm(cred, file, 0);
 		break;
