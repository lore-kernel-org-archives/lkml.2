Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab0IPG1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 02:27:12 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47535 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab0IPG1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 02:27:11 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 16 Sep 2010 15:22:04 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH][-mm] memcg : memory cgroup cpu hotplug support update.
Message-Id: <20100916152204.6c457936.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100916062159.GF22371@balbir.in.ibm.com>
References: <20100916144618.852b7e9a.kamezawa.hiroyu@jp.fujitsu.com>
	<20100916062159.GF22371@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Sep 2010 11:51:59 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-09-16 14:46:18]:
> 
> > This is onto The mm-of-the-moment snapshot 2010-09-15-16-21.
> > 
> > ==
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > Now, memory cgroup uses for_each_possible_cpu() for percpu stat handling.
> > It's just because cpu hotplug handler doesn't handle them.
> > On the other hand, per-cpu usage counter cache is maintained per cpu and
> > it's cpu hotplug aware.
> > 
> > This patch adds a cpu hotplug hanlder and replaces for_each_possible_cpu()
> > with for_each_online_cpu(). And this merges new callbacks with old
> > callbacks.(IOW, memcg has only one cpu-hotplug handler.)
> >
> 
> Thanks for accepting my suggestion on get_online_cpus() and for
> working on these patches, this is the right way forward
>  
I just like step-by-step patches.


> > For this purpose, mem_cgroup_walk_all() is added.
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > ---
> >  mm/memcontrol.c |  118 ++++++++++++++++++++++++++++++++++++++++++++++----------
> >  1 file changed, 98 insertions(+), 20 deletions(-)
> > 
> > Index: mmotm-0915/mm/memcontrol.c
> > ===================================================================
> > --- mmotm-0915.orig/mm/memcontrol.c
> > +++ mmotm-0915/mm/memcontrol.c
> > @@ -89,7 +89,10 @@ enum mem_cgroup_stat_index {
> >  	MEM_CGROUP_STAT_PGPGIN_COUNT,	/* # of pages paged in */
> >  	MEM_CGROUP_STAT_PGPGOUT_COUNT,	/* # of pages paged out */
> >  	MEM_CGROUP_STAT_SWAPOUT, /* # of pages, swapped out */
> > -	MEM_CGROUP_EVENTS,	/* incremented at every  pagein/pageout */
> > +	MEM_CGROUP_STAT_DATA,    /* stat above this is for statistics */
> > +
> > +	MEM_CGROUP_EVENTS = MEM_CGROUP_STAT_DATA,
> > +				/* incremented at every  pagein/pageout */
> >  	MEM_CGROUP_ON_MOVE,	/* someone is moving account between groups */
> > 
> >  	MEM_CGROUP_STAT_NSTATS,
> > @@ -537,7 +540,7 @@ static s64 mem_cgroup_read_stat(struct m
> >  	int cpu;
> >  	s64 val = 0;
> > 
> > -	for_each_possible_cpu(cpu)
> > +	for_each_online_cpu(cpu)
> >  		val += per_cpu(mem->stat->count[idx], cpu);
> >  	return val;
> >  }
> > @@ -700,6 +703,35 @@ static inline bool mem_cgroup_is_root(st
> >  	return (mem == root_mem_cgroup);
> >  }
> > 
> > +static int mem_cgroup_walk_all(void *data,
> > +		int (*func)(struct mem_cgroup *, void *))
> 
> Can we call this for_each_mem_cgroup()?
> 

This naming is from mem_cgroup_walk_tree(). Now we have

  mem_cgroup_walk_tree();
  mem_cgroup_walk_all();

Rename both ? But it should be in separated patch.

Thanks,
-Kame

