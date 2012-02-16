Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab2BPMZw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 07:25:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:57765 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab2BPMZu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 07:25:50 -0500
Message-ID: <1329395138.2293.206.camel@twins>
Subject: Re: [RFC PATCH 04/14] sched: maintain the load contribution of
 blocked entities
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Thu, 16 Feb 2012 13:25:38 +0100
In-Reply-To: <20120202013826.20844.16743.stgit@kitami.mtv.corp.google.com>
References: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
	 <20120202013826.20844.16743.stgit@kitami.mtv.corp.google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-01 at 17:38 -0800, Paul Turner wrote:
> +static inline void subtract_blocked_load_contrib(struct cfs_rq *cfs_rq,
> +                                                long load_contrib)
> +{
> +       if (likely(load_contrib < cfs_rq->blocked_load_avg))
> +               cfs_rq->blocked_load_avg -= load_contrib;
> +       else
> +               cfs_rq->blocked_load_avg = 0;
> +}
> +
>  /* Update a sched_entity's runnable average */
> -static inline void update_entity_load_avg(struct sched_entity *se)
> +static inline void update_entity_load_avg(struct sched_entity *se,
> +                                         int update_cfs_rq)
>  {
>         struct cfs_rq *cfs_rq = cfs_rq_of(se);
>         long contrib_delta;
> @@ -1106,8 +1130,34 @@ static inline void update_entity_load_avg(struct sched_entity *se)
>                 return;
>  
>         contrib_delta = __update_entity_load_avg_contrib(se);
> +
> +       if (!update_cfs_rq)
> +               return;
> +
>         if (se->on_rq)
>                 cfs_rq->runnable_load_avg += contrib_delta;
> +       else
> +               subtract_blocked_load_contrib(cfs_rq, -contrib_delta);
> +} 

So that last bit is add_blocked_load_contrib(), right? 
