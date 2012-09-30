Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649Ab2I3TlR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 15:41:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518Ab2I3Tkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 15:40:40 -0400
Date: Sun, 30 Sep 2012 21:41:58 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] uprobes/x86: Only rep+nop can be emulated correctly
Message-ID: <20120930194158.GA11316@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120930194119.GA11278@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__skip_sstep() correctly detects the "nontrivial" nop insns,
but since it doesn't update regs->ip we can not really skip
"0x0f 0x1f | 0x0f 0x19 | 0x87 0xc0", the probed application
is killed by SIGILL'ed handle_swbp().

Remove these additional checks. If we want to implement this
correctly we need to know the full insn length to update ->ip.

rep* + nop is fine even without updating ->ip.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/uprobes.c |   16 ++--------------
 1 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 9538f00..aafa555 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -651,31 +651,19 @@ void arch_uprobe_abort_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 
 /*
  * Skip these instructions as per the currently known x86 ISA.
- * 0x66* { 0x90 | 0x0f 0x1f | 0x0f 0x19 | 0x87 0xc0 }
+ * rep=0x66*; nop=0x90
  */
 static bool __skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
 	int i;
 
 	for (i = 0; i < MAX_UINSN_BYTES; i++) {
-		if ((auprobe->insn[i] == 0x66))
+		if (auprobe->insn[i] == 0x66)
 			continue;
 
 		if (auprobe->insn[i] == 0x90)
 			return true;
 
-		if (i == (MAX_UINSN_BYTES - 1))
-			break;
-
-		if ((auprobe->insn[i] == 0x0f) && (auprobe->insn[i+1] == 0x1f))
-			return true;
-
-		if ((auprobe->insn[i] == 0x0f) && (auprobe->insn[i+1] == 0x19))
-			return true;
-
-		if ((auprobe->insn[i] == 0x87) && (auprobe->insn[i+1] == 0xc0))
-			return true;
-
 		break;
 	}
 	return false;
-- 
1.5.5.1

