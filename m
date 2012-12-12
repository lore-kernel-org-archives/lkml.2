Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab2LLXms (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 18:42:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462Ab2LLXmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 18:42:47 -0500
Date: Thu, 13 Dec 2012 00:43:07 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] arch/tile: provide PT_FLAGS_COMPAT value in pt_regs
Message-ID: <20121212234307.GA7694@redhat.com>
References: <201212122227.qBCMRiNg000851@farm-0002.internal.tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201212122227.qBCMRiNg000851@farm-0002.internal.tilera.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

it is too late for me to even try to read this patch, but...

On 12/12, Chris Metcalf wrote:
>
> This flag is set for ptrace GETREGS or PEEKUSER for processes
> that are COMPAT, i.e. 32-bit.
           ^^^^^^^^^^^^^^^^^^^

at least on x86 this is not the same. TS_COMPAT can also be set if a 64-bit
task calls the 32-bit syscall.

> --- a/arch/tile/include/uapi/asm/ptrace.h
> +++ b/arch/tile/include/uapi/asm/ptrace.h
> @@ -84,5 +84,11 @@ struct pt_regs {
>  #define PTRACE_O_TRACEMIGRATE	0x00010000
>  #define PTRACE_EVENT_MIGRATE	16
>
> +/*
> + * Flag bits in pt_regs.flags that are part of the ptrace API.
> + * We start our numbering higher up to avoid confusion with the
> + * non-ABI kernel-internal values that use the low 16 bits.
> + */
> +#define PT_FLAGS_COMPAT		0x10000  /* process is an -m32 compat process */

Can't understand how this connects to ptrace (I mean task->ptrace).

OK, let it live in asm/ptrace.h, but it seems that it is similar to
(say) PT_FLAGS_RESTORE_REGS and thus it should be 8?

And. arch/tile/kernel/ptrace.c:arch_ptrace() does

	case PTRACE_SETOPTIONS:
		/* Support TILE-specific ptrace options. */
		child->ptrace &= ~PT_TRACE_MASK_TILE;
		tmp = data & PTRACE_O_MASK_TILE;
		data &= ~PTRACE_O_MASK_TILE;

AFAICS we need something like BUILD_BUG_ON(PTRACE_O_MASK_TILE & PTRACE_O_MASK),
and

		ret = ptrace_request(child, request, addr, data);
		if (tmp & PTRACE_O_TRACEMIGRATE)
			child->ptrace |= PT_TRACE_MIGRATE;

this also needs "ret == 0" check, and "&= ~PT_TRACE_MASK_TILE" abobe should
be moved here, no?

OTOH using /bin/grep I can't see where do we check ">ptrace & PT_TRACE_MIGRATE".


In short: confused ;)

Oleg.

