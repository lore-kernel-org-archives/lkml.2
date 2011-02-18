Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab1BREtY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 23:49:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58900 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752379Ab1BREtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 23:49:22 -0500
Message-ID: <4D5DFA41.9060207@zytor.com>
Date: Thu, 17 Feb 2011 20:49:05 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, tony.luck@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86-64: use relative 32-bit pointers in exception
  tables
References: <4D5D62EE02000078000327E7@vpn.id2.novell.com>
In-Reply-To: <4D5D62EE02000078000327E7@vpn.id2.novell.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2011 09:03 AM, Jan Beulich wrote:
> Convert exception table pointers from absolute 64-bit to relative 32-
> bit ones, thus shrinking the table size by half. Rather than providing
> an x86-64-specific extable implementation, generalize the common one
> to deal with different ways of storing the pointers, which will allow
> ia64's custom implementation to be dropped subsequently.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Tony Luck <tony.luck@intel.com>
> --- /dev/null
> +++ 2.6.38-rc5-extable/include/asm-generic/extable.h
> @@ -0,0 +1,49 @@
> +#ifndef __ASM_GENERIC_EXTABLE_H
> +#define __ASM_GENERIC_EXTABLE_H
> +
> +/*
> + * The exception table consists of pairs of addresses: the first is the
> + * address of an instruction that is allowed to fault, and the second is
> + * the address at which the program should continue.  No registers are
> + * modified, so it is entirely up to the continuation code to figure out
> + * what to do.
> + *
> + * All the routines below use bits of fixup code that are out of line
> + * with the main instruction path.  This means when everything is well,
> + * we don't even have to jump over them.  Further, they do not intrude
> + * on our cache or tlb entries.
> + */
> +
> +struct exception_table_entry
> +{
> +#ifdef CONFIG_EXTABLE_RELATIVE_POINTERS
> +	s32 insn_off, fixup_off;
> +#else
> +	unsigned long insn, fixup;
> +#endif
> +};
> +

This breaks arch/x86/kernel/test_nx.c:

/home/hpa/kernel/linux-2.6-tip.asm/arch/x86/kernel/test_nx.c: In
function ‘fudze_exception_table’:
/home/hpa/kernel/linux-2.6-tip.asm/arch/x86/kernel/test_nx.c:62: error:
‘struct exception_table_entry’ has no member named ‘insn’
make[4]: *** [arch/x86/kernel/test_nx.o] Error 1
make[3]: *** [arch/x86/kernel] Error 2
make[2]: *** [arch/x86] Error 2
make[2]: *** Waiting for unfinished jobs....
