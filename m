Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910Ab2INO0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 10:26:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752493Ab2INO0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 10:26:16 -0400
Date: Fri, 14 Sep 2012 10:25:39 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Michal Hocko <mhocko@suse.cz>, Glauber Costa <glommer@parallels.com>,
        Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Thomas Graf <tgraf@suug.ch>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>
Subject: Re: [RFC] cgroup TODOs
Message-ID: <20120914142539.GC6221@redhat.com>
References: <20120913205827.GO7677@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120913205827.GO7677@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 01:58:27PM -0700, Tejun Heo wrote:

[..]
>   * blkio is the most problematic.  It has two sub-controllers - cfq
>     and blk-throttle.  Both are utterly broken in terms of hierarchy
>     support and the former is known to have pretty hairy code base.  I
>     don't see any other way than just biting the bullet and fixing it.

I am still little concerned about changing the blkio behavior
unexpectedly. Can we have some kind of mount time flag which retains
the old flat behavior and we warn user that this mode is deprecated
and will soon be removed. Move over to hierarchical mode. Then after
few release we can drop the flag and cleanup any extra code which
supports flat mode in CFQ. This will atleast make transition smooth.

> 
>   * cgroup_freezer and others shouldn't be too difficult to fix.
> 
>   Who:
> 
>   memcg can be handled by memcg people and I can handle cgroup_freezer
>   and others with help from the authors.  The problematic one is
>   blkio.  If anyone is interested in working on blkio, please be my
>   guest.  Vivek?  Glauber?

I will try to spend some time on this. Doing changes in blk-throttle
should be relatively easy. Painful part if CFQ. It does so much that
it is not clear whether a particular change will bite us badly or
not. So doing changes becomes hard. There are heuristics, preemptions,
queue selection logic, service tree and bringing it all together
for full hierarchy becomes interesting.

I think first thing which needs to be done is merge group scheduling
and cfqq scheduling. Because of flat hierarchy currently we use two
scheduling algorithm. Old logic for queue selection and new logic
for group scheduling. If we treat task and group at same level then
we have to merge two and come up with single logic.

Glauber feel free to jump into it if you like to. We can sort it out
together.

[..]
>   * Vivek brought up the issue of distributing resources to tasks and
>     groups in the same cgroup.  I don't know.  Need to think more
>     about it.

This one will require some thought. I have heard arguments for both the
models. Treating tasks and groups at same level seem to have one
disadvantange and that is that people can't think of system resources
in terms of %. People often say, give 20% of disk resources to a
particular cgroup. But it is not possible as there are all kernel
threads running in root cgroup and tasks come and go and that means
% share of a group is variable and not fixed.

To make it fixed, we will need to make sure that number of entities
fighting for resources are not variable. That means only group fight
for resources at a level and tasks with-in groups. 

Now the question is should kernel enforce it or should it be left to 
user space. I think doing it in user space is also messy as different
agents control different part of hiearchy. For example, if somebody says
that give a particular virtual machine a x% of system resource, libvirt
has no way to do that. At max it can ensure x% of parent group but above
that hierarchy is controlled by systemd and libvirtd has no control
over that.

Only possible way to do this will seem to be that systemd creates libvirt
group at top level with a minimum fixed % of quota and then libvirt can
figure out % share of each virtual machine. But it is hard to do.

So while % model is more intutive to users, it is hard to implement. So
an easier way is to stick to the model of relative weights/share and
let user specify relative importance of a virtual machine and actual
quota or % will vary dynamically depending on other tasks/components
in the system.

Thoughts?

Thanks
Vivek
