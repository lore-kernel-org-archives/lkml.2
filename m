Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319Ab2BQMCH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 07:02:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34760 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977Ab2BQMCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 07:02:04 -0500
Date: Fri, 17 Feb 2012 13:01:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Milton Miller <miltonm@bga.com>, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86: drop false warning of empty cpumask in IPI
Message-ID: <20120217120146.GB25601@elte.hu>
References: <1329298204-5026-1-git-send-email-gilad@benyossef.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329298204-5026-1-git-send-email-gilad@benyossef.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Gilad Ben-Yossef <gilad@benyossef.com> wrote:

> With current generic SMP infrastructure, it is feasible
> for the target CPUs to begin processing an IPI work item
> even before we sent them the actual IPI in the case that
> an IPI from another CPU woke them first.
> 
> This can lead to generating a false warning in a valid
> state of trying to send IPI with an empty cpumask when
> multiple concurrent IPIs are being sent.
> 
> This patch was triggered by the following LKML discussion:
> https://lkml.org/lkml/2012/1/13/308
> 
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: "H. Peter Anvin" <hpa@zytor.com>
> CC: Milton Miller <miltonm@bga.com>
> CC: x86@kernel.org
> ---
>  arch/x86/kernel/apic/ipi.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/ipi.c b/arch/x86/kernel/apic/ipi.c
> index cce91bf..00b68a3 100644
> --- a/arch/x86/kernel/apic/ipi.c
> +++ b/arch/x86/kernel/apic/ipi.c
> @@ -106,7 +106,10 @@ void default_send_IPI_mask_logical(const struct cpumask *cpumask, int vector)
>  	unsigned long mask = cpumask_bits(cpumask)[0];
>  	unsigned long flags;
>  
> -	if (WARN_ONCE(!mask, "empty IPI mask"))
> +	if (!mask)
> +		/* The target CPUs must have already processed the
> +		 * work items due to a concurrent IPI
> +		 */
>  		return;

This could potentially hide real bugs on other callsites.

So why not do the checking at the call site? In almost every 
other scenario it's invalid to send an empty mask.

Thanks,

	Ingo
