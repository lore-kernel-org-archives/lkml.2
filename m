Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab0FWKII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:08:08 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:59853 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863Ab0FWKEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 06:04:32 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: Jason Baron <jbaron@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Michael Ellerman <michael@ellerman.id.au>,
       Ian Munsie <imunsie@au1.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>,
       Jesper Nilsson <jesper.nilsson@axis.com>,
       David Howells <dhowells@redhat.com>
Subject: [PATCH 26/40] trace syscalls, PPC: Add PPC_REGS_SYSCALL_DEFINE macros
Date: Wed, 23 Jun 2010 20:03:07 +1000
Message-Id: <1277287401-28571-27-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
References: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

Certain system calls on PowerPC access to the registers through a 7th
parameter, which will not fit into the model of the existing
SYSCALL_DEFINE macros.

This patch a new class of macros to handle this situation, recording the
metadata required for ftrace syscalls but still using the correct syntax
to place the registers in the 7th parameter.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 arch/powerpc/include/asm/syscalls.h |   54 +++++++++++++++++++++++++++++++++++
 1 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/include/asm/syscalls.h b/arch/powerpc/include/asm/syscalls.h
index be37ef8..72badaa 100644
--- a/arch/powerpc/include/asm/syscalls.h
+++ b/arch/powerpc/include/asm/syscalls.h
@@ -5,12 +5,66 @@
 #include <linux/compiler.h>
 #include <linux/linkage.h>
 #include <linux/types.h>
+#include <linux/syscalls.h>
 #include <asm/signal.h>
 
 struct pt_regs;
 struct rtas_args;
 struct sigaction;
 
+#define __SC_DUMMY_ARGS0 unsigned long __dummy_arg_1, __SC_DUMMY_ARGS1
+#define __SC_DUMMY_ARGS1 unsigned long __dummy_arg_2, __SC_DUMMY_ARGS2
+#define __SC_DUMMY_ARGS2 unsigned long __dummy_arg_3, __SC_DUMMY_ARGS3
+#define __SC_DUMMY_ARGS3 unsigned long __dummy_arg_4, __SC_DUMMY_ARGS4
+#define __SC_DUMMY_ARGS4 unsigned long __dummy_arg_5, __SC_DUMMY_ARGS5
+#define __SC_DUMMY_ARGS5 unsigned long __dummy_arg_6, __SC_DUMMY_ARGS6
+#define __SC_DUMMY_ARGS6
+
+/* Native syscalls that require register access */
+#define PPC_REGS_SYSCALL_DEFINE1_RET(ret, name, regs, ...) PPC_REGS_SYSCALL_DEFINEx(1, ret, sys_##name, _##name, regs, __VA_ARGS__)
+#define PPC_REGS_SYSCALL_DEFINE2_RET(ret, name, regs, ...) PPC_REGS_SYSCALL_DEFINEx(2, ret, sys_##name, _##name, regs, __VA_ARGS__)
+#define PPC_REGS_SYSCALL_DEFINE3_RET(ret, name, regs, ...) PPC_REGS_SYSCALL_DEFINEx(3, ret, sys_##name, _##name, regs, __VA_ARGS__)
+#define PPC_REGS_SYSCALL_DEFINE4_RET(ret, name, regs, ...) PPC_REGS_SYSCALL_DEFINEx(4, ret, sys_##name, _##name, regs, __VA_ARGS__)
+#define PPC_REGS_SYSCALL_DEFINE5_RET(ret, name, regs, ...) PPC_REGS_SYSCALL_DEFINEx(5, ret, sys_##name, _##name, regs, __VA_ARGS__)
+#define PPC_REGS_SYSCALL_DEFINE6_RET(ret, name, regs, ...) PPC_REGS_SYSCALL_DEFINEx(6, ret, sys_##name, _##name, regs, __VA_ARGS__)
+
+#ifdef CONFIG_COMPAT
+
+/* 32bit compat syscalls that require register access */
+#define PPC_REGS_COMPAT_SYSCALL_DEFINE1_RET(ret, name, regs, ...) PPC_REGS_COMPAT_SYSCALL_DEFINEx(1, ret, compat_sys_##name, name, regs, __VA_ARGS__)
+#define PPC_REGS_COMPAT_SYSCALL_DEFINE2_RET(ret, name, regs, ...) PPC_REGS_COMPAT_SYSCALL_DEFINEx(2, ret, compat_sys_##name, name, regs, __VA_ARGS__)
+#define PPC_REGS_COMPAT_SYSCALL_DEFINE3_RET(ret, name, regs, ...) PPC_REGS_COMPAT_SYSCALL_DEFINEx(3, ret, compat_sys_##name, name, regs, __VA_ARGS__)
+#define PPC_REGS_COMPAT_SYSCALL_DEFINE4_RET(ret, name, regs, ...) PPC_REGS_COMPAT_SYSCALL_DEFINEx(4, ret, compat_sys_##name, name, regs, __VA_ARGS__)
+#define PPC_REGS_COMPAT_SYSCALL_DEFINE5_RET(ret, name, regs, ...) PPC_REGS_COMPAT_SYSCALL_DEFINEx(5, ret, compat_sys_##name, name, regs, __VA_ARGS__)
+#define PPC_REGS_COMPAT_SYSCALL_DEFINE6_RET(ret, name, regs, ...) PPC_REGS_COMPAT_SYSCALL_DEFINEx(6, ret, compat_sys_##name, name, regs, __VA_ARGS__)
+
+#define PPC_REGS_COMPAT_SYSCALL_DEFINEx(x, ret, sysname, sname, regs,  ...)	\
+	SYSCALL_METADATAx(sysname, compat_sys_##sname, x, compat_syscall, __VA_ARGS__);\
+	__PPC_REGS_SYSCALL_DEFINEx(x, ret, sysname, regs, __VA_ARGS__)
+
+#define PPC_REGS_COMPAT_SYSCALL_DEFINE0_RET(ret, name, regs)			\
+	SYSCALL_METADATA0(compat_sys_##name, name, syscall)			\
+	__PPC_REGS_SYSCALL_DEFINE0(ret, compat_sys_##name, regs)
+
+#endif /*CONFIG_COMPAT */
+
+#define PPC_REGS_SYSCALL_DEFINEx(x, ret, sysname, sname, regs, ...)		\
+	SYSCALL_METADATAx(sysname, sname, x, syscall, __VA_ARGS__);		\
+	__PPC_REGS_SYSCALL_DEFINEx(x, ret, sysname, regs, __VA_ARGS__)
+
+#define PPC_REGS_SYSCALL_DEFINE0_RET(ret, name, regs)				\
+	SYSCALL_METADATA0(sys_##name, name, syscall)				\
+	__PPC_REGS_SYSCALL_DEFINE0(ret, sys_##name, regs)
+
+#define __PPC_REGS_SYSCALL_DEFINEx(x, ret, sysname, regs, ...)			\
+	ret sysname(__SC_DECL##x(__VA_ARGS__),					\
+			__SC_DUMMY_ARGS##x					\
+			struct pt_regs *regs)
+
+#define __PPC_REGS_SYSCALL_DEFINE0(ret, sysname, regs)				\
+	ret sysname(__SC_DUMMY_ARGS0 struct pt_regs *regs)
+
+
 asmlinkage unsigned long sys_mmap(unsigned long addr, size_t len,
 		unsigned long prot, unsigned long flags,
 		unsigned long fd, off_t offset);
-- 
1.7.1

