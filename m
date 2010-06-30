Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab0F3HGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 03:06:55 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:45836 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab0F3HGy convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:5:1>);
	Wed, 30 Jun 2010 03:06:54 -0400
Message-Id: <4C2B09450200007800008B95@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 30 Jun 2010 08:07:17 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: <jeremy.fitzhardinge@citrix.com>, <mingo@elte.hu>, <tglx@linutronix.de>,
       "Ky Srinivasan" <KSrinivasan@novell.com>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4, v2] x86: enlightenment for ticket spin locks -
	 eliminate NOPs introduced by first patch
References: <4C2A205902000078000089E7@vpn.id2.novell.com>
 <4C2A9A1E.6010005@zytor.com>
In-Reply-To: <4C2A9A1E.6010005@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 30.06.10 at 03:13, "H. Peter Anvin" <hpa@zytor.com> wrote:
> On 06/29/2010 07:33 AM, Jan Beulich wrote:
>> Under the assumption that the nop-s added by the base ticket spinlock
>> enlightenment patch might be considered undesirable (or worse), here
>> is an optional patch to eliminate these nop-s again. This is done
>> through extending the memory operands of the inc instructions used for
>> unlocking ticket locks to the necessary size, using assembler and
>> linker features.
>> 
>> --- 2.6.35-rc3-virt-spinlocks.orig/arch/x86/include/asm/spinlock.h
>> +++ 2.6.35-rc3-virt-spinlocks/arch/x86/include/asm/spinlock.h
>> @@ -10,7 +10,6 @@
>>  
>>  #ifdef CONFIG_ENLIGHTEN_SPINLOCKS
>>  #include <asm/alternative.h>
>> -#include <asm/nops.h>
>>  /* Including asm/smp.h here causes a cyclic include dependency. */
>>  #include <asm/percpu.h>
>>  DECLARE_PER_CPU(int, cpu_number);
>> @@ -156,8 +155,7 @@ static __always_inline void __ticket_spi
>>  #else
>>  	unsigned int token;
>>  
>> -	alternative_io(UNLOCK_LOCK_PREFIX "incb %[lock]\n\t"
>> -		ASM_NOP3,
>> +	alternative_io(UNLOCK_LOCK_PREFIX "unary incb %[lock]\n\t",
>>  		ALTERNATIVE_TICKET_UNLOCK_HEAD
>>  		UNLOCK_LOCK_PREFIX "incb %[lock]\n\t"
>>  		"movzwl %[lock], %[token]\n\t"
>> @@ -228,8 +226,7 @@ static __always_inline void __ticket_spi
>>  #else
>>  	unsigned int token, tmp;
>>  
>> -	alternative_io(UNLOCK_LOCK_PREFIX "incw %[lock]\n\t"
>> -		ASM_NOP2,
>> +	alternative_io(UNLOCK_LOCK_PREFIX "unary incw %[lock]\n\t",
>>  		ALTERNATIVE_TICKET_UNLOCK_HEAD
>>  		UNLOCK_LOCK_PREFIX "incw %[lock]\n\t"
>>  		"movl %[lock], %[token]\n\t"
> 
> If you're stretching (bloating) them anyway, perhaps we should be using
> "add" instructions instead, with their better EFLAGS behavior?

Hmm, yes, that possibility I didn't even consider. Would have
the potential to get away without that admittedly ugly "unary"
assembler macro altogether, though at the price of growing all
instructions rather than just those that have a non-symbolic
and small displacement. Since unlock generally gets inlined, I'm
not certain this additional growth in code size would be
acceptable...

Please let me know, though before submitting an eventual third
version I'd appreciate knowing especially the first two patches
need further changes in order to get accepted.

Thanks, Jan

