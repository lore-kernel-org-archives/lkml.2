Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab0DQFXp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 01:23:45 -0400
Received: from mailgw.tensilica.com ([65.119.96.134]:35291 "EHLO
	mailgw.tensilica.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab0DQFXn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 01:23:43 -0400
X-Greylist: delayed 1296 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Apr 2010 01:23:42 EDT
From: Marc Gauthier <marc@tensilica.com>
To: David VomLehn <dvomlehn@cisco.com>,
       "to@dvomlehn-lnx2.corp.sa.net" <to@dvomlehn-lnx2.corp.sa.net>,
       "\"linux-arch@vger.kernel.org\"@cisco.com" 
	<"linux-arch@vger.kernel.org"@cisco.com>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "maint_arch@dvomlehn-lnx2.corp.sa.net" 
	<maint_arch@dvomlehn-lnx2.corp.sa.net>,
       "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>
Date: Fri, 16 Apr 2010 21:51:42 -0700
Subject: RE: [PATCH 23/23] Make register values available to Xtensa panic
 notifiers
Thread-Topic: [PATCH 23/23] Make register values available to Xtensa panic
 notifiers
Thread-Index: AcrdHWaAorgWSZ2bQkW0S8DFbAzx9QAp4lbQ
Message-ID: <522C1DF17AF50042AD8AE87F7887BD3D0163037B63@exch.hq.tensilica.com>
References: <20100412060719.GA26007@dvomlehn-lnx2.corp.sa.net>
In-Reply-To: <20100412060719.GA26007@dvomlehn-lnx2.corp.sa.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

David VomLehn wrote:
> The save_ptregs() function has not been tested or even built. I will
> need help to complete this.

Just having a first look...  (thanks for the invite to
chortle with merriment  :-)

I take it this is supposed to save the kernel's registers
around the call to save_ptregs()?  (not just find the
current exception/interrupt's pt_regs)
Does __always_inline work compiling the kernel with -O0?
if not, saving regs of save_ptregs() itself fails because
that call frame is gone by the time something uses the
regs to do a backtrace.  So should save_ptregs() save the
registers of its caller instead?  And is the caller of
save_ptregs not expected to return?

Almost wonder whether it's easier to write a panic system
call, given the system call mechanism saves all registers
for everyone already.

-Marc



> Signed-off-by: David VomLehn <dvomlehn@cisco.com>
> ---
>  arch/xtensa/include/asm/ptrace.h |   93
>  ++++++++++++++++++++++++++++++++++++++ arch/xtensa/kernel/traps.c
>  |    4 +- 2 files changed, 95 insertions(+), 2 deletions(-)
>
> diff --git a/arch/xtensa/include/asm/ptrace.h
> b/arch/xtensa/include/asm/ptrace.h index 905e1e6..56d5721 100644
> --- a/arch/xtensa/include/asm/ptrace.h
> +++ b/arch/xtensa/include/asm/ptrace.h
> @@ -130,6 +130,99 @@ extern void show_regs(struct pt_regs *);
>
>  #endif       /* !__ASSEMBLY__ */
>
> +/* Macros for saving the contents of registers and for the output
> constraint + * for those registers */
> +#define PTREG_SAVE(r, name)          "movel  " #r ", %[" #name "]\n"
> +#define PTREG_SAVE_R(r)                      PTREG_SAVE_I(r, r, i)
> +
> +#define PTREG_OUT_R(regs, i)         PTREG_OUT_I(regs, i)
> +
> +#define arch_has_save_ptregs 1
> +
> +/**
> + * save_ptregs - save processor registers for backtracing
> + * @regs:    Pointer to &struct pt_regs structure in which to save the
> + *           registers
> + *
> + * Returns a constant pointer to @regs.
> + *
> + * This function must be called first in a function. There must be no
> + * auto variables defined that are initialized before calling this
> function. + */
> +static __always_inline
> +const struct pt_regs *save_ptregs(struct pt_regs *regs)
> +{
> +     __asm__ __volatile__ (
> +                     PTREG_SAVE(pc, pc)
> +                     PTREG_SAVE(ps, ps)
> +                     PTREG_SAVE(depc, depc)
> +                     PTREG_SAVE(exccause, exccause)
> +                     PTREG_SAVE(excvaddr, excvaddr)
> +                     PTREG_SAVE(debugcause, debugcause)
> +                     PTREG_SAVE(wmask, wmask)
> +                     PTREG_SAVE(lbeg, lbeg)
> +                     PTREG_SAVE(lend, lend)
> +                     PTREG_SAVE(lcount, lcount)
> +                     PTREG_SAVE(sar, sar)
> +                     PTREG_SAVE(windowbase, windowbase)
> +                     PTREG_SAVE(windowstart, windowstart)
> +                     PTREG_SAVE(syscall, syscall)
> +                     PTREG_SAVE(icountlevel, icountlevel)
> +                     /* Don't know how to handle xtregs_opt_t definitions */
> +                     PTREG_SAVE_R(0)
> +                     PTREG_SAVE_R(1)
> +                     PTREG_SAVE_R(2)
> +                     PTREG_SAVE_R(3)
> +                     PTREG_SAVE_R(4)
> +                     PTREG_SAVE_R(5)
> +                     PTREG_SAVE_R(6)
> +                     PTREG_SAVE_R(7)
> +                     PTREG_SAVE_R(8)
> +                     PTREG_SAVE_R(9)
> +                     PTREG_SAVE_R(10)
> +                     PTREG_SAVE_R(11)
> +                     PTREG_SAVE_R(12)
> +                     PTREG_SAVE_R(13)
> +                     PTREG_SAVE_R(14)
> +                     PTREG_SAVE_R(15)
> +     :
> +             PTREG_OUT(regs, pc, pc),
> +             PTREG_OUT(regs, ps, ps),
> +             PTREG_OUT(regs, depc, depc),
> +             PTREG_OUT(regs, exccause, exccause),
> +             PTREG_OUT(regs, excvaddr, excvaddr),
> +             PTREG_OUT(regs, debugcause, debugcause),
> +             PTREG_OUT(regs, wmask, wmask),
> +             PTREG_OUT(regs, lbeg, lbeg),
> +             PTREG_OUT(regs, lend, lend),
> +             PTREG_OUT(regs, lcount, lcount),
> +             PTREG_OUT(regs, sar, sar),
> +             PTREG_OUT(regs, windowbase, windowbase),
> +             PTREG_OUT(regs, windowstart, windowstart),
> +             PTREG_OUT(regs, syscall, syscall),
> +             PTREG_OUT(regs, icountlevel, icountlevel),
> +             /* Don't know how to handle xtregs_opt_t definitions */
> +             PTREG_OUT_R(regs, 0),
> +             PTREG_OUT_R(regs, 1),
> +             PTREG_OUT_R(regs, 2),
> +             PTREG_OUT_R(regs, 3),
> +             PTREG_OUT_R(regs, 4),
> +             PTREG_OUT_R(regs, 5),
> +             PTREG_OUT_R(regs, 6),
> +             PTREG_OUT_R(regs, 7),
> +             PTREG_OUT_R(regs, 8),
> +             PTREG_OUT_R(regs, 9),
> +             PTREG_OUT_R(regs, 10),
> +             PTREG_OUT_R(regs, 11),
> +             PTREG_OUT_R(regs, 12),
> +             PTREG_OUT_R(regs, 13),
> +             PTREG_OUT_R(regs, 14),
> +             PTREG_OUT_R(regs, 15)
> +     :
> +     );
> +
> +     return regs;
> +}
>  #endif  /* __KERNEL__ */
>
>  #endif       /* _XTENSA_PTRACE_H */
> diff --git a/arch/xtensa/kernel/traps.c b/arch/xtensa/kernel/traps.c
> index e64efac..3441d54 100644
> --- a/arch/xtensa/kernel/traps.c
> +++ b/arch/xtensa/kernel/traps.c
> @@ -497,10 +497,10 @@ void die(const char * str, struct pt_regs *
>       regs, long err) spin_unlock_irq(&die_lock);
>
>       if (in_interrupt())
> -             panic("Fatal exception in interrupt");
> +             panic_with_regs(regs, "Fatal exception in interrupt");
>
>       if (panic_on_oops)
> -             panic("Fatal exception");
> +             panic_with_regs(regs, "Fatal exception");
>
>       do_exit(err);
>  }
