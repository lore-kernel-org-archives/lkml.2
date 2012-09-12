Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab2ILPr4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 11:47:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58044 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960Ab2ILPry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 11:47:54 -0400
Date: Wed, 12 Sep 2012 17:47:45 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Glauber Costa <glommer@parallels.com>,
        Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Thomas Graf <tgraf@suug.ch>,
        "Serge E. Hallyn" <serue@us.ibm.com>, Vivek Goyal <vgoyal@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH REPOST RFC cgroup/for-3.7] cgroup: mark subsystems with
 broken hierarchy support and whine if cgroups are nested for them
Message-ID: <20120912154745.GV21579@dhcp22.suse.cz>
References: <20120910223125.GC7677@google.com>
 <20120910223355.GD7677@google.com>
 <20120911100433.GC8058@dhcp22.suse.cz>
 <20120911170746.GL7677@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120911170746.GL7677@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 11-09-12 10:07:46, Tejun Heo wrote:
> Hello, Michal.
> 
> On Tue, Sep 11, 2012 at 12:04:33PM +0200, Michal Hocko wrote:
> > >  	cgroup_unlock();
> > > @@ -4953,6 +4958,7 @@ mem_cgroup_create(struct cgroup *cont)
> > >  						&per_cpu(memcg_stock, cpu);
> > >  			INIT_WORK(&stock->work, drain_local_stock);
> > >  		}
> > > +		mem_cgroup_subsys.broken_hierarchy = !memcg->use_hierarchy;
> > 
> > Hmmm, this will warn even if we have
> > root (default use_hierarchy=0)
> >  \
> >   A (use_hierarchy=1)
> >    \
> >     B <- here
> > 
> > which is unfortunate because it will add a noise to a reasonable
> > configuration.
> 
> I suppose you're talking about having root group not performing any
> accounting and/or control?

It doesn't do any controlling because you cannot set any limit for it.
Root cgroup has always been special.

> I suppose such could be a valid use case
> (is it really necessary tho?)  but I don't think .use_hierarchy is the
> right interface for that.  

I am not sure I understand what you mean by that. My only concern with
is that we shouldn't complain if somebody doesn't do anything wrong.
And creating a group under root without any other children, no matter
what use_hierarchy says, is a valid use case and we shouldn't make too
much noise about that.
The only difference in such a use case is that hierarchical stats will
include numbers from the group only if root had use_hierarchy==1. There
are no other side effects.

> If it's absolutely necessary, I think it should be a root-only flag
> (even if that ends up using the same code path).  Eventually, we
> really want to kill .use_hierarchy, or at least make it to RO 1.  As
> it's currently defined, it's just way too confusing.

Agreed on that, definitely.

-- 
Michal Hocko
SUSE Labs
