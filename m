Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932983Ab2GBKJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 06:09:47 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:37682
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932850Ab2GBKJo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 06:09:44 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI9371I1432Izz1202hzz8275bhz2dh2a8h668h839hd25hf0ah)
Date: Mon, 2 Jul 2012 18:10:48 +0800
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: Tabi Timur-B04825 <B04825@freescale.com>
CC: Zhao Chenhui-B35336 <B35336@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        Li Yang-R58472 <r58472@freescale.com>, <leoli@freescale.com>
Subject: Re: [PATCH v6 1/5] powerpc/85xx: implement hardware timebase sync
Message-ID: <20120702101048.GA22108@localhost.localdomain>
References: <1340706359-9455-1-git-send-email-chenhui.zhao@freescale.com>
 <CAOZdJXWiGOCtP1iJYR2S48XwR2Wpry8+VswctctdVfY9Z+QTiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <CAOZdJXWiGOCtP1iJYR2S48XwR2Wpry8+VswctctdVfY9Z+QTiQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2012 at 10:39:24AM -0500, Tabi Timur-B04825 wrote:
> On Tue, Jun 26, 2012 at 5:25 AM, Zhao Chenhui
> <chenhui.zhao@freescale.com> wrote:
> > Do hardware timebase sync. Firstly, stop all timebases, and transfer
> > the timebase value of the boot core to the other core. Finally,
> > start all timebases.
> >
> > Only apply to dual-core chips, such as MPC8572, P2020, etc.
> >
> > Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
> > Signed-off-by: Li Yang <leoli@freescale.com>
> > ---
> > Changes for v6:
> >  * added 85xx_TB_SYNC
> >  * added isync() after set_tb()
> >  * removed extra entries from mpc85xx_smp_guts_ids
> >
> >  arch/powerpc/include/asm/fsl_guts.h |    2 +
> >  arch/powerpc/platforms/85xx/Kconfig |    5 ++
> >  arch/powerpc/platforms/85xx/smp.c   |   84 +++++++++++++++++++++++++++++++++++
> >  3 files changed, 91 insertions(+), 0 deletions(-)
> >
> > diff --git a/arch/powerpc/platforms/85xx/smp.c b/arch/powerpc/platforms/85xx/smp.c
> > index ff42490..edb0cad 100644
> > --- a/arch/powerpc/platforms/85xx/smp.c
> > +++ b/arch/powerpc/platforms/85xx/smp.c
> > @@ -24,6 +24,7 @@
> >  #include <asm/mpic.h>
> >  #include <asm/cacheflush.h>
> >  #include <asm/dbell.h>
> > +#include <asm/fsl_guts.h>
> >
> >  #include <sysdev/fsl_soc.h>
> >  #include <sysdev/mpic.h>
> > @@ -42,6 +43,69 @@ extern void __early_start(void);
> >  #define NUM_BOOT_ENTRY         8
> >  #define SIZE_BOOT_ENTRY                (NUM_BOOT_ENTRY * sizeof(u32))
> >
> > +#ifdef CONFIG_85xx_TB_SYNC
> > +static struct ccsr_guts __iomem *guts;
> > +static u64 timebase;
> > +static int tb_req;
> > +static int tb_valid;
> > +
> > +static void mpc85xx_timebase_freeze(int freeze)
> > +{
> > +       unsigned int mask;
> 
> 'mask' should be uint32_t

OK.

> 
> > +
> > +       if (!guts)
> > +               return;
> 
> This function should never be called if guts is NULL, so this check
> should be unnecessary.

OK.

> 
> > +
> > +       mask = CCSR_GUTS_DEVDISR_TB0 | CCSR_GUTS_DEVDISR_TB1;
> > +       if (freeze)
> > +               setbits32(&guts->devdisr, mask);
> > +       else
> > +               clrbits32(&guts->devdisr, mask);
> > +
> > +       in_be32(&guts->devdisr);
> > +}
> > +
> > @@ -249,6 +323,16 @@ void __init mpc85xx_smp_init(void)
> >                smp_85xx_ops.cause_ipi = doorbell_cause_ipi;
> >        }
> >
> > +       np = of_find_matching_node(NULL, mpc85xx_smp_guts_ids);
> > +       if (np) {
> > +#ifdef CONFIG_85xx_TB_SYNC
> > +               guts = of_iomap(np, 0);
> 
> You need to test the return value of of_iomap().  smp_85xx_ops should
> be set only if guts is not NULL.

Yes. Thanks.

> 
> > +               smp_85xx_ops.give_timebase = mpc85xx_give_timebase;
> > +               smp_85xx_ops.take_timebase = mpc85xx_take_timebase;
> > +#endif
> > +               of_node_put(np);
> > +       }
> > +
> >        smp_ops = &smp_85xx_ops;
> >
> >  #ifdef CONFIG_KEXEC
> > --
> > 1.6.4.1

