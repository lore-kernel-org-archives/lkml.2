Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab2KFGjH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 01:39:07 -0500
Received: from mga03.intel.com ([143.182.124.21]:48593 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277Ab2KFGiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 01:38:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,721,1344236400"; 
   d="scan'208";a="164945429"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl
Cc: eranian@google.com, ak@linux.intel.com,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH V3 7/7] perf, x86: Discard zero length call entries in LBR call stack
Date: Tue,  6 Nov 2012 14:38:18 +0800
Message-Id: <1352183898-5601-8-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352183898-5601-1-git-send-email-zheng.z.yan@intel.com>
References: <1352183898-5601-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

Zero length call is also referred to as zero displacement call.
It is usually used in 32-bit code to get address of next
instruction. The assembly code looks like:

  call    next_ip
  next_ip:
  popl    %ebx

Zero length calls may confuse the hardware and make the recorded
call stack incorrect. Try fixing the call stack by discarding
zero length call entries.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_lbr.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 910200b..0546689 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -86,7 +86,8 @@ enum {
 	X86_BR_ABORT		= 1 << 12,/* transaction abort */
 	X86_BR_INTX		= 1 << 13,/* in transaction */
 	X86_BR_NOTX		= 1 << 14,/* not in transaction */
-	X86_BR_CALL_STACK	= 1 << 15,/* call stack */
+	X86_BR_ZERO_CALL	= 1 << 15,/* zero length call */
+	X86_BR_CALL_STACK	= 1 << 16,/* call stack */
 };
 
 #define X86_BR_PLM (X86_BR_USER | X86_BR_KERNEL)
@@ -103,13 +104,15 @@ enum {
 	 X86_BR_JMP	 |\
 	 X86_BR_IRQ	 |\
 	 X86_BR_ABORT	 |\
-	 X86_BR_IND_CALL)
+	 X86_BR_IND_CALL |\
+	 X86_BR_ZERO_CALL)
 
 #define X86_BR_ALL (X86_BR_PLM | X86_BR_ANY)
 
 #define X86_BR_ANY_CALL		 \
 	(X86_BR_CALL		|\
 	 X86_BR_IND_CALL	|\
+	 X86_BR_ZERO_CALL	|\
 	 X86_BR_SYSCALL		|\
 	 X86_BR_IRQ		|\
 	 X86_BR_INT)
@@ -625,6 +628,12 @@ static int branch_type(unsigned long from, unsigned long to, int abort)
 		ret = X86_BR_INT;
 		break;
 	case 0xe8: /* call near rel */
+		insn_get_immediate(&insn);
+		if (insn.immediate1.value == 0) {
+			/* zero length call */
+			ret = X86_BR_ZERO_CALL;
+			break;
+		}
 	case 0x9a: /* call far absolute */
 		ret = X86_BR_CALL;
 		break;
-- 
1.7.11.7

