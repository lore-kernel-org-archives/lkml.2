Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227Ab2JVF5g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 01:57:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:39696 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755137Ab2JVF5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 01:57:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,628,1344236400"; 
   d="scan'208";a="230478558"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.n
Cc: eranian@google.com, ak@linux.intel.com,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH 6/6] perf, x86: Discard zero length call entries in LBR call stack
Date: Mon, 22 Oct 2012 13:57:16 +0800
Message-Id: <1350885436-5540-7-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1350885436-5540-1-git-send-email-zheng.z.yan@intel.com>
References: <1350885436-5540-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

Zero length calls may confuse the hardware and make the recorded
call stack incorrect. Try fixing the call stack by discarding
zero length call entries.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_lbr.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index c6efec1..9eee5d9 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -90,7 +90,8 @@ enum {
 	X86_BR_ABORT		= 1 << 12,/* transaction abort */
 	X86_BR_INTX		= 1 << 13,/* in transaction */
 	X86_BR_NOTX		= 1 << 14,/* not in transaction */
-	X86_BR_CALL_STACK	= 1 << 15,/* call stack */
+	X86_BR_ZERO_CALL	= 1 << 15,/* zero length call */
+	X86_BR_CALL_STACK	= 1 << 16,/* call stack */
 };
 
 #define X86_BR_PLM (X86_BR_USER | X86_BR_KERNEL)
@@ -107,13 +108,15 @@ enum {
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
@@ -636,6 +639,12 @@ static int branch_type(unsigned long from, unsigned long to, int abort)
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

