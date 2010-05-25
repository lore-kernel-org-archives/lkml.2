Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757647Ab0EYTUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 15:20:31 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37012 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176Ab0EYTUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 15:20:30 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: uclinux-dev@uclinux.org, David Howells <dhowells@redhat.com>,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       Paul Mundt <lethal@linux-sh.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org, microblaze-uclinux@itee.uq.edu.au,
       Michal Simek <monstr@monstr.eu>, linux-m32r@ml.linux-m32r.org,
       Hirokazu Takata <takata@linux-m32r.org>, linux-kernel@vger.kernel.org,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Jie Zhang <jie.zhang@analog.com>
Subject: [PATCH] FLAT: allow arches to declare a larger alignment than the slab
Date: Tue, 25 May 2010 15:24:27 -0400
Message-Id: <1274815467-14584-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jie Zhang <jie.zhang@analog.com>

The recent commit 1f0ce8b3dd667dca7 which moved the ARCH_SLAB_MINALIGN
default into the global header inadvertently broke FLAT for a bunch of
systems.  Blackfin systems now fail on any FLAT exec with:
Unable to read code+data+bss, errno 14
When your /init is a FLAT binary, obviously this can be annoying ;).

This stems from the alignment usage in the FLAT loader.  The behavior
before was that FLAT would default to ARCH_SLAB_MINALIGN only if it was
defined, and this was only defined by arches when they wanted a larger
alignment value.  Otherwise it'd default to pointer alignment.  Arguably,
this is kind of hokey that the FLAT is semi-abusing defines it shouldn't.

But let's ignore that and let arches declare a larger FLAT alignment
specifically anyways as some arches are OK with the default slab alignment
but need stricter FLAT alignments for shared FLAT libraries.

The nommu arches might want to check to see if they need to declare this
in their headers as well ...

Signed-off-by: Jie Zhang <jie.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/flat.h |    2 ++
 fs/binfmt_flat.c                 |   11 ++++++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/blackfin/include/asm/flat.h b/arch/blackfin/include/asm/flat.h
index c1314c5..cf2a73e 100644
--- a/arch/blackfin/include/asm/flat.h
+++ b/arch/blackfin/include/asm/flat.h
@@ -11,6 +11,8 @@
 
 #include <asm/unaligned.h>
 
+#define ARCH_FLAT_DATA_ALIGN			0x20
+
 #define	flat_argvp_envp_on_stack()		0
 #define	flat_old_ram_flag(flags)		(flags)
 
diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index 49566c1..6906170 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -56,12 +56,17 @@
 #endif
 
 /*
- * User data (stack, data section and bss) needs to be aligned
- * for the same reasons as SLAB memory is, and to the same amount.
+ * User data (stack, data section and bss) needs to be aligned.
+ * If ARCH_FLAT_DATA_ALIGN is defined, use it.
+ */
+#ifdef ARCH_FLAT_DATA_ALIGN
+#define FLAT_DATA_ALIGN	(ARCH_FLAT_DATA_ALIGN)
+/* Otherwise user data nees to be aligned for the same reasons
+ * as SLAB memory is aligned, and to the same amount.
  * Avoid duplicating architecture specific code by using the same
  * macro as with SLAB allocation:
  */
-#ifdef ARCH_SLAB_MINALIGN
+#elif defined(ARCH_SLAB_MINALIGN)
 #define FLAT_DATA_ALIGN	(ARCH_SLAB_MINALIGN)
 #else
 #define FLAT_DATA_ALIGN	(sizeof(void *))
-- 
1.7.1

