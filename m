Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990Ab2IKRgK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 13:36:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516Ab2IKRgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 13:36:08 -0400
Date: Tue, 11 Sep 2012 13:35:25 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        Li Zefan <lizf@cn.fujitsu.com>, Glauber Costa <glommer@parallels.com>,
        Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Thomas Graf <tgraf@suug.ch>,
        "Serge E. Hallyn" <serue@us.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC cgroup/for-3.7] cgroup: mark subsystems with broken
 hierarchy support and whine if cgroups are nested for them
Message-ID: <20120911173524.GJ12039@redhat.com>
References: <20120910223125.GC7677@google.com>
 <20120911145106.GG12039@redhat.com>
 <20120911171601.GN7677@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120911171601.GN7677@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 10:16:01AM -0700, Tejun Heo wrote:
> Hello, Vivek.
> 
> On Tue, Sep 11, 2012 at 10:51:06AM -0400, Vivek Goyal wrote:
> > > * Move users away from using hierarchy on currently non-hierarchical
> > >   subsystems, so that implementing proper hierarchy support on those
> > >   doesn't surprise them.
> > 
> > I know two current/potential users. systemd and libvirt. They are
> > anyway going to create hierarchy irrespective of the fact whether
> > controller supports it or not.
> 
> systemd mounts all controllers by default but it only creates
> hierarchy for controllers other than cpu, so we're in the clear there.
> 
> > So even if we start screaming, nothing is going to change there, I 
> > suspect. Just that by default they expect every controller supports
> > hiearchies. 
> 
> As for libvirt, that's exactly the case where we want to be warning.
> The problem is that they're currently creating a hierarchy and
> expecting (or at least experiencing) flat behavior.  We want them to
> be either switch to explicit flat cgroups or at least know very well
> that they're doing something unsupported and the behavior will change
> beneath them.

It is kind of strange. First kernel allows creation of hiearchy for
non-hierarchical controllers and it also gives warning for user space to
not do that.

If creating hiearchy for flat controllers is wrong then kernel should
not allow it in first place and enforce it, instead of just giving a
warning to user space to not create the hierarchy.

Initially I had blocked the creation of hierarchy deeper than 1 level
but later had to remove it as people wanted libvirt to use blkio
controller and seemed to be fine with flat support. In fact there
were people who insisted on flat support as they thought that made
more sense.

> 
> > > * Keep track of which controllers are broken how and nudge the
> > >   subsystems to implement proper hierarchy support.
> > 
> > I thought we can easily keep track of this in a simple .txt file and
> > we really don't have to  provide explicit warnings.
> > 
> > I think for these controllers it is a known fact that they don't support
> > hiearchy yet. I am skeptical that providing explicit warnings is going
> > to help.
> 
> We should change blkio to support full hierarchy and soon and the
> current users of the broken hierarchy should be warned loudly and
> clearly; otherwise, this whole excercise is pointless,

Sure. Just that CFQ code now has become really complicated and messy
(especially with that 3 service trees per group) so making it hierarchical
is significant amount of effort.

And regarding change of behavior, we can always intoduce a .hierarchy
file like cgroup which needs to be explicitly set to make controller
truly hiearchical. That way behavior does not change in a subtle manner
in future kernel releases. (Not that I am a fan of hierarchy file, just
that it is cost we pay for not implementing hierarchical controller to
begin with).

Thanks
Vivek
