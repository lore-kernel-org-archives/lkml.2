Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534Ab2HBLLn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 07:11:43 -0400
Received: from [65.55.88.12] ([65.55.88.12]:57885 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750737Ab2HBLLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 07:11:42 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VS-5(zz98dI9371I168aJ1432Izz1202hzz8275bhz2dh2a8h668h839h944hd25hf0ah107ah)
Date: Thu, 2 Aug 2012 19:12:24 +0800
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: Kumar Gala <galak@kernel.crashing.org>
CC: <linuxppc-dev@lists.ozlabs.org>, <scottwood@freescale.com>,
        <linux-kernel@vger.kernel.org>, <leoli@freescale.com>
Subject: Re: [PATCH v8 5/7] powerpc/85xx: add sleep and deep sleep support
Message-ID: <20120802111224.GB13777@localhost.localdomain>
References: <1342788159-27529-1-git-send-email-chenhui.zhao@freescale.com>
 <1342788159-27529-6-git-send-email-chenhui.zhao@freescale.com>
 <F8FE8505-6F6A-4A4B-8302-C1CF16B48B60@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <F8FE8505-6F6A-4A4B-8302-C1CF16B48B60@kernel.crashing.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 09:15:33AM -0500, Kumar Gala wrote:
> 
> On Jul 20, 2012, at 7:42 AM, Zhao Chenhui wrote:
> 
> > In sleep PM mode, the clocks of e500 core and unused IP blocks is
> > turned off. IP blocks which are allowed to wake up the processor
> > are still running.
> > 
> > Some Freescale chips like MPC8536 and P1022 has deep sleep PM mode
> > in addtion to the sleep PM mode.
> > 
> > While in deep sleep PM mode, additionally, the power supply is
> > removed from e500 core and most IP blocks. Only the blocks needed
> > to wake up the chip out of deep sleep are ON.
> > 
> > This patch supports 32-bit and 36-bit address space.
> > 
> > The sleep mode is equal to the Standby state in Linux. The deep sleep
> > mode is equal to the Suspend-to-RAM state of Linux Power Management.
> > 
> > Command to enter sleep mode.
> >  echo standby > /sys/power/state
> > Command to enter deep sleep mode.
> >  echo mem > /sys/power/state
> > 
> > Signed-off-by: Dave Liu <daveliu@freescale.com>
> > Signed-off-by: Li Yang <leoli@freescale.com>
> > Signed-off-by: Jin Qing <b24347@freescale.com>
> > Signed-off-by: Jerry Huang <Chang-Ming.Huang@freescale.com>
> > Cc: Scott Wood <scottwood@freescale.com>
> > Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
> > ---
> > arch/powerpc/Kconfig                  |    2 +-
> > arch/powerpc/include/asm/cacheflush.h |    2 +
> > arch/powerpc/kernel/Makefile          |    3 +
> > arch/powerpc/kernel/l2cache_85xx.S    |   56 +++
> > arch/powerpc/platforms/85xx/Makefile  |    2 +-
> > arch/powerpc/platforms/85xx/sleep.S   |  621 +++++++++++++++++++++++++++++++++
> > arch/powerpc/sysdev/fsl_pmc.c         |   98 +++++-
> > arch/powerpc/sysdev/fsl_soc.h         |    5 +
> > 8 files changed, 769 insertions(+), 20 deletions(-)
> > create mode 100644 arch/powerpc/kernel/l2cache_85xx.S
> > create mode 100644 arch/powerpc/platforms/85xx/sleep.S
> > 
> > diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> > index a7c6914..9d6de82 100644
> > --- a/arch/powerpc/Kconfig
> > +++ b/arch/powerpc/Kconfig
> > @@ -665,7 +665,7 @@ config FSL_PCI
> > config FSL_PMC
> > 	bool
> > 	default y
> > -	depends on SUSPEND && (PPC_85xx || PPC_86xx)
> > +	depends on SUSPEND && (PPC_85xx || PPC_86xx) && !PPC_E500MC
> > 	help
> > 	  Freescale MPC85xx/MPC86xx power management controller support
> > 	  (suspend/resume). For MPC83xx see platforms/83xx/suspend.c
> > diff --git a/arch/powerpc/include/asm/cacheflush.h b/arch/powerpc/include/asm/cacheflush.h
> > index b843e35..6c5f1c2 100644
> > --- a/arch/powerpc/include/asm/cacheflush.h
> > +++ b/arch/powerpc/include/asm/cacheflush.h
> > @@ -58,6 +58,8 @@ extern void flush_inval_dcache_range(unsigned long start, unsigned long stop);
> > extern void flush_dcache_phys_range(unsigned long start, unsigned long stop);
> > #endif
> > 
> > +extern void flush_dcache_L1(void);
> > +
> > #define copy_to_user_page(vma, page, vaddr, dst, src, len) \
> > 	do { \
> > 		memcpy(dst, src, len); \
> > diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
> > index 83afacd..0ddef24 100644
> > --- a/arch/powerpc/kernel/Makefile
> > +++ b/arch/powerpc/kernel/Makefile
> > @@ -64,6 +64,9 @@ obj-$(CONFIG_FA_DUMP)		+= fadump.o
> > ifeq ($(CONFIG_PPC32),y)
> > obj-$(CONFIG_E500)		+= idle_e500.o
> > endif
> > +ifneq ($(CONFIG_PPC_E500MC),y)
> > +obj-$(CONFIG_PPC_85xx)		+= l2cache_85xx.o
> > +endif
> 
> why do we need this, beyond reduce code size on an e500mc kernel build?  If so why isn't 85xx/sleep.S doing the same thing?
> - k
> 

Yes, it is a little awkward. I have an idea to put e500/e500mc/e5500/e6500 related flush cache routines
into this file, and rename it to cache_fsl_booke.S.

As for 85xx/sleep.S, it is used by fsl_pmc.c. I will use CONFIG_FSL_PMC to guard it.

-Chenhui

