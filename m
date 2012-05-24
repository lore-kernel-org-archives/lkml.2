Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757796Ab2EXQIq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 12:08:46 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:42194 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757703Ab2EXQIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 12:08:41 -0400
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: mcgrathr@google.com, hpa@zytor.com, indan@nul.nu, netdev@parisplace.org,
        linux-security-module@vger.kernel.org,
        kernel-hardening@lists.openwall.com, mingo@redhat.com, oleg@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, tglx@linutronix.de,
        luto@mit.edu, serge.hallyn@canonical.com, pmoore@redhat.com,
        akpm@linux-foundation.org, corbet@lwn.net, markus@chromium.org,
        coreyb@linux.vnet.ibm.com, keescook@chromium.org,
        viro@zeniv.linux.org.uk, jmorris@namei.org,
        Will Drewry <wad@chromium.org>
Subject: [RFC PATCH 2/3] arch/x86: move secure_computing after ptrace
Date: Thu, 24 May 2012 11:08:00 -0500
Message-Id: <1337875681-20717-3-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1337875681-20717-1-git-send-email-wad@chromium.org>
References: <20120522173942.GJ11775@ZenIV.linux.org.uk>
 <1337875681-20717-1-git-send-email-wad@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At present, seccomp modes 1 and 2 may have their
behavior changed by a ptrace()ing task.  The ptracer
cannot change blocked/disallowed system calls, but it can
change allowed system calls to calls that would otherwise
not be allowed by the seccomp policy.

Signed-off-by: Will Drewry <wad@chromium.org>
---
 arch/x86/kernel/ptrace.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 13b1990..ad649a6 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1479,13 +1479,6 @@ long syscall_trace_enter(struct pt_regs *regs)
 	if (test_thread_flag(TIF_SINGLESTEP))
 		regs->flags |= X86_EFLAGS_TF;
 
-	/* do the secure computing check first */
-	if (secure_computing(regs->orig_ax)) {
-		/* seccomp failures shouldn't expose any additional code. */
-		ret = -1L;
-		goto out;
-	}
-
 	if (unlikely(test_thread_flag(TIF_SYSCALL_EMU)))
 		ret = -1L;
 
@@ -1493,6 +1486,12 @@ long syscall_trace_enter(struct pt_regs *regs)
 	    tracehook_report_syscall_entry(regs))
 		ret = -1L;
 
+	/* check secure computing after userspace can't change the syscall. */
+	if (!ret && secure_computing(regs->orig_ax)) {
+		ret = -1L;
+		goto out;
+	}
+
 	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
 		trace_sys_enter(regs, regs->orig_ax);
 
-- 
1.7.9.5

