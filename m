Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab0H0Jo4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:44:56 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33242 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829Ab0H0Jow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:44:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=G82jZJj5G8Xdl5kSpX6RBKuR8yFlYt6uuduMozk6QLsz2LuatELkXsH5P6HFgpVH+Y
         HXAG17iAQ7OdjQIsw1qzRtzCtLc8RV6MDPaURtqAwX5S9Fx9W3HN5Lk5uWm83nFFt8Qt
         PVl/SpyDvNSkTYHpISvlPce93oPPKTwSUGQmU=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: [RFC PATCH 38/43] ptrace, sparc: cleanup arch_ptrace()
Date: Fri, 27 Aug 2010 18:42:24 +0900
Message-Id: <1282902149-12991-39-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

factor out struct fps and remove redundant castings.

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

