Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab1HQBzH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 21:55:07 -0400
Received: from mail.windriver.com ([147.11.1.11]:39365 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab1HQBzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 21:55:06 -0400
From: Yong Zhang <yong.zhang@windriver.com>
To: <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>
CC: Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH] MIPS: use 32-bit wrapper for compat_sys_futex
Date: Wed, 17 Aug 2011 09:54:54 +0800
Message-ID: <1313546094-11882-1-git-send-email-yong.zhang@windriver.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can't trust in the caller(userspace) to give signed-extend
parameter, thus futex-wait may fail in some special case.

For example, if 'val' is too big and bit-31 is 1,
the caller may enter endless loop at:
futex_wait_setup()
{
	...

	if (uval != val) {
		queue_unlock(q, *hb);
		ret = -EWOULDBLOCK;

	...
}

Below assembler code will make it more easy to understand how
the patch take effect :)

Dump of assembler code for function SyS_32_futex:
   0xffffffff811b6fe8 <+0>:	sll	a1,a1,0x0
   0xffffffff811b6fec <+4>:	sll	a2,a2,0x0
   0xffffffff811b6ff0 <+8>:	j	0xffffffff8121a240 <compat_sys_futex>
   0xffffffff811b6ff4 <+12>:	sll	a5,a5,0x0

Signed-off-by: Yong Zhang <yong.zhang@windriver.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
---
 arch/mips/kernel/linux32.c     |    7 +++++++
 arch/mips/kernel/scall64-n32.S |    2 +-
 arch/mips/kernel/scall64-o32.S |    2 +-
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/mips/kernel/linux32.c b/arch/mips/kernel/linux32.c
index 876a75c..922a554 100644
--- a/arch/mips/kernel/linux32.c
+++ b/arch/mips/kernel/linux32.c
@@ -349,3 +349,10 @@ SYSCALL_DEFINE6(32_fanotify_mark, int, fanotify_fd, unsigned int, flags,
 	return sys_fanotify_mark(fanotify_fd, flags, merge_64(a3, a4),
 				 dfd, pathname);
 }
+
+SYSCALL_DEFINE6(32_futex, u32 __user *, uaddr, int, op, u32, val,
+		struct compat_timespec __user *, utime, u32 __user *, uaddr2,
+		u32, val3)
+{
+	return compat_sys_futex(uaddr, op, val, utime, uaddr2, val3);
+}
diff --git a/arch/mips/kernel/scall64-n32.S b/arch/mips/kernel/scall64-n32.S
index b85842f..c956cc9 100644
--- a/arch/mips/kernel/scall64-n32.S
+++ b/arch/mips/kernel/scall64-n32.S
@@ -315,7 +315,7 @@ EXPORT(sysn32_call_table)
 	PTR	sys_fremovexattr
 	PTR	sys_tkill
 	PTR	sys_ni_syscall
-	PTR	compat_sys_futex
+	PTR	sys_32_futex
 	PTR	compat_sys_sched_setaffinity	/* 6195 */
 	PTR	compat_sys_sched_getaffinity
 	PTR	sys_cacheflush
diff --git a/arch/mips/kernel/scall64-o32.S b/arch/mips/kernel/scall64-o32.S
index 46c4763..f48b18e 100644
--- a/arch/mips/kernel/scall64-o32.S
+++ b/arch/mips/kernel/scall64-o32.S
@@ -441,7 +441,7 @@ sys_call_table:
 	PTR	sys_fremovexattr		/* 4235 */
 	PTR	sys_tkill
 	PTR	sys_sendfile64
-	PTR	compat_sys_futex
+	PTR	sys_32_futex
 	PTR	compat_sys_sched_setaffinity
 	PTR	compat_sys_sched_getaffinity	/* 4240 */
 	PTR	compat_sys_io_setup
-- 
1.7.4.1

