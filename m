Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab1BRJeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 04:34:19 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:39486 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161Ab1BRJeJ (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:4:1>);
	Fri, 18 Feb 2011 04:34:09 -0500
Message-Id: <4D5E4B520200007800032A5F@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 18 Feb 2011 09:34:58 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: <mingo@elte.hu>, <tony.luck@intel.com>, <tglx@linutronix.de>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] x86-64: use relative 32-bit pointers in
	 exception  tables
References: <4D5D62EE02000078000327E7@vpn.id2.novell.com>
 <4D5DFA41.9060207@zytor.com>
In-Reply-To: <4D5DFA41.9060207@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 18.02.11 at 05:49, "H. Peter Anvin" <hpa@zytor.com> wrote:
> On 02/17/2011 09:03 AM, Jan Beulich wrote:
>> Convert exception table pointers from absolute 64-bit to relative 32-
>> bit ones, thus shrinking the table size by half. Rather than providing
>> an x86-64-specific extable implementation, generalize the common one
>> to deal with different ways of storing the pointers, which will allow
>> ia64's custom implementation to be dropped subsequently.
>> 
>> Signed-off-by: Jan Beulich <jbeulich@novell.com>
>> Cc: Tony Luck <tony.luck@intel.com>
>> --- /dev/null
>> +++ 2.6.38-rc5-extable/include/asm-generic/extable.h
>> @@ -0,0 +1,49 @@
>> +#ifndef __ASM_GENERIC_EXTABLE_H
>> +#define __ASM_GENERIC_EXTABLE_H
>> +
>> +/*
>> + * The exception table consists of pairs of addresses: the first is the
>> + * address of an instruction that is allowed to fault, and the second is
>> + * the address at which the program should continue.  No registers are
>> + * modified, so it is entirely up to the continuation code to figure out
>> + * what to do.
>> + *
>> + * All the routines below use bits of fixup code that are out of line
>> + * with the main instruction path.  This means when everything is well,
>> + * we don't even have to jump over them.  Further, they do not intrude
>> + * on our cache or tlb entries.
>> + */
>> +
>> +struct exception_table_entry
>> +{
>> +#ifdef CONFIG_EXTABLE_RELATIVE_POINTERS
>> +	s32 insn_off, fixup_off;
>> +#else
>> +	unsigned long insn, fixup;
>> +#endif
>> +};
>> +
> 
> This breaks arch/x86/kernel/test_nx.c:
> 
> /home/hpa/kernel/linux-2.6-tip.asm/arch/x86/kernel/test_nx.c: In
> function ‘fudze_exception_table’:
> /home/hpa/kernel/linux-2.6-tip.asm/arch/x86/kernel/test_nx.c:62: error:
> ‘struct exception_table_entry’ has no member named ‘insn’
> make[4]: *** [arch/x86/kernel/test_nx.o] Error 1
> make[3]: *** [arch/x86/kernel] Error 2
> make[2]: *** [arch/x86] Error 2
> make[2]: *** Waiting for unfinished jobs....

And rightly so: The code inserts pointers into stack and heap,
which clearly can't be expressed as relative 32-bit pointers. The
question now is whether I should drop the whole idea, or
whether the hackish test code could get dropped (until someone
can come up with a better idea than patching the module's
exception table) for x86-64.

Jan
