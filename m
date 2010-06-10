Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759364Ab0FJOz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 10:55:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43457 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759300Ab0FJOzz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 10:55:55 -0400
Subject: Re: [PATCH] [10/23] SCHED: Only allocate per cpu cpu mask buffer
 with offstack cpumasks
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100610145243.GC19561@basil.fritz.box>
References: <20100610110.764742110@firstfloor.org>
	 <20100610111046.18EB4B1A2B@basil.firstfloor.org>
	 <1276181030.2077.399.camel@twins>  <20100610145243.GC19561@basil.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 10 Jun 2010 16:55:43 +0200
Message-ID: <1276181743.2077.426.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-10 at 16:52 +0200, Andi Kleen wrote:
> > This patch will actually break things.. please read the code.
> > 
> > I guess we could move the unsigned long into that block, but I really
> > don't see the point.
> 
> How does it break things? 
> 
> ptr is not used for anything unless that define is set. gcc doesn't
> lie on this.

        if (alloc_size) {
                ptr = (unsigned long)kzalloc(alloc_size, GFP_NOWAIT);

#ifdef CONFIG_FAIR_GROUP_SCHED
                init_task_group.se = (struct sched_entity **)ptr;
                ptr += nr_cpu_ids * sizeof(void **);

                init_task_group.cfs_rq = (struct cfs_rq **)ptr;
                ptr += nr_cpu_ids * sizeof(void **);

#endif /* CONFIG_FAIR_GROUP_SCHED */
#ifdef CONFIG_RT_GROUP_SCHED
                init_task_group.rt_se = (struct sched_rt_entity **)ptr;
                ptr += nr_cpu_ids * sizeof(void **);

                init_task_group.rt_rq = (struct rt_rq **)ptr;
                ptr += nr_cpu_ids * sizeof(void **);

#endif /* CONFIG_RT_GROUP_SCHED */
#ifdef CONFIG_CPUMASK_OFFSTACK
                for_each_possible_cpu(i) {
                        per_cpu(load_balance_tmpmask, i) = (void *)ptr;
                        ptr += cpumask_size();
                }
#endif /* CONFIG_CPUMASK_OFFSTACK */
        }

