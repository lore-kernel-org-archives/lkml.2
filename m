Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072Ab0FWKEl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:04:41 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:50609 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab0FWKEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 06:04:37 -0400
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
       Chase Douglas <cndougla@linux.vnet.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 29/40] trace syscalls, PPC: Convert ppc32_ syscalls to ARCH_COMPAT_SYSCALL_DEFINE
Date: Wed, 23 Jun 2010 20:03:10 +1000
Message-Id: <1277287401-28571-30-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
References: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

This patch renames the 32bit compat syscalls prefixed with ppc32_ to
sys32_ and uses the ARCH_COMPAT_SYSCALL_DEFINE macros to record their
metadata for tracing.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 arch/powerpc/include/asm/systbl.h |    4 ++--
 arch/powerpc/kernel/sys_ppc32.c   |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/include/asm/systbl.h b/arch/powerpc/include/asm/systbl.h
index 228eecb..bbcc700 100644
--- a/arch/powerpc/include/asm/systbl.h
+++ b/arch/powerpc/include/asm/systbl.h
@@ -236,9 +236,9 @@ COMPAT_SYS_SPU(io_getevents)
 COMPAT_SYS_SPU(io_submit)
 SYSCALL_SPU(io_cancel)
 SYSCALL(set_tid_address)
-SYSX_SPU(sys_fadvise64,ppc32_fadvise64,sys_fadvise64)
+SYSX_SPU(sys_fadvise64,sys32_fadvise64,sys_fadvise64)
 SYSCALL(exit_group)
-SYSX(sys_lookup_dcookie,ppc32_lookup_dcookie,sys_lookup_dcookie)
+SYSX(sys_lookup_dcookie,sys32_lookup_dcookie,sys_lookup_dcookie)
 SYSCALL_SPU(epoll_create)
 SYSCALL_SPU(epoll_ctl)
 SYSCALL_SPU(epoll_wait)
diff --git a/arch/powerpc/kernel/sys_ppc32.c b/arch/powerpc/kernel/sys_ppc32.c
index 27cf460..cf18164 100644
--- a/arch/powerpc/kernel/sys_ppc32.c
+++ b/arch/powerpc/kernel/sys_ppc32.c
@@ -594,15 +594,15 @@ asmlinkage int compat_sys_ftruncate64(unsigned int fd, u32 reg4, unsigned long h
 	return sys_ftruncate(fd, (high << 32) | low);
 }
 
-long ppc32_lookup_dcookie(u32 cookie_high, u32 cookie_low, char __user *buf,
-			  size_t len)
+ARCH_COMPAT_SYSCALL_DEFINE4(lookup_dcookie, u32, cookie_high, u32, cookie_low,
+		char __user *, buf, size_t, len)
 {
 	return sys_lookup_dcookie((u64)cookie_high << 32 | cookie_low,
 				  buf, len);
 }
 
-long ppc32_fadvise64(int fd, u32 unused, u32 offset_high, u32 offset_low,
-		     size_t len, int advice)
+ARCH_COMPAT_SYSCALL_DEFINE6(fadvise64, int, fd, u32, unused, u32, offset_high,
+		u32, offset_low, size_t, len, int, advice)
 {
 	return sys_fadvise64(fd, (u64)offset_high << 32 | offset_low, len,
 			     advice);
-- 
1.7.1

