Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab2JPOE2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 10:04:28 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58176 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514Ab2JPOE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 10:04:26 -0400
Date: Tue, 16 Oct 2012 16:04:14 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Daniel Mack <zonque@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arch@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [git pull] signals pile 3
Message-ID: <20121016140414.GS639@pengutronix.de>
References: <20121013005334.GM2616@ZenIV.linux.org.uk>
 <507ADBBB.9090209@gmail.com>
 <20121014202431.GL21164@n2100.arm.linux.org.uk>
 <20121014222449.GN21164@n2100.arm.linux.org.uk>
 <507B3F2C.1090500@gmail.com>
 <20121014231649.GO21164@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121014231649.GO21164@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Oct 15, 2012 at 12:16:49AM +0100, Russell King - ARM Linux wrote:
> On Mon, Oct 15, 2012 at 12:39:40AM +0200, Daniel Mack wrote:
> > Tested-by: Daniel Mack <zonque@gmail.com>
> > 
> > Many thanks for the very prompt response!
> 
> Thanks Daniel.
> 
> I've also tested this on my OMAP4430 board running in ARM mode, so that
> still works - we've covered the possibilities between us here between
> ARM mode and Thumb mode, so...
> 
> Linus, could you merge this patch please, thanks.
> 
> 8<===
> From: Russell King <rmk+kernel@arm.linux.org.uk>
> Subject: [PATCH] ARM: fix oops on initial entry to userspace with Thumb2 kernels
> 
> Daniel Mack reports an oops at boot with the latest kernels:
> 
> [    4.896717] Internal error: Oops - undefined instruction: 0 [#1] SMP THUMB2
> [    4.904034] Modules linked in:
> [    4.907253] CPU: 0    Not tainted  (3.6.0-11057-g584df1d #145)
> [    4.913372] PC is at cpsw_probe+0x45a/0x9ac
> [    4.917760] LR is at trace_hardirqs_on_caller+0x8f/0xfc
> [    4.923235] pc : [<c03493de>]    lr : [<c005e81f>]    psr: 60000113
> [    4.923235] sp : cf055fb0  ip : 00000000  fp : 00000000
> [    4.935246] r10: 00000000  r9 : 00000000  r8 : 00000000
> [    4.940715] r7 : 00000000  r6 : 00000000  r5 : c0344555  r4 : 00000000
> [    4.947548] r3 : cf057a40  r2 : 00000000  r1 : 00000001  r0 : 00000000
> [    4.954383] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM Segment user
> [    4.961853] Control: 50c5387d  Table: 8f3f4019  DAC: 00000015
> [    4.967868] Process init (pid: 1, stack limit = 0xcf054240)
> [    4.973702] Stack: (0xcf055fb0 to 0xcf056000)
> [    4.978269] 5fa0:                                     00000001 00000000 00000000 00000000
> [    4.986836] 5fc0: cf055fb0 c000d1a8 00000000 00000000 00000000 00000000 00000000 00000000
> [    4.995403] 5fe0: 00000000 be9b3f10 00000000 b6f6add0 00000010 00000000 aaaabfaf a8babbaa
> 
> The analysis of this is as follows.  In init/main.c, we issue:
> 
> 	kernel_thread(kernel_init, NULL, CLONE_FS | CLONE_SIGHAND);
> 
> This creates a new thread, which falls through to the ret_from_fork
> assembly, with r4 set NULL and r5 set to kernel_init.  You can see
> this in your oops dump register set - r5 is 0xc0344555, which is the
> address of kernel_init plus 1 which marks the function as Thumb code.
> 
> Now, let's look at this code a little closer - this is what the
> disassembly looks like:
> 
> c000d180 <ret_from_fork>:
> c000d180:       f03a fe08       bl      c0047d94 <schedule_tail>
> c000d184:       2d00            cmp     r5, #0
> c000d186:       bf1e            ittt    ne
> c000d188:       4620            movne   r0, r4
> c000d18a:       46fe            movne   lr, pc <-- XXXXXXX
> c000d18c:       46af            movne   pc, r5
> c000d18e:       46e9            mov     r9, sp
> c000d190:       ea4f 3959       mov.w   r9, r9, lsr #13
> c000d194:       ea4f 3949       mov.w   r9, r9, lsl #13
> c000d198:       e7c8            b.n     c000d12c <ret_to_user>
> c000d19a:       bf00            nop
> c000d19c:       f3af 8000       nop.w
> 
> This code was introduced in 9fff2fa0db911 (arm: switch to saner
> kernel_execve() semantics).  I have marked one instruction, and it's
> the significant one - I'll come back to that later.
> 
> Eventually, having had a successful call to kernel_execve(), kernel_init()
> returns zero.
> 
> In returning, it uses the value in 'lr' which was set by the instruction
> I marked above.  Unfortunately, this causes lr to contain 0xc000d18e -
> an even address.  This switches the ISA to ARM on return but with a non
> word aligned PC value.
> 
> So, what do we end up executing?  Well, not the instructions above - yes
> the opcodes, but they don't mean the same thing in ARM mode.  In ARM mode,
> it looks like this instead:
> 
> c000d18c:       46e946af        strbtmi r4, [r9], pc, lsr #13
> c000d190:       3959ea4f        ldmdbcc r9, {r0, r1, r2, r3, r6, r9, fp, sp, lr, pc}^
> c000d194:       3949ea4f        stmdbcc r9, {r0, r1, r2, r3, r6, r9, fp, sp, lr, pc}^
> c000d198:       bf00e7c8        svclt   0x0000e7c8
> c000d19c:       8000f3af        andhi   pc, r0, pc, lsr #7
> c000d1a0:       e88db092        stm     sp, {r1, r4, r7, ip, sp, pc}
> c000d1a4:       46e81fff                        ; <UNDEFINED> instruction: 0x46e81fff
> c000d1a8:       8a00f3ef        bhi     0xc004a16c
> c000d1ac:       0a0cf08a        beq     0xc03493dc
> 
> I have included more above, because it's relevant.  The PSR flags which we
> can see in the oops dump are nZCv, so Z and C are set.
> 
> All the above ARM instructions are not executed, except for two.  c000d1a0,
> which has no writeback, and writes below the current stack pointer (and
> that data is lost when we take the next exception.)  The other instruction
> which is executed is c000d1ac, which takes us to... 0xc03493dc.  However,
> remember that bit 1 of the PC got set.  So that makes the PC value
> 0xc03493de.
> 
> And that value is the value we find in the oops dump for PC.  What is the
> instruction here when interpreted in ARM mode?
> 
>        0:       f71e150c                ; <UNDEFINED> instruction: 0xf71e150c
> 
> and there we have our undefined instruction (remember that the 'never'
> condition code, 0xf, has been deprecated and is now always executed as it
> is now being used for additional instructions.)
> 
> This path also nicely explains the state of the stack we see in the oops
> dump too.
> 
> The above is a consistent and sane story for how we got to the oops dump,
> which all stems from the instruction at 0xc000d18a being wrong.
> 
> Reported-by: Daniel Mack <zonque@gmail.com>
> Tested-by: Daniel Mack <zonque@gmail.com>
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
This patch makes my Cortex-M3 boot again on v3.7-rc1. I did it slightly
different:

> ---
>  arch/arm/kernel/entry-common.S |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
> index 417bac1..3471175 100644
> --- a/arch/arm/kernel/entry-common.S
> +++ b/arch/arm/kernel/entry-common.S
> @@ -88,9 +88,9 @@ ENTRY(ret_from_fork)
>  	bl	schedule_tail
>  	cmp	r5, #0
>  	movne	r0, r4
> -	movne	lr, pc
> +	adrne	lr, BSYM(1f)
>  	movne	pc, r5
> -	get_thread_info tsk
> +1:	get_thread_info tsk
>  	b	ret_slow_syscall

I used:
 	movne	r0, r4
-	movne	lr, pc
-	movne	pc, r5
+	blxne	r5
 	get_thread_info tsk

but I assume Russell's patch is better. (Probably because blx doesn't
exist everywhere?!)

So if it's not too late yet:

Tested-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Thanks
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
