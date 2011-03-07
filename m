Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab1CGLno (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 06:43:44 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:41813 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab1CGLnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 06:43:43 -0500
Date: Mon, 7 Mar 2011 17:13:37 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, anton@samba.org, benh@kernel.crashing.org
Subject: [PATCH 1/7] powerpc/kdump: CPUs assume the context of the oopsing
	CPU
Message-ID: <20110307114337.GC8194@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    powerpc/kdump: CPUs assume the context of the oopsing CPU

    Commit: 0644079410065567e3bb31fcb8e6441f2b7685a9 upstream

    We wrap the crash_shutdown_handles[] calls with longjmp/setjmp, so if any
    of them fault we can recover. The problem is we add a hook to the debugger
    fault handler hook which calls longjmp unconditionally.

    This first part of kdump is run before we marshall the other CPUs, so there
    is a very good chance some CPU on the box is going to page fault. And when
    it does it hits the longjmp code and assumes the context of the oopsing CPU.
    The machine gets very confused when it has 10 CPUs all with the same stack,
    all thinking they have the same CPU id. I get even more confused trying
    to debug it.

    The patch below adds crash_shutdown_cpu and uses it to specify which cpu is
    in the protected region. Since it can only be -1 or the oopsing CPU, we don't
    need to use memory barriers since it is only valid on the local CPU - no other
    CPU will ever see a value that matches it's local CPU id.

    Eventually we should switch the order and marshall all CPUs before doing the
    crash_shutdown_handles[] calls, but that is a bigger fix.

    Signed-off-by: Anton Blanchard <anton@samba.org>
    Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
    Signed-off-by: Kamalesh babulal <kamalesh@linux.vnet.ibm.com>
---
 arch/powerpc/kernel/crash.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: b/arch/powerpc/kernel/crash.c
===================================================================
--- a/arch/powerpc/kernel/crash.c	2011-03-06 23:25:07.077520356 -0800
+++ b/arch/powerpc/kernel/crash.c	2011-03-06 23:26:33.913521564 -0800
@@ -347,10 +347,13 @@
 EXPORT_SYMBOL(crash_shutdown_unregister);

 static unsigned long crash_shutdown_buf[JMP_BUF_LEN];
+static int crash_shutdown_cpu = -1;

 static int handle_fault(struct pt_regs *regs)
 {
	longjmp(crash_shutdown_buf, 1);
+	if (crash_shutdown_cpu == smp_processor_id())
+		longjmp(crash_shutdown_buf, 1);
	return 0;
 }

@@ -388,6 +391,7 @@
	 */
	old_handler = __debugger_fault_handler;
	__debugger_fault_handler = handle_fault;
+	crash_shutdown_cpu = smp_processor_id();
	for (i = 0; crash_shutdown_handles[i]; i++) {
		if (setjmp(crash_shutdown_buf) == 0) {
			/*
@@ -401,6 +405,7 @@
			asm volatile("sync; isync");
		}
	}
+	crash_shutdown_cpu = -1;
	__debugger_fault_handler = old_handler;

	/*
