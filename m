Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932707Ab2JEToE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 15:44:04 -0400
Received: from nm27-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.232]:23987 "HELO
	nm27-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S964827Ab2JETn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 15:43:58 -0400
X-Yahoo-Newman-Id: 638313.23044.bm@omp1005.access.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: aSotusQVM1mHTbRtZ6yTohjlmBGWN9nSE67vBnduPRSIK0e
 ve3.C33zStZnUnNCva_.QHbXfubd5FU.51SOVMJR8Cug51oVj6yQLnxmybyS
 AMsbV9SHU._RSkqgcKVHQGTSmTD17vlqsWmOqeLivgNQDlMa1iuX0CUn19A8
 926KQorXpjy4ZvyISu8WD1MW3S0.9ubA9eS7Pt2H9PIBJBLo3JjoGVhMVo.I
 kHBAi_Dktq2zdvLPyNxu5Ql1tf7bwRU5iUFGD47KIbgT5.VeIGJx_ZlUAbFj
 Y.M6pHG9Uo8p.GKtqHKvfqETYVph97Kpfty_ka.4grmx91ilrCWHoRTDjVtn
 OHQH.7N7AxPEWf9Trw2JuBmHI_vVJDno5FBXy4jeQ0oeSb2ZZ9dzMsvMpMP0
 d0ReeE_YrsK9u.BXunpPbxoKyI7v1h46ht9of8Vjj7eBY3vG_xnxY
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: danielfsantos@att.net
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>,
        David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Santos <daniel.santos@pobox.com>
Subject: [PATCH v2 10/10] bug.h: Convert BUILD_BUG{,_ON} to use BUILD_BUG_ON_MSG
Date: Fri,  5 Oct 2012 14:42:49 -0500
Message-Id: <1349466169-20637-10-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1349465759-20524-1-git-send-email-daniel.santos@pobox.com>
References: <1349465759-20524-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicate code by converting BUILD_BUG and BUILD_BUG_ON to just
call BUILD_BUG_ON_MSG.  This not only reduces source code bloat, but
also prevents the possibility of code being changed for one macro and
not for the other (which was previously the case for BUILD_BUG and
BUILD_BUG_ON).

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 include/linux/bug.h |   17 +++--------------
 1 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/include/linux/bug.h b/include/linux/bug.h
index 91bd9d5..ee880e5 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -84,14 +84,8 @@ struct pt_regs;
 #ifndef __OPTIMIZE__
 #define BUILD_BUG_ON(condition) __compiletime_error_fallback(condition)
 #else
-#define BUILD_BUG_ON(condition)						\
-	do {								\
-		extern void __build_bug_on_failed(void)			\
-			__compiletime_error("BUILD_BUG_ON failed");	\
-		__compiletime_error_fallback(condition);		\
-		if (condition)						\
-			__build_bug_on_failed();			\
-	} while(0)
+#define BUILD_BUG_ON(condition) \
+	BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
 #endif
 
 /**
@@ -101,12 +95,7 @@ struct pt_regs;
  * build time, you should use BUILD_BUG to detect if it is
  * unexpectedly used.
  */
-#define BUILD_BUG()						\
-	do {							\
-		extern void __build_bug_failed(void)		\
-			__compiletime_error("BUILD_BUG failed");\
-		__build_bug_failed();				\
-	} while (0)
+#define BUILD_BUG() BUILD_BUG_ON_MSG(1, "BUILD_BUG failed")
 
 #endif	/* __CHECKER__ */
 
-- 
1.7.3.4

