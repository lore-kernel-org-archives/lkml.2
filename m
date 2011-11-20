Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab1KTBF1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 20:05:27 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4026 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab1KTBF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 20:05:26 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6535"; a="136948449"
From: Stepan Moskovchenko <stepanm@codeaurora.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Leif Lindholm <leif.lindholm@arm.com>, bryanh@codeaurora.org,
        David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH] arm: Add condition code check to SWP emulator
Date: Sat, 19 Nov 2011 17:04:30 -0800
Message-Id: <1321751070-7932-1-git-send-email-stepanm@codeaurora.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <CAHkRjk6Ynfh9+UbTuAtyiXCOF-yDbTNxi0ikF5ttwHViisZRZA@mail.gmail.com>
References: <CAHkRjk6Ynfh9+UbTuAtyiXCOF-yDbTNxi0ikF5ttwHViisZRZA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When emulating a SWP/SWPB instruction, check the condition
code of the instruction and compare it against CPSR status
bits rather than relying on the architecture to only raise
an undefined instruction exception if the condition checks
are passing.

Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
---
Hello

I already had a version prepared, so here it is.

Steve

 arch/arm/kernel/swp_emulate.c |   57 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 57 insertions(+), 0 deletions(-)

diff --git a/arch/arm/kernel/swp_emulate.c b/arch/arm/kernel/swp_emulate.c
index 40ee7e5..7669848 100644
--- a/arch/arm/kernel/swp_emulate.c
+++ b/arch/arm/kernel/swp_emulate.c
@@ -173,6 +173,57 @@ static int emulate_swpX(unsigned int address, unsigned int *data,
 	return res;
 }
 
+static int check_condition(struct pt_regs *regs, unsigned int insn)
+{
+	unsigned int base_cond, neg, cond = 0;
+	unsigned int cpsr_z, cpsr_c, cpsr_n, cpsr_v;
+
+	cpsr_n = (regs->ARM_cpsr & PSR_N_BIT) ? 1 : 0;
+	cpsr_z = (regs->ARM_cpsr & PSR_Z_BIT) ? 1 : 0;
+	cpsr_c = (regs->ARM_cpsr & PSR_C_BIT) ? 1 : 0;
+	cpsr_v = (regs->ARM_cpsr & PSR_V_BIT) ? 1 : 0;
+
+	/* Upper 3 bits indicate condition, lower bit incicates negation */
+	base_cond = insn >> 29;
+	neg = insn & BIT(28) ? 1 : 0;
+
+	switch (base_cond) {
+	case 0x0:	/* equal */
+		cond = cpsr_z;
+		break;
+
+	case 0x1:	/* carry set */
+		cond = cpsr_c;
+		break;
+
+	case 0x2:	/* minus / negative */
+		cond = cpsr_n;
+		break;
+
+	case 0x3:	/* overflow */
+		cond = cpsr_v;
+		break;
+
+	case 0x4:	/* unsigned higher */
+		cond = (cpsr_c == 1) && (cpsr_z == 0);
+		break;
+
+	case 0x5:	/* signed greater / equal */
+		cond = (cpsr_n == cpsr_v);
+		break;
+
+	case 0x6:	/* signed greater */
+		cond = (cpsr_z == 0) && (cpsr_n == cpsr_v);
+		break;
+
+	case 0x7:	/* always */
+		cond = 1;
+		break;
+	};
+
+	return cond && !neg;
+}
+
 /*
  * swp_handler logs the id of calling process, dissects the instruction, sanity
  * checks the memory location, calls emulate_swpX for the actual operation and
@@ -191,6 +242,12 @@ static int swp_handler(struct pt_regs *regs, unsigned int instr)
 		previous_pid = current->pid;
 	}
 
+	/* Ignore the instruction if it fails its condition code check */
+	if (!check_condition(regs, instr)) {
+		regs->ARM_pc += 4;
+		return 0;
+	}
+
 	address = regs->uregs[EXTRACT_REG_NUM(instr, RN_OFFSET)];
 	data	= regs->uregs[EXTRACT_REG_NUM(instr, RT2_OFFSET)];
 	destreg = EXTRACT_REG_NUM(instr, RT_OFFSET);
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

