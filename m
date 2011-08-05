Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065Ab1HEFht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 01:37:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:45372 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756319Ab1HEFhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 01:37:47 -0400
Date: Fri, 5 Aug 2011 05:37:41 GMT
From: tip-bot for Andy Lutomirski <luto@mit.edu>
Message-ID: <tip-9c40818da5b39fca236029059ab839857b1ef56c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        luto@mit.edu, a.miskiewicz@gmail.com, tglx@linutronix.de,
        hpa@linux.intel.com, luto@mit.edu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        luto@mit.edu, a.miskiewicz@gmail.com, tglx@linutronix.de,
        hpa@linux.intel.com, luto@mit.edu
In-Reply-To: <f0716870c297242a841b949953d80c0d87bf3d3f.1312378163.git.luto@mit.edu>
References: <f0716870c297242a841b949953d80c0d87bf3d3f.1312378163.git.luto@mit.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86-64: Move the "user" vsyscall segment out of the data segment.
Git-Commit-ID: 9c40818da5b39fca236029059ab839857b1ef56c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 05 Aug 2011 05:37:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9c40818da5b39fca236029059ab839857b1ef56c
Gitweb:     http://git.kernel.org/tip/9c40818da5b39fca236029059ab839857b1ef56c
Author:     Andy Lutomirski <luto@MIT.EDU>
AuthorDate: Wed, 3 Aug 2011 09:31:50 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 4 Aug 2011 16:13:35 -0700

x86-64: Move the "user" vsyscall segment out of the data segment.

The kernel's loader doesn't seem to care, but gold complains.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
Link: http://lkml.kernel.org/r/f0716870c297242a841b949953d80c0d87bf3d3f.1312378163.git.luto@mit.edu
Reported-by: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/vmlinux.lds.S |   36 ++++++++++++++++++------------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 4aa9c54..e79fb39 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -154,6 +154,24 @@ SECTIONS
 
 #ifdef CONFIG_X86_64
 
+	. = ALIGN(PAGE_SIZE);
+	__vvar_page = .;
+
+	.vvar : AT(ADDR(.vvar) - LOAD_OFFSET) {
+
+	      /* Place all vvars at the offsets in asm/vvar.h. */
+#define EMIT_VVAR(name, offset) 		\
+		. = offset;		\
+		*(.vvar_ ## name)
+#define __VVAR_KERNEL_LDS
+#include <asm/vvar.h>
+#undef __VVAR_KERNEL_LDS
+#undef EMIT_VVAR
+
+	} :data
+
+       . = ALIGN(__vvar_page + PAGE_SIZE, PAGE_SIZE);
+
 #define VSYSCALL_ADDR (-10*1024*1024)
 
 #define VLOAD_OFFSET (VSYSCALL_ADDR - __vsyscall_0 + LOAD_OFFSET)
@@ -162,7 +180,6 @@ SECTIONS
 #define VVIRT_OFFSET (VSYSCALL_ADDR - __vsyscall_0)
 #define VVIRT(x) (ADDR(x) - VVIRT_OFFSET)
 
-	. = ALIGN(4096);
 	__vsyscall_0 = .;
 
 	. = VSYSCALL_ADDR;
@@ -185,23 +202,6 @@ SECTIONS
 #undef VVIRT_OFFSET
 #undef VVIRT
 
-	__vvar_page = .;
-
-	.vvar : AT(ADDR(.vvar) - LOAD_OFFSET) {
-
-	      /* Place all vvars at the offsets in asm/vvar.h. */
-#define EMIT_VVAR(name, offset) 		\
-		. = offset;		\
-		*(.vvar_ ## name)
-#define __VVAR_KERNEL_LDS
-#include <asm/vvar.h>
-#undef __VVAR_KERNEL_LDS
-#undef EMIT_VVAR
-
-	} :data
-
-       . = ALIGN(__vvar_page + PAGE_SIZE, PAGE_SIZE);
-
 #endif /* CONFIG_X86_64 */
 
 	/* Init code and data - will be freed after init */
