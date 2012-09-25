Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab2IYXbQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 19:31:16 -0400
Received: from nm25.bullet.mail.sp2.yahoo.com ([98.139.91.95]:47047 "HELO
	nm25.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752678Ab2IYXbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 19:31:12 -0400
X-Yahoo-Newman-Id: 399425.3371.bm@omp1005.access.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ry3bd7EVM1kWTe9uLvtNKLI47jBcgsGNbqOXk9U3RhXF.R1
 giFdA5lQOsdTD6oG3dGAMeuOBueL_o_FrnQuqS00raWnlL3B1a5g5orXM8NR
 0a1hgzLq21Duf1R0ABea9sYEoZfhlA04ZgnMPECZiAenVZi.IMimVm4VLASu
 psKPvsgnjl7pGKNnfSoOKqxulDxWjS0Ytdon5M2egYYQiUcXsJB2dkV7gmmI
 6KsCfttqDyNQSIqKLuf_A7URZDIRL4VVY_NN9i.zwxqURT0Z4F_4t7jNgdhi
 pj6bPemtfGQaQd3bAa9PFjz8KCkYOnCuyLH5cWNJc8inndpXWHYtV6GIz6gZ
 DZDdXV0pHPDCie_HqZprETumlfv2DQWH6JKxJMYUAW.iNSEPyDgT2W29RRSD
 iPlBGk84IV6PqvovvBLRQ24qQcIsMc1nAK_yxlh5GPeNV18xPmcBx
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: Daniel Santos <daniel.santos@pobox.com>
To: Daniel Santos <daniel.santos@pobox.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Richard Weinberger <richard@nod.at>,
        LKML <linux-kernel@vger.kernel.org>,
        Michel Lespinasse <walken@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>
Subject: [PATCH v5 10/25] bug.h: Add gcc 4.2+ versions of BUILD_BUG_ON_* macros
Date: Tue, 25 Sep 2012 18:31:06 -0500
Message-Id: <1348615866-10293-1-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1348615467-9850-1-git-send-email-daniel.santos@pobox.com>
References: <1348615467-9850-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BUILD_BUG_ON42(arg)
BUILD_BUG_ON_CONST42(arg)

Prior to gcc 4.2, the optimizer was unable to determine that many
constant values stored in structs were indeed compile-time constants and
optimize them out.  Sometimes, it will find an intergral value to be a
compile-time constant, but fail to perform a bit-wise AND at
compile-time.  These two macros provide a mechanism to perform these
build-time checks, but not break on older compilers where we already
know they can't be checked at compile time.

For specific details, consult the doc comments for BUILD_BUG_ON_CONST.
These macros are used in the generic rbtree code.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 include/linux/bug.h |   36 ++++++++++++++++++++++++++++++++++++
 1 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/include/linux/bug.h b/include/linux/bug.h
index e30f600..d14c23c 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -2,6 +2,7 @@
 #define _LINUX_BUG_H
 
 #include <asm/bug.h>
+#include <linux/compiler.h>
 
 enum bug_trap_type {
 	BUG_TRAP_TYPE_NONE = 0,
@@ -129,6 +130,41 @@ struct pt_regs;
 #define BUILD_BUG_ON_NON_CONST(exp)
 #endif
 
+
+#if GCC_VERSION >= 40200
+/**
+ * BUILD_BUG_ON_NON_CONST42 - break compile if expression cannot be determined
+ *                            to be a compile-time constant (disabled prior to
+ *                            gcc 4.2)
+ * @exp: value to test for compile-time constness
+ *
+ * Use this macro instead of BUILD_BUG_ON_NON_CONST when testing struct
+ * members or dereferenced arrays and pointers.  Note that the version checks
+ * for this macro are not perfect.  BUILD_BUG_ON_NON_CONST42 expands to nothing
+ * prior to gcc-4.2, after which it is the same as BUILD_BUG_ON_NON_CONST.
+ * However, there are still many checks that will break with this macro (see
+ * the Gory Details section of BUILD_BUG_ON_NON_CONST for more info).
+ *
+ * See also BUILD_BUG_ON_NON_CONST()
+ */
+# define BUILD_BUG_ON_NON_CONST42(exp) BUILD_BUG_ON_NON_CONST(exp)
+
+/**
+ * BUILD_BUG_ON42 - break compile if expression cannot be determined
+ *                   (disabled prior to gcc 4.2)
+ *
+ * This gcc-version check is necessary due to breakages in testing struct
+ * members prior to gcc 4.2.
+ *
+ * See also BUILD_BUG_ON()
+ */
+# define BUILD_BUG_ON42(arg) BUILD_BUG_ON(arg)
+#else
+# define BUILD_BUG_ON_NON_CONST42(exp)
+# define BUILD_BUG_ON42(arg)
+#endif /* GCC_VERSION >= 40200 */
+
+
 #endif	/* __CHECKER__ */
 
 #ifdef CONFIG_GENERIC_BUG
-- 
1.7.3.4

