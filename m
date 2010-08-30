Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab0H3R33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 13:29:29 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:46471 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042Ab0H3R32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 13:29:28 -0400
Date: Mon, 30 Aug 2010 22:50:31 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>, Chris Friesen <cfriesen@nortel.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Pierre Bourdon <pbourdon@excellency.fr>
Subject: Re: [RFC][PATCH 1/3] sched: Rewrite tg_shares_up
Message-ID: <20100830172031.GA17281@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20100828223025.054328145@chello.nl>
 <20100828223546.952988054@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100828223546.952988054@chello.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 29, 2010 at 12:30:26AM +0200, Peter Zijlstra wrote:
> By tracking a per-cpu load-avg for each cfs_rq and folding it into a
> global task_group load on each tick we can rework tg_shares_up to be
> strictly per-cpu.

So tg->load_weight is supposed to represent more or less current task load
across all cpus? I see only atomic_add() to it - which means it can only keep
growing or remain constant - IOW capturing the historical load even since
the task group was started? I was expecting it to reduce based on how a group 
goes idle, otherwise 

> +static void update_cfs_shares(struct cfs_rq *cfs_rq)
> +{
> +	struct task_group *tg;
> +	struct sched_entity *se;
> +	unsigned long load_weight, load, shares;
> +
> +	if (!cfs_rq)
> +		return;
> +
> +	tg = cfs_rq->tg;
> +	se = tg->se[cpu_of(rq_of(cfs_rq))];
> +	if (!se)
> +		return;
> +
> +	load = cfs_rq->load.weight;
> +
> +	load_weight = atomic_read(&tg->load_weight);
> +	load_weight -= cfs_rq->load_contribution;
> +	load_weight += load;
> +
> +	shares = (tg->shares * load);
> +	if (load_weight)
> +		shares /= load_weight;

this seem incorrect? Even though we have corrected tg->load_weight to reflect
current load on 'cfs_rq', tg->load_weight still captures historical load on
other cpus and hence could be a large #, making the division inaccurate?

Also I wonder how much of a hot spot tg->load_weight would become ..

- vatsa
