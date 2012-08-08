Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090Ab2HHMlS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 08:41:18 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61926 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757995Ab2HHMlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 08:41:17 -0400
Date: Wed, 8 Aug 2012 13:41:11 +0100
From: Dave Martin <dave.martin@linaro.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        linaro-dev@lists.linaro.org, Ian.Campbell@citrix.com, arnd@arndb.de,
        konrad.wilk@oracle.com, catalin.marinas@arm.com, tim@xen.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 02/23] xen/arm: hypercalls
Message-ID: <20120808124111.GB2134@linaro.org>
References: <alpine.DEB.2.02.1208061428060.4645@kaball.uk.xensource.com>
 <1344263246-28036-2-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344263246-28036-2-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 03:27:05PM +0100, Stefano Stabellini wrote:
> Use r12 to pass the hypercall number to the hypervisor.
> 
> We need a register to pass the hypercall number because we might not
> know it at compile time and HVC only takes an immediate argument.
> 
> Among the available registers r12 seems to be the best choice because it
> is defined as "intra-procedure call scratch register".
> 
> Use the ISS to pass an hypervisor specific tag.
> 
> Changes in v2:
> - define an HYPERCALL macro for 5 arguments hypercall wrappers, even if
> at the moment is unused;
> - use ldm instead of pop;
> - fix up comments.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/arm/include/asm/xen/hypercall.h |   50 ++++++++++++++++
>  arch/arm/xen/Makefile                |    2 +-
>  arch/arm/xen/hypercall.S             |  106 ++++++++++++++++++++++++++++++++++
>  3 files changed, 157 insertions(+), 1 deletions(-)
>  create mode 100644 arch/arm/include/asm/xen/hypercall.h
>  create mode 100644 arch/arm/xen/hypercall.S

[...]

> diff --git a/arch/arm/xen/hypercall.S b/arch/arm/xen/hypercall.S
> new file mode 100644
> index 0000000..074f5ed
> --- /dev/null
> +++ b/arch/arm/xen/hypercall.S
> @@ -0,0 +1,106 @@
> +/******************************************************************************
> + * hypercall.S
> + *
> + * Xen hypercall wrappers
> + *
> + * Stefano Stabellini <stefano.stabellini@eu.citrix.com>, Citrix, 2012
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License version 2
> + * as published by the Free Software Foundation; or, when distributed
> + * separately from the Linux kernel or incorporated into other
> + * software packages, subject to the following license:
> + *
> + * Permission is hereby granted, free of charge, to any person obtaining a copy
> + * of this source file (the "Software"), to deal in the Software without
> + * restriction, including without limitation the rights to use, copy, modify,
> + * merge, publish, distribute, sublicense, and/or sell copies of the Software,
> + * and to permit persons to whom the Software is furnished to do so, subject to
> + * the following conditions:
> + *
> + * The above copyright notice and this permission notice shall be included in
> + * all copies or substantial portions of the Software.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> + * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> + * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
> + * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
> + * IN THE SOFTWARE.
> + */
> +
> +/*
> + * The Xen hypercall calling convention is very similar to the ARM
> + * procedure calling convention: the first paramter is passed in r0, the
> + * second in r1, the third in r2 and the fourth in r3. Considering that
> + * Xen hypercalls have 5 arguments at most, the fifth paramter is passed
> + * in r4, differently from the procedure calling convention of using the
> + * stack for that case.
> + *
> + * The hypercall number is passed in r12.
> + *
> + * The return value is in r0.
> + *
> + * The hvc ISS is required to be 0xEA1, that is the Xen specific ARM
> + * hypercall tag.
> + */
> +
> +#include <linux/linkage.h>
> +#include <asm/assembler.h>
> +#include <xen/interface/xen.h>
> +
> +
> +/* HVC 0xEA1 */
> +#ifdef CONFIG_THUMB2_KERNEL
> +#define xen_hvc .word 0xf7e08ea1
> +#else
> +#define xen_hvc .word 0xe140ea71
> +#endif

Consider using my opcode injection helpers patch for this (see
separate repost: [PATCH v2 REPOST 0/4] ARM: opcodes: Facilitate custom
opcode injection), assuming that nobody objects to it.  This should mean
that the right opcodes get generated when building a kernel for a big-
endian target for example.

I believe the __HVC(imm) macro which I put in <asm/opcodes-virt.h> as an
example should do what you need in this case.

> +
> +#define HYPERCALL_SIMPLE(hypercall)		\
> +ENTRY(HYPERVISOR_##hypercall)			\
> +	mov r12, #__HYPERVISOR_##hypercall;	\
> +	xen_hvc;							\
> +	mov pc, lr;							\
> +ENDPROC(HYPERVISOR_##hypercall)
> +
> +#define HYPERCALL0 HYPERCALL_SIMPLE
> +#define HYPERCALL1 HYPERCALL_SIMPLE
> +#define HYPERCALL2 HYPERCALL_SIMPLE
> +#define HYPERCALL3 HYPERCALL_SIMPLE
> +#define HYPERCALL4 HYPERCALL_SIMPLE
> +
> +#define HYPERCALL5(hypercall)			\
> +ENTRY(HYPERVISOR_##hypercall)			\
> +	stmdb sp!, {r4}						\
> +	ldr r4, [sp, #4]					\
> +	mov r12, #__HYPERVISOR_##hypercall;	\
> +	xen_hvc								\
> +	ldm sp!, {r4}						\
> +	mov pc, lr							\
> +ENDPROC(HYPERVISOR_##hypercall)
> +
> +                .text
> +
> +HYPERCALL2(xen_version);
> +HYPERCALL3(console_io);
> +HYPERCALL3(grant_table_op);
> +HYPERCALL2(sched_op);
> +HYPERCALL2(event_channel_op);
> +HYPERCALL2(hvm_op);
> +HYPERCALL2(memory_op);
> +HYPERCALL2(physdev_op);
> +
> +ENTRY(privcmd_call)
> +	stmdb sp!, {r4}
> +	mov r12, r0
> +	mov r0, r1
> +	mov r1, r2
> +	mov r2, r3
> +	ldr r3, [sp, #8]
> +	ldr r4, [sp, #4]
> +	xen_hvc
> +	ldm sp!, {r4}
> +	mov pc, lr

Note that the preferred entry/exit sequences in such cases are:

	stmfd	sp!, {r4,lr}
	...
	ldmfd	sp!, {r4,pc}

...but it works either way.  I would bother to change it unless you
have other changes to make too.


Cheers
---Dave

