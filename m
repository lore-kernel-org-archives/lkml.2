Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab1FISgf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 14:36:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:35196 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab1FISge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 14:36:34 -0400
Subject: Re: [PATCH 2/3] perf_events: fix validation of events using an
 extra reg (v4)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, andi@firstfloor.org,
        ming.m.lin@intel.com
In-Reply-To: <20110606145708.GA7279@quad>
References: <20110606145708.GA7279@quad>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Jun 2011 20:40:12 +0200
Message-ID: <1307644812.2497.1022.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-06 at 16:57 +0200, Stephane Eranian wrote:
> +static struct cpu_hw_events *allocate_fake_cpuc(void)
> +{
> +       struct cpu_hw_events *cpuc;
> +       int cpu = smp_processor_id();

That's a boo-boo, clearly we are in a preemptible context here (see the
GFP_KERNEL allocation on the next line), so using smp_processor_id()
isn't valid.

Now since all that allocate_shared_regs() does with it is pick a NUMA
node, we should probably use raw_smp_processor_id() and leave it at
that, right?

> +       cpuc = kzalloc(sizeof(*cpuc), GFP_KERNEL);
> +       if (!cpuc)
> +               return ERR_PTR(-ENOMEM);
> +
> +       /* only needed, if we have extra_regs */
> +       if (x86_pmu.extra_regs) {
> +               cpuc->shared_regs = allocate_shared_regs(cpu);
> +               if (!cpuc->shared_regs)
> +                       goto error;
> +       }
> +       return cpuc;
> +error:
> +       free_fake_cpuc(cpuc);
> +       return ERR_PTR(-ENOMEM);
> +} 

