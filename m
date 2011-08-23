Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab1HWXlH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 19:41:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:57437 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755736Ab1HWXk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 19:40:59 -0400
Date: Tue, 23 Aug 2011 23:40:23 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-7ca0758cdb7c241cb4e0490a8d95f0eb5b861daf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, stable@kernel.org, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, stable@kernel.org, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <CA+55aFztZ=r5wa0x26KJQxvZOaQq8s2v3u50wCyJcA-Sc4g8gQ@mail.gmail.com>
References: <CA+55aFztZ=r5wa0x26KJQxvZOaQq8s2v3u50wCyJcA-Sc4g8gQ@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86-32, vdso: On system call restart after SYSENTER, use int $0x80
Git-Commit-ID: 7ca0758cdb7c241cb4e0490a8d95f0eb5b861daf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (hera.kernel.org [127.0.0.1]); Tue, 23 Aug 2011 23:40:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7ca0758cdb7c241cb4e0490a8d95f0eb5b861daf
Gitweb:     http://git.kernel.org/tip/7ca0758cdb7c241cb4e0490a8d95f0eb5b861daf
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Mon, 22 Aug 2011 13:27:06 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 23 Aug 2011 16:20:10 -0700

x86-32, vdso: On system call restart after SYSENTER, use int $0x80

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
Cc: <stable@kernel.org>
---
 arch/x86/vdso/vdso32/sysenter.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
