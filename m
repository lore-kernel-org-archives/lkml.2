Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab0FDLml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 07:42:41 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:40648 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451Ab0FDLmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 07:42:39 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19464.59051.727647.820630@pilspetsen.it.uu.se>
Date: Fri, 4 Jun 2010 13:42:35 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] compiler-gcc.h: gcc-4.5 needs noclone and noinline on __naked functions
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A __naked function is defined in C but with a body completely
implemented by asm(), including any prologue and epilogue.  These
asm() bodies expect standard calling conventions for parameter
passing.  Older GCCs implement that correctly, but 4.[56] currently
do not, see GCC PR44290.  In the Linux kernel this breaks ARM,
causing most arch/arm/mm/copypage-*.c modules to get miscompiled,
resulting in kernel crashes during bootup.

Part of the kernel fix is to augment the __naked function attribute
to also imply noinline and noclone.  This patch implements that, and
has been verified to fix boot failures with gcc-4.5 compiled 2.6.34
and 2.6.35-rc1 kernels.  The patch is a no-op with older GCCs.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
Signed-off-by: Khem Raj <raj.khem@gmail.com>
Cc: stable@kernel.org
---
This part of the fix touches code outside of arch/arm/ so RMK asked
me to send it via LKML.  Another fix for broken asm() is also needed
on some machine types, but that's handled via the ARM tree.

I can't find an obvious maintainer for include/linux/compiler-gcc.h.
Does any core system maintainer want to handle this, or should I
resend with cc: Linus?

 include/linux/compiler-gcc.h  |   10 +++++++++-
 include/linux/compiler-gcc4.h |    4 ++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff -rupN linux-2.6.35-rc1/include/linux/compiler-gcc.h linux-2.6.35-rc1.arm-gcc45-attribute-naked/include/linux/compiler-gcc.h
--- linux-2.6.35-rc1/include/linux/compiler-gcc.h	2010-02-25 14:45:04.000000000 +0100
+++ linux-2.6.35-rc1.arm-gcc45-attribute-naked/include/linux/compiler-gcc.h	2010-06-01 20:18:33.000000000 +0200
@@ -58,8 +58,12 @@
  * naked functions because then mcount is called without stack and frame pointer
  * being set up and there is no chance to restore the lr register to the value
  * before mcount was called.
+ *
+ * The asm() bodies of naked functions often depend on standard calling conventions,
+ * therefore they must be noinline and noclone.  GCC 4.[56] currently fail to enforce
+ * this, so we must do so ourselves.  See GCC PR44290.
  */
-#define __naked				__attribute__((naked)) notrace
+#define __naked				__attribute__((naked)) noinline __noclone notrace
 
 #define __noreturn			__attribute__((noreturn))
 
@@ -85,3 +89,7 @@
 #define _gcc_header(x) __gcc_header(linux/compiler-gcc##x.h)
 #define gcc_header(x) _gcc_header(x)
 #include gcc_header(__GNUC__)
+
+#if !defined(__noclone)
+#define __noclone	/* not needed */
+#endif
diff -rupN linux-2.6.35-rc1/include/linux/compiler-gcc4.h linux-2.6.35-rc1.arm-gcc45-attribute-naked/include/linux/compiler-gcc4.h
--- linux-2.6.35-rc1/include/linux/compiler-gcc4.h	2010-02-25 14:45:04.000000000 +0100
+++ linux-2.6.35-rc1.arm-gcc45-attribute-naked/include/linux/compiler-gcc4.h	2010-06-01 20:18:33.000000000 +0200
@@ -48,6 +48,10 @@
  * unreleased.  Really, we need to have autoconf for the kernel.
  */
 #define unreachable() __builtin_unreachable()
+
+/* Mark a function definition as prohibited from being cloned. */
+#define __noclone	__attribute__((__noclone__))
+
 #endif
 
 #endif
