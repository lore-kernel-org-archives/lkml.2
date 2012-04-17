Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976Ab2DQTu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 15:50:27 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54910 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab2DQTuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 15:50:21 -0400
From: Will Drewry <wad@chromium.org>
To: jmorris@namei.org
Cc: linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
        linux-security-module@vger.kernel.org, Will Drewry <wad@chromium.org>,
        Eric Paris <eparis@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: [PATCH 2/2] seccomp: fix build warnings when there is no CONFIG_SECCOMP_FILTER
Date: Tue, 17 Apr 2012 14:48:58 -0500
Message-Id: <1334692161-6834-2-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1334692161-6834-1-git-send-email-wad@chromium.org>
References: <1334692161-6834-1-git-send-email-wad@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If both audit and seccomp filter support are disabled, 'ret' is marked
as unused.

If just seccomp filter support is disabled, data and skip are considered
unused.

This change fixes those build warnings.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Will Drewry <wad@chromium.org>
Acked-by: Kees Cook <keescook@chromium.org>
---
 kernel/seccomp.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index d9db6ec..ee376be 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -377,8 +377,7 @@ int __secure_computing(int this_syscall)
 	int mode = current->seccomp.mode;
 	int exit_sig = 0;
 	int *syscall;
-	u32 ret = SECCOMP_RET_KILL;
-	int data;
+	u32 ret;
 
 	switch (mode) {
 	case SECCOMP_MODE_STRICT:
@@ -392,12 +391,15 @@ int __secure_computing(int this_syscall)
 				return 0;
 		} while (*++syscall);
 		exit_sig = SIGKILL;
+		ret = SECCOMP_RET_KILL;
 		break;
 #ifdef CONFIG_SECCOMP_FILTER
-	case SECCOMP_MODE_FILTER:
+	case SECCOMP_MODE_FILTER: {
+		int data;
 		ret = seccomp_run_filters(this_syscall);
 		data = ret & SECCOMP_RET_DATA;
-		switch (ret & SECCOMP_RET_ACTION) {
+		ret &= SECCOMP_RET_ACTION;
+		switch (ret) {
 		case SECCOMP_RET_ERRNO:
 			/* Set the low-order 16-bits as a errno. */
 			syscall_set_return_value(current, task_pt_regs(current),
@@ -432,6 +434,7 @@ int __secure_computing(int this_syscall)
 		}
 		exit_sig = SIGSYS;
 		break;
+	}
 #endif
 	default:
 		BUG();
@@ -442,8 +445,10 @@ int __secure_computing(int this_syscall)
 #endif
 	audit_seccomp(this_syscall, exit_sig, ret);
 	do_exit(exit_sig);
+#ifdef CONFIG_SECCOMP_FILTER
 skip:
 	audit_seccomp(this_syscall, exit_sig, ret);
+#endif
 	return -1;
 }
 
-- 
1.7.5.4

