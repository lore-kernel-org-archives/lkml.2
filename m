Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651Ab2IKRHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 13:07:53 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:43493 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab2IKRHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 13:07:51 -0400
Date: Tue, 11 Sep 2012 10:07:46 -0700
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
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
Message-ID: <20120911170746.GL7677@google.com>
References: <20120910223125.GC7677@google.com>
 <20120910223355.GD7677@google.com>
 <20120911100433.GC8058@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120911100433.GC8058@dhcp22.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Michal.

On Tue, Sep 11, 2012 at 12:04:33PM +0200, Michal Hocko wrote:
> >  	cgroup_unlock();
> > @@ -4953,6 +4958,7 @@ mem_cgroup_create(struct cgroup *cont)
> >  						&per_cpu(memcg_stock, cpu);
> >  			INIT_WORK(&stock->work, drain_local_stock);
> >  		}
> > +		mem_cgroup_subsys.broken_hierarchy = !memcg->use_hierarchy;
> 
> Hmmm, this will warn even if we have
> root (default use_hierarchy=0)
>  \
>   A (use_hierarchy=1)
>    \
>     B <- here
> 
> which is unfortunate because it will add a noise to a reasonable
> configuration.

I suppose you're talking about having root group not performing any
accounting and/or control?  I suppose such could be a valid use case
(is it really necessary tho?)  but I don't think .use_hierarchy is the
right interface for that.  If it's absolutely necessary, I think it
should be a root-only flag (even if that ends up using the same code
path).  Eventually, we really want to kill .use_hierarchy, or at least
make it to RO 1.  As it's currently defined, it's just way too
confusing.

> >  		hotcpu_notifier(memcg_cpu_hotplug_callback, 0);
> >  	} else {
> >  		parent = mem_cgroup_from_cont(cont->parent);
> > --- a/net/core/netprio_cgroup.c
> > +++ b/net/core/netprio_cgroup.c
> > @@ -330,7 +330,17 @@ struct cgroup_subsys net_prio_subsys = {
> >  	.subsys_id	= net_prio_subsys_id,
> >  #endif
> >  	.base_cftypes	= ss_files,
> > -	.module		= THIS_MODULE
> > +	.module		= THIS_MODULE,
> > +
> > +	/*
> > +	 * net_prio has artificial limit on the number of cgroups and
> > +	 * disallows nesting making it impossible to co-mount it with other
> > +	 * hierarchical subsystems.  Remove the artificially low PRIOIDX_SZ
> > +	 * limit and properly nest configuration such that children follow
> > +	 * their parents' configurations by default and are allowed to
> > +	 * override and remove the following.
> > +	 */
> > +	.broken_hierarchy = trye,
> 
> typo

Heh, I thought I enabled all controllers.  Thanks. :)

-- 
tejun
