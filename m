Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab0KRIbG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 03:31:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34886 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975Ab0KRIbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 03:31:04 -0500
Date: Thu, 18 Nov 2010 09:30:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org
Subject: Re: [PATCH 4/9 UPDATED-1] x86: Initialize 32bit logical apicid
 mapping early during boot
Message-ID: <20101118083045.GB26398@elte.hu>
References: <1289473363-29440-1-git-send-email-tj@kernel.org>
 <1289473363-29440-5-git-send-email-tj@kernel.org>
 <4CDD17EC.8000507@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CDD17EC.8000507@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> On x86_32, non-standard logical apicid mapping can be used by
> different NUMA setups and the mapping is queried while bringing up
> each CPU using apic->cpu_to_logical_apicid() to build
> cpu_2_logical_apicid[] array.  The logical apicid is then used to
> deliver IPIs and determine NUMA configuration.
> 
> Unfortunately, initializing at SMP bring up is too late for percpu
> setup making static percpu variables setup w/o considering NUMA.  This
> also is different from how x86_64 is configured making the code
> difficult to follow and maintain.
> 
> This patch updates logical apicid mapping handling such that,
> 
> * early_percpu variable x86_cpu_to_logical_apicid replaces
>   cpu_2_logical_apicid[].
> 
> * apic->cpu_to_logical_apicid() is called once during get_smp_config()
>   and the output is recorded in x86_cpu_to_logical_apicid.
> 
> * apic->cpu_to_logical_apicid() is allowed to return BAD_APICID if it
>   can't determine the value that early during boot.  In this case, the
>   mapping will be initialized during SMP bring up by reading APIC LDR
>   as before.
> 
> - Brian Gerst spotted that setup_per_cpu_areas() was not copying the
>   early x86_cpu_to_logical_apicid to the permanent percpu area and
>   es7000_32 is using per_cpu() instead of early_per_cpu(), which in
>   itself is not incorrect as they're never used before setup_per_cpu()
>   but still confusing.  Both updated.
> 
> - Using local variable @cpu to cache smp_processor_id() in
>   setup_local_APIC() separated out into a separate patch as suggested
>   by Yinghai Lu.

This patch is still _WAY_ too large.

Also, these:

> +#ifdef CONFIG_X86_32
> +#endif

> +#ifdef CONFIG_X86_32
> +#endif

> +#ifdef CONFIG_X86_32
> +#endif

> +#ifdef CONFIG_X86_32
> +#endif

Are rather ugly.

	Ingo
