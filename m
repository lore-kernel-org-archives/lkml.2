Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760887Ab2ILRe0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:34:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754954Ab2ILReY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 13:34:24 -0400
Date: Wed, 12 Sep 2012 19:36:24 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>, mingo@kernel.org
Subject: Re: [RFC][PATCH] perf, intel: Don't touch MSR_IA32_DEBUGCTLMSR
	from NMI context
Message-ID: <20120912173624.GA8902@redhat.com>
References: <1347466967.15764.63.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347466967.15764.63.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12, Peter Zijlstra wrote:
>
> Oleg and Sebastian found that touching MSR_IA32_DEBUGCTLMSR from NMI
> context is problematic since the only way to change the various
> unrelated bits in there is:
>
>   debugctl = get_debugctlmsr()
>   /* frob flags in debugctl */
>   update_debugctlmsr(debugctl);
>
> Which is entirely unsafe if we prod at the MSR from NMI context.
>
> In particular the path that is responsible is:
>
>   x86_pmu_handle_irq() (NMI handler)
>     x86_pmu_stop()
>       x86_pmu.disable -> intel_pmu_disable_event()
>         intel_pmu_lbr_disable()
>           __intel_pmu_lbr_disable()
>             wrmsrl(MSR_IA32_DEBUGCTLMSR,... );

Not only.

x86_pmu_handle_irq() does intel_pmu_disable_all() and intel_pmu_enable_all(),
this leads to intel_pmu_enable_bts() and intel_pmu_disable_bts().

And those intel_pmu_*_bts() are also called by intel_pmu_disable_event()
and intel_pmu_enable_event(), the latter is probably fine.

Oleg.

