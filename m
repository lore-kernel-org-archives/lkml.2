Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab1FOAXy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 20:23:54 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51973 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab1FOAXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 20:23:52 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 15 Jun 2011 09:16:52 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <jweiner@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Ying Han <yinghan@google.com>
Subject: Re: [BUGFIX][PATCH 5/5] memcg: fix percpu cached charge draining
 frequency
Message-Id: <20110615091652.7d29baca.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110614100412.GE6371@redhat.com>
References: <20110613120054.3336e997.kamezawa.hiroyu@jp.fujitsu.com>
	<20110613121648.3d28afcd.kamezawa.hiroyu@jp.fujitsu.com>
	<20110614100412.GE6371@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jun 2011 12:04:12 +0200
Johannes Weiner <jweiner@redhat.com> wrote:

> On Mon, Jun 13, 2011 at 12:16:48PM +0900, KAMEZAWA Hiroyuki wrote:
> > @@ -1670,8 +1670,8 @@ static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
> >  		victim = mem_cgroup_select_victim(root_mem);
> >  		if (victim == root_mem) {
> >  			loop++;
> > -			if (loop >= 1)
> > -				drain_all_stock_async();
> > +			if (!check_soft && loop >= 1)
> > +				drain_all_stock_async(root_mem);
> 
> I agree with Michal, this should be a separate change.
> 

Hm, ok, I'll do.

> > @@ -2008,26 +2011,50 @@ static void refill_stock(struct mem_cgroup *mem, unsigned int nr_pages)
> >   * expects some charges will be back to res_counter later but cannot wait for
> >   * it.
> >   */
> > -static void drain_all_stock_async(void)
> > +static void drain_all_stock_async(struct mem_cgroup *root_mem)
> >  {
> > -	int cpu;
> > -	/* This function is for scheduling "drain" in asynchronous way.
> > -	 * The result of "drain" is not directly handled by callers. Then,
> > -	 * if someone is calling drain, we don't have to call drain more.
> > -	 * Anyway, WORK_STRUCT_PENDING check in queue_work_on() will catch if
> > -	 * there is a race. We just do loose check here.
> > +	int cpu, curcpu;
> > +	/*
> > +	 * If someone calls draining, avoid adding more kworker runs.
> >  	 */
> > -	if (atomic_read(&memcg_drain_count))
> > +	if (!mutex_trylock(&percpu_charge_mutex))
> >  		return;
> >  	/* Notify other cpus that system-wide "drain" is running */
> > -	atomic_inc(&memcg_drain_count);
> >  	get_online_cpus();
> > +
> > +	/*
> > +	 * get a hint for avoiding draining charges on the current cpu,
> > +	 * which must be exhausted by our charging. But this is not
> > +	 * required to be a precise check, We use raw_smp_processor_id()
> > +	 * instead of getcpu()/putcpu().
> > +	 */
> > +	curcpu = raw_smp_processor_id();
> >  	for_each_online_cpu(cpu) {
> >  		struct memcg_stock_pcp *stock = &per_cpu(memcg_stock, cpu);
> > -		schedule_work_on(cpu, &stock->work);
> > +		struct mem_cgroup *mem;
> > +
> > +		if (cpu == curcpu)
> > +			continue;
> > +
> > +		mem = stock->cached;
> > +		if (!mem)
> > +			continue;
> > +		if (mem != root_mem) {
> > +			if (!root_mem->use_hierarchy)
> > +				continue;
> > +			/* check whether "mem" is under tree of "root_mem" */
> > +			rcu_read_lock();
> > +			if (!css_is_ancestor(&mem->css, &root_mem->css)) {
> > +				rcu_read_unlock();
> > +				continue;
> > +			}
> > +			rcu_read_unlock();
> 
> css_is_ancestor() takes the rcu read lock itself already.
> 

you're right.

I'll post an update.

Thanks,
-Kame

