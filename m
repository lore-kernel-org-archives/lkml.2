Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035Ab1KTIld (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 03:41:33 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48251 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab1KTIlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 03:41:32 -0500
Date: Sun, 20 Nov 2011 08:41:11 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stepan Moskovchenko <stepanm@codeaurora.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
        bryanh@codeaurora.org, David Brown <davidb@codeaurora.org>,
        Leif Lindholm <leif.lindholm@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: Add condition code check to SWP emulator
Message-ID: <20111120084111.GM9581@n2100.arm.linux.org.uk>
References: <CAHkRjk6Ynfh9+UbTuAtyiXCOF-yDbTNxi0ikF5ttwHViisZRZA@mail.gmail.com> <1321751070-7932-1-git-send-email-stepanm@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321751070-7932-1-git-send-email-stepanm@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 19, 2011 at 05:04:30PM -0800, Stepan Moskovchenko wrote:
> +static int check_condition(struct pt_regs *regs, unsigned int insn)
> +{
> +	unsigned int base_cond, neg, cond = 0;
> +	unsigned int cpsr_z, cpsr_c, cpsr_n, cpsr_v;
> +
> +	cpsr_n = (regs->ARM_cpsr & PSR_N_BIT) ? 1 : 0;
> +	cpsr_z = (regs->ARM_cpsr & PSR_Z_BIT) ? 1 : 0;
> +	cpsr_c = (regs->ARM_cpsr & PSR_C_BIT) ? 1 : 0;
> +	cpsr_v = (regs->ARM_cpsr & PSR_V_BIT) ? 1 : 0;
> +
> +	/* Upper 3 bits indicate condition, lower bit incicates negation */
> +	base_cond = insn >> 29;
> +	neg = insn & BIT(28) ? 1 : 0;
> +
> +	switch (base_cond) {
> +	case 0x0:	/* equal */
> +		cond = cpsr_z;
> +		break;
> +
> +	case 0x1:	/* carry set */
> +		cond = cpsr_c;
> +		break;
> +
> +	case 0x2:	/* minus / negative */
> +		cond = cpsr_n;
> +		break;
> +
> +	case 0x3:	/* overflow */
> +		cond = cpsr_v;
> +		break;
> +
> +	case 0x4:	/* unsigned higher */
> +		cond = (cpsr_c == 1) && (cpsr_z == 0);
> +		break;
> +
> +	case 0x5:	/* signed greater / equal */
> +		cond = (cpsr_n == cpsr_v);
> +		break;
> +
> +	case 0x6:	/* signed greater */
> +		cond = (cpsr_z == 0) && (cpsr_n == cpsr_v);
> +		break;
> +
> +	case 0x7:	/* always */
> +		cond = 1;
> +		break;
> +	};
> +
> +	return cond && !neg;

There's a much better algorithm to check this.  See the bottom of
arch/arm/nwfpe/fpopcode.c.

It would probably be best for there to be a common function for doing
this kind of check, rather than having several implementations of it
scattered around the kernel.
