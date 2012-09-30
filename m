Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374Ab2I3I4g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 04:56:36 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38486 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750792Ab2I3I4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 04:56:34 -0400
Message-ID: <1348995388.2458.8.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH v3 04/13] kmem accounting basic infrastructure
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Tejun Heo <tj@kernel.org>
Cc: Glauber Costa <glommer@parallels.com>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        devel@openvz.org, linux-mm@kvack.org,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Date: Sun, 30 Sep 2012 09:56:28 +0100
In-Reply-To: <20120930080249.GF10383@mtj.dyndns.org>
References: <506381B2.2060806@parallels.com>
	 <20120926224235.GB10453@mtj.dyndns.org> <50638793.7060806@parallels.com>
	 <20120926230807.GC10453@mtj.dyndns.org> <20120927142822.GG3429@suse.de>
	 <20120927144942.GB4251@mtj.dyndns.org> <50646977.40300@parallels.com>
	 <20120927174605.GA2713@localhost> <50649EAD.2050306@parallels.com>
	 <20120930075700.GE10383@mtj.dyndns.org>
	 <20120930080249.GF10383@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-09-30 at 17:02 +0900, Tejun Heo wrote:
> On Sun, Sep 30, 2012 at 04:57:00PM +0900, Tejun Heo wrote:
> > On Thu, Sep 27, 2012 at 10:45:01PM +0400, Glauber Costa wrote:
> > > > Can you please give other examples of cases where this type of issue
> > > > exists (plenty of shared kernel data structure which is inherent to
> > > > the workload at hand)?  Until now, this has been the only example for
> > > > this type of issues.
> > > 
> > > Yes. the namespace related caches (*), all kinds of sockets and network
> > > structures, other file system structures like file struct, vm areas, and
> > > pretty much everything a full container does.
> > > 
> > > (*) we run full userspace, so we have namespaces + cgroups combination.
> > 
> > This is probably me being dumb but wouldn't resources used by full
> > namespaces be mostly independent?  Which parts get shared?  Also, if
> > you do full namespace, isn't it more likely that you would want fuller
> > resource isolation too?
> 
> Just a thought about dentry/inode.  Would it make sense to count total
> number of references per cgroup and charge the total amount according
> to that?  Reference counts are how the shared ownership is represented
> after all.  Counting total per cgroup isn't accurate and pathological
> cases could be weird tho.

The beancounter approach originally used by OpenVZ does exactly this.
There are two specific problems, though, firstly you can't count
references in generic code, so now you have to extend the cgroup
tentacles into every object, an invasiveness which people didn't really
like.  Secondly split accounting causes oddities too, like your total
kernel memory usage can appear to go down even though you do nothing
just because someone else added a share.  Worse, if someone drops the
reference, your usage can go up, even though you did nothing, and push
you over your limit, at which point action gets taken against the
container.  This leads to nasty system unpredictability (The whole point
of cgroup isolation is supposed to be preventing resource usage in one
cgroup from affecting that in another).

We discussed this pretty heavily at the Containers Mini Summit in Santa
Rosa.  The emergent consensus was that no-one really likes first use
accounting, but it does solve all the problems and it has the fewest
unexpected side effects.

If you have an alternative that wasn't considered then, I'm sure
everyone would be interested, but it isn't split accounting.

James


