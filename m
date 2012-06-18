Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385Ab2FREyV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 00:54:21 -0400
Received: from linux-sh.org ([111.68.239.195]:57322 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903Ab2FREyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 00:54:20 -0400
Date: Mon, 18 Jun 2012 13:54:17 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] bug.h: Fix up powerpc build regression.
Message-ID: <20120618045417.GB19803@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The asm-generic/bug.h __ASSEMBLY__ guarding is completely bogus, which
tripped up the powerpc build when the kernel.h include was added:

	In file included from include/asm-generic/bug.h:5:0,
			 from arch/powerpc/include/asm/bug.h:127,
			 from arch/powerpc/kernel/head_64.S:31:
	include/linux/kernel.h:44:0: warning: "ALIGN" redefined [enabled by default]
	include/linux/linkage.h:57:0: note: this is the location of the previous definition
	include/linux/sysinfo.h: Assembler messages:
	include/linux/sysinfo.h:7: Error: Unrecognized opcode: `struct'
	include/linux/sysinfo.h:8: Error: Unrecognized opcode: `__kernel_long_t'

Moving the __ASSEMBLY__ guard up and stashing the kernel.h include under
it fixes this up, as well as covering the case the original fix was
attempting to handle.

Tested-by: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 include/asm-generic/bug.h |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 9f02005..506ec19 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -2,7 +2,6 @@
 #define _ASM_GENERIC_BUG_H
 
 #include <linux/compiler.h>
-#include <linux/kernel.h>
 
 #ifdef CONFIG_BUG
 
@@ -32,6 +31,9 @@ struct bug_entry {
 
 #endif	/* CONFIG_GENERIC_BUG */
 
+#ifndef __ASSEMBLY__
+#include <linux/kernel.h>
+
 /*
  * Don't use BUG() or BUG_ON() unless there's really no way out; one
  * example might be detecting data structure corruption in the middle
@@ -61,7 +63,6 @@ struct bug_entry {
  * to provide better diagnostics.
  */
 #ifndef __WARN_TAINT
-#ifndef __ASSEMBLY__
 extern __printf(3, 4)
 void warn_slowpath_fmt(const char *file, const int line,
 		       const char *fmt, ...);
@@ -70,7 +71,6 @@ void warn_slowpath_fmt_taint(const char *file, const int line, unsigned taint,
 			     const char *fmt, ...);
 extern void warn_slowpath_null(const char *file, const int line);
 #define WANT_WARN_ON_SLOWPATH
-#endif
 #define __WARN()		warn_slowpath_null(__FILE__, __LINE__)
 #define __WARN_printf(arg...)	warn_slowpath_fmt(__FILE__, __LINE__, arg)
 #define __WARN_printf_taint(taint, arg...)				\
@@ -203,4 +203,6 @@ extern void warn_slowpath_null(const char *file, const int line);
 # define WARN_ON_SMP(x)			({0;})
 #endif
 
+#endif /* __ASSEMBLY__ */
+
 #endif

