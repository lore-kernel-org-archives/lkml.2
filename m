Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab1HRTLx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:11:53 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48371 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780Ab1HRTLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:11:50 -0400
Date: Thu, 18 Aug 2011 20:11:49 +0100
To: richard@nod.at
Subject: Subject: [PATCH 77/91] um: fix gcov build breakage
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu80L-00082z-UV@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


a) exports in gmon_syms.c duplicate kernel/gcov/* ones
b) excluding -pg in vdso compile is not enough - -fprofile-arcs
and -ftest-coverage also needs to be excluded

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/kernel/gmon_syms.c |   15 ---------------
 arch/x86/um/vdso/Makefile  |    4 ++--
 2 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/arch/um/kernel/gmon_syms.c b/arch/um/kernel/gmon_syms.c
index 72eccd2..e9bcf247 100644
--- a/arch/um/kernel/gmon_syms.c
+++ b/arch/um/kernel/gmon_syms.c
@@ -7,18 +7,3 @@
 
 extern void __bb_init_func(void *)  __attribute__((weak));
 EXPORT_SYMBOL(__bb_init_func);
-
-/*
- * This is defined (and referred to in profiling stub code) only by some GCC
- * versions in libgcov.
- *
- * Since SuSE backported the fix, we cannot handle it depending on GCC version.
- * So, unconditionally export it. But also give it a weak declaration, which
- * will be overridden by any other one.
- */
-
-extern void __gcov_init(void *) __attribute__((weak));
-EXPORT_SYMBOL(__gcov_init);
-
-extern void __gcov_merge_add(void *) __attribute__((weak));
-EXPORT_SYMBOL(__gcov_merge_add);
diff --git a/arch/x86/um/vdso/Makefile b/arch/x86/um/vdso/Makefile
index 5dffe6d..6c803ca 100644
--- a/arch/x86/um/vdso/Makefile
+++ b/arch/x86/um/vdso/Makefile
@@ -46,8 +46,8 @@ $(vobjs): KBUILD_CFLAGS += $(CFL)
 #
 # vDSO code runs in userspace and -pg doesn't help with profiling anyway.
 #
-CFLAGS_REMOVE_vdso-note.o = -pg
-CFLAGS_REMOVE_um_vdso.o = -pg
+CFLAGS_REMOVE_vdso-note.o = -pg -fprofile-arcs -ftest-coverage
+CFLAGS_REMOVE_um_vdso.o = -pg -fprofile-arcs -ftest-coverage
 
 targets += vdso-syms.lds
 obj-$(VDSO64-y)			+= vdso-syms.lds
-- 
1.7.2.5


