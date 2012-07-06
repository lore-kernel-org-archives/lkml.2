Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763Ab2GFVOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 17:14:41 -0400
Received: from service87.mimecast.com ([91.220.42.44]:60877 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758309Ab2GFVGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 17:06:38 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>
Subject: [PATCH 03/36] ipc: allow compat IPC version field parsing if !ARCH_WANT_OLD_COMPAT_IPC
Date: Fri,  6 Jul 2012 22:05:44 +0100
Message-Id: <1341608777-12982-4-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 06 Jul 2012 21:07:29.0875 (UTC) FILETIME=[5A7CC230:01CD5BBB]
X-MC-Unique: 112070622063605101
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id q66LEkeD005466

From: Will Deacon <will.deacon@arm.com>

Commit 48b25c43 ("[PATCH v3] ipc: provide generic compat versions of IPC
syscalls") added a new ARCH_WANT_OLD_COMPAT_IPC config option for
architectures to select if their compat target requires the old IPC
syscall interface.

For architectures that do not require the internal calling conventions
provided by this option, but have a compat target where the C library
passes the IPC_64 flag explicitly, compat_ipc_parse_version no longer
strips out the flag before calling the native system call
implementation, resulting in unknown SHM/IPC commands and -EINVAL being
returned to userspace.

This patch separates the selection of the internal calling conventions
for the IPC syscalls from the version parsing, allowing architectures to
select __ARCH_WANT_COMPAT_IPC_PARSE_VERSION if they want to use version
parsing whilst retaining the newer syscall calling conventions.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 include/linux/compat.h |    1 +
 ipc/compat.c           |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/compat.h b/include/linux/compat.h
index 4e89039..9f68e90 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -256,6 +256,7 @@ compat_sys_get_robust_list(int pid, compat_uptr_t __user *head_ptr,
 			   compat_size_t __user *len_ptr);
 
 #ifdef CONFIG_ARCH_WANT_OLD_COMPAT_IPC
+#define __ARCH_WANT_COMPAT_IPC_PARSE_VERSION
 long compat_sys_semctl(int first, int second, int third, void __user *uptr);
 long compat_sys_msgsnd(int first, int second, int third, void __user *uptr);
 long compat_sys_msgrcv(int first, int second, int msgtyp, int third,
diff --git a/ipc/compat.c b/ipc/compat.c
index 53cebdf..a41600f 100644
--- a/ipc/compat.c
+++ b/ipc/compat.c
@@ -118,7 +118,7 @@ extern int sem_ctls[];
 
 static inline int compat_ipc_parse_version(int *cmd)
 {
-#ifdef CONFIG_ARCH_WANT_OLD_COMPAT_IPC
+#ifdef	__ARCH_WANT_COMPAT_IPC_PARSE_VERSION
 	int version = *cmd & IPC_64;
 
 	/* this is tricky: architectures that have support for the old

