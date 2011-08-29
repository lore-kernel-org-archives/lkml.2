Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751224Ab1H2EP7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 00:15:59 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46205 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab1H2EPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 00:15:52 -0400
Date: Sun, 28 Aug 2011 23:15:42 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>,
        Fengzhe Zhang <fengzhe.zhang@intel.com>, mingo@redhat.com,
        hpa@zytor.com, Ian Campbell <Ian.Campbell@eu.citrix.com>,
        JBeulich@novell.com, xen-devel@lists.xensource.com,
        Lars Boegild Thomsen <lth@cow.dk>
Subject: [regression] Ideapad S10-3 does not wake up from suspend (Re: [PATCH
 v2 2/2] x86: don't unmask disabled irqs when migrating them)
Message-ID: <20110829041532.GA22087@elie.gateway.2wire.net>
References: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F7E3@shsmsx502.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F7E3@shsmsx502.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21+46 (b01d63af6fea) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Lars Boegild Thomsen writes[1]:

> After update from 2.6 kernel to 3.0 my Idepad S10-3 will not wake up after 
> sleep.  Back to latest 2.6 kernel works fine.
[...]
> Upon wakeup, the power light go from slow flashing to on, the battery light 
> goes from off to on, the hdd light blink once and then everything is dead.  
> Nothing happens on the screen, all keys dead.  The fan/hdd switch on 
> physically (very hard to hear on this model or I am getting deaf).  
> Ctrl+alt+del or the alt+sysreq is non-responsive.  The only LED that show 
> keyboard status is CAPS lock and that is unresponsive too.  Only way I have 
> found to get it rebooted is holding down the power button a few secs until it 
> switch physically off and then switch it on again.
[...]
> Here's the result of the final bisect:
>
> 983bbf1af0664b78689612b247acb514300f62c7 is the first bad commit
[...]
> I also tried to go back to HEAD and manually change arch/x86/irq.c revert this 
> particular commit and it works.

For reference:

> commit 983bbf1af0664b78689612b247acb514300f62c7
> Author: Tian, Kevin <kevin.tian@intel.com>
> Date:   Fri May 6 14:43:56 2011 +0800
>
>    x86: Don't unmask disabled irqs when migrating them
>
>    It doesn't make sense to unconditionally unmask a disabled irq when
>    migrating it from offlined cpu to another. If the irq triggers then it
>    will be disabled in the interrupt handler anyway. So we can just avoid
>    unmasking it.
> 
>    [ tglx: Made masking unconditional again and fixed the changelog ]
> 
>    Signed-off-by: Fengzhe Zhang <fengzhe.zhang@intel.com>
>    Signed-off-by: Kevin Tian <kevin.tian@intel.com>
>    Cc: Ian Campbell <Ian.Campbell@citrix.com>
>    Cc: Jan Beulich <JBeulich@novell.com>
>    Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
>    Link: http://lkml.kernel.org/r/%3C625BA99ED14B2D499DC4E29D8138F1505C8ED7F7E3%40shsmsx502.ccr.corp.intel.com%3
>    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>
> diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
> index 544efe2741be..6c0802eb2f7f 100644
> --- a/arch/x86/kernel/irq.c
> +++ b/arch/x86/kernel/irq.c
> @@ -276,7 +276,8 @@ void fixup_irqs(void)
>  		else if (!(warned++))
>  			set_affinity = 0;
>  
> -		if (!irqd_can_move_in_process_context(data) && chip->irq_unmask)
> +		if (!irqd_can_move_in_process_context(data) &&
> +		    !irqd_irq_disabled(data) && chip->irq_unmask)
>  			chip->irq_unmask(data);
>  
>  		raw_spin_unlock(&desc->lock);

Known problem?  Ideas?

Regards,
Jonathan

[1] http://bugs.debian.org/635575
