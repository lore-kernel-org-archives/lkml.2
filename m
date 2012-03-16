Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761555Ab2CPMRc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 08:17:32 -0400
Received: from thoth.sbs.de ([192.35.17.2]:18088 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753934Ab2CPMRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 08:17:30 -0400
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 1/4] kgdb: x86: Return all segment registers also in 64-bit mode
Date: Fri, 16 Mar 2012 13:17:11 +0100
Message-Id: <04b93bdc9d3d8ea89dc42adf055ce1c0787bb91f.1331900215.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1331900215.git.jan.kiszka@siemens.com>
References: <cover.1331900215.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1331900215.git.jan.kiszka@siemens.com>
References: <cover.1331900215.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even if the content is always 0, gdb expects us to return also ds,
es, fs, and gs while in x86-64 mode. Do this to avoid ugly errors on
"info registers".

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 arch/x86/include/asm/kgdb.h |    6 +++++-
 arch/x86/kernel/kgdb.c      |    6 ++++--
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kgdb.h b/arch/x86/include/asm/kgdb.h
index 77e95f5..e857f1a 100644
--- a/arch/x86/include/asm/kgdb.h
+++ b/arch/x86/include/asm/kgdb.h
@@ -64,9 +64,13 @@ enum regnames {
 	GDB_PS,			/* 17 */
 	GDB_CS,			/* 18 */
 	GDB_SS,			/* 19 */
+	GDB_DS,			/* 20 */
+	GDB_ES,			/* 21 */
+	GDB_FS,			/* 22 */
+	GDB_GS,			/* 23 */
 };
 #define GDB_ORIG_AX		57
-#define DBG_MAX_REG_NUM		20
+#define DBG_MAX_REG_NUM		24
 /* 17 64 bit regs and 3 32 bit regs */
 #define NUMREGBYTES		((17 * 8) + (3 * 4))
 #endif /* ! CONFIG_X86_32 */
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index faba577..fdc37b3 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -67,8 +67,6 @@ struct dbg_reg_def_t dbg_reg_def[DBG_MAX_REG_NUM] =
 	{ "ss", 4, offsetof(struct pt_regs, ss) },
 	{ "ds", 4, offsetof(struct pt_regs, ds) },
 	{ "es", 4, offsetof(struct pt_regs, es) },
-	{ "fs", 4, -1 },
-	{ "gs", 4, -1 },
 #else
 	{ "ax", 8, offsetof(struct pt_regs, ax) },
 	{ "bx", 8, offsetof(struct pt_regs, bx) },
@@ -90,7 +88,11 @@ struct dbg_reg_def_t dbg_reg_def[DBG_MAX_REG_NUM] =
 	{ "flags", 4, offsetof(struct pt_regs, flags) },
 	{ "cs", 4, offsetof(struct pt_regs, cs) },
 	{ "ss", 4, offsetof(struct pt_regs, ss) },
+	{ "ds", 4, -1 },
+	{ "es", 4, -1 },
 #endif
+	{ "fs", 4, -1 },
+	{ "gs", 4, -1 },
 };
 
 int dbg_set_reg(int regno, void *mem, struct pt_regs *regs)
-- 
1.7.3.4

