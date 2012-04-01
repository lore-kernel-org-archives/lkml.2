Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab2DAQDl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 12:03:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55546 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab2DAQDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 12:03:36 -0400
Subject: [RFC PATCH -tip 07/16] kdb: Provide original instruction modified by
 sw breakpoint
To: linux-kernel@vger.kernel.org
From: Masami Hiramatsu <masami.hiramatsu@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon, 02 Apr 2012 01:03:32 +0900
Message-ID: <20120401160332.4502.8291.stgit@shimauta>
In-Reply-To: <20120401160229.4502.2541.stgit@shimauta>
References: <20120401160229.4502.2541.stgit@shimauta>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add kdb_get_saved_instr() for someone who needs to know
the original instruction in kernel text.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu@gmail.com>
---
 include/linux/kgdb.h      |    1 +
 kernel/debug/debug_core.c |   14 ++++++++++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index fa39183..e1eb57c 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -209,6 +209,7 @@ extern void kgdb_arch_set_pc(struct pt_regs *regs, unsigned long pc);
 extern int kgdb_validate_break_address(unsigned long addr);
 extern int kgdb_arch_set_breakpoint(unsigned long addr, char *saved_instr);
 extern int kgdb_arch_remove_breakpoint(unsigned long addr, char *bundle);
+extern int kgdb_get_saved_instr(unsigned long addr, unsigned char *buf);
 
 /**
  *	kgdb_arch_late - Perform any architecture specific initalization.
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 1dc53ba..8982ba0 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -349,6 +349,20 @@ int kgdb_isremovedbreak(unsigned long addr)
 	return 0;
 }
 
+int kgdb_get_saved_instr(unsigned long addr, unsigned char *buf)
+{
+	int i;
+	for (i = 0; i < KGDB_MAX_BREAKPOINTS; i++) {
+		if (kgdb_break[i].bpt_addr == addr &&
+		    kgdb_break[i].state == BP_ACTIVE) {
+			memcpy(buf, kgdb_break[i].saved_instr,
+				BREAK_INSTR_SIZE);
+			return 1;
+		}
+	}
+	return 0;
+}
+
 int dbg_remove_all_break(void)
 {
 	unsigned long addr;

