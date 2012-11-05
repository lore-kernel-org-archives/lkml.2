Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971Ab2KEIPj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 03:15:39 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:44034 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab2KEIPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 03:15:38 -0500
Subject: [PATCH] Enable hardware breakpoint upon re-registering
To: linuxppc-dev@ozlabs.org, mikey@neuling.org, linux-kernel@vger.kernel.org,
        fweisbec@redhat.com, benh@kernel.crashing.org
From: Aravinda Prasad <aravinda@linux.vnet.ibm.com>
Date: Mon, 05 Nov 2012 13:45:28 +0530
Message-ID: <20121105081527.29141.11384.stgit@aravinda>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12110508-2876-0000-0000-000001BA53CC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On powerpc, ptrace will disable hardware breakpoint request once the
breakpoint is hit. It is the responsibility of the caller to set it
again. However, when the caller sets the hardware breakpoint again
using ptrace(PTRACE_SET_DEBUGREG, child_pid, 0, addr), the hardware
breakpoint is not enabled.

While gdb's approach is to unregister and re-register the hardware
breakpoint every time the breakpoint is hit - which is working fine,
this could affect other programs trying to re-register hardware
breakpoint without unregistering.

This patch enables hardware breakpoint if the caller is re-registering.

Signed-off-by: Aravinda Prasad <aravinda@linux.vnet.ibm.com>
---
 arch/powerpc/kernel/ptrace.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index 79d8e56..09371d0 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -952,6 +952,10 @@ int ptrace_set_debugreg(struct task_struct *task, unsigned long addr,
 		arch_bp_generic_fields(data &
 					(DABR_DATA_WRITE | DABR_DATA_READ),
 							&attr.bp_type);
+
+		/* Enable breakpoint */
+		attr.disabled = false;
+
 		ret =  modify_user_hw_breakpoint(bp, &attr);
 		if (ret) {
 			ptrace_put_breakpoints(task);

