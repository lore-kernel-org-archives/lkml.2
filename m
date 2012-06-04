Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760072Ab2FDLER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 07:04:17 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:45271
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751677Ab2FDLEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 07:04:15 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -11
X-BigFish: VS-11(zzbb2dI9371I1432N98dKzz1202hzzz2dh2a8h668h839h944hd25hf0ah)
Date: Mon, 4 Jun 2012 19:04:44 +0800
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: Scott Wood <scottwood@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <galak@kernel.crashing.org>, <leoli@freescale.com>
Subject: Re: [PATCH v5 2/5] powerpc/85xx: add HOTPLUG_CPU support
Message-ID: <20120604110444.GA20676@localhost.localdomain>
References: <1336737235-15370-1-git-send-email-chenhui.zhao@freescale.com>
 <1336737235-15370-2-git-send-email-chenhui.zhao@freescale.com>
 <4FC933BF.1020901@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4FC933BF.1020901@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2012 at 04:27:27PM -0500, Scott Wood wrote:
> On 05/11/2012 06:53 AM, Zhao Chenhui wrote:
> \> +#if defined(CONFIG_FSL_BOOKE) || defined(CONFIG_6xx)
> > +extern void __flush_disable_L1(void);
> > +#endif
> 
> Prototypes aren't normally guarded by ifdefs.

OK. Thanks.

> 
> > +static void __cpuinit smp_85xx_mach_cpu_die(void)
> > +{
> > +	unsigned int cpu = smp_processor_id();
> > +	u32 tmp;
> > +
> > +	local_irq_disable();
> > +	idle_task_exit();
> > +	generic_set_cpu_dead(cpu);
> > +	mb();
> > +
> > +	mtspr(SPRN_TCR, 0);
> > +
> > +	__flush_disable_L1();
> > +	tmp = (mfspr(SPRN_HID0) & ~(HID0_DOZE|HID0_SLEEP)) | HID0_NAP;
> > +	mtspr(SPRN_HID0, tmp);
> > +
> > +	/* Enter NAP mode. */
> > +	tmp = mfmsr();
> > +	tmp |= MSR_WE;
> > +	mb();
> > +	mtmsr(tmp);
> > +	isync();
> 
> Need isync after writing to HID0.
> 
> > +		/*
> > +		 * We don't set the BPTR register here upon it points
> > +		 * to the boot page properly.
> > +		 */
> > +		mpic_reset_core(hw_cpu);
> 
> That comment's wording is hard to follow -- maybe s/upon it points/since
> it already points/
> 
> > +		/* wait until core is ready... */
> > +		if (!spin_event_timeout(in_be32(&spin_table->addr_l) == 1,
> > +						10000, 100)) {
> > +			pr_err("%s: timeout waiting for core %d to reset\n",
> > +							__func__, hw_cpu);
> > +			ret = -ENOENT;
> > +			goto out;
> > +		}
> 
> We need to fix U-Boot to write addr_l last (with an msync beforehand).

I agree.

> 
> > -#ifdef CONFIG_KEXEC
> > +#if defined(CONFIG_KEXEC) || defined(CONFIG_HOTPLUG_CPU)
> 
> Let's not grow lists like this.  Is there any harm in building it
> unconditionally?
> 
> -Scott

We need this ifdef. We only set give_timebase/take_timebase
when CONFIG_KEXEC or CONFIG_HOTPLUG_CPU is defined.

-Chenhui

