Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab2FLRYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 13:24:40 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:21226 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab2FLRYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 13:24:38 -0400
Message-ID: <201206121724.q5CHOaeU002148@farm-0023.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 12 Jun 2012 13:18:19 -0400
Subject: [PATCH] sched/numa: fix compat declarations for sys_numa_{t,m}bind()
To: Arnd Bergmann <arnd@arndb.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The asm-generic code needs actual declarations of the routines,
and the syscall entries need to reference the correct names.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
The tilegx architecture is currently broken in linux-next because
of this issue.

However, although this fixes the problem, I'd like to question the use of
"compat" syscall entries here at all.  The syscalls in question take only
"int" and "unsigned long" arguments, so it would seem that you could
use them directly from compat userspace.  The compat code present in
the original commit just calls onward to the normal versions without
any other changes, so I think it should be sufficient to use a model
more like sys_mprotect, for example, where there is no compat function.

 include/asm-generic/unistd.h |    4 ++--
 include/linux/compat.h       |    6 ++++++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/unistd.h b/include/asm-generic/unistd.h
index 4dfef49..43c6b8d 100644
--- a/include/asm-generic/unistd.h
+++ b/include/asm-generic/unistd.h
@@ -692,9 +692,9 @@ __SC_COMP(__NR_process_vm_readv, sys_process_vm_readv, \
 __SC_COMP(__NR_process_vm_writev, sys_process_vm_writev, \
           compat_sys_process_vm_writev)
 #define __NR_numa_mbind 272
-__SC_COMP(__NR_numa_mbind, sys_numa_mbind, compat_sys_ms_mbind)
+__SC_COMP(__NR_numa_mbind, sys_numa_mbind, compat_sys_numa_mbind)
 #define __NR_numa_tbind 273
-__SC_COMP(__NR_numa_tbind, sys_numa_tbind, compat_sys_ms_tbind)
+__SC_COMP(__NR_numa_tbind, sys_numa_tbind, compat_sys_numa_tbind)
 
 #undef __NR_syscalls
 #define __NR_syscalls 274
diff --git a/include/linux/compat.h b/include/linux/compat.h
index 4e89039..bb081e1 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -590,6 +590,12 @@ asmlinkage ssize_t compat_sys_process_vm_writev(compat_pid_t pid,
 		unsigned long liovcnt, const struct compat_iovec __user *rvec,
 		unsigned long riovcnt, unsigned long flags);
 
+asmlinkage long compat_sys_numa_mbind(compat_ulong_t addr, compat_ulong_t len,
+				      compat_int_t ng_id,
+                                      compat_ulong_t flags);
+asmlinkage long compat_sys_numa_tbind(compat_int_t tid, compat_int_t ng_id,
+				      compat_ulong_t flags);
+
 #else
 
 #define is_compat_task() (0)
-- 
1.7.10.3

