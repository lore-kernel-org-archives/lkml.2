Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758192Ab2EIOFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:05:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33780 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693Ab2EIOFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:05:43 -0400
Date: Wed, 9 May 2012 16:05:39 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hui Zhu <teawater@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Geoff Levand <geoff@infradead.org>, jason.wessel@windriver.com
Subject: Re: [PATCH]KGTP (Linux Kernel debugger and tracer) lite patch for review
Message-ID: <20120509140538.GZ27374@one.firstfloor.org>
References: <4FAA1953.60102@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FAA1953.60102@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please provide better explanation of the use case for this module.
One paragraph why someone would want it in their kernel.

> +++ b/arch/arm/include/asm/gtp.h
> @@ -0,0 +1,34 @@
> +#ifndef _ASM_ARM_GTP_H_
> +#define _ASM_ARM_GTP_H_
> +
> +#define ULONGEST		uint64_t

So u64 in kernel. Just use that.

> +#define CORE_ADDR		unsigned long

In linux kernel CORE_ADDR is always unsigned long. Use that.

> +
> +#define GTP_REG_ASCII_SIZE	336
> +
> +static inline void
> +gtp_regs2ascii(struct pt_regs *regs, char *buf)
> +{
> +#ifdef __LITTLE_ENDIAN
> +#define SWAB(a)		swab32(a)
> +#else
> +#define SWAB(a)		(a)
> +#endif

That's just ntohl()? Just use that

Linux already has macros for this: 
> +	int	i;
> +
> +	for (i = 0; i < 16; i++) {
> +		sprintf(buf, "%08lx", (unsigned long) SWAB(regs->uregs[i]));

Is the gdb protocol really big endian in ASCII?

Also could you share code on this with the in kernel gdbstub?

> +#include <linux/slab.h>
> +#include <asm/gtp.h>
> +
> +#define GTP_DEBUG		KERN_WARNING

You should use the pr_* macros now

> +static int			gtp_disconnected_tracing;
> +static int			gtp_circular;
> +
> +static DEFINE_SPINLOCK(gtp_frame_lock);

Every spinlock needs a comment that describes what it protects.
I believe checkpatch warns about that. Did you run it?

> +
> +	tmp = gtp_frame_alloc(GTP_FRAME_REG_SIZE);
> +	if (!tmp)
> +		return NULL;
> +
> +	*next = tmp;
> +	tmp[0] = 'r';
> +	freg = (struct gtp_frame_reg *) (tmp + 1);
> +	memcpy(&freg->regs, regs, sizeof(struct pt_regs));
> +#if !defined CONFIG_X86_32 && !defined CONFIG_X86_64
> +	freg->regs.sp = (unsigned long)&regs->sp;
> +#endif	/* CONFIG_X86_32 CONFIG_X86_64 */

That looks weird. What does that do?

> +gtp_action_alloc(char type)
> +{
> +	struct action	*ret;
> +
> +	ret = kmalloc(sizeof(struct action), GFP_KERNEL);

kzalloc

Same problem in others.

> +static int
> +hex2int(char hex, int *i)

I'm sure we have code for this. strtoul et.al.?

Didn't read further so far.


-Andi
