Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab0JNTs0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 15:48:26 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53188 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945Ab0JNTsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 15:48:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=aEle1ACgmBGuM36j5dkwIO8RnLSovqGZKWGLHJKTu0y3IBUZQLB4ee5I2iVArfwKmH
         EXhLyN/dFLa6oQFYXMIRgDjYZMf+YwEunEZEwB4JHHZGSAhptSBD+MCz+8G/OwxiHSY6
         bRY1j9A6101iM2IubXMaunNkOVkf6jToV8WiQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/2] x86: Barf when vmalloc and kmemcheck faults happen in NMI
Date: Thu, 14 Oct 2010 21:42:51 +0200
Message-Id: <1287085371-29177-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1287085371-29177-1-git-send-regression-fweisbec@gmail.com>
References: <1287085371-29177-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In x86, faults exit by executing the iret instruction, which then
reenables NMIs if we faulted in NMI context. Then if a fault
happens in NMI, another NMI can nest after the fault exits.

But we don't yet support nested NMIs because we have only one NMI
stack. To prevent from that, check that vmalloc and kmemcheck
faults don't happen in this context. Most of the other kernel faults
in NMIs can be more easily spotted by finding explicit
copy_from,to_user() calls on review.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/mm/fault.c               |    4 ++++
 arch/x86/mm/kmemcheck/kmemcheck.c |    2 ++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 4c4508e..a24c6cf 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -251,6 +251,8 @@ static noinline __kprobes int vmalloc_fault(unsigned long address)
 	if (!(address >= VMALLOC_START && address < VMALLOC_END))
 		return -1;
 
+	WARN_ON_ONCE(in_nmi());
+
 	/*
 	 * Synchronize this task's top level page-table
 	 * with the 'reference' page table.
@@ -369,6 +371,8 @@ static noinline __kprobes int vmalloc_fault(unsigned long address)
 	if (!(address >= VMALLOC_START && address < VMALLOC_END))
 		return -1;
 
+	WARN_ON_ONCE(in_nmi());
+
 	/*
 	 * Copy kernel mappings over when needed. This can also
 	 * happen within a race in page table update. In the later
diff --git a/arch/x86/mm/kmemcheck/kmemcheck.c b/arch/x86/mm/kmemcheck/kmemcheck.c
index b3b531a..d87dd6d 100644
--- a/arch/x86/mm/kmemcheck/kmemcheck.c
+++ b/arch/x86/mm/kmemcheck/kmemcheck.c
@@ -631,6 +631,8 @@ bool kmemcheck_fault(struct pt_regs *regs, unsigned long address,
 	if (!pte)
 		return false;
 
+	WARN_ON_ONCE(in_nmi());
+
 	if (error_code & 2)
 		kmemcheck_access(regs, address, KMEMCHECK_WRITE);
 	else
-- 
1.6.2.3

