Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab0C3Evn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 00:51:43 -0400
Received: from claw.goop.org ([74.207.240.146]:36411 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899Ab0C3Evm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 00:51:42 -0400
Message-ID: <4BB1835A.1060603@goop.org>
Date: Mon, 29 Mar 2010 21:51:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.3
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Johannes Stezenbach <js@sig21.net>, lguest@ozlabs.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Gaurav Kukreja <mailme.gaurav@gmail.com>
Subject: Re: [Lguest]  2.6.33 guest crash
References: <20091025175521.GA13300@sig21.net> <20100314173459.GA919@sig21.net> <20100314212310.GA3388@sig21.net> <201003301457.14590.rusty@rustcorp.com.au>
In-Reply-To: <201003301457.14590.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2010 09:27 PM, Rusty Russell wrote:
> On Mon, 15 Mar 2010 07:53:10 am Johannes Stezenbach wrote:
>    
>> On Sun, Mar 14, 2010 at 06:34:59PM +0100, I wrote:
>>      
>>> Am I correct to assume that I can avoid the issue
>>> by switching to a 64bit kernel (on host + guest)?
>>>        
>> Silly question  ;-/
>>
>> So what would be the real fix?
>>      
> That patch broke Real Machines.  The real answer is actually to do some
> more emulation in the host; I like lguest but I can't really justify many
> lguest-specific hacks outside the lguest dirs.
>
> There are a few patches needed to make Linus' latest work, I'll post them
> soon.  But for this specific issue, how's this?
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

Why isn't the cli getting paravirtualized?

     J

> Signed-off-by: Rusty Russell<rusty@rustcorp.com.au>
> Cc: Jeremy Fitzhardinge<jeremy@xensource.com>
> Cc: virtualization@lists.osdl.org
>
> diff --git a/drivers/lguest/x86/core.c b/drivers/lguest/x86/core.c
> --- a/drivers/lguest/x86/core.c
> +++ b/drivers/lguest/x86/core.c
> @@ -288,6 +288,18 @@ static int emulate_insn(struct lg_cpu *c
>   	insn = lgread(cpu, physaddr, u8);
>
>   	/*
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
>   	 * 0x66 is an "operand prefix".  It means it's using the upper 16 bits
>   	 * of the eax register.
>   	 */
>
>    

