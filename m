Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab2KEIhh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 03:37:37 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:32848 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab2KEIhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 03:37:36 -0500
Date: Mon, 5 Nov 2012 09:37:26 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: linux-next: manual merge of the signal tree with the cortex tree
Message-ID: <20121105083726.GA22235@pengutronix.de>
References: <20121105150307.05dc233ef299ab73df5dbf89@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121105150307.05dc233ef299ab73df5dbf89@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Stephen,

On Mon, Nov 05, 2012 at 03:03:07PM +1100, Stephen Rothwell wrote:
> Today's linux-next merge of the signal tree got a conflict in
> arch/arm/kernel/process.c between commit 77a3018e38b9 ("Cortex-M3: Add
> support for exception handling") from the cortex tree and commit
> 9e6479930021 ("arm: switch to generic fork/vfork/clone") from the signal
> tree.
> 
> I fixed it up (I think - see below) and can carry the fix as necessary
> (no action is required).
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc arch/arm/kernel/process.c
> index 585b9ab,4ab80bb..0000000
> --- a/arch/arm/kernel/process.c
> +++ b/arch/arm/kernel/process.c
> @@@ -384,14 -383,11 +384,15 @@@ copy_thread(unsigned long clone_flags, 
>   
>   	memset(&thread->cpu_context, 0, sizeof(struct cpu_context_save));
>   
> - 	if (likely(regs)) {
> - 		*childregs = *regs;
> + 	if (likely(!(p->flags & PF_KTHREAD))) {
> + 		*childregs = *current_pt_regs();
>   		childregs->ARM_r0 = 0;
> - 		childregs->ARM_sp = stack_start;
> + 		if (stack_start)
> + 			childregs->ARM_sp = stack_start;
>  +#if defined CONFIG_CPU_V7M
>  +		/* Return to Thread mode with Process stack */
>  +		childregs->ARM_EXC_RET = 0xfffffffdUL;
>  +#endif
>   	} else {
>   		memset(childregs, 0, sizeof(struct pt_regs));
>   		thread->cpu_context.r4 = stk_sz;
looks good and works for me

Thanks
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
