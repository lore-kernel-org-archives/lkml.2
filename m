Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396Ab0IBPsq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 11:48:46 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33315 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756371Ab0IBPso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 11:48:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DfrRCfE16/GxAPY/S4asfdOP/4wc4k7f7dWrxQJRpH4O8SWsNQgiYwI9wZDiSAVFUb
         imMmYsArWo2iU3skb4BGvn2tLgm3UiGJAC80myzNyXS2NGM7wjT3U7jM4789vQew34hw
         ARuUmX3iUm4dXLYrqFm80/nV48+ywF9AD/XYQ=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH v2 21/24] ptrace: cleanup arch_ptrace() on sparc
Date: Fri,  3 Sep 2010 00:46:28 +0900
Message-Id: <1283442391-23612-22-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283442391-23612-1-git-send-email-namhyung@gmail.com>
References: <1283442391-23612-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out struct fps and remove redundant castings.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
---
 arch/sparc/kernel/ptrace_32.c |   54 +++++++++++++++-------------------------
 arch/sparc/kernel/ptrace_64.c |    8 +++---
 2 files changed, 24 insertions(+), 38 deletions(-)

diff --git a/arch/sparc/kernel/ptrace_32.c b/arch/sparc/kernel/ptrace_32.c
index e08ba4a..27b9e93 100644
--- a/arch/sparc/kernel/ptrace_32.c
+++ b/arch/sparc/kernel/ptrace_32.c
@@ -323,19 +323,35 @@ const struct user_regset_view *task_user_regset_view(struct task_struct *task)
 	return &user_sparc32_view;
 }
 
+struct fps {
+	unsigned long regs[32];
+	unsigned long fsr;
+	unsigned long flags;
+	unsigned long extra;
+	unsigned long fpqd;
+	struct fq {
+		unsigned long *insnaddr;
+		unsigned long insn;
+	} fpq[16];
+};
+
 long arch_ptrace(struct task_struct *child, long request,
 		 unsigned long addr, unsigned long data)
 {
 	unsigned long addr2 = current->thread.kregs->u_regs[UREG_I4];
+	void __user *addr2p;
 	const struct user_regset_view *view;
+	struct pt_regs __user *pregs;
+	struct fps __user *fps;
 	int ret;
 
 	view = task_user_regset_view(current);
+	addr2p = (void __user *) addr2;
+	pregs = (struct pt_regs __user *) addr;
+	fps = (struct fps __user *) addr;
 
 	switch(request) {
 	case PTRACE_GETREGS: {
-		struct pt_regs __user *pregs = (struct pt_regs __user *) addr;
-
 		ret = copy_regset_to_user(child, view, REGSET_GENERAL,
 					  32 * sizeof(u32),
 					  4 * sizeof(u32),
@@ -349,8 +365,6 @@ long arch_ptrace(struct task_struct *child, long request,
 	}
 
 	case PTRACE_SETREGS: {
-		struct pt_regs __user *pregs = (struct pt_regs __user *) addr;
-
 		ret = copy_regset_from_user(child, view, REGSET_GENERAL,
 					    32 * sizeof(u32),
 					    4 * sizeof(u32),
@@ -364,19 +378,6 @@ long arch_ptrace(struct task_struct *child, long request,
 	}
 
 	case PTRACE_GETFPREGS: {
-		struct fps {
-			unsigned long regs[32];
-			unsigned long fsr;
-			unsigned long flags;
-			unsigned long extra;
-			unsigned long fpqd;
-			struct fq {
-				unsigned long *insnaddr;
-				unsigned long insn;
-			} fpq[16];
-		};
-		struct fps __user *fps = (struct fps __user *) addr;
-
 		ret = copy_regset_to_user(child, view, REGSET_FP,
 					  0 * sizeof(u32),
 					  32 * sizeof(u32),
@@ -398,19 +399,6 @@ long arch_ptrace(struct task_struct *child, long request,
 	}
 
 	case PTRACE_SETFPREGS: {
-		struct fps {
-			unsigned long regs[32];
-			unsigned long fsr;
-			unsigned long flags;
-			unsigned long extra;
-			unsigned long fpqd;
-			struct fq {
-				unsigned long *insnaddr;
-				unsigned long insn;
-			} fpq[16];
-		};
-		struct fps __user *fps = (struct fps __user *) addr;
-
 		ret = copy_regset_from_user(child, view, REGSET_FP,
 					    0 * sizeof(u32),
 					    32 * sizeof(u32),
@@ -425,8 +413,7 @@ long arch_ptrace(struct task_struct *child, long request,
 
 	case PTRACE_READTEXT:
 	case PTRACE_READDATA:
-		ret = ptrace_readdata(child, addr,
-				      (void __user *) addr2, data);
+		ret = ptrace_readdata(child, addr, addr2p, data);
 
 		if (ret == data)
 			ret = 0;
@@ -436,8 +423,7 @@ long arch_ptrace(struct task_struct *child, long request,
 
 	case PTRACE_WRITETEXT:
 	case PTRACE_WRITEDATA:
-		ret = ptrace_writedata(child, (void __user *) addr2,
-				       addr, data);
+		ret = ptrace_writedata(child, addr2p, addr, data);
 
 		if (ret == data)
 			ret = 0;
diff --git a/arch/sparc/kernel/ptrace_64.c b/arch/sparc/kernel/ptrace_64.c
index d9db5a4..9ccc812 100644
--- a/arch/sparc/kernel/ptrace_64.c
+++ b/arch/sparc/kernel/ptrace_64.c
@@ -976,10 +976,12 @@ long arch_ptrace(struct task_struct *child, long request,
 	unsigned long addr2 = task_pt_regs(current)->u_regs[UREG_I4];
 	struct pt_regs __user *pregs;
 	struct fps __user *fps;
+	void __user *addr2p;
 	int ret;
 
 	pregs = (struct pt_regs __user *) addr;
 	fps = (struct fps __user *) addr;
+	addr2p = (void __user *) addr2;
 
 	switch (request) {
 	case PTRACE_PEEKUSR:
@@ -1030,8 +1032,7 @@ long arch_ptrace(struct task_struct *child, long request,
 
 	case PTRACE_READTEXT:
 	case PTRACE_READDATA:
-		ret = ptrace_readdata(child, addr,
-				      (char __user *)addr2, data);
+		ret = ptrace_readdata(child, addr, addr2p, data);
 		if (ret == data)
 			ret = 0;
 		else if (ret >= 0)
@@ -1040,8 +1041,7 @@ long arch_ptrace(struct task_struct *child, long request,
 
 	case PTRACE_WRITETEXT:
 	case PTRACE_WRITEDATA:
-		ret = ptrace_writedata(child, (char __user *) addr2,
-				       addr, data);
+		ret = ptrace_writedata(child, addr2p, addr, data);
 		if (ret == data)
 			ret = 0;
 		else if (ret >= 0)
-- 
1.7.2.2

