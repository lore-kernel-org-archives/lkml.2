Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab2INN7N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 09:59:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755173Ab2INN7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 09:59:07 -0400
Date: Fri, 14 Sep 2012 09:58:30 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Daniel P. Berrange" <berrange@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>, Michal Hocko <mhocko@suse.cz>,
        Paul Mackerras <paulus@samba.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Johannes Weiner <hannes@cmpxchg.org>, Thomas Graf <tgraf@suug.ch>,
        "Serge E. Hallyn" <serue@us.ibm.com>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC] cgroup TODOs
Message-ID: <20120914135830.GB6221@redhat.com>
References: <20120913205827.GO7677@google.com>
 <20120914091032.GA6819@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120914091032.GA6819@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 10:10:32AM +0100, Daniel P. Berrange wrote:

[..]
> > 6. Multiple hierarchies
> > 
> >   Apart from the apparent wheeeeeeeeness of it (I think I talked about
> >   that enough the last time[1]), there's a basic problem when more
> >   than one controllers interact - it's impossible to define a resource
> >   group when more than two controllers are involved because the
> >   intersection of different controllers is only defined in terms of
> >   tasks.
> > 
> >   IOW, if an entity X is of interest to two controllers, there's no
> >   way to map X to the cgroups of the two controllers.  X may belong to
> >   A and B when viewed by one task but A' and B when viewed by another.
> >   This already is a head scratcher in writeback where blkcg and memcg
> >   have to interact.
> > 
> >   While I am pushing for unified hierarchy, I think it's necessary to
> >   have different levels of granularities depending on controllers
> >   given that nesting involves significant overhead and noticeable
> >   controller-dependent behavior changes.
> > 
> >   Solution:
> > 
> >   I think a unified hierarchy with the ability to ignore subtrees
> >   depending on controllers should work.  For example, let's assume the
> >   following hierarchy.
> > 
> >           R
> > 	/   \
> >        A     B
> >       / \
> >      AA AB
> > 
> >   All controllers are co-mounted.  There is per-cgroup knob which
> >   controls which controllers nest beyond it.  If blkio doesn't want to
> >   distinguish AA and AB, the user can specify that blkio doesn't nest
> >   beyond A and blkio would see the tree as,
> > 
> >           R
> > 	/   \
> >        A     B
> > 
> >   While other controllers keep seeing the original tree.  The exact
> >   form of interface, I don't know yet.  It could be a single file
> >   which the user echoes [-]controller name into it or per-controller
> >   boolean file.
> > 
> >   I think this level of flexibility should be enough for most use
> >   cases.  If someone disagrees, please voice your objections now.

Tejun, Daniel,

I am little concerned about above and wondering how systemd and libvirt
will interact and behave out of the box.

Currently systemd does not create its own hierarchy under blkio and
libvirt does. So putting all together means there is no way to avoid
the overhead of systemd created hierarchy.

\
|
+- system
     |
     +- libvirtd.service
              |
              +- virt-machine1
              +- virt-machine2

So there is now way to avoid the overhead of two levels of hierarchy
created by systemd. I really wish that systemd gets rid of "system"
cgroup and puts services directly in top level group. Creating deeper
hieararchices is expensive.

I just want to mention it clearly that with above model, it will not
be possible for libvirt to avoid hierarchy levels created by systemd.
So solution would be to keep depth of hierarchy as low as possible and
to keep controller overhead as low as possible.

Now I know that with blkio idling kills performance. So one solution
could be that on anything fast, don't use CFQ. Use deadline and then
group idling overhead goes away and tools like systemd and libvirt don't
have to worry about keeping track of disks and what scheduler is running.
They don't want to do it and expect kernel to get it right.

But getting that right out of box does not happen as of today as CFQ
is default on everything. Distributions can carry their own patches
to do some approximation, but it would be better to have a better
mechanism in kernel to select better IO scheduler out of box for a
storage lun. It is more important now then even since blkio controller
has come into picture.

Above is the scenario I am most worried about where CFQ shows up by default
on all the luns, systemd and libvirt create 4-5 level deep hierarchies
by default and IO performance sucks out of the box. Already CFQ underforms
for fast storage and with group creation problem becomes worse.

Thanks
Vivek
