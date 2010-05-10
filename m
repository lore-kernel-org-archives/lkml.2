Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105Ab0EJUkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 16:40:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:56050 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757022Ab0EJUk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 16:40:29 -0400
Date: Mon, 10 May 2010 20:40:14 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de, avi@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, tglx@linutronix.de, avi@redhat.com
In-Reply-To: <1273135546-29690-3-git-send-email-avi@redhat.com>
References: <1273135546-29690-3-git-send-email-avi@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86, fpu: Unbreak FPU emulation
Message-ID: <tip-c3f8978ea332cd4be88e12574452a025892ac9af@git.kernel.org>
Git-Commit-ID: c3f8978ea332cd4be88e12574452a025892ac9af
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 10 May 2010 20:40:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c3f8978ea332cd4be88e12574452a025892ac9af
Gitweb:     http://git.kernel.org/tip/c3f8978ea332cd4be88e12574452a025892ac9af
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Mon, 10 May 2010 13:37:16 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 10 May 2010 13:37:16 -0700

x86, fpu: Unbreak FPU emulation

Unbreak FPU emulation, broken by checkin
86603283326c9e95e5ad4e9fdddeec93cac5d9ad:
x86: Introduce 'struct fpu' and related API

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <1273135546-29690-3-git-send-email-avi@redhat.com>
---
 arch/x86/math-emu/fpu_aux.c    |    2 +-
 arch/x86/math-emu/fpu_entry.c  |    4 ++--
 arch/x86/math-emu/fpu_system.h |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/math-emu/fpu_aux.c b/arch/x86/math-emu/fpu_aux.c
index 62797f9..dc8adad 100644
--- a/arch/x86/math-emu/fpu_aux.c
+++ b/arch/x86/math-emu/fpu_aux.c
@@ -52,7 +52,7 @@ void finit_soft_fpu(struct i387_soft_struct *soft)
 
 void finit(void)
 {
-	finit_task(&current->thread.fpu);
+	finit_soft_fpu(&current->thread.fpu.state->soft);
 }
 
 /*
diff --git a/arch/x86/math-emu/fpu_entry.c b/arch/x86/math-emu/fpu_entry.c
index 5d87f58..7718541 100644
--- a/arch/x86/math-emu/fpu_entry.c
+++ b/arch/x86/math-emu/fpu_entry.c
@@ -681,7 +681,7 @@ int fpregs_soft_set(struct task_struct *target,
 		    unsigned int pos, unsigned int count,
 		    const void *kbuf, const void __user *ubuf)
 {
-	struct i387_soft_struct *s387 = &target->thread.xstate->soft;
+	struct i387_soft_struct *s387 = &target->thread.fpu.state->soft;
 	void *space = s387->st_space;
 	int ret;
 	int offset, other, i, tags, regnr, tag, newtop;
@@ -733,7 +733,7 @@ int fpregs_soft_get(struct task_struct *target,
 		    unsigned int pos, unsigned int count,
 		    void *kbuf, void __user *ubuf)
 {
-	struct i387_soft_struct *s387 = &target->thread.xstate->soft;
+	struct i387_soft_struct *s387 = &target->thread.fpu.state->soft;
 	const void *space = s387->st_space;
 	int ret;
 	int offset = (S387->ftop & 7) * 10, other = 80 - offset;
diff --git a/arch/x86/math-emu/fpu_system.h b/arch/x86/math-emu/fpu_system.h
index 50fa0ec..2c61441 100644
--- a/arch/x86/math-emu/fpu_system.h
+++ b/arch/x86/math-emu/fpu_system.h
@@ -31,7 +31,7 @@
 #define SEG_EXPAND_DOWN(s)	(((s).b & ((1 << 11) | (1 << 10))) \
 				 == (1 << 10))
 
-#define I387			(current->thread.xstate)
+#define I387			(current->thread.fpu.state)
 #define FPU_info		(I387->soft.info)
 
 #define FPU_CS			(*(unsigned short *) &(FPU_info->regs->cs))
