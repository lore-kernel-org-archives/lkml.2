Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751146Ab0GPEWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 00:22:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:41052 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906Ab0GPEWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 00:22:37 -0400
Date: Fri, 16 Jul 2010 04:21:49 GMT
From: tip-bot for Matt Fleming <matt@console-pimps.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        masami.hiramatsu.pt@hitachi.com, matt@console-pimps.org,
        imunsie@au.ibm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com,
        masami.hiramatsu.pt@hitachi.com, a.p.zijlstra@chello.nl,
        matt@console-pimps.org, imunsie@au.ibm.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <e55812819ad18c2ceca5651ac7698a2af46180d7.1278774279.git.matt@console-pimps.org>
References: <e55812819ad18c2ceca5651ac7698a2af46180d7.1278774279.git.matt@console-pimps.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add DWARF register lookup for SH
Message-ID: <tip-0dd9ac63ce26ec87b080ca9c3e6efed33c23ace6@git.kernel.org>
Git-Commit-ID: 0dd9ac63ce26ec87b080ca9c3e6efed33c23ace6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 16 Jul 2010 04:21:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0dd9ac63ce26ec87b080ca9c3e6efed33c23ace6
Gitweb:     http://git.kernel.org/tip/0dd9ac63ce26ec87b080ca9c3e6efed33c23ace6
Author:     Matt Fleming <matt@console-pimps.org>
AuthorDate: Sat, 10 Jul 2010 16:10:39 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 12 Jul 2010 11:25:10 -0300

perf tools: Add DWARF register lookup for SH

Implement get_arch_regstr() for SH so that, given a DWARF register number, the
corresponding symbolic name of that register can be looked up.

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ian Munsie <imunsie@au.ibm.com>
LKML-Reference: <e55812819ad18c2ceca5651ac7698a2af46180d7.1278774279.git.matt@console-pimps.org>
Signed-off-by: Matt Fleming <matt@console-pimps.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/arch/{powerpc => sh}/Makefile           |    0
 .../perf/arch/sh/util/dwarf-regs.c                 |   48 +++++++++++++-------
 2 files changed, 32 insertions(+), 16 deletions(-)

diff --git a/tools/perf/arch/powerpc/Makefile b/tools/perf/arch/sh/Makefile
similarity index 100%
copy from tools/perf/arch/powerpc/Makefile
copy to tools/perf/arch/sh/Makefile
diff --git a/kernel/rcutiny_plugin.h b/tools/perf/arch/sh/util/dwarf-regs.c
similarity index 55%
copy from kernel/rcutiny_plugin.h
copy to tools/perf/arch/sh/util/dwarf-regs.c
index d223a92..a11edb0 100644
--- a/kernel/rcutiny_plugin.h
+++ b/tools/perf/arch/sh/util/dwarf-regs.c
@@ -1,7 +1,7 @@
 /*
- * Read-Copy Update mechanism for mutual exclusion (tree-based version)
- * Internal non-public definitions that provide either classic
- * or preemptable semantics.
+ * Mapping of DWARF debug register numbers into register names.
+ *
+ * Copyright (C) 2010 Matt Fleming <matt@console-pimps.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -17,23 +17,39 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  *
- * Copyright IBM Corporation, 2009
- *
- * Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
  */
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-
-#include <linux/kernel_stat.h>
+#include <libio.h>
+#include <dwarf-regs.h>
 
 /*
- * During boot, we forgive RCU lockdep issues.  After this function is
- * invoked, we start taking RCU lockdep issues seriously.
+ * Generic dwarf analysis helpers
  */
-void rcu_scheduler_starting(void)
+
+#define SH_MAX_REGS 18
+const char *sh_regs_table[SH_MAX_REGS] = {
+	"r0",
+	"r1",
+	"r2",
+	"r3",
+	"r4",
+	"r5",
+	"r6",
+	"r7",
+	"r8",
+	"r9",
+	"r10",
+	"r11",
+	"r12",
+	"r13",
+	"r14",
+	"r15",
+	"pc",
+	"pr",
+};
+
+/* Return architecture dependent register string (for kprobe-tracer) */
+const char *get_arch_regstr(unsigned int n)
 {
-	WARN_ON(nr_context_switches() > 0);
-	rcu_scheduler_active = 1;
+	return (n <= SH_MAX_REGS) ? sh_regs_table[n] : NULL;
 }
-
-#endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
