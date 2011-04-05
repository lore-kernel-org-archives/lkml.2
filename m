Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab1DEN2n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 09:28:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48268 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab1DEN20 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 09:28:26 -0400
Subject: Re: [patch 03/15] sched: accumulate per-cfs_rq cpu usage
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Nikhil Rao <ncrao@google.com>
In-Reply-To: <20110323030448.950261975@google.com>
References: <20110323030326.789836913@google.com>
	 <20110323030448.950261975@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 05 Apr 2011 15:28:18 +0200
Message-ID: <1302010098.2225.1330.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-22 at 20:03 -0700, Paul Turner wrote:
> +static void request_cfs_rq_quota(struct cfs_rq *cfs_rq)
> +{
> +       struct task_group *tg = cfs_rq->tg;
> +       struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
> +       u64 amount = 0, min_amount;
> +
> +       min_amount = sched_cfs_bandwidth_slice() + (-cfs_rq->quota_remaining);
> +
> +       if (cfs_b->runtime > 0 || cfs_b->quota == RUNTIME_INF) {
> +               raw_spin_lock(&cfs_b->lock);
> +               if (cfs_b->quota != RUNTIME_INF) {
> +                       amount = min(cfs_b->runtime, min_amount);
> +                       cfs_b->runtime -= amount;
> +               } else {
> +                       amount = min_amount;
> +               }

So why would quota be RUNTIME_INF and quota_enabled be true? If its due
to a race when fiddling with the cgroup filesystem setting things up
that else branch wants a comment, if its for another reason all together
there's also a comment missing somewhere ;-)

> +               raw_spin_unlock(&cfs_b->lock);
> +       }
> +
> +       cfs_rq->quota_remaining += amount;
> +}
> +
> +static void account_cfs_rq_quota(struct cfs_rq *cfs_rq,
> +               unsigned long delta_exec)
> +{
> +       if (!cfs_rq->quota_enabled)
> +               return;
> +
> +       cfs_rq->quota_remaining -= delta_exec;
> +
> +       if (cfs_rq->quota_remaining > 0)
> +               return;
> +
> +       request_cfs_rq_quota(cfs_rq);
> +} 
