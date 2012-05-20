Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab2ETBTY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 21:19:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:33340 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124Ab2ETBTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 21:19:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="145275676"
From: Tony Luck <tony.luck@intel.com>
Date: Sat, 19 May 2012 17:49:24 -0700
Subject: [PATCH] x86/mce: Fix check for processor context when machine check was taken.
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Message-Id: <0169270@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus pointed out that checking "m->ip" was incorrect as "0" is
a legitimate value.  Also we need to consider that we may have
interrupted VM86 execution (in which case "CS" isn't any use in
determining user/kernel).

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
In case you are unable to sleep at night worrying about those
poor systems that don't recover because they do the wrong thing
if there is a VM86 process running, or some malicious user has
a "jmp 0" at the base of a code segment.

Mea culpa: Andi fixed the VM86 part of this a year and
a half ago, and I failed to pick up the fix from his tree
when I took over. There are some other bits I need to pick
up too.

 arch/x86/kernel/cpu/mcheck/mce-severity.c |   11 +++++------
 arch/x86/kernel/cpu/mcheck/mce.c          |    2 ++
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c b/arch/x86/kernel/cpu/mcheck/mce-severity.c
index 0c82091..5dfb77a 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
@@ -165,15 +165,14 @@ static struct severity {
 };
 
 /*
- * If the EIPV bit is set, it means the saved IP is the
- * instruction which caused the MCE.
+ * No need to re-check mcgstatus here. We either found a
+ * good value for "cs" on the stack earlier (or faked one
+ * for the VM86 case) - or we didn't and "m->cs" will be
+ * zero which we will treat conservatively as "IN_KERNEL".
  */
 static int error_context(struct mce *m)
 {
-	if (m->mcgstatus & MCG_STATUS_EIPV)
-		return (m->ip && (m->cs & 3) == 3) ? IN_USER : IN_KERNEL;
-	/* Unknown, assume kernel */
-	return IN_KERNEL;
+	return ((m->cs & 3) == 3) ? IN_USER : IN_KERNEL;
 }
 
 int mce_severity(struct mce *m, int tolerant, char **msg)
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 11c9166..a2d53f3 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -437,6 +437,8 @@ static inline void mce_gather_info(struct mce *m, struct pt_regs *regs)
 		if (m->mcgstatus & (MCG_STATUS_RIPV|MCG_STATUS_EIPV)) {
 			m->ip = regs->ip;
 			m->cs = regs->cs;
+			if (v8086_mode(regs))
+				m->cs |= 3; /* fake user mode for VM86 */
 		}
 		/* Use accurate RIP reporting if available. */
 		if (rip_msr)
-- 
1.7.9.5

