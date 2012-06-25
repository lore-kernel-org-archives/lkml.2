Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab2FYLmN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 07:42:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51058 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab2FYLmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 07:42:11 -0400
Date: Mon, 25 Jun 2012 04:41:35 -0700
From: tip-bot for Ingo Molnar <mingo@kernel.org>
Message-ID: <tip-7b37393f13d511fa076d4527e35e86cc45d974c5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        lethal@linux-sh.org, rdunlap@xenotime.net, tglx@linutronix.de,
        sfr@canb.auug.org.au
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        rdunlap@xenotime.net, lethal@linux-sh.org, sfr@canb.auug.org.au,
        tglx@linutronix.de
In-Reply-To: <20120625094215.GA25847@gmail.com>
References: <20120625094215.GA25847@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] bug.h: Fix x86 !CONFIG_BUG build regression
Git-Commit-ID: 7b37393f13d511fa076d4527e35e86cc45d974c5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 25 Jun 2012 04:41:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7b37393f13d511fa076d4527e35e86cc45d974c5
Gitweb:     http://git.kernel.org/tip/7b37393f13d511fa076d4527e35e86cc45d974c5
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Mon, 25 Jun 2012 11:42:15 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 25 Jun 2012 12:48:29 +0200

bug.h: Fix x86 !CONFIG_BUG build regression

Commit 2603efa31a03 ("bug.h: Fix up powerpc build regression.")
broke most x86 !CONFIG_BUG builds in -rc4:

  include/linux/cpumask.h: In function ‘cpumask_check’:
  include/linux/cpumask.h:108:2: error: implicit declaration of function ‘WARN_ON_ONCE’
  [...]

The commit mis-placed the !ASSEMBLY block, mixing it with the
CONFIG_BUG section.

Hiding an #include <kernel.h> deep inside a generic header is in
pretty bad taste anyway, it creates kconfig dependent breakages
and makes it harder to untangle header files.

Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mundt <lethal@linux-sh.org>
Link: http://lkml.kernel.org/r/20120625094215.GA25847@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/asm-generic/bug.h |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 506ec19..53f3eb1 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -3,6 +3,10 @@
 
 #include <linux/compiler.h>
 
+#ifndef __ASSEMBLY__
+# include <linux/kernel.h>
+#endif
+
 #ifdef CONFIG_BUG
 
 #ifdef CONFIG_GENERIC_BUG
@@ -31,9 +35,6 @@ struct bug_entry {
 
 #endif	/* CONFIG_GENERIC_BUG */
 
-#ifndef __ASSEMBLY__
-#include <linux/kernel.h>
-
 /*
  * Don't use BUG() or BUG_ON() unless there's really no way out; one
  * example might be detecting data structure corruption in the middle
@@ -63,6 +64,8 @@ struct bug_entry {
  * to provide better diagnostics.
  */
 #ifndef __WARN_TAINT
+
+#ifndef __ASSEMBLY__
 extern __printf(3, 4)
 void warn_slowpath_fmt(const char *file, const int line,
 		       const char *fmt, ...);
@@ -70,6 +73,8 @@ extern __printf(4, 5)
 void warn_slowpath_fmt_taint(const char *file, const int line, unsigned taint,
 			     const char *fmt, ...);
 extern void warn_slowpath_null(const char *file, const int line);
+#endif /* __ASSEMBLY__ */
+
 #define WANT_WARN_ON_SLOWPATH
 #define __WARN()		warn_slowpath_null(__FILE__, __LINE__)
 #define __WARN_printf(arg...)	warn_slowpath_fmt(__FILE__, __LINE__, arg)
@@ -108,6 +113,7 @@ extern void warn_slowpath_null(const char *file, const int line);
 })
 
 #else /* !CONFIG_BUG */
+
 #ifndef HAVE_ARCH_BUG
 #define BUG() do {} while(0)
 #endif
@@ -203,6 +209,4 @@ extern void warn_slowpath_null(const char *file, const int line);
 # define WARN_ON_SMP(x)			({0;})
 #endif
 
-#endif /* __ASSEMBLY__ */
-
 #endif
