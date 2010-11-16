Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932790Ab0KPODN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 09:03:13 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:52611 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932311Ab0KPODL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 09:03:11 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1961D9f9il6xI2FM5L0XcJKUJ6UvbZGXjn4gFgg39
	kGfn/GnjnXlip6
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: Mike Galbraith <efault@gmx.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <20101116015648.GA11534@redhat.com>
References: <AANLkTimHtjH3YvtX6i542_XjfFeuvG-AnU8i224a1R4j@mail.gmail.com>
	 <1289778189.5154.10.camel@maggy.simson.net>
	 <AANLkTimwSktAQ5PkXNGY2EQz71DFmKY3Bt2fbZYasD0G@mail.gmail.com>
	 <AANLkTi=fT-DCP40_U24zft-3owseW24px=Zq=LnEJ_FF@mail.gmail.com>
	 <1289783580.495.58.camel@maggy.simson.net>
	 <1289811438.2109.474.camel@laptop>
	 <1289820766.16406.45.camel@maggy.simson.net>
	 <1289821590.16406.47.camel@maggy.simson.net>
	 <20101115125716.GA22422@redhat.com>
	 <1289856350.14719.135.camel@maggy.simson.net>
	 <20101116015648.GA11534@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Nov 2010 07:02:51 -0700
Message-ID: <1289916171.5169.117.camel@maggy.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-15 at 20:56 -0500, Vivek Goyal wrote:

> Mike,
> 
> IIUC, this automatically created task group is invisible to user space? I
> mean generally there is a task group associated with a cgroup and user space
> tools can walk through cgroup hierarchy to figure out how system is
> configured. Will that be possible with this patch.

No, it's dirt simple automation only at this point.

> I am wondering what will happen to things like some kind of per cgroup
> stats. For example block controller keeps track of number of sectors
> transferred per cgroup. Hence this information will not be available for
> these internal task groups?

No, it won't.  The target audience is those folks who don't _do_ the
configuration they _could_ do, folks who don't use SCHED_IDLE or nice,
or the power available through userspace cgroup tools.. folks who expect
their box to "just work", out of the box.

> Looks like everybody likes the idea but let me still ask the following
> question.
> 
> Should this kind of thing be done in user space? I mean what we are 
> essentially doing providing isolation between two groups. That's why
> this cgroup infrastructure is in place. Just that currently how cgroups
> are created is fully depends on user space and kernel does not create
> cgroups of its own by default (ecept root cgroup).

I was of the same mind when Linus first broached the subject, but Ingo
convinced me it was worth exploring because of the simple fact that
people are not using the available tools.

Sadly, this includes distros.

AFAIK, no distro has cgroups configured and ready for aunt tilly, no
distro has taught the GUI to use cgroups _at all_, even though it's
trivial to launch self-reaping task groups from userspace.
  
> I think systemd does something similar in the sense every system service
> it puts in a cgroup of its own on system startup.
> 
> libcgroup daemon has the facility to listen for kernel events (through
> netlink socket), and then put newly created tasks in cgroups as per
> the user spcefied rules in a config file. For example, if one wants 
> isolation between tasks of two user ids, one can just write a rule and
> once the user logs in, its login session will be automatically placed
> in right cgroup. Hence one will be able to achieve isolation between
> two users. I think now it also has rules for classifying executables
> based on names/paths. So one can put "firefox" in one cgroup and say
> "make -j64" in a separate cgroup and provide isolation between two
> applications. It is just a matter of putting right rule in the config file.

I fiddled with configuring my system, but found options lacking.  For
instance, I found no way to automate per tty (or pgid in my case).  I
had to cobble scripts together to get the job done.  Nothing that my
distro delivered could just make it just happen for me.

When the tool mature, and distros use them, in kernel automation may
well become more or less moot, but in the here and now, there is a
target audience with a need that is not being serviced.

> This patch sounds like an extension to user id problem where we want
> isolation between the processes of same user (process groups using
> different terminals). Would it make sense to generate some kind of kernel
> event for this and let user space execute the rules instead of creating
> this functionality in kernel.

Per user isn't very useful.  The typical workstation has one user
whacking away on the kbd/mouse.  While you can identify firefox etc,
it's not being done, and requires identifying every application.  Heck,
cgroups is built in, but userspace doesn't even mount.  Nothing but
nothing uses cgroups.

> This way once we extend this functionality to other subsystems, we can
> make it more flexible in user space. For example, create these groups
> for cpu controller but lets say not for block controller. Otherwise
> we will end up creating more kernel tunables for achieving same effect.

I see your arguments, and agree to a large extent.  As Linus noted,
there are other advantages to in kernel automation, but for me, it all
boils down to the fact that userspace is doing nothing with the tools.

ATM, cgroups is an enterprise or power user tool.  The out of the box
distro kernel user sees zero benefit for the overhead investment.

	-Mike

