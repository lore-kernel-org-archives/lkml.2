Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321Ab2ILREX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:04:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54888 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212Ab2ILREC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 13:04:02 -0400
Date: Wed, 12 Sep 2012 10:03:57 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        Li Zefan <lizf@cn.fujitsu.com>, Peter Zijlstra <peterz@infradead.org>,
        Paul Turner <pjt@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Graf <tgraf@suug.ch>, "Serge E. Hallyn" <serue@us.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC cgroup/for-3.7] cgroup: mark subsystems with broken
 hierarchy support and whine if cgroups are nested for them
Message-ID: <20120912170357.GN7677@google.com>
References: <20120910223125.GC7677@google.com>
 <505055E5.90903@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505055E5.90903@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Glauber.

On Wed, Sep 12, 2012 at 01:29:09PM +0400, Glauber Costa wrote:
> Haven't gone through the whole patch yet, and not sure how you actually
> touch memcg in here. And I absolutely know we have discussed this
> before, but I still stand that for the memcg case, in which hierarchy
> can be enabled by a crazy boolean, we should be enabling it somehow. It
> is fine if we don't want to change the default without warning first,
> but a Kconfig option to make this default would really help. We should
> tell everybody with a well defined lifecycle to just enable it.

I'm not really sure how useful the Kconfig would be.  I'm not gonna
nack it but am not sure it's useful either.  Michal seems to be in the
same boat, so I suppose there's no strong opposition.

I don't think it would make life easier for distros.  It could differ
depending on distros but in my experience with SUSE trivial patches
flipping the default aren't big deals especially if upstream has
transition plan in place.  The difficulty here is that somebody needs
to assess the situation and preferably make that decision conciously -
the mechanism to do so be it a one liner patch or Kconfig option
doesn't really matter and across the transition period we would want
to keep the memcg behavior consistent regardless which kernel is in
use.

The problem with Kconfig is that we shouldn't enable the new behavior
by default as that would change the behavior silently and if we can't
do that it's just something which is buried under the sea of config
options.  Kconfig or no, we need to coordinate with the distros.

>From upstream, my current plan for .use_hierarchy is

* Warn about broken hierarchy usage in increasing verbosity.

* After a couple releases, warn about creating any mem cgroup if
  .use_hierarchy == 0 at root.

* After a couple releases, switch .use_hierarchy to 1 by default and
  loudly warn on any attempts to set it to zero.

* Rip out flat hierarchy support and fail any attempt to set
  .use_hierarchy to 0.

It'll take some months but I don't think it's too crazy and I think
the whole process should take longer than eight months to ensure any
active distro notices it.

Distros should set .use_hierarchy to 1 on mounting memcg.  This
probably should happen on a new release w/ accompanying release note.
I'll try to coordinate it at least for the popular ones.

> > +	 * It's now diallowed to create nested cgroups if the subsystem is
> typo, disallowed.

Ooh, will fix.

> > +	 * broken and cgroup core will emit a warning message on such
> > +	 * cases.  Eventually, all subsystems will be made properly
> > +	 * hierarchical and this will go away.
> > +	 */
> > +	bool broken_hierarchy;
> > +	bool warned_broken_hierarchy;
> > +
> 
> why do we need the extra bool? Isn't WARN_ON_ONCE() suitable here?

We want to warn once per subsys instead of once for the whole system.

> > +	/*
> > +	 * net_prio has artificial limit on the number of cgroups and
> > +	 * disallows nesting making it impossible to co-mount it with other
> > +	 * hierarchical subsystems.  Remove the artificially low PRIOIDX_SZ
> > +	 * limit and properly nest configuration such that children follow
> > +	 * their parents' configurations by default and are allowed to
> > +	 * override and remove the following.
> > +	 */
> > +	.broken_hierarchy = trye,
> >  };
> 
> "trye" doesn't seem to be a recognized word.

Yeah, fixed.

> >  static int netprio_device_event(struct notifier_block *unused,
> > --- a/net/sched/cls_cgroup.c
> > +++ b/net/sched/cls_cgroup.c
> > @@ -82,6 +82,15 @@ struct cgroup_subsys net_cls_subsys = {
> >  #endif
> >  	.base_cftypes	= ss_files,
> >  	.module		= THIS_MODULE,
> > +
> > +	/*
> > +	 * While net_cls cgroup has the rudimentary hierarchy support of
> > +	 * inheriting the parent's classid on cgroup creation, it doesn't
> > +	 * properly propagates config changes in ancestors to their
> > +	 * descendents.  A child should follow the parent's configuration
> > +	 * but be allowed to override it.  Fix it and remove the following.
> > +	 */
> > +	.broken_hierarchy = true,
> >  };
> >  
> 
> Since all this cgroup provides is a marking, it is not terribly obvious
> to me what "proper hierarchy" would mean. Input from the authors would
> be strongly advisable here.

Setting mark on a parent should be reflected on all its children w/o
their own explicit settings.

Thanks.

-- 
tejun
