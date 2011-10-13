Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709Ab1JMR25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 13:28:57 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:13845 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756433Ab1JMR24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 13:28:56 -0400
Message-ID: <4E971FD3.2020308@cavium.com>
Date: Thu, 13 Oct 2011 10:28:51 -0700
From: David Daney <david.daney@cavium.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: manesoni@cisco.com
CC: ralf@linux-mips.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, ananth@in.ibm.com, kamensky@cisco.com
Subject: Re: [PATCH] MIPS Kprobes: Support branch instructions probing
References: <20111013090749.GB16761@cisco.com>
In-Reply-To: <20111013090749.GB16761@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Oct 2011 17:28:55.0701 (UTC) FILETIME=[95895C50:01CC89CD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2011 02:07 AM, Maneesh Soni wrote:
>
> From: Maneesh Soni<manesoni@cisco.com>
>
> This patch provides support for kprobes on branch instructions. The branch
> instruction at the probed address is actually emulated and not executed
> out-of-line like other normal instructions. Instead the delay-slot instruction
> is copied and single stepped out of line.
>
> At the time of probe hit, the original branch instruction is evaluated
> and the target cp0_epc is computed similar to compute_retrun_epc(). It
> is also checked if the delay slot instruction can be skipped, which is
> true if there is a NOP in delay slot or branch is taken in case of
> branch likely instructions. Once the delay slot instruction is single
> stepped the normal execution resume with the cp0_epc updated the earlier
> computed cp0_epc as per the branch instructions.
>

I haven't tested it but...


> Signed-off-by: Maneesh Soni<manesoni@cisco.com>
> ---
>   arch/mips/include/asm/kprobes.h |    7 +
>   arch/mips/kernel/kprobes.c      |  341 +++++++++++++++++++++++++++++++++++----
>   2 files changed, 320 insertions(+), 28 deletions(-)
>
[...]
> +static int evaluate_branch_instruction(struct kprobe *p, struct pt_regs *regs,
> +					struct kprobe_ctlblk *kcb)
>   {
> +	union mips_instruction insn = p->opcode;
> +	unsigned int dspcontrol;
> +	long epc;
> +
> +	epc = regs->cp0_epc;
> +	if (epc&  3)
> +		goto unaligned;
> +
> +	if (p->ainsn.insn->word == 0)
> +		kcb->flags |= SKIP_DELAYSLOT;
> +	else
> +		kcb->flags&= ~SKIP_DELAYSLOT;
> +
> +	switch (insn.i_format.opcode) {
> +	/*
> +	 * jr and jalr are in r_format format.
> +	 */
> +	case spec_op:
[...]
> +	case bgtzl_op:
> +		/* rt field assumed to be zero */
> +		if ((long)regs->regs[insn.i_format.rs]>  0) {
> +			epc = epc + 4 + (insn.i_format.simmediate<<  2);
> +			kcb->flags |= SKIP_DELAYSLOT;
> +		} else
> +			epc += 8;
> +		regs->cp0_epc = epc;
> +		break;



Where is the handling for:

	case cop1_op:

#ifdef CONFIG_CPU_CAVIUM_OCTEON
	case lwc2_op: /* This is bbit0 on Octeon */
	case ldc2_op: /* This is bbit032 on Octeon */
	case swc2_op: /* This is bbit1 on Octeon */
	case sdc2_op: /* This is bbit132 on Octeon */
#endif

These are all defined in insn_has_delayslot() but not here.

