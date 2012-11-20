Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab2KTVGg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 16:06:36 -0500
Received: from nm27-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.227]:22435
	"EHLO nm27-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753234Ab2KTVFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 16:05:18 -0500
X-Yahoo-Newman-Id: 851647.4524.bm@smtp108.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: YMbMSyEVM1kAoiolFc7NRp3ycUJwXl48DvcyzrNBzp8c1NW
 QJH_0cA68UPI4zkZe5fShWpghe2QkJJlQrpXVr4BTZCwE1PIE6CvVmoMF_q4
 oNpcLu1c.1SFv7dQ88.ZFcFig_Pwf_dKX.CU303IFbipEdxJWE_rwvbt785R
 xYZK1zdshXkhbm6ywgaHV5CG5DThVmETpuuKNy6RuJcycuOJwXBbvrq2Whga
 sHuOn9wO0e1mtmXmDnzY1RK9bt6kKK.Zn8DdAw8SRPR1O0GLKOvUFrUvhaHe
 8PL4dJWoY1E8YXPDrqn2kn5KQ4T_2CCrxJGWtB5X8djzEsoH9PFJcy.nNBAB
 Vq_Yr73tMZTMbqEa5N9SXQzXgMNX1EYNL3zy85Kn7LXYXJoDn7k1npT6FDBx
 dmCBNsZdiNxl.KpnnH7Cm0ydoF1ZDvuQiGp.O21lhjuWKlTJkxAupKvftbf5
 FEisUozZ1IbFFF9W3a6smy3pONLCDfMg-
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
Subject: [PATCH v6 4/9] compiler{,-gcc4}.h, bug.h: Remove duplicate macros
Date: Tue, 20 Nov 2012 15:05:02 -0600
Message-Id: <1353445507-7233-4-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1353444132-6809-1-git-send-email-daniel.santos@pobox.com>
References: <1353444132-6809-1-git-send-email-daniel.santos@pobox.com>
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
index aaac4bb..298a916 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -73,7 +73,7 @@ extern int __build_bug_on_failed;
 #define BUILD_BUG()						\
 	do {							\
 		extern void __build_bug_failed(void)		\
-			__linktime_error("BUILD_BUG failed");	\
+			__compiletime_error("BUILD_BUG failed");\
 		__build_bug_failed();				\
 	} while (0)
 
diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index 9755029..7f143ac 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -33,8 +33,6 @@
    the kernel context */
 #define __cold			__attribute__((__cold__))
 
-#define __linktime_error(message) __attribute__((__error__(message)))
-
 #ifndef __CHECKER__
 # define __compiletime_warning(message) __attribute__((warning(message)))
 # define __compiletime_error(message) __attribute__((error(message)))
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index b121554..cbf6d9d 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -299,9 +299,6 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
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
1.7.3.4

