Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab0HWX4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 19:56:13 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47203 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158Ab0HWX4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 19:56:11 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 24 Aug 2010 08:51:11 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: linux-mm@kvack.org,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        gthelen@google.com, m-ikeda@ds.jp.nec.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kamezawa.hiroyuki@gmail.com
Subject: Re: [PATCH 2/5] memcg: use array and ID for quick look up
Message-Id: <20100824085111.6acf8881.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100823123533.b75b99c5.nishimura@mxp.nes.nec.co.jp>
References: <20100820185552.426ff12e.kamezawa.hiroyu@jp.fujitsu.com>
	<20100820185917.87876cb0.kamezawa.hiroyu@jp.fujitsu.com>
	<20100823123533.b75b99c5.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Aug 2010 12:35:33 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> Hi,
> 
> > +/* 0 is unused */
> > +static atomic_t mem_cgroup_num;
> > +#define NR_MEMCG_GROUPS (CONFIG_MEM_CGROUP_MAX_GROUPS + 1)
> > +static struct mem_cgroup *mem_cgroups[NR_MEMCG_GROUPS] __read_mostly;
> > +
> > +/* Must be called under rcu_read_lock */
> > +static struct mem_cgroup *id_to_memcg(unsigned short id)
> > +{
> > +	struct mem_cgroup *ret;
> > +	/* see mem_cgroup_free() */
> > +	ret = rcu_dereference_check(mem_cgroups[id], rch_read_lock_held());
> > +	if (likely(ret && ret->valid))
> > +		return ret;
> > +	return NULL;
> > +}
> > +
> I prefer "mem" to "ret".
> 
Hmm, ok.


> > @@ -2231,7 +2244,7 @@ __mem_cgroup_commit_charge_swapin(struct
> >  
> >  		id = swap_cgroup_record(ent, 0);
> >  		rcu_read_lock();
> > -		memcg = mem_cgroup_lookup(id);
> > +		memcg = id_to_memcg(id);
> >  		if (memcg) {
> >  			/*
> >  			 * This recorded memcg can be obsolete one. So, avoid
> > @@ -2240,9 +2253,10 @@ __mem_cgroup_commit_charge_swapin(struct
> >  			if (!mem_cgroup_is_root(memcg))
> >  				res_counter_uncharge(&memcg->memsw, PAGE_SIZE);
> >  			mem_cgroup_swap_statistics(memcg, false);
> > +			rcu_read_unlock();
> >  			mem_cgroup_put(memcg);
> > -		}
> > -		rcu_read_unlock();
> > +		} else
> > +			rcu_read_unlock();
> >  	}
> >  	/*
> >  	 * At swapin, we may charge account against cgroup which has no tasks.
> > @@ -2495,7 +2509,7 @@ void mem_cgroup_uncharge_swap(swp_entry_
> >  
> >  	id = swap_cgroup_record(ent, 0);
> >  	rcu_read_lock();
> > -	memcg = mem_cgroup_lookup(id);
> > +	memcg = id_to_memcg(id);
> >  	if (memcg) {
> >  		/*
> >  		 * We uncharge this because swap is freed.
> > @@ -2504,9 +2518,10 @@ void mem_cgroup_uncharge_swap(swp_entry_
> >  		if (!mem_cgroup_is_root(memcg))
> >  			res_counter_uncharge(&memcg->memsw, PAGE_SIZE);
> >  		mem_cgroup_swap_statistics(memcg, false);
> > +		rcu_read_unlock();
> >  		mem_cgroup_put(memcg);
> > -	}
> > -	rcu_read_unlock();
> > +	} else
> > +		rcu_read_unlock();
> >  }
> >  
> >  /**
> Could you explain why we need rcu_read_unlock() before mem_cgroup_put() ?
> I suspect that it's because mem_cgroup_put() can free the memcg, but do we
> need mem->valid then ?
> 
mem_cgroup_put() may call synchronize_rcu(). So, we have to unlock before it.

Thanks,
-Kame



