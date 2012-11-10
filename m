Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab2KJWpe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 17:45:34 -0500
Received: from smtp.outflux.net ([198.145.64.163]:34497 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927Ab2KJWpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 17:45:31 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, Geremy Condra <gcondra@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>
Subject: [PATCH 3/4] arch/arm: allow a scno of -1 to not cause a SIGILL
Date: Sat, 10 Nov 2012 14:44:44 -0800
Message-Id: <1352587485-18348-4-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352587485-18348-1-git-send-email-keescook@chromium.org>
References: <1352587485-18348-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On tracehook-friendly platforms, a system call number of -1 falls
through without running much code or taking much action.

ARM is different. This adds a short-circuit check in the trace path to
avoid any additional work, as suggested by Russell King, to make sure
that ARM behaves the same way as other platforms.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/arm/kernel/entry-common.S |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index 8355d4b..0bef977 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -448,7 +448,10 @@ __sys_trace:
 	ldmccia	r1, {r0 - r6}			@ have to reload r0 - r6
 	stmccia	sp, {r4, r5}			@ and update the stack args
 	ldrcc	pc, [tbl, scno, lsl #2]		@ call sys_* routine
-	b	2b
+	cmp	scno, #-1			@ skip the syscall?
+	bne	2b
+	add	sp, sp, #S_OFF			@ restore stack
+	b	ret_slow_syscall
 
 __sys_trace_return:
 	str	r0, [sp, #S_R0 + S_OFF]!	@ save returned r0
-- 
1.7.9.5

