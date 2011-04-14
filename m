Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab1DNGrx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 02:47:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39575 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409Ab1DNGrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 02:47:52 -0400
Date: Thu, 14 Apr 2011 08:47:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@openvz.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: maciej.rutecki@gmail.com, Shaun Ruffell <sruffell@digium.com>,
        Don Zickus <dzickus@redhat.com>, linux-kernel@vger.kernel.org,
        Lin Ming <ming.m.lin@intel.com>
Subject: Re: [regression 2.6.39-rc2][bisected] "perf, x86: P4 PMU - Read
 proper MSR register to catch" and NMIs
Message-ID: <20110414064737.GB15535@elte.hu>
References: <20110406223036.GA15721@digium.com>
 <201104132133.51958.maciej.rutecki@gmail.com>
 <4DA6011F.7070405@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA6011F.7070405@openvz.org>
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

> -	apic_write(APIC_LVTPC, APIC_DM_NMI);
> 
>  	handled = x86_pmu.handle_irq(args->regs);
>  	if (!handled)
>  		return NOTIFY_DONE;
> 
> +	/*
> +	 * Unmasking should be done after IRQ handled, otherwise
> +	 * there is a race between clearing of counter overflow
> +	 * flag and LTV entry unmasking (which might lead to double
> +	 * NMIs generation).
> +	 */
> +	apic_write(APIC_LVTPC, APIC_DM_NMI);

Here we could leak a masked IRQ through the !handled path. If we got a LVTPC 
irq we better handle it and unmask the LVTPC unconditionally - regardless of 
whether we consider it 'handled' or not from the kernel POV ...

Thanks,

	Ingo
