Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab2BIIHI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 03:07:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59853 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099Ab2BIIHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 03:07:06 -0500
Date: Thu, 9 Feb 2012 09:06:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@alien8.de>, Nick Bowler <nbowler@elliptictech.com>,
        Randy Dunlap <rdunlap@xenotime.net>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Kevin Winchester <kjwinchester@gmail.com>
Subject: Re: MCE, AMD: Hide smp-only code around CONFIG_SMP
Message-ID: <20120209080648.GI18387@elte.hu>
References: <1328209817-18913-1-git-send-email-bp@alien8.de>
 <20120202193702.GA9502@elliptictech.com>
 <20120202202427.GA2234@x1.osrc.amd.com>
 <20120203191801.GA2846@x1.osrc.amd.com>
 <20120207095746.GH15359@elte.hu>
 <20120208101956.GA1772@x1.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120208101956.GA1772@x1.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> +++ b/arch/x86/include/asm/smp.h
> @@ -33,8 +33,15 @@ static inline bool cpu_has_ht_siblings(void)
>  
>  DECLARE_PER_CPU(cpumask_var_t, cpu_sibling_map);
>  DECLARE_PER_CPU(cpumask_var_t, cpu_core_map);
> -/* cpus sharing the last level cache: */
> +
> +#ifdef CONFIG_SMP
> +/* CPUs sharing the last level cache: */
>  DECLARE_PER_CPU(cpumask_var_t, cpu_llc_shared_map);
> +#else
> +static DECLARE_BITMAP(cpu_llc_shared_bits, NR_CPUS) __read_mostly = { [0] = 1UL };
> +static struct cpumask *const cpu_llc_shared_map = to_cpumask(cpu_llc_shared_bits);
> +#endif

Why not just expose it like on SMP?

We want to *reduce* the specialness of UP, not increase it - one 
more word of .data and .text does not matter much - UP is 
becoming more and more an oddball, rarely tested config. By the 
time these changes hit any real boxes it will be even more 
oddball.

Thanks,

	Ingo
