Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934001Ab2FELfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 07:35:00 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:59233
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755272Ab2FELe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 07:34:59 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -13
X-BigFish: VS-13(zzbb2dI9371I168aJ1432N98dKzz1202hzz8275dhz2dh2a8h668h839h944hd25hf0ah)
Date: Tue, 5 Jun 2012 19:35:30 +0800
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: Scott Wood <scottwood@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <galak@kernel.crashing.org>, <leoli@freescale.com>
Subject: Re: [PATCH v5 3/5] powerpc/85xx: add sleep and deep sleep support
Message-ID: <20120605113530.GC22427@localhost.localdomain>
References: <1336737235-15370-1-git-send-email-chenhui.zhao@freescale.com>
 <1336737235-15370-3-git-send-email-chenhui.zhao@freescale.com>
 <4FC93A1B.8060209@freescale.com>
 <20120604111206.GB20676@localhost.localdomain>
 <4FCD3D9E.9010509@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4FCD3D9E.9010509@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2012 at 05:58:38PM -0500, Scott Wood wrote:
> On 06/04/2012 06:12 AM, Zhao Chenhui wrote:
> > On Fri, Jun 01, 2012 at 04:54:35PM -0500, Scott Wood wrote:
> >> On 05/11/2012 06:53 AM, Zhao Chenhui wrote:
> >>> diff --git a/arch/powerpc/include/asm/cacheflush.h b/arch/powerpc/include/asm/cacheflush.h
> >>> index 94ec20a..baa000c 100644
> >>> --- a/arch/powerpc/include/asm/cacheflush.h
> >>> +++ b/arch/powerpc/include/asm/cacheflush.h
> >>> @@ -33,6 +33,11 @@ extern void flush_dcache_page(struct page *page);
> >>>  #if defined(CONFIG_FSL_BOOKE) || defined(CONFIG_6xx)
> >>>  extern void __flush_disable_L1(void);
> >>>  #endif
> >>> +#if defined(CONFIG_FSL_BOOKE)
> >>> +extern void flush_dcache_L1(void);
> >>> +#else
> >>> +#define flush_dcache_L1()	do { } while (0)
> >>> +#endif
> >>
> >> It doesn't seem right to no-op this on other platforms.
> > 
> > The pmc_suspend_enter() in fsl_pmc.c used by mpc85xx and mpc86xx,
> > but flush_dcache_L1() have no definition in mpc86xx platform.
> > I will write flush_dcache_L1() for mpc86xx platform.
> 
> How about only calling the function when it's needed?  If we didn't need
> an L1 flush here on 86xx before, why do we need it now?

How about using CONFIG_PPC_85xx to gard it, like this.

	case PM_SUSPEND_STANDBY:
		local_irq_disable();
#ifdef CONFIG_PPC_85xx
		flush_dcache_L1();
#endif
		setbits32(&pmc_regs->powmgtcsr, POWMGTCSR_SLP);

> 
> >>>  extern void __flush_icache_range(unsigned long, unsigned long);
> >>>  static inline void flush_icache_range(unsigned long start, unsigned long stop)
> >>> diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
> >>> index f5808a3..cb70dba 100644
> >>> --- a/arch/powerpc/kernel/Makefile
> >>> +++ b/arch/powerpc/kernel/Makefile
> >>> @@ -64,6 +64,9 @@ obj-$(CONFIG_FA_DUMP)		+= fadump.o
> >>>  ifeq ($(CONFIG_PPC32),y)
> >>>  obj-$(CONFIG_E500)		+= idle_e500.o
> >>>  endif
> >>> +ifneq ($(CONFIG_PPC_E500MC),y)
> >>> +obj-$(CONFIG_PPC_85xx)		+= l2cache_85xx.o
> >>> +endif
> >>
> >> Can we introduce a symbol that specifically means pre-e500mc e500,
> >> rather than using negative logic?
> >>
> >> I think something like CONFIG_PPC_E500_V1_V2 has been proposed before.
> > 
> > Agree. But CONFIG_PPC_E500_V1_V2 haven't been merged.
> 
> Has the concept been NACKed, or just forgotten?  If the latter, you
> could include it in this patchset.
> 
> -Scott

In patchwork, it's state is "Superseded".
http://patchwork.ozlabs.org/patch/124284/

-Chenhui

