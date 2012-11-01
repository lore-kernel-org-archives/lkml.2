Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992502Ab2KATrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 15:47:21 -0400
Received: from smtp.outflux.net ([198.145.64.163]:58140 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964853Ab2KATrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 15:47:17 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>,
        Will Drewry <wad@chromium.org>, Geremy Condra <gcondra@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 3/4] arch/arm: allow a scno of -1 to not cause a SIGILL
Date: Thu,  1 Nov 2012 12:46:38 -0700
Message-Id: <1351799199-6853-4-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351799199-6853-1-git-send-email-keescook@chromium.org>
References: <1351799199-6853-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Drewry <wad@chromium.org>

On tracehook-friendly platforms, a system call number of -1 falls
through without running much code or taking much action.

ARM is different.  This adds a lightweight check to arm_syscall()
to make sure that ARM behaves the same way.

Signed-off-by: Will Drewry <wad@chromium.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/arm/kernel/traps.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index b0179b8..f303ea6 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -540,6 +540,10 @@ asmlinkage int arm_syscall(int no, struct pt_regs *regs)
 	struct thread_info *thread = current_thread_info();
 	siginfo_t info;
 
+	/* Emulate/fallthrough. */
+	if (no == -1)
+		return regs->ARM_r0;
+
 	if ((no >> 16) != (__ARM_NR_BASE>> 16))
 		return bad_syscall(no, regs);
 
-- 
1.7.9.5

