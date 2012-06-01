Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964804Ab2FAV1i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 17:27:38 -0400
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:45269
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932538Ab2FAV1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 17:27:36 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VS-5(zzbb2dI9371I98dKzz1202hzzz2dh2a8h668h839h93fhd25he5bhf0ah)
Message-ID: <4FC933BF.1020901@freescale.com>
Date: Fri, 1 Jun 2012 16:27:27 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Zhao Chenhui <chenhui.zhao@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <galak@kernel.crashing.org>, <leoli@freescale.com>
Subject: Re: [PATCH v5 2/5] powerpc/85xx: add HOTPLUG_CPU support
References: <1336737235-15370-1-git-send-email-chenhui.zhao@freescale.com> <1336737235-15370-2-git-send-email-chenhui.zhao@freescale.com>
In-Reply-To: <1336737235-15370-2-git-send-email-chenhui.zhao@freescale.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2012 06:53 AM, Zhao Chenhui wrote:
\> +#if defined(CONFIG_FSL_BOOKE) || defined(CONFIG_6xx)
> +extern void __flush_disable_L1(void);
> +#endif

Prototypes aren't normally guarded by ifdefs.

> +static void __cpuinit smp_85xx_mach_cpu_die(void)
> +{
> +	unsigned int cpu = smp_processor_id();
> +	u32 tmp;
> +
> +	local_irq_disable();
> +	idle_task_exit();
> +	generic_set_cpu_dead(cpu);
> +	mb();
> +
> +	mtspr(SPRN_TCR, 0);
> +
> +	__flush_disable_L1();
> +	tmp = (mfspr(SPRN_HID0) & ~(HID0_DOZE|HID0_SLEEP)) | HID0_NAP;
> +	mtspr(SPRN_HID0, tmp);
> +
> +	/* Enter NAP mode. */
> +	tmp = mfmsr();
> +	tmp |= MSR_WE;
> +	mb();
> +	mtmsr(tmp);
> +	isync();

Need isync after writing to HID0.

> +		/*
> +		 * We don't set the BPTR register here upon it points
> +		 * to the boot page properly.
> +		 */
> +		mpic_reset_core(hw_cpu);

That comment's wording is hard to follow -- maybe s/upon it points/since
it already points/

> +		/* wait until core is ready... */
> +		if (!spin_event_timeout(in_be32(&spin_table->addr_l) == 1,
> +						10000, 100)) {
> +			pr_err("%s: timeout waiting for core %d to reset\n",
> +							__func__, hw_cpu);
> +			ret = -ENOENT;
> +			goto out;
> +		}

We need to fix U-Boot to write addr_l last (with an msync beforehand).

> -#ifdef CONFIG_KEXEC
> +#if defined(CONFIG_KEXEC) || defined(CONFIG_HOTPLUG_CPU)

Let's not grow lists like this.  Is there any harm in building it
unconditionally?

-Scott

