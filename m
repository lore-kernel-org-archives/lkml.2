Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab0F3BN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 21:13:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56499 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858Ab0F3BN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 21:13:28 -0400
Message-ID: <4C2A9A1E.6010005@zytor.com>
Date: Tue, 29 Jun 2010 18:13:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, jeremy.fitzhardinge@citrix.com,
       Ky Srinivasan <KSrinivasan@novell.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4, v2] x86: enlightenment for ticket spin locks -	 eliminate
 NOPs introduced by first patch
References: <4C2A205902000078000089E7@vpn.id2.novell.com>
In-Reply-To: <4C2A205902000078000089E7@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2010 07:33 AM, Jan Beulich wrote:
> Under the assumption that the nop-s added by the base ticket spinlock
> enlightenment patch might be considered undesirable (or worse), here
> is an optional patch to eliminate these nop-s again. This is done
> through extending the memory operands of the inc instructions used for
> unlocking ticket locks to the necessary size, using assembler and
> linker features.
> 
> --- 2.6.35-rc3-virt-spinlocks.orig/arch/x86/include/asm/spinlock.h
> +++ 2.6.35-rc3-virt-spinlocks/arch/x86/include/asm/spinlock.h
> @@ -10,7 +10,6 @@
>  
>  #ifdef CONFIG_ENLIGHTEN_SPINLOCKS
>  #include <asm/alternative.h>
> -#include <asm/nops.h>
>  /* Including asm/smp.h here causes a cyclic include dependency. */
>  #include <asm/percpu.h>
>  DECLARE_PER_CPU(int, cpu_number);
> @@ -156,8 +155,7 @@ static __always_inline void __ticket_spi
>  #else
>  	unsigned int token;
>  
> -	alternative_io(UNLOCK_LOCK_PREFIX "incb %[lock]\n\t"
> -		ASM_NOP3,
> +	alternative_io(UNLOCK_LOCK_PREFIX "unary incb %[lock]\n\t",
>  		ALTERNATIVE_TICKET_UNLOCK_HEAD
>  		UNLOCK_LOCK_PREFIX "incb %[lock]\n\t"
>  		"movzwl %[lock], %[token]\n\t"
> @@ -228,8 +226,7 @@ static __always_inline void __ticket_spi
>  #else
>  	unsigned int token, tmp;
>  
> -	alternative_io(UNLOCK_LOCK_PREFIX "incw %[lock]\n\t"
> -		ASM_NOP2,
> +	alternative_io(UNLOCK_LOCK_PREFIX "unary incw %[lock]\n\t",
>  		ALTERNATIVE_TICKET_UNLOCK_HEAD
>  		UNLOCK_LOCK_PREFIX "incw %[lock]\n\t"
>  		"movl %[lock], %[token]\n\t"

If you're stretching (bloating) them anyway, perhaps we should be using
"add" instructions instead, with their better EFLAGS behavior?

	-hpa
