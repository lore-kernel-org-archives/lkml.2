Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049Ab0CRSVc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 14:21:32 -0400
Received: from mail-px0-f198.google.com ([209.85.216.198]:58881 "EHLO
	mail-px0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab0CRSV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 14:21:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=aA2i5U7u+e+FSV2JWCVSA0UMyseISvYk2xvvcMa0HrrbO9SadZb273zFk536X5l+Bd
         LRyeEwal8SeKbb2cedVRpwGMa+Z4kNoB1f8bW03p0ys1wsh00POUHtDIoqb9PMDNmY63
         87i59u4gviLtk0NdwctHsHdkhx7AnK4TOw1Nk=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] x86-32: Remove die_if_kernel()
Date: Thu, 18 Mar 2010 14:20:50 -0400
Message-Id: <1268936453-3727-3-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1268936453-3727-1-git-send-email-brgerst@gmail.com>
References: <1268936453-3727-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merge die_if_kernel() into do_cache_flush_error().

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/kernel/traps.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 45b9cb0..cea343e 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -108,15 +108,6 @@ static inline void preempt_conditional_cli(struct pt_regs *regs)
 	dec_preempt_count();
 }
 
-#ifdef CONFIG_X86_32
-static inline void
-die_if_kernel(const char *str, struct pt_regs *regs, long err)
-{
-	if (!user_mode_vm(regs))
-		die(str, regs, err);
-}
-#endif
-
 static void __kprobes
 do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
 	long error_code, siginfo_t *info)
@@ -273,7 +264,8 @@ do_cache_flush_error(struct pt_regs *regs, long error_code)
 	}
 	current->thread.trap_no = 19;
 	current->thread.error_code = error_code;
-	die_if_kernel("cache flush denied", regs, error_code);
+	if (!user_mode(regs))
+		die("cache flush denied", regs, error_code);
 	force_sig(SIGSEGV, current);
 }
 #endif
-- 
1.6.6.1

