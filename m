Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab2KUHQh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 02:16:37 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:42607 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab2KUHQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 02:16:32 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v3 03/12] x86, 64bit: set extra ident page table for whole kernel range
Date: Tue, 20 Nov 2012 23:16:01 -0800
Message-Id: <1353482170-10160-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1353482170-10160-1-git-send-email-yinghai@kernel.org>
References: <1353482170-10160-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current when kernel is loaded above 1G, only [_text, _text+2M]
is set up with extra ident page table.
That is not enough, some variables that could be used early are
out of that range. (like gdt...)

Just set map for [_text, _end] include text/data/bss/brk...

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
---
 arch/x86/kernel/head_64.S |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 94bf9cc..efc0c08 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -115,7 +115,16 @@ startup_64:
 	andq	$(PTRS_PER_PMD - 1), %rax
 	leaq	__PAGE_KERNEL_IDENT_LARGE_EXEC(%rdi), %rdx
 	leaq	level2_spare_pgt(%rip), %rbx
-	movq	%rdx, 0(%rbx, %rax, 8)
+	leaq	_end(%rip), %r8
+	decq	%r8
+	shrq	$PMD_SHIFT, %r8
+	andq	$(PTRS_PER_PMD - 1), %r8
+1:	movq	%rdx, 0(%rbx, %rax, 8)
+	addq	$PMD_SIZE, %rdx
+	incq	%rax
+	cmp	%r8, %rax
+	jle	1b
+
 ident_complete:
 
 	/*
-- 
1.7.7

