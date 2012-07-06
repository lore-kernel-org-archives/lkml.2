Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760Ab2GFVOk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 17:14:40 -0400
Received: from service87.mimecast.com ([91.220.42.44]:60888 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758323Ab2GFVGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 17:06:38 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>
Subject: [PATCH 04/36] ipc: compat: use signed size_t types for msgsnd and msgrcv
Date: Fri,  6 Jul 2012 22:05:45 +0100
Message-Id: <1341608777-12982-5-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 06 Jul 2012 21:07:30.0188 (UTC) FILETIME=[5AAC84C0:01CD5BBB]
X-MC-Unique: 112070622063702001
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id q66LF0TK005471

From: Will Deacon <will.deacon@arm.com>

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

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
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
 

