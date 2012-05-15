Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965639Ab2EOC1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:27:42 -0400
Received: from mail.windriver.com ([147.11.1.11]:49871 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965516Ab2EOCSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:18:17 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 168/179] x86-32, vdso: On system call restart after SYSENTER, use int $0x80
Date: Mon, 14 May 2012 22:14:24 -0400
Message-ID: <1337048075-6132-169-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 7ca0758cdb7c241cb4e0490a8d95f0eb5b861daf upstream.

When we enter a 32-bit system call via SYSENTER or SYSCALL, we shuffle
the arguments to match the int $0x80 calling convention.  This was
probably a design mistake, but it's what it is now.  This causes
errors if the system call as to be restarted.

For SYSENTER, we have to invoke the instruction from the vdso as the
return address is hardcoded.  Accordingly, we can simply replace the
jump in the vdso with an int $0x80 instruction and use the slower
entry point for a post-restart.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/CA%2B55aFztZ=r5wa0x26KJQxvZOaQq8s2v3u50wCyJcA-Sc4g8gQ@mail.gmail.com
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/vdso/vdso32/sysenter.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/vdso/vdso32/sysenter.S b/arch/x86/vdso/vdso32/sysenter.S
index e2800af..e354bce 100644
--- a/arch/x86/vdso/vdso32/sysenter.S
+++ b/arch/x86/vdso/vdso32/sysenter.S
@@ -43,7 +43,7 @@ __kernel_vsyscall:
 	.space 7,0x90
 
 	/* 14: System call restart point is here! (SYSENTER_RETURN-2) */
-	jmp .Lenter_kernel
+	int $0x80
 	/* 16: System call normal return point is here! */
 VDSO32_SYSENTER_RETURN:	/* Symbol used by sysenter.c via vdso32-syms.h */
 	pop %ebp
-- 
1.7.9.6

