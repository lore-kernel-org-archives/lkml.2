Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab2HOAVc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 20:21:32 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:53241 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab2HOAVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 20:21:30 -0400
Date: Tue, 14 Aug 2012 17:21:30 -0700
From: Olof Johansson <olof@lixom.net>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 12/31] arm64: Atomic operations
Message-ID: <20120815002130.GE19607@quad.lixom.net>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <1344966752-16102-13-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344966752-16102-13-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Aug 14, 2012 at 06:52:13PM +0100, Catalin Marinas wrote:
> This patch introduces the atomic, mutex and futex operations. Many
> atomic operations use the load-acquire and store-release operations
> which imply barriers, avoiding the need for explicit DMB.
> 
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
>  arch/arm64/include/asm/atomic.h |  306 +++++++++++++++++++++++++++++++++++++++
>  arch/arm64/include/asm/futex.h  |  134 +++++++++++++++++
>  2 files changed, 440 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm64/include/asm/atomic.h
>  create mode 100644 arch/arm64/include/asm/futex.h
> 
> diff --git a/arch/arm64/include/asm/atomic.h b/arch/arm64/include/asm/atomic.h
> new file mode 100644
> index 0000000..fa60c8b
> --- /dev/null
> +++ b/arch/arm64/include/asm/atomic.h
> @@ -0,0 +1,306 @@
> +/*
> + * Based on arch/arm/include/asm/atomic.h
> + *
> + * Copyright (C) 1996 Russell King.
> + * Copyright (C) 2002 Deep Blue Solutions Ltd.
> + * Copyright (C) 2012 ARM Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +#ifndef __ASM_ATOMIC_H
> +#define __ASM_ATOMIC_H
> +
> +#include <linux/compiler.h>
> +#include <linux/types.h>
> +
> +#include <asm/barrier.h>
> +#include <asm/cmpxchg.h>
> +
> +#define ATOMIC_INIT(i)	{ (i) }
> +
> +#ifdef __KERNEL__
> +
> +/*
> + * On ARM, ordinary assignment (str instruction) doesn't clear the local
> + * strex/ldrex monitor on some implementations. The reason we can use it for
> + * atomic_set() is the clrex or dummy strex done on every exception return.
> + */
> +#define atomic_read(v)	(*(volatile int *)&(v)->counter)
> +#define atomic_set(v,i)	(((v)->counter) = (i))
> +
> +/*
> + * AArch64 UP and SMP safe atomic ops.  We use load exclusive and
> + * store exclusive to ensure that these are atomic.  We may loop
> + * to ensure that the update happens.
> + */
> +static inline void atomic_add(int i, atomic_t *v)
> +{
> +	unsigned long tmp;
> +	int result;
> +
> +	asm volatile("// atomic_add\n"
> +"1:	ldxr	%w0, [%3]\n"
> +"	add	%w0, %w0, %w4\n"
> +"	stxr	%w1, %w0, [%3]\n"
> +"	cbnz	%w1,1b"

Nit: space before 1b

[...]

> diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
> new file mode 100644
> index 0000000..0745e82
> --- /dev/null
> +++ b/arch/arm64/include/asm/futex.h
> @@ -0,0 +1,134 @@
> +/*
> + * Copyright (C) 2012 ARM Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +#ifndef __ASM_FUTEX_H
> +#define __ASM_FUTEX_H
> +
> +#ifdef __KERNEL__
> +
> +#include <linux/futex.h>
> +#include <linux/uaccess.h>
> +#include <asm/errno.h>
> +
> +#define __futex_atomic_op(insn, ret, oldval, uaddr, tmp, oparg)		\
> +	asm volatile(							\
> +"1:	ldaxr	%w1, %2\n"						\
> +	insn "\n"							\
> +"2:	stlxr	%w3, %w0, %2\n"						\
> +"	cbnz	%w3, 1b\n"						\
> +"3:	.pushsection __ex_table,\"a\"\n"				\
> +"	.align	3\n"							\
> +"	.quad	1b, 4f, 2b, 4f\n"					\
> +"	.popsection\n"							\
> +"	.pushsection .fixup,\"ax\"\n"					\

Moving the exception table below the body of the code makes the flow easier to
read, please do that.

Also, don't you need a barrier here?

> +"4:	mov	%w0, %w5\n"						\
> +"	b	3b\n"							\
> +"	.popsection"							\
> +	: "=&r" (ret), "=&r" (oldval), "+Q" (*uaddr), "=&r" (tmp)	\
> +	: "r" (oparg), "Ir" (-EFAULT)					\
> +	: "cc")
> +
> +static inline int
> +futex_atomic_op_inuser (int encoded_op, u32 __user *uaddr)
> +{
> +	int op = (encoded_op >> 28) & 7;
> +	int cmp = (encoded_op >> 24) & 15;
> +	int oparg = (encoded_op << 8) >> 20;
> +	int cmparg = (encoded_op << 20) >> 20;
> +	int oldval = 0, ret, tmp;
> +
> +	if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
> +		oparg = 1 << oparg;
> +
> +	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
> +		return -EFAULT;
> +
> +	pagefault_disable();	/* implies preempt_disable() */
> +
> +	switch (op) {
> +	case FUTEX_OP_SET:
> +		__futex_atomic_op("mov	%w0, %w4",
> +				  ret, oldval, uaddr, tmp, oparg);
> +		break;
> +	case FUTEX_OP_ADD:
> +		__futex_atomic_op("add	%w0, %w1, %w4",
> +				  ret, oldval, uaddr, tmp, oparg);
> +		break;
> +	case FUTEX_OP_OR:
> +		__futex_atomic_op("orr	%w0, %w1, %w4",
> +				  ret, oldval, uaddr, tmp, oparg);
> +		break;
> +	case FUTEX_OP_ANDN:
> +		__futex_atomic_op("and	%w0, %w1, %w4",
> +				  ret, oldval, uaddr, tmp, ~oparg);
> +		break;
> +	case FUTEX_OP_XOR:
> +		__futex_atomic_op("eor	%w0, %w1, %w4",
> +				  ret, oldval, uaddr, tmp, oparg);
> +		break;
> +	default:
> +		ret = -ENOSYS;
> +	}
> +
> +	pagefault_enable();	/* subsumes preempt_enable() */
> +
> +	if (!ret) {
> +		switch (cmp) {
> +		case FUTEX_OP_CMP_EQ: ret = (oldval == cmparg); break;
> +		case FUTEX_OP_CMP_NE: ret = (oldval != cmparg); break;
> +		case FUTEX_OP_CMP_LT: ret = (oldval < cmparg); break;
> +		case FUTEX_OP_CMP_GE: ret = (oldval >= cmparg); break;
> +		case FUTEX_OP_CMP_LE: ret = (oldval <= cmparg); break;
> +		case FUTEX_OP_CMP_GT: ret = (oldval > cmparg); break;
> +		default: ret = -ENOSYS;
> +		}
> +	}
> +	return ret;
> +}
> +
> +static inline int
> +futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
> +			      u32 oldval, u32 newval)
> +{
> +	int ret = 0;
> +	u32 val, tmp;
> +
> +	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
> +		return -EFAULT;
> +
> +	asm volatile("// futex_atomic_cmpxchg_inatomic\n"
> +"1:	ldaxr	%w1, %2\n"
> +"	sub	%w3, %w1, %w4\n"
> +"	cbnz	%w3, 3f\n"
> +"2:	stlxr	%w3, %w5, %2\n"
> +"	cbnz	%w3, 1b\n"
> +"3:	.pushsection __ex_table,\"a\"\n"
> +"	.align	3\n"
> +"	.quad	1b, 4f, 2b, 4f\n"
> +"	.popsection\n"
> +"	.pushsection .fixup,\"ax\"\n"

Same here w.r.t. exception table location and barrier.

> +"4:	mov	%w0, %w6\n"
> +"	b	3b\n"
> +"	.popsection"
> +	: "+r" (ret), "=&r" (val), "+Q" (*uaddr), "=&r" (tmp)
> +	: "r" (oldval), "r" (newval), "Ir" (-EFAULT)
> +	: "cc", "memory");
> +
> +	*uval = val;
> +	return ret;
> +}
> +
> +#endif /* __KERNEL__ */
> +#endif /* __ASM_FUTEX_H */


-Olof
