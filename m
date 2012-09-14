Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab2INNpu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 09:45:50 -0400
Received: from service87.mimecast.com ([91.220.42.44]:46224 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab2INNpr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 09:45:47 -0400
Message-ID: <50533500.2020606@arm.com>
Date: Fri, 14 Sep 2012 14:45:36 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>, "tim@xen.org" <tim@xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Dave Martin <dave.martin@linaro.org>
Subject: Re: [PATCH v4 02/24] xen/arm: hypercalls
References: <alpine.DEB.2.02.1209141145150.29232@kaball.uk.xensource.com> <1347621207-11294-2-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1347621207-11294-2-git-send-email-stefano.stabellini@eu.citrix.com>
X-Enigmail-Version: 1.5a1pre
X-OriginalArrivalTime: 14 Sep 2012 13:45:38.0123 (UTC) FILETIME=[392AF1B0:01CD927F]
X-MC-Unique: 112091414454404301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/09/12 12:13, Stefano Stabellini wrote:
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

You should consider using Dave Martin's opcode injection series for
that. The patches are already in Russell's for-next branch.

	M.
-- 
Jazz is not dead. It just smells funny...

