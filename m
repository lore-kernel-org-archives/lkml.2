Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762Ab2INNIm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 09:08:42 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:42898 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab2INNIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 09:08:39 -0400
Date: Fri, 14 Sep 2012 08:57:29 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: arnd@arndb.de, linux@arm.linux.org.uk, catalin.marinas@arm.com,
        linaro-dev@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        tim@xen.org, Ian.Campbell@citrix.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 02/24] xen/arm: hypercalls
Message-ID: <20120914125729.GG25249@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1209141145150.29232@kaball.uk.xensource.com>
 <1347621207-11294-2-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347621207-11294-2-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 12:13:04PM +0100, Stefano Stabellini wrote:
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
> 
> Changes in v2:
> - define an HYPERCALL macro for 5 arguments hypercall wrappers, even if
> at the moment is unused;
> - use ldm instead of pop;
> - fix up comments.
> 
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

.. since this is all in non-x86 and non-Xen generic parts so cannot
provide you with an Ack :-)

> ---
>  arch/arm/include/asm/xen/hypercall.h |   50 ++++++++++++++++
>  arch/arm/xen/Makefile                |    2 +-
>  arch/arm/xen/hypercall.S             |  106 ++++++++++++++++++++++++++++++++++
>  3 files changed, 157 insertions(+), 1 deletions(-)
>  create mode 100644 arch/arm/include/asm/xen/hypercall.h
>  create mode 100644 arch/arm/xen/hypercall.S
> 
> diff --git a/arch/arm/include/asm/xen/hypercall.h b/arch/arm/include/asm/xen/hypercall.h
> new file mode 100644
> index 0000000..4ac0624
> --- /dev/null
> +++ b/arch/arm/include/asm/xen/hypercall.h
> @@ -0,0 +1,50 @@
> +/******************************************************************************
> + * hypercall.h
> + *
> + * Linux-specific hypervisor handling.
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
> +#ifndef _ASM_ARM_XEN_HYPERCALL_H
> +#define _ASM_ARM_XEN_HYPERCALL_H
> +
> +#include <xen/interface/xen.h>
> +
> +long privcmd_call(unsigned call, unsigned long a1,
> +		unsigned long a2, unsigned long a3,
> +		unsigned long a4, unsigned long a5);
> +int HYPERVISOR_xen_version(int cmd, void *arg);
> +int HYPERVISOR_console_io(int cmd, int count, char *str);
> +int HYPERVISOR_grant_table_op(unsigned int cmd, void *uop, unsigned int count);
> +int HYPERVISOR_sched_op(int cmd, void *arg);
> +int HYPERVISOR_event_channel_op(int cmd, void *arg);
> +unsigned long HYPERVISOR_hvm_op(int op, void *arg);
> +int HYPERVISOR_memory_op(unsigned int cmd, void *arg);
> +int HYPERVISOR_physdev_op(int cmd, void *arg);
> +
> +#endif /* _ASM_ARM_XEN_HYPERCALL_H */
> diff --git a/arch/arm/xen/Makefile b/arch/arm/xen/Makefile
> index 0bad594..b9d6acc 100644
> --- a/arch/arm/xen/Makefile
> +++ b/arch/arm/xen/Makefile
> @@ -1 +1 @@
> -obj-y		:= enlighten.o
> +obj-y		:= enlighten.o hypercall.o
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
> +ENDPROC(privcmd_call);
> -- 
> 1.7.2.5
