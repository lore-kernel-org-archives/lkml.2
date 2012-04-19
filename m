Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab2DSAuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 20:50:39 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52779 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab2DSAuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 20:50:37 -0400
From: Will Drewry <wad@chromium.org>
To: james@namei.org, paul.gortmaker@windriver.com
Cc: eparis@redhat.com, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        linux-security-module@vger.kernel.org, Will Drewry <wad@chromium.org>
Subject: [PATCH] samples/seccomp: fix dependencies on arch macros
Date: Wed, 18 Apr 2012 19:50:25 -0500
Message-Id: <1334796625-26830-1-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change fixes the compilation error triggered here for
i386 allmodconfig in linux-next:
  http://kisskb.ellerman.id.au/kisskb/buildresult/6123842/

Logic attempting to predict the host architecture has been
removed from the Makefile.  Instead, the bpf-direct sample
should now compile on any architecture, but if the architecture
is not supported, it will compile a minimal main() function.

This change also ensures the samples are not compiled when
there is no seccomp filter support.

(Note, I wasn't able to reproduce the error locally, but
 the existing approach was clearly flawed.  This tweak
 should resolve your issue and avoid other future weirdness.)

Reported-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Suggested-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Will Drewry <wad@chromium.org>
---
 samples/seccomp/Makefile     |   12 +++---------
 samples/seccomp/bpf-direct.c |   18 ++++++++++++++++--
 2 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/samples/seccomp/Makefile b/samples/seccomp/Makefile
index e8fe0f5..16aa2d4 100644
--- a/samples/seccomp/Makefile
+++ b/samples/seccomp/Makefile
@@ -1,27 +1,21 @@
 # kbuild trick to avoid linker error. Can be omitted if a module is built.
 obj- := dummy.o
 
-hostprogs-$(CONFIG_SECCOMP) := bpf-fancy dropper
-bpf-fancy-objs := bpf-fancy.o bpf-helper.o
+hostprogs-$(CONFIG_SECCOMP_FILTER) := bpf-fancy dropper bpf-direct
 
 HOSTCFLAGS_bpf-fancy.o += -I$(objtree)/usr/include
 HOSTCFLAGS_bpf-fancy.o += -idirafter $(objtree)/include
 HOSTCFLAGS_bpf-helper.o += -I$(objtree)/usr/include
 HOSTCFLAGS_bpf-helper.o += -idirafter $(objtree)/include
+bpf-fancy-objs := bpf-fancy.o bpf-helper.o
 
 HOSTCFLAGS_dropper.o += -I$(objtree)/usr/include
 HOSTCFLAGS_dropper.o += -idirafter $(objtree)/include
 dropper-objs := dropper.o
 
-# bpf-direct.c is x86-only.
-ifeq ($(SRCARCH),x86)
-# List of programs to build
-hostprogs-$(CONFIG_SECCOMP) += bpf-direct
-bpf-direct-objs := bpf-direct.o
-endif
-
 HOSTCFLAGS_bpf-direct.o += -I$(objtree)/usr/include
 HOSTCFLAGS_bpf-direct.o += -idirafter $(objtree)/include
+bpf-direct-objs := bpf-direct.o
 
 # Try to match the kernel target.
 ifeq ($(CONFIG_64BIT),)
diff --git a/samples/seccomp/bpf-direct.c b/samples/seccomp/bpf-direct.c
index 26f523e..151ec3f 100644
--- a/samples/seccomp/bpf-direct.c
+++ b/samples/seccomp/bpf-direct.c
@@ -8,6 +8,11 @@
  * and can serve as a starting point for developing
  * applications using prctl(PR_SET_SECCOMP, 2, ...).
  */
+#if defined(__i386__) || defined(__x86_64__)
+#define SUPPORTED_ARCH 1
+#endif
+
+#if defined(SUPPORTED_ARCH)
 #define __USE_GNU 1
 #define _GNU_SOURCE 1
 
@@ -43,8 +48,6 @@
 #define REG_ARG3	REG_R10
 #define REG_ARG4	REG_R8
 #define REG_ARG5	REG_R9
-#else
-#error Unsupported platform
 #endif
 
 #ifndef PR_SET_NO_NEW_PRIVS
@@ -174,3 +177,14 @@ int main(int argc, char **argv)
 		payload("Error message going to STDERR\n"));
 	return 0;
 }
+#else	/* SUPPORTED_ARCH */
+/*
+ * This sample is x86-only.  Since kernel samples are compiled with the
+ * host toolchain, a non-x86 host will result in using only the main()
+ * below.
+ */
+int main(void)
+{
+	return 1;
+}
+#endif	/* SUPPORTED_ARCH */
-- 
1.7.5.4

