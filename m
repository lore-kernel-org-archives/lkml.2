Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab1JNR2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 13:28:35 -0400
Received: from ams-iport-3.cisco.com ([144.254.224.146]:65070 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab1JNR2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 13:28:34 -0400
X-IronPort-AV: E=Sophos;i="4.69,347,1315180800"; 
   d="scan'208";a="1047933"
Date: Fri, 14 Oct 2011 22:58:31 +0530
From: Maneesh Soni <manesoni@cisco.com>
To: David Daney <david.daney@cavium.com>
Cc: ralf@linux-mips.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, ananth@in.ibm.com, kamensky@cisco.com
Subject: Re: [PATCH] MIPS Kprobes: Support branch instructions probing
Message-ID: <20111014172831.GA8521@cisco.com>
Reply-To: manesoni@cisco.com
References: <20111013090749.GB16761@cisco.com>
 <4E971FD3.2020308@cavium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E971FD3.2020308@cavium.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 10:28:51AM -0700, David Daney wrote:
> On 10/13/2011 02:07 AM, Maneesh Soni wrote:
> >
> >From: Maneesh Soni<manesoni@cisco.com>
> >
> >This patch provides support for kprobes on branch instructions. The branch
> >instruction at the probed address is actually emulated and not executed
> >out-of-line like other normal instructions. Instead the delay-slot instruction
> >is copied and single stepped out of line.
> >
> >At the time of probe hit, the original branch instruction is evaluated
> >and the target cp0_epc is computed similar to compute_retrun_epc(). It
> >is also checked if the delay slot instruction can be skipped, which is
> >true if there is a NOP in delay slot or branch is taken in case of
> >branch likely instructions. Once the delay slot instruction is single
> >stepped the normal execution resume with the cp0_epc updated the earlier
> >computed cp0_epc as per the branch instructions.
> >
> 
> I haven't tested it but...
> 
> 
> >Signed-off-by: Maneesh Soni<manesoni@cisco.com>
> >---
> >  arch/mips/include/asm/kprobes.h |    7 +
> >  arch/mips/kernel/kprobes.c      |  341 +++++++++++++++++++++++++++++++++++----
> >  2 files changed, 320 insertions(+), 28 deletions(-)
> >
> [...]
> >+static int evaluate_branch_instruction(struct kprobe *p, struct pt_regs *regs,
> >+					struct kprobe_ctlblk *kcb)
> >  {
> >+	union mips_instruction insn = p->opcode;
> >+	unsigned int dspcontrol;
> >+	long epc;
> >+
> >+	epc = regs->cp0_epc;
> >+	if (epc&  3)
> >+		goto unaligned;
> >+
> >+	if (p->ainsn.insn->word == 0)
> >+		kcb->flags |= SKIP_DELAYSLOT;
> >+	else
> >+		kcb->flags&= ~SKIP_DELAYSLOT;
> >+
> >+	switch (insn.i_format.opcode) {
> >+	/*
> >+	 * jr and jalr are in r_format format.
> >+	 */
> >+	case spec_op:
> [...]
> >+	case bgtzl_op:
> >+		/* rt field assumed to be zero */
> >+		if ((long)regs->regs[insn.i_format.rs]>  0) {
> >+			epc = epc + 4 + (insn.i_format.simmediate<<  2);
> >+			kcb->flags |= SKIP_DELAYSLOT;
> >+		} else
> >+			epc += 8;
> >+		regs->cp0_epc = epc;
> >+		break;
> 
> 
> 
> Where is the handling for:
> 
> 	case cop1_op:
> 
> #ifdef CONFIG_CPU_CAVIUM_OCTEON
> 	case lwc2_op: /* This is bbit0 on Octeon */
> 	case ldc2_op: /* This is bbit032 on Octeon */
> 	case swc2_op: /* This is bbit1 on Octeon */
> 	case sdc2_op: /* This is bbit132 on Octeon */
> #endif
> 
> These are all defined in insn_has_delayslot() but not here.

My bad.. will include them as well. Actually as Ralf suggested,
will keep this as common code.

Thanks
Maneesh
