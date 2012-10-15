Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab2JORb5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 13:31:57 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59843 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812Ab2JORb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 13:31:56 -0400
Date: Mon, 15 Oct 2012 18:31:47 +0100
From: Dave Martin <dave.martin@linaro.org>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, oleg@redhat.com
Subject: Re: [PATCH 9/9] ARM: add uprobes support
Message-ID: <20121015173147.GA18614@linaro.org>
References: <1350242593-17761-1-git-send-email-rabin@rab.in>
 <1350242593-17761-9-git-send-email-rabin@rab.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350242593-17761-9-git-send-email-rabin@rab.in>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 14, 2012 at 09:23:13PM +0200, Rabin Vincent wrote:
> Add basic uprobes support for ARM.
> 
> perf probe --exec and SystemTap's userspace probing work.  The ARM
> kprobes test code has also been run in a userspace harness to test the
> uprobe instruction decoding.
> 
> Caveats:
> 
>  - Thumb is not supported
>  - XOL abort/trap handling is not implemented

[...]

> diff --git a/arch/arm/kernel/uprobes.c b/arch/arm/kernel/uprobes.c
> new file mode 100644
> index 0000000..f25a4af
> --- /dev/null
> +++ b/arch/arm/kernel/uprobes.c

[...]

> +bool is_swbp_insn(uprobe_opcode_t *insn)
> +{
> +	return (__mem_to_opcode_arm(*insn) & 0x0fffffff) == UPROBE_SWBP_INSN;

You should take care not to match any instruction whose top bits are
0xF0000000.  That could be some completely different instruction.

[...]

> +static int uprobe_trap_handler(struct pt_regs *regs, unsigned int instr)
> +{
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
> +	if ((instr & 0x0fffffff) == UPROBE_SWBP_INSN)

Is the check unnecessary here?  I think the same comparison will
happen as a result of evaluating the associated undef_hook.

However, as above you must still check for and reject cases where
(instr & 0xF0000000) == 0xF0000000.

[...]

> +static struct undef_hook uprobes_arm_break_hook = {
> +	.instr_mask	= 0x0fffffff,
> +	.instr_val	= UPROBE_SWBP_INSN,
> +	.cpsr_mask	= MODE_MASK,
> +	.cpsr_val	= USR_MODE,
> +	.fn		= uprobe_trap_handler,
> +};
> +
> +static struct undef_hook uprobes_arm_ss_hook = {
> +	.instr_mask	= 0x0fffffff,
> +	.instr_val	= UPROBE_SS_INSN,
> +	.cpsr_mask	= MODE_MASK,
> +	.cpsr_val	= USR_MODE,
> +	.fn		= uprobe_trap_handler,
> +};
