Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933611Ab1FWSAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:00:22 -0400
Received: from mail.windriver.com ([147.11.1.11]:35056 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933582Ab1FWRhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:37:34 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 155/247] powerpc/kdump: CPUs assume the context of the oopsing CPU
Date: Thu, 23 Jun 2011 13:33:43 -0400
Message-Id: <1308850515-15242-96-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@samba.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 0644079410065567e3bb31fcb8e6441f2b7685a9 upstream.

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/powerpc/kernel/crash.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/crash.c b/arch/powerpc/kernel/crash.c
index 6f4613d..fbe3c1c 100644
--- a/arch/powerpc/kernel/crash.c
+++ b/arch/powerpc/kernel/crash.c
@@ -347,10 +347,12 @@ int crash_shutdown_unregister(crash_shutdown_t handler)
 EXPORT_SYMBOL(crash_shutdown_unregister);
 
 static unsigned long crash_shutdown_buf[JMP_BUF_LEN];
+static int crash_shutdown_cpu = -1;
 
 static int handle_fault(struct pt_regs *regs)
 {
-	longjmp(crash_shutdown_buf, 1);
+	if (crash_shutdown_cpu == smp_processor_id())
+		longjmp(crash_shutdown_buf, 1);
 	return 0;
 }
 
@@ -388,6 +390,7 @@ void default_machine_crash_shutdown(struct pt_regs *regs)
 	 */
 	old_handler = __debugger_fault_handler;
 	__debugger_fault_handler = handle_fault;
+	crash_shutdown_cpu = smp_processor_id();
 	for (i = 0; crash_shutdown_handles[i]; i++) {
 		if (setjmp(crash_shutdown_buf) == 0) {
 			/*
@@ -401,6 +404,7 @@ void default_machine_crash_shutdown(struct pt_regs *regs)
 			asm volatile("sync; isync");
 		}
 	}
+	crash_shutdown_cpu = -1;
 	__debugger_fault_handler = old_handler;
 
 	/*
-- 
1.7.4.4

