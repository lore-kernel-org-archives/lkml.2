Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab1ABIBS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 03:01:18 -0500
Received: from mail.windriver.com ([147.11.1.11]:35136 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434Ab1ABHWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:22:53 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Roland McGrath <roland@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 081/260] x86-64, compat: Retruncate rax after ia32 syscall entry tracing
Date: Sun,  2 Jan 2011 02:16:17 -0500
Message-Id: <1293952756-15010-82-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:21:37.0992 (UTC) FILETIME=[B1A73480:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland McGrath <roland@redhat.com>

commit eefdca043e8391dcd719711716492063030b55ac upstream.

In commit d4d6715, we reopened an old hole for a 64-bit ptracer touching a
32-bit tracee in system call entry.  A %rax value set via ptrace at the
entry tracing stop gets used whole as a 32-bit syscall number, while we
only check the low 32 bits for validity.

Fix it by truncating %rax back to 32 bits after syscall_trace_enter,
in addition to testing the full 64 bits as has already been added.

Reported-by: Ben Hawkes <hawkes@sota.gen.nz>
Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/ia32/ia32entry.S |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 944e3fc..4f5f71e 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -50,7 +50,12 @@
 	/*
 	 * Reload arg registers from stack in case ptrace changed them.
 	 * We don't reload %eax because syscall_trace_enter() returned
-	 * the value it wants us to use in the table lookup.
+	 * the %rax value we should see.  Instead, we just truncate that
+	 * value to 32 bits again as we did on entry from user mode.
+	 * If it's a new value set by user_regset during entry tracing,
+	 * this matches the normal truncation of the user-mode value.
+	 * If it's -1 to make us punt the syscall, then (u32)-1 is still
+	 * an appropriately invalid value.
 	 */
 	.macro LOAD_ARGS32 offset, _r9=0
 	.if \_r9
@@ -60,6 +65,7 @@
 	movl \offset+48(%rsp),%edx
 	movl \offset+56(%rsp),%esi
 	movl \offset+64(%rsp),%edi
+	movl %eax,%eax			/* zero extension */
 	.endm
 	
 	.macro CFI_STARTPROC32 simple
-- 
1.7.3.3

