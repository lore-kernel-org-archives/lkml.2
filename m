Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab0DMP31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 11:29:27 -0400
Received: from bar.sig21.net ([80.81.252.164]:55053 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243Ab0DMP3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 11:29:25 -0400
Date: Tue, 13 Apr 2010 17:29:23 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lguest@ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Gaurav Kukreja <mailme.gaurav@gmail.com>
Subject: Re: [Lguest]  2.6.33 guest crash (was: Re: 2.6.32-rc5 guest crash)
Message-ID: <20100413152923.GA5008@sig21.net>
References: <20091025175521.GA13300@sig21.net>
 <20100314173459.GA919@sig21.net>
 <20100314212310.GA3388@sig21.net>
 <201003301457.14590.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003301457.14590.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -3.6 (---)
X-Spam-21-Report: No, score=-3.6 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.783,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

On Tue, Mar 30, 2010 at 02:57:14PM +1030, Rusty Russell wrote:
> 
> Subject: lguest: workaround cmpxchg8b_emu by ignoring cli in the guest.
> 
> It's only used by cmpxchg8b_emu (see db677ffa5f5a for the gory
> details), and fixing that to be paravirt aware would be more work than
> simply ignoring it (and AFAICT only help lguest).
> 
> (We can't emulate it properly: the popf which expects to restore interrupts
> does not trap).
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
> Cc: virtualization@lists.osdl.org
> 
> diff --git a/drivers/lguest/x86/core.c b/drivers/lguest/x86/core.c
> --- a/drivers/lguest/x86/core.c
> +++ b/drivers/lguest/x86/core.c
> @@ -288,6 +288,18 @@ static int emulate_insn(struct lg_cpu *c
>  	insn = lgread(cpu, physaddr, u8);
>  
>  	/*
> +	 * Around 2.6.33, the kernel started using an emulation for the
> +	 * cmpxchg8b instruction in early boot on many configurations.  This
> +	 * code isn't paravirtualized, and it tries to disable interrupts.
> +	 * Ignore it, which will Mostly Work.
> +	 */
> +	if (insn == 0xfa) {
> +		/* "cli", or Clear Interrupt Enable instruction.  Skip it. */ 
> +		cpu->regs->eip++;
> +		return 1;
> +	}
> +
> +	/*
>  	 * 0x66 is an "operand prefix".  It means it's using the upper 16 bits
>  	 * of the eax register.
>  	 */
> 

I just tested this patch with 2.6.34-rc4 (as both host and guest),
it seems to work fine.


Thanks,
Johannes
