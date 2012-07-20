Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab2GTOWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 10:22:20 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48229 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab2GTOWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 10:22:09 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6777"; a="210405113"
Message-ID: <5009698C.2020707@codeaurora.org>
Date: Fri, 20 Jul 2012 10:22:04 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [07/36] AArch64: Assembly macros and definitions
References: <1341608777-12982-8-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1341608777-12982-8-git-send-email-catalin.marinas@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

On 01/-10/-28163 02:59 PM, Catalin Marinas wrote:
> This patch introduces several assembly macros and definitions used in
> the .S files across arch/aarch64/ like IRQ disabling/enabling, together
> with asm-offsets.c.

[...]

> diff --git a/arch/aarch64/include/asm/assembler.h b/arch/aarch64/include/asm/assembler.h
> new file mode 100644
> index 0000000..c6ac3cf
> --- /dev/null
> +++ b/arch/aarch64/include/asm/assembler.h

[...]

> +#define USER(x...)				\
> +9999:	x;					\
> +	.section __ex_table,"a";		\
> +	.align	3;				\
> +	.quad	9999b,9001f;			\
> +	.previous

It appears that this macro depends on a 9001 label being defined in the
source file somewhere after the macro is used. It might be preferable to
incorporate the label into the macro if possible, or pass the label as
an argument to the macro.

> +
> +/*
> + * User access macros.
> + */
> +	.macro	usracc, instr, reg, reg2, ptr, inc, rept, abort
> +	.rept	\rept
> +9999:
> +	.if	\inc == 1
> +	\instr\()b \reg, [\ptr], #\inc
> +	.elseif	\inc == 4
> +	\instr\() \reg, [\ptr], #\inc
> +	.elseif	\inc == 8
> +	\instr\() \reg, [\ptr], #\inc
> +	.elseif \inc == 16
> +	\instr\() \reg, \reg2, [\ptr], #\inc
> +	.else
> +	.error	"Unsupported inc macro argument"
> +	.endif
> +
> +	.section __ex_table,"a"
> +	.align	3
> +	.quad	9999b, \abort
> +	.previous

Could you use the USER preprocessor macro here to reduce this small
duplication of directives?

> +	.endr
> +	.endm
> +
> +	.macro	ldrusr, reg, ptr, inc, rept=1, abort=9001f
> +	 usracc	ldr, \reg, \reg, \ptr, \inc, \rept, \abort
> +	.endm
> +
> +	.macro	ldrpusr, reg, reg2, ptr, rept=1, abort=9001f
> +	 usracc	ldp, \reg, \reg2, \ptr, 16, \rept, \abort
> +	.endm

How about "ldpusr" to more directly match the assembly?

(Also, the 9001 label strikes again.)

> +
> +/*
> + * Register aliases.
> + */
> +lr	.req	x30		// link register

Regards,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
