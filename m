Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641Ab1DYUlK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:41:10 -0400
Received: from 1wt.eu ([62.212.114.60]:34324 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932320Ab1DYUY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:56 -0400
Message-Id: <20110425200236.122428633@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:03:44 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kamalesh babulal <kamalesh@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 072/173] powerpc/kdump: CPUs assume the context of the oopsing CPU
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Anton Blanchard <anton@samba.org>

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
Cc: Kamalesh babulal <kamalesh@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/kernel/crash.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/powerpc/kernel/crash.c
+++ b/arch/powerpc/kernel/crash.c
@@ -347,10 +347,12 @@ int crash_shutdown_unregister(crash_shut
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
 
@@ -388,6 +390,7 @@ void default_machine_crash_shutdown(stru
 	 */
 	old_handler = __debugger_fault_handler;
 	__debugger_fault_handler = handle_fault;
+	crash_shutdown_cpu = smp_processor_id();
 	for (i = 0; crash_shutdown_handles[i]; i++) {
 		if (setjmp(crash_shutdown_buf) == 0) {
 			/*
@@ -401,6 +404,7 @@ void default_machine_crash_shutdown(stru
 			asm volatile("sync; isync");
 		}
 	}
+	crash_shutdown_cpu = -1;
 	__debugger_fault_handler = old_handler;
 
 	/*


