Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab2BTARI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 19:17:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57296 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab2BTARF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 19:17:05 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        hjl.tools@gmail.com
Subject: [PATCH 18/30] x32: Generate <asm/unistd_x32.h>
Date: Sun, 19 Feb 2012 16:07:56 -0800
Message-Id: <1329696488-16970-19-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1329696488-16970-1-git-send-email-hpa@zytor.com>
References: <1329696488-16970-1-git-send-email-hpa@zytor.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 19 Feb 2012 16:16:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>

Generate <asm/unistd_x32.h>; this exports x32 system call numbers to
user space.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/Kbuild   |    1 +
 arch/x86/include/asm/unistd.h |    7 ++++++-
 arch/x86/syscalls/Makefile    |   10 ++++++++--
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/Kbuild b/arch/x86/include/asm/Kbuild
index 986954f..f9c0d3b 100644
--- a/arch/x86/include/asm/Kbuild
+++ b/arch/x86/include/asm/Kbuild
@@ -25,3 +25,4 @@ header-y += vsyscall.h
 
 genhdr-y += unistd_32.h
 genhdr-y += unistd_64.h
+genhdr-y += unistd_x32.h
diff --git a/arch/x86/include/asm/unistd.h b/arch/x86/include/asm/unistd.h
index 21f77b8..dab5349 100644
--- a/arch/x86/include/asm/unistd.h
+++ b/arch/x86/include/asm/unistd.h
@@ -1,6 +1,9 @@
 #ifndef _ASM_X86_UNISTD_H
 #define _ASM_X86_UNISTD_H 1
 
+/* x32 syscall flag bit */
+#define __X32_SYSCALL_BIT	0x40000000
+
 #ifdef __KERNEL__
 # ifdef CONFIG_X86_32
 
@@ -52,8 +55,10 @@
 #else
 # ifdef __i386__
 #  include <asm/unistd_32.h>
-# else
+# elif defined(__LP64__)
 #  include <asm/unistd_64.h>
+# else
+#  include <asm/unistd_x32.h>
 # endif
 #endif
 
diff --git a/arch/x86/syscalls/Makefile b/arch/x86/syscalls/Makefile
index 89dd958..54bdbd7 100644
--- a/arch/x86/syscalls/Makefile
+++ b/arch/x86/syscalls/Makefile
@@ -11,7 +11,8 @@ systbl := $(srctree)/$(src)/syscalltbl.sh
 
 quiet_cmd_syshdr = SYSHDR  $@
       cmd_syshdr = $(CONFIG_SHELL) '$(syshdr)' $< $@ \
-		   $(syshdr_abi_$(basetarget)) $(syshdr_pfx_$(basetarget))
+		   $(syshdr_abi_$(basetarget)) $(syshdr_pfx_$(basetarget)) \
+		   $(syshdr_offset_$(basetarget))
 quiet_cmd_systbl = SYSTBL  $@
       cmd_systbl = $(CONFIG_SHELL) '$(systbl)' $< $@
 
@@ -24,6 +25,11 @@ syshdr_pfx_unistd_32_ia32 := ia32_
 $(out)/unistd_32_ia32.h: $(syscall32) $(syshdr)
 	$(call if_changed,syshdr)
 
+syshdr_abi_unistd_x32 := common,x32
+syshdr_offset_unistd_x32 := __X32_SYSCALL_BIT
+$(out)/unistd_x32.h: $(syscall64) $(syshdr)
+	$(call if_changed,syshdr)
+
 syshdr_abi_unistd_64 := common,64
 $(out)/unistd_64.h: $(syscall64) $(syshdr)
 	$(call if_changed,syshdr)
@@ -33,7 +39,7 @@ $(out)/syscalls_32.h: $(syscall32) $(systbl)
 $(out)/syscalls_64.h: $(syscall64) $(systbl)
 	$(call if_changed,systbl)
 
-syshdr-y			+= unistd_32.h unistd_64.h
+syshdr-y			+= unistd_32.h unistd_64.h unistd_x32.h
 syshdr-y			+= syscalls_32.h
 syshdr-$(CONFIG_X86_64)		+= unistd_32_ia32.h
 syshdr-$(CONFIG_X86_64)		+= syscalls_64.h
-- 
1.7.6.5

