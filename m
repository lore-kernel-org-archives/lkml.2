Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759126Ab2ILOYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 10:24:12 -0400
Received: from [205.233.59.134] ([205.233.59.134]:50895 "EHLO
	merlin.infradead.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758417Ab2ILOYL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:24:11 -0400
Message-ID: <1347459764.15764.32.camel@twins>
Subject: Re: [PATCH v2 2/3] perf: use hrtimer for event multiplexing
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        zheng.z.yan@intel.com, robert.richter@amd.com
Date: Wed, 12 Sep 2012 16:22:44 +0200
In-Reply-To: <1347459195-5491-3-git-send-email-eranian@google.com>
References: <1347459195-5491-1-git-send-email-eranian@google.com>
	 <1347459195-5491-3-git-send-email-eranian@google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-12 at 16:13 +0200, Stephane Eranian wrote:
> +static DEFINE_PER_CPU(struct list_head, rotation_list);

Why do you keep the rotation list? The only use seems to be:


> +void perf_cpu_hrtimer_cancel(int cpu)
> +{
> +       struct list_head *head = &__get_cpu_var(rotation_list);
> +       struct perf_cpu_context *cpuctx, *tmp;
> +       unsigned long flags;
> +
> +       if (WARN_ON(cpu != smp_processor_id()))
> +               return;
> +
> +       local_irq_save(flags);
> +
> +       list_for_each_entry_safe(cpuctx, tmp, head, rotation_list) {
> +               if (cpuctx->hrtimer_active) {
> +                       hrtimer_cancel(&cpuctx->hrtimer);
> +                       cpuctx->hrtimer_active = 0;
> +               }
> +       }
> +
> +       local_irq_restore(flags);
> +}

Which is weird, why not use the existing for-each-pmu loop in
perf_event_exit_cpu_context() ? Or something similar to iterate all
extant PMUs and thus their cpuctxs?

Also, you can do away with hrtimer_active, you can hrtimer_cancel() on
an inactive hrtimer just fine, it will DTRT.
