Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695Ab1CWLgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 07:36:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60372 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932242Ab1CWLgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 07:36:24 -0400
Date: Wed, 23 Mar 2011 12:36:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
        perfmon2-devel@lists.sf.net, paulus@samba.org, davem@davemloft.net
Subject: Re: [PATCH] perf_events: fix cgrp stale pointer in
 update_cgrp_time_from_cpuctx()
Message-ID: <20110323113601.GA27809@elte.hu>
References: <20110321151126.GA5084@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110321151126.GA5084@quad>
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


* Stephane Eranian <eranian@google.com> wrote:

> -	if (is_cgroup_event(event))
> +	if (is_cgroup_event(event)) {
>  		ctx->nr_cgroups--;
> +		cpuctx = __get_cpu_context(ctx);
> +		/*
> +		 * if there are no more cgroup events
> +		 * then clear cgrp to avoid stale pointer
> +		 * in update_cgrp_time_from_cpuctx()
> +		 */
> +		if (!ctx->nr_cgroups)
> +			cpuctx->cgrp = NULL;
> +	}

The ->cgrp pointer does not exist on !CGROUPS kernels. I suspect the cleanest 
approach would be to make those two cgrp fields available unconditionally in 
struct perf_event.

Thanks,

	Ingo
