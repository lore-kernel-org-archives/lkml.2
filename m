Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab2FWECX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 00:02:23 -0400
Received: from nm4.access.bullet.mail.mud.yahoo.com ([66.94.237.205]:47673
	"HELO nm4.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751520Ab2FWEBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 00:01:44 -0400
X-Yahoo-Newman-Id: 787071.55476.bm@smtp103.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 6DzYZQwVM1nZ7rUo1_h_yAttK03itVEtY_qXmwgQHkZCjeR
 rFtJ2AjzylQSm6ks7W1WV.c1wYGR1fKu489PMakErjvJkOATh_AeskzFEHld
 30MzATX13qhTSGmWzEL8fA7Qbrrpp9hoOuxcx3ohbEgMWnGN8jx.TDwpuz4i
 Xb9_oHb_k16pTXWwCcFbRLXxCmsF9LVU.Cmq.aKl2vc5XcNYU36wbeit5j.r
 6PI8cikwVOXEI8BDnbUeCGo4o7KIrEHNdhaG0BRF4p.E7wUZ7CAcYunCk9ip
 yE57ppYu19Q5PNX6lKEJkVbcaWDLzhmse5VjlvXIeTvpv3jkeBSfTW8FiCvA
 zOtKMAOA9DhJwcFODp5t8r9OzyxPCpEsl3XEEEn3QA9J4CFH8t1gVdNX1OFa
 t5IRPDKh5srAy4A.YXcOV3.VM0DRntL7xr24-
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: Daniel Santos <daniel.santos@pobox.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-doc@vger.kernel.org, linux-sparse@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Paul Turner <pjt@google.com>, Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Weinberger <richard@nod.at>, Rob Landley <rob@landley.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH v4 10/13] bug.h: Add gcc 4.2+ versions of BUILD_BUG_ON_* macros
Date: Fri, 22 Jun 2012 23:00:45 -0500
Message-Id: <1340424048-7759-11-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1340424048-7759-1-git-send-email-daniel.santos@pobox.com>
References: <1340424048-7759-1-git-send-email-daniel.santos@pobox.com>
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
 include/linux/bug.h |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/include/linux/bug.h b/include/linux/bug.h
index e30f600..8e30337 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -129,6 +129,41 @@ struct pt_regs;
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

