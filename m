Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492Ab2HSDDF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 23:03:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:1635 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753949Ab2HSC5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="204911357"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>, Andy Lutomirski <luto@mit.edu>
Subject: [PATCH 54/74] x86, lto, vdso: Don't duplicate vvar address variables
Date: Sat, 18 Aug 2012 19:56:50 -0700
Message-Id: <1345345030-22211-55-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Every includer of vvar.h currently gets own static variables
for all the vvar addresses. Generate just one set each for the
main kernel and for the vdso. This saves some data space.

Cc: Andy Lutomirski <luto@mit.edu>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/vvar.h    |   27 +++++++++++++++++----------
 arch/x86/vdso/vclock_gettime.c |    1 +
 arch/x86/vdso/vma.c            |    1 +
 3 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/vvar.h b/arch/x86/include/asm/vvar.h
index d76ac40..1fd06a8 100644
--- a/arch/x86/include/asm/vvar.h
+++ b/arch/x86/include/asm/vvar.h
@@ -24,27 +24,34 @@
 /* The kernel linker script defines its own magic to put vvars in the
  * right place.
  */
-#define DECLARE_VVAR(offset, type, name) \
-	EMIT_VVAR(name, offset)
+#define DECLARE_VVAR(type, name) \
+	EMIT_VVAR(name, VVAR_OFFSET_ ## name)
+
+#elif defined(__VVAR_ADDR)
+
+#define DECLARE_VVAR(type, name)					\
+	type const * const vvaraddr_ ## name =				\
+	(void *)(VVAR_ADDRESS + (VVAR_OFFSET_ ## name));
 
 #else
 
-#define DECLARE_VVAR(offset, type, name)				\
-	static type const * const vvaraddr_ ## name =			\
-		(void *)(VVAR_ADDRESS + (offset));
+#define DECLARE_VVAR(type, name)					\
+	extern type const * const vvaraddr_ ## name;
 
 #define DEFINE_VVAR(type, name)						\
 	type name							\
 	__attribute__((section(".vvar_" #name), aligned(16))) __visible
+#endif
 
 #define VVAR(name) (*vvaraddr_ ## name)
 
-#endif
-
 /* DECLARE_VVAR(offset, type, name) */
 
-DECLARE_VVAR(0, volatile unsigned long, jiffies)
-DECLARE_VVAR(16, int, vgetcpu_mode)
-DECLARE_VVAR(128, struct vsyscall_gtod_data, vsyscall_gtod_data)
+#define VVAR_OFFSET_jiffies 0
+DECLARE_VVAR(volatile unsigned long, jiffies)
+#define VVAR_OFFSET_vgetcpu_mode 16
+DECLARE_VVAR(int, vgetcpu_mode)
+#define VVAR_OFFSET_vsyscall_gtod_data 128
+DECLARE_VVAR(struct vsyscall_gtod_data, vsyscall_gtod_data)
 
 #undef DECLARE_VVAR
diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index 885eff4..007eac4 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -10,6 +10,7 @@
 
 /* Disable profiling for userspace code: */
 #define DISABLE_BRANCH_PROFILING
+#define __VVAR_ADDR 1
 
 #include <linux/kernel.h>
 #include <linux/posix-timers.h>
diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index fe08e2b..4432cfc 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -3,6 +3,7 @@
  * Copyright 2007 Andi Kleen, SUSE Labs.
  * Subject to the GPL, v.2
  */
+#define __VVAR_ADDR 1
 #include <linux/mm.h>
 #include <linux/err.h>
 #include <linux/sched.h>
-- 
1.7.7.6

