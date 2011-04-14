Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351Ab1DNRnm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:43:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51076 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932200Ab1DNRnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:43:41 -0400
Date: Thu, 14 Apr 2011 19:43:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Lin Ming <ming.m.lin@intel.com>, Don Zickus <dzickus@redhat.com>,
        Shaun Ruffell <sruffell@digium.com>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Robert Richter <robert.richter@amd.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf, x86: fix unknown NMIs on a Pentium4 box
Message-ID: <20110414174327.GA8863@elte.hu>
References: <4DA70950.3060102@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA70950.3060102@openvz.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> --- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event.c
> +++ linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
> @@ -1370,9 +1370,16 @@ perf_event_nmi_handler(struct notifier_b
>  		return NOTIFY_DONE;
>  	}
> 
> -	apic_write(APIC_LVTPC, APIC_DM_NMI);
> 
>  	handled = x86_pmu.handle_irq(args->regs);
> +
> +	/*
> +	 * Note the unmasking of LVTPC entry must be
> +	 * done *after* counter oveflow flag is cleared
> +	 * otherwise it might lead to double NMIs generation.
> +	 */
> +	apic_write(APIC_LVTPC, APIC_DM_NMI);
> +
>  	if (!handled)
>  		return NOTIFY_DONE;
> 

This breaks 'perf top' on Intel Nehalem and probably other CPUs. The NMI gets 
stuck fast on all CPUs:

  NMI: 16 6 3 3 3 3 3 3 3 3 3 3 3 3 4 5 Non-maskable interrupts

Thanks,

	Ingo
