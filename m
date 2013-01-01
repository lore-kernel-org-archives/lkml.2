Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503Ab3AAVPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 16:15:44 -0500
Received: from nm1-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.94]:29550
	"EHLO nm1-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751788Ab3AAVPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 16:15:43 -0500
X-Greylist: delayed 331 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Jan 2013 16:15:43 EST
X-Yahoo-Newman-Id: 401933.17119.bm@smtp109.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: UlhhYL8VM1n.p5AXva4rpFahEciYtYPEMxe1dyV5X_dJM3h
 95N.y.zXIUT_bwCEpMhXpPzV2eicjfvB.XjFQQhc06_MbfzGwffkVnfTldC.
 k2AkTz7QPxLCpPNvM7x_peX_z.TILW9_HN59iDhoTNE8v0znjgv7f8vcT9a7
 vV821X688TmG35PcRpHVjpyUUqegiZOlaXGYB7gKI9chBJlLgWZlyy88rMbC
 I5CT_wKg23qdzUyyOM.t6VFpn2MWSAOvWF2TMgWZ5cOQaU3xBC6GE67FLHTN
 BMlxYqOUzKDPdBvfmSko.5NZ_HYhROf3lkVN0Vj9ZvaVqTIMoEjgT1DWnJxj
 ySE3sLepOFIRtIqLVXnbXS4Es9HgMlVXn5nzph5thPtSFBosZguZhd3i0T9J
 FQMgFDQXpCzvMfqpUrXRbRQgtqFM2fjwpTTmg6IhnWG2oqGC7m1cl_Q--
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
Subject: [PATCH v7 4/9] compiler{,-gcc4}.h, bug.h: Remove duplicate macros
Date: Tue,  1 Jan 2013 15:09:52 -0600
Message-Id: <1357074597-21722-4-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1357074597-21722-1-git-send-email-daniel.santos@pobox.com>
References: <1357074491-21669-1-git-send-email-daniel.santos@pobox.com>
 <1357074597-21722-1-git-send-email-daniel.santos@pobox.com>
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

