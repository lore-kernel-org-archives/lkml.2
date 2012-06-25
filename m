Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab2FYIPl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 04:15:41 -0400
Received: from linux-sh.org ([111.68.239.195]:37093 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754147Ab2FYIPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 04:15:35 -0400
Date: Mon, 25 Jun 2012 17:15:31 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] bug.h: Fix up CONFIG_BUG=n implicit function declarations.
Message-ID: <20120625081531.GD24033@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2603efa31a0377eeaa06723bded8a1d644dd4901 (bug.h: Fix up powerpc build
regression.) corrected the powerpc build case and extended the
__ASSEMBLY__ guards, but it also got caught in pre-processor hell
accidentally matching the else case of CONFIG_BUG resulting in the BUG
disabled case tripping up on -Werror=implicit-function-declaration.

It's not possible to __ASSEMBLY__ guard the entire file as architecture
code needs to get at the BUGFLAG_WARNING definition in the GENERIC_BUG
case, but the rest of the CONFIG_BUG=y/n case needs to be guarded. Rather
than littering endless __ASSEMBLY__ checks in each of the if/else cases
we just move the BUGFLAG definitions up under their own GENERIC_BUG test
and then shove everything else under one big __ASSEMBLY__ guard.

Build tested on all of x86 CONFIG_BUG=y, CONFIG_BUG=n, powerpc (due to
it's dependence on BUGFLAG definitions in assembly code), and sh (due to
not bringing in linux/kernel.h to satisfy the taint flag definitions used
by the generic bug code).

Hopefully that's the end of the corner cases and I can abstain from ever
having to touch this infernal header ever again.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Tested-by: Fengguang Wu <wfg@linux.intel.com>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 include/asm-generic/bug.h |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 506ec19..7d10f96 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -3,10 +3,18 @@
 
 #include <linux/compiler.h>
 
+#ifdef CONFIG_GENERIC_BUG
+#define BUGFLAG_WARNING		(1 << 0)
+#define BUGFLAG_TAINT(taint)	(BUGFLAG_WARNING | ((taint) << 8))
+#define BUG_GET_TAINT(bug)	((bug)->flags >> 8)
+#endif
+
+#ifndef __ASSEMBLY__
+#include <linux/kernel.h>
+
 #ifdef CONFIG_BUG
 
 #ifdef CONFIG_GENERIC_BUG
-#ifndef __ASSEMBLY__
 struct bug_entry {
 #ifndef CONFIG_GENERIC_BUG_RELATIVE_POINTERS
 	unsigned long	bug_addr;
@@ -23,17 +31,8 @@ struct bug_entry {
 #endif
 	unsigned short	flags;
 };
-#endif		/* __ASSEMBLY__ */
-
-#define BUGFLAG_WARNING		(1 << 0)
-#define BUGFLAG_TAINT(taint)	(BUGFLAG_WARNING | ((taint) << 8))
-#define BUG_GET_TAINT(bug)	((bug)->flags >> 8)
-
 #endif	/* CONFIG_GENERIC_BUG */
 
-#ifndef __ASSEMBLY__
-#include <linux/kernel.h>
-
 /*
  * Don't use BUG() or BUG_ON() unless there's really no way out; one
  * example might be detecting data structure corruption in the middle
