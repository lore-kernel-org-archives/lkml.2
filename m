Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab2DWXun (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 19:50:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57640 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171Ab2DWXul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 19:50:41 -0400
Date: Mon, 23 Apr 2012 16:50:29 -0700
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-045b09a0be388ece1469aa02f17252e57c95093e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        bruce.j.beare@intel.com, arnd@arndb.de, tglx@linutronix.de,
        hjl.rools@gmail.com, hpa@linux.intel.com
Reply-To: arnd@arndb.de, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, bruce.j.beare@intel.com,
        hjl.rools@gmail.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <CAMe9rOqF6Kh6-NK7oP0Fpzkd4SBAWU+G53hwBbSD4iA2UzyxuA@mail.gmail.com>
References: <CAMe9rOqF6Kh6-NK7oP0Fpzkd4SBAWU+G53hwBbSD4iA2UzyxuA@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x32, siginfo:
  Provide proper overrides for x32 siginfo_t
Git-Commit-ID: 045b09a0be388ece1469aa02f17252e57c95093e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 23 Apr 2012 16:50:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  045b09a0be388ece1469aa02f17252e57c95093e
Gitweb:     http://git.kernel.org/tip/045b09a0be388ece1469aa02f17252e57c95093e
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Mon, 23 Apr 2012 16:34:12 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 23 Apr 2012 16:36:45 -0700

x32, siginfo: Provide proper overrides for x32 siginfo_t

Provide the proper override macros for x32 siginfo_t.  The combination
of a special type here and an overall alignment constraint actually
ends up with all the types being properly aligned, but the hack is
needed to keep the substructures inside siginfo_t from adding padding.

Note: use __attribute__((aligned())) since __aligned() is not exported
to user space.

Reported-by: H.J. Lu <hjl.rools@gmail.com>
Cc: Bruce J. Beare <bruce.j.beare@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Link: http://lkml.kernel.org/r/CAMe9rOqF6Kh6-NK7oP0Fpzkd4SBAWU%2BG53hwBbSD4iA2UzyxuA@mail.gmail.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/siginfo.h |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/siginfo.h b/arch/x86/include/asm/siginfo.h
index fc1aa55..073d445 100644
--- a/arch/x86/include/asm/siginfo.h
+++ b/arch/x86/include/asm/siginfo.h
@@ -2,7 +2,13 @@
 #define _ASM_X86_SIGINFO_H
 
 #ifdef __x86_64__
-# define __ARCH_SI_PREAMBLE_SIZE	(4 * sizeof(int))
+# ifdef __ILP32__ /* x32 */
+typedef long long __kernel_si_clock_t __attribute__((aligned(4)));
+#  define __ARCH_SI_CLOCK_T		__kernel_si_clock_t;
+#  define __ARCH_SI_ATTRIBUTES		__attribute__((aligned(8)))
+# else /* x86-64 */
+#  define __ARCH_SI_PREAMBLE_SIZE	(4 * sizeof(int))
+# endif
 #endif
 
 #include <asm-generic/siginfo.h>
