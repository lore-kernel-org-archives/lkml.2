Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932892Ab2GKPco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 11:32:44 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51560 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755722Ab2GKPcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 11:32:39 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: davem@davemloft.net, chris@zankel.net, catalin.marinas@arm.com,
        arnd@arndb.de, cmetcalf@tilera.com, akpm@linux-foundation.org,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 3/3] ipc: compat: use signed size_t types for msgsnd and msgrcv
Date: Wed, 11 Jul 2012 16:32:21 +0100
Message-Id: <1342020741-12758-4-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1342020741-12758-1-git-send-email-will.deacon@arm.com>
References: <1342020741-12758-1-git-send-email-will.deacon@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The msgsnd and msgrcv system calls use size_t to represent the size of
the message being transferred. POSIX states that values of msgsz greater
than SSIZE_MAX cause the result to be implementation-defined. On Linux,
this equates to returning -EINVAL if (long) msgsz < 0.

For compat tasks where !CONFIG_ARCH_WANT_OLD_COMPAT_IPC and
compat_size_t is smaller than size_t, negative size values passed from
userspace will be interpreted as positive values by do_msg{rcv,snd} and
will fail to exit early with -EINVAL.

This patch changes the compat prototypes for msg{rcv,snd} so that the
message size is represented as a compat_ssize_t, which we cast to the
native ssize_t type for the core IPC code.

Cc: Arnd Bergmann <arnd@arndb.de>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 include/linux/compat.h |    4 ++--
 ipc/compat.c           |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/compat.h b/include/linux/compat.h
index 9f68e90..f2b8fe2 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -266,9 +266,9 @@ long compat_sys_shmat(int first, int second, compat_uptr_t third, int version,
 #else
 long compat_sys_semctl(int semid, int semnum, int cmd, int arg);
 long compat_sys_msgsnd(int msqid, struct compat_msgbuf __user *msgp,
-		size_t msgsz, int msgflg);
+		compat_ssize_t msgsz, int msgflg);
 long compat_sys_msgrcv(int msqid, struct compat_msgbuf __user *msgp,
-		size_t msgsz, long msgtyp, int msgflg);
+		compat_ssize_t msgsz, long msgtyp, int msgflg);
 long compat_sys_shmat(int shmid, compat_uptr_t shmaddr, int shmflg);
 #endif
 long compat_sys_msgctl(int first, int second, void __user *uptr);
diff --git a/ipc/compat.c b/ipc/compat.c
index a41600f..20f92b2 100644
--- a/ipc/compat.c
+++ b/ipc/compat.c
@@ -373,21 +373,21 @@ long compat_sys_semctl(int semid, int semnum, int cmd, int arg)
 }
 
 long compat_sys_msgsnd(int msqid, struct compat_msgbuf __user *msgp,
-		       size_t msgsz, int msgflg)
+		       compat_ssize_t msgsz, int msgflg)
 {
 	compat_long_t mtype;
 
 	if (get_user(mtype, &msgp->mtype))
 		return -EFAULT;
-	return do_msgsnd(msqid, mtype, msgp->mtext, msgsz, msgflg);
+	return do_msgsnd(msqid, mtype, msgp->mtext, (ssize_t)msgsz, msgflg);
 }
 
 long compat_sys_msgrcv(int msqid, struct compat_msgbuf __user *msgp,
-		       size_t msgsz, long msgtyp, int msgflg)
+		       compat_ssize_t msgsz, long msgtyp, int msgflg)
 {
 	long err, mtype;
 
-	err =  do_msgrcv(msqid, &mtype, msgp->mtext, msgsz, msgtyp, msgflg);
+	err =  do_msgrcv(msqid, &mtype, msgp->mtext, (ssize_t)msgsz, msgtyp, msgflg);
 	if (err < 0)
 		goto out;
 
-- 
1.7.4.1

