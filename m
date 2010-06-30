Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab0F3IYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 04:24:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:42226 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab0F3IYf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 04:24:35 -0400
Subject: Re: [PATCH 1/4, v2] x86: enlightenment for ticket spin locks -
 base implementation
From: Peter Zijlstra <peterz@infradead.org>
To: Jan Beulich <JBeulich@novell.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       jeremy.fitzhardinge@citrix.com, Ky Srinivasan <KSrinivasan@novell.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <4C2A1FE902000078000089E1@vpn.id2.novell.com>
References: <4C2A1FE902000078000089E1@vpn.id2.novell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 30 Jun 2010 10:24:23 +0200
Message-ID: <1277886263.1868.76.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-29 at 15:31 +0100, Jan Beulich wrote:
> @@ -62,18 +110,20 @@ static __always_inline void __ticket_spi
>  {
>         short inc = 0x0100;
>  
> -       asm volatile (
> +       alternative_common(
>                 LOCK_PREFIX "xaddw %w0, %1\n"
>                 "1:\t"
>                 "cmpb %h0, %b0\n\t"
> -               "je 2f\n\t"
> +               "je 2f\n\t",
>                 "rep ; nop\n\t"
>                 "movb %1, %b0\n\t"
>                 /* don't need lfence here, because loads are in-order
> */
>                 "jmp 1b\n"
> -               "2:"
> -               : "+Q" (inc), "+m" (lock->slock)
> -               :
> +               "2:",
> +               ALTERNATIVE_TICKET_LOCK,
> +               X86_FEATURE_SPINLOCK_YIELD,
> +               ASM_OUTPUT2("+Q" (inc), "+m" (lock->slock)),
> +               [stub] "i" (virt_spin_lock_stub)
>                 : "memory", "cc");
>  }


Also, instead of obfuscating __ticket_spin_lock(), can't you provide a
whole alternative arch_spin_lock() implementation and switch between
that and whatever bat-shit these paravirt people come up with?
