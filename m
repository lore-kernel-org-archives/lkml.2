Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab2EXGCO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 02:02:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43995 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973Ab2EXGCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 02:02:13 -0400
Date: Wed, 23 May 2012 23:02:10 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Dave Jones <davej@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v2] mm, oom: normalize oom scores to oom_score_adj scale
 only for userspace
In-Reply-To: <20120523153718.b70bb762.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1205232259040.15547@chino.kir.corp.google.com>
References: <20120426193551.GA24968@redhat.com> <alpine.DEB.2.00.1204261437470.28376@chino.kir.corp.google.com> <alpine.DEB.2.00.1205031513400.1631@chino.kir.corp.google.com> <20120503222949.GA13762@redhat.com> <alpine.DEB.2.00.1205171432250.6951@chino.kir.corp.google.com>
 <20120517145022.a99f41e8.akpm@linux-foundation.org> <alpine.DEB.2.00.1205230014450.9290@chino.kir.corp.google.com> <20120523153718.b70bb762.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2012, Andrew Morton wrote:

> > @@ -367,12 +354,13 @@ static struct task_struct *select_bad_process(unsigned int *ppoints,
> >  		}
> >  
> >  		points = oom_badness(p, memcg, nodemask, totalpages);
> > -		if (points > *ppoints) {
> > +		if (points > chosen_points) {
> >  			chosen = p;
> > -			*ppoints = points;
> > +			chosen_points = points;
> >  		}
> >  	} while_each_thread(g, p);
> >  
> > +	*ppoints = chosen_points * 1000 / totalpages;
> >  	return chosen;
> >  }
> >  
> 
> It's still not obvious that we always avoid the divide-by-zero here. 
> If there's some weird way of convincing constrained_alloc() to look at
> an empty nodemask, or a nodemask which covers only empty nodes then
> blam.
> 
> Now, it's probably the case that this is a can't-happen but that
> guarantee would be pretty convoluted and fragile?
> 

It can only happen for memcg with a zero limit, something I tried to 
prevent by not allowing tasks to be attached to the memcgs with such a 
limit in a different patch but you didn't like that :)

So I fixed it in this patch with this:

@@ -572,7 +560,7 @@ void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	}
 
 	check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, order, NULL);
-	limit = mem_cgroup_get_limit(memcg) >> PAGE_SHIFT;
+	limit = mem_cgroup_get_limit(memcg) >> PAGE_SHIFT ? : 1;
 	read_lock(&tasklist_lock);
 	p = select_bad_process(&points, limit, memcg, NULL, false);
 	if (p && PTR_ERR(p) != -1UL)

Cpusets do not allow threads to be attached without a set of mems or the 
final mem in a cpuset to be removed while tasks are still attached.  The 
page allocator certainly wouldn't be calling the oom killer for a set of 
zones that span no pages.

Any suggestion on where to put the check for !totalpages so it's easier to 
understand?
