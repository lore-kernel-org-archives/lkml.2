Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab2GNPfz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 11:35:55 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61138 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567Ab2GNPfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 11:35:22 -0400
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Cc: fengxj325@gmail.com, eparis@redhat.com, keescook@chromium.org,
        james.l.morris@oracle.com, hpa@zytor.com, cevans@chromium.org,
        luto@mit.edu, rob@landley.net, linux-doc@vger.kernel.org,
        Will Drewry <wad@chromium.org>
Subject: [PATCH 2/3] vsyscall_64: allow SECCOMP_RET_TRACErs to skip
Date: Sat, 14 Jul 2012 10:32:53 -0500
Message-Id: <1342279974-26917-2-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342279974-26917-1-git-send-email-wad@chromium.org>
References: <1342279974-26917-1-git-send-email-wad@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current quirky ptrace behavior with vsyscall and seccomp
does not allow tracers to bypass the call.  This change
provides that ability by checking if orig_ax changed.

Signed-off-by: Will Drewry <wad@chromium.org>
---
 arch/x86/kernel/vsyscall_64.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 5db36ca..5f9640c 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -142,11 +142,15 @@ static int addr_to_vsyscall_nr(unsigned long addr)
 #ifdef CONFIG_SECCOMP
 static int vsyscall_seccomp(struct task_struct *tsk, int syscall_nr)
 {
+	int ret;
 	if (!seccomp_mode(&tsk->seccomp))
 		return 0;
 	task_pt_regs(tsk)->orig_ax = syscall_nr;
 	task_pt_regs(tsk)->ax = syscall_nr;
-	return __secure_computing(syscall_nr);
+	ret = __secure_computing(syscall_nr);
+	if (task_pt_regs(tsk)->orig_ax != syscall_nr)
+		return 1; /* ptrace syscall skip */
+	return ret;
 }
 #else
 #define vsyscall_seccomp(_tsk, _nr) 0
@@ -278,9 +282,9 @@ bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
 	current_thread_info()->sig_on_uaccess_error = prev_sig_on_uaccess_error;
 
 	if (skip) {
-		if ((long)regs->ax <= 0L) /* seccomp errno emulation */
+		if ((long)regs->ax <= 0L || skip == 1) /* seccomp errno/trace */
 			goto do_ret;
-		goto done; /* seccomp trace/trap */
+		goto done; /* seccomp trap */
 	}
 
 	if (ret == -EFAULT) {
-- 
1.7.9.5

