Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935286Ab2JXQkS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 12:40:18 -0400
Received: from nm24.access.bullet.mail.sp2.yahoo.com ([98.139.44.151]:43602
	"EHLO nm24.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935273Ab2JXQkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 12:40:12 -0400
X-Yahoo-Newman-Id: 362087.79197.bm@smtp105.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: i57YP.0VM1nmEGFwtYJDuZVjRrU1blbCw8vjqNj_jJgXb4g
 jHuQLbh585ZdSuoXTlOlhPWfimbEcYeFegJgRFQv9rP8mQtJuaiyMTIMrkEP
 2RBjxQ7vCdyv5UyofI7k2U6AmdzqYGMMCwwZVRc2oTvu_84twOW5A4LjHlD_
 aI15bGSgxEGIRzqltol3whQFEcTSbynb1gzEp84CD0LPuRbudA8p6MN956rD
 SgbT.hLgjHqOhlUf4SKDkrsK_lXpoMupujTkdJXig1vv0FuVKQEhNvod7EAi
 IvXdisZ6UL_EPVaEWfB8ri_w.eTMHObMJIoSd_mJYQe_IC9kES89LQRzFFMa
 XljjVZPoRo4R634XOsoyvFevqKcxR4nSkgN18X5mkfAEiz5nXeiVBxjG9uFk
 ScL8nbZRka8R_1h6CdaY3Udhs9uI91ZykdyAKVIXJS6mlmzKo_TVE
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: danielfsantos@att.net
To: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Borislav Petkov <bp@alien8.de>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH v3 10/10] bug.h: Convert BUILD_BUG{,_ON} to use BUILD_BUG_ON_MSG
Date: Wed, 24 Oct 2012 11:34:01 -0500
Message-Id: <1351096441-12388-10-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1351096132-12244-1-git-send-email-daniel.santos@pobox.com>
References: <1351096132-12244-1-git-send-email-daniel.santos@pobox.com>
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
index f6f81f6..c791d2a 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -80,14 +80,8 @@ struct pt_regs;
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
@@ -97,12 +91,7 @@ struct pt_regs;
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

