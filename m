Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab3AAWye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 17:54:34 -0500
Received: from nm1-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.27]:21980
	"EHLO nm1-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752499Ab3AAWyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 17:54:24 -0500
X-Yahoo-Newman-Id: 282118.18166.bm@smtp107.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: vg7ytBcVM1lRp4cIVmQESmBhhEBD1aOo_dxfus99Iwbbl8J
 7lADzBI22Ba04dKH7wCjwMHBYEW0WrD9lg8HHaLou4WzxNcLlXojKbs5X.Os
 ytiPr463CvMwzSOZfLt.h_XpB_zEitGp9jZRYYlyTbAEizO.HMlaJfllqU85
 RtDfVnybcy3XUeN5tZPwKQq.UGxVkW8Atd.yVeqUvmjzQA0WC83p1kkeYhvi
 XkH2GjX_2ZNHStszIyKoeup9iLofT4mdW9xr.o6IfxnCCumOUvl95BdsYVkJ
 2QoGJ_MSSS.ZUUQur.BM4MbNW9VBrE.ZX9bJ_BGqAFBNQ6c4x0g6H3.ilqUy
 Fr8D.p_vMMDPxIhPqLPrIROHhQw.JRlg5rvRNDU9GhU66wp5m_wmdxXyx6m8
 r4VzEq3W3ljRllfmkgDo33Sq0.hS51l1rHcb5wuCJXnzoA2LLNzANrR8-
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: danielfsantos@att.net
To: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>,
        Josh Triplett <josh@joshtriplett.org>, linux-sparse@vger.kernel.org,
        Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Daniel Santos <daniel.santos@pobox.com>
Subject: [PATCH v8 4/9] compiler{,-gcc4}.h, bug.h: Remove duplicate macros
Date: Tue,  1 Jan 2013 16:54:06 -0600
Message-Id: <1357080851-30938-5-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1357080851-30938-1-git-send-email-daniel.santos@pobox.com>
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com>
 <1357080851-30938-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__linktime_error() does the same thing as __compiletime_error() and is
only used in bug.h.  Since the macro defines a function attribute that
will cause a failure at compile-time (not link-time), it makes more
sense to keep __compiletime_error(), which is also neatly mated with
__compiletime_warning().

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Borislav Petkov <bp@alien8.de>
---
 include/linux/bug.h           |    2 +-
 include/linux/compiler-gcc4.h |    2 --
 include/linux/compiler.h      |    3 ---
 3 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/include/linux/bug.h b/include/linux/bug.h
index b1cf40d..2a11774 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -74,7 +74,7 @@ extern int __build_bug_on_failed;
 #define BUILD_BUG()						\
 	do {							\
 		extern void __build_bug_failed(void)		\
-			__linktime_error("BUILD_BUG failed");	\
+			__compiletime_error("BUILD_BUG failed");\
 		__build_bug_failed();				\
 	} while (0)
 
diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index a9ffdfe..68b162d 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -33,8 +33,6 @@
    the kernel context */
 #define __cold			__attribute__((__cold__))
 
-#define __linktime_error(message) __attribute__((__error__(message)))
-
 #define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __COUNTER__)
 
 #ifndef __CHECKER__
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index dd852b7..4c638be 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -308,9 +308,6 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 #ifndef __compiletime_error
 # define __compiletime_error(message)
 #endif
-#ifndef __linktime_error
-# define __linktime_error(message)
-#endif
 /*
  * Prevent the compiler from merging or refetching accesses.  The compiler
  * is also forbidden from reordering successive instances of ACCESS_ONCE(),
-- 
1.7.8.6

