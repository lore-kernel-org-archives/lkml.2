Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108Ab2GXQki (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 12:40:38 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57757 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753280Ab2GXQkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 12:40:36 -0400
Date: Tue, 24 Jul 2012 17:40:16 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Christopher Covington <cov@codeaurora.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <Will.Deacon@arm.com>
Subject: Re: [07/36] AArch64: Assembly macros and definitions
Message-ID: <20120724164016.GC29519@arm.com>
References: <1341608777-12982-8-git-send-email-catalin.marinas@arm.com>
 <5009698C.2020707@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5009698C.2020707@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 03:22:04PM +0100, Christopher Covington wrote:
> On 01/-10/-28163 02:59 PM, Catalin Marinas wrote:
> > This patch introduces several assembly macros and definitions used in
> > the .S files across arch/aarch64/ like IRQ disabling/enabling, together
> > with asm-offsets.c.
> 
> [...]
> 
> > diff --git a/arch/aarch64/include/asm/assembler.h b/arch/aarch64/include/asm/assembler.h
> > new file mode 100644
> > index 0000000..c6ac3cf
> > --- /dev/null
> > +++ b/arch/aarch64/include/asm/assembler.h
> 
> [...]
> 
> > +#define USER(x...)				\
> > +9999:	x;					\
> > +	.section __ex_table,"a";		\
> > +	.align	3;				\
> > +	.quad	9999b,9001f;			\
> > +	.previous
> 
> It appears that this macro depends on a 9001 label being defined in the
> source file somewhere after the macro is used. It might be preferable to
> incorporate the label into the macro if possible, or pass the label as
> an argument to the macro.

Good point, I changed to USER(l, x...).

> > +/*
> > + * User access macros.
> > + */
> > +	.macro	usracc, instr, reg, reg2, ptr, inc, rept, abort
> > +	.rept	\rept
> > +9999:
> > +	.if	\inc == 1
> > +	\instr\()b \reg, [\ptr], #\inc
> > +	.elseif	\inc == 4
> > +	\instr\() \reg, [\ptr], #\inc
> > +	.elseif	\inc == 8
> > +	\instr\() \reg, [\ptr], #\inc
> > +	.elseif \inc == 16
> > +	\instr\() \reg, \reg2, [\ptr], #\inc
> > +	.else
> > +	.error	"Unsupported inc macro argument"
> > +	.endif
> > +
> > +	.section __ex_table,"a"
> > +	.align	3
> > +	.quad	9999b, \abort
> > +	.previous
> 
> Could you use the USER preprocessor macro here to reduce this small
> duplication of directives?
> 
> > +	.endr
> > +	.endm
> > +
> > +	.macro	ldrusr, reg, ptr, inc, rept=1, abort=9001f
> > +	 usracc	ldr, \reg, \reg, \ptr, \inc, \rept, \abort
> > +	.endm
> > +
> > +	.macro	ldrpusr, reg, reg2, ptr, rept=1, abort=9001f
> > +	 usracc	ldp, \reg, \reg2, \ptr, 16, \rept, \abort
> > +	.endm
> 
> How about "ldpusr" to more directly match the assembly?
> 
> (Also, the 9001 label strikes again.)

For now I removed these entirely. I have additional patches for
optimised library functions that make use of these but I don't plan to
push any of them until I can benchmark on real hardware.

Thanks.

-- 
Catalin
