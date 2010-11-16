Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759139Ab0KPB5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 20:57:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759128Ab0KPB5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 20:57:17 -0500
Date: Mon, 15 Nov 2010 20:56:48 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101116015648.GA11534@redhat.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289856350.14719.135.camel@maggy.simson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 02:25:50PM -0700, Mike Galbraith wrote:

[..]
> 
> A recurring complaint from CFS users is that parallel kbuild has a negative
> impact on desktop interactivity.  This patch implements an idea from Linus,
> to automatically create task groups.  This patch only implements Linus' per
> tty task group suggestion, and only for fair class tasks, but leaves the way
> open for enhancement.
> 
> Implementation: each task's signal struct contains an inherited pointer to a
> refcounted autogroup struct containing a task group pointer, the default for
> all tasks pointing to the init_task_group.  When a task calls __proc_set_tty(),
> the process wide reference to the default group is dropped, a new task group is
> created, and the process is moved into the new task group.  Children thereafter
> inherit this task group, and increase it's refcount.  On exit, a reference to the
> current task group is dropped when the last reference to each signal struct is
> dropped.  The task group is destroyed when the last signal struct referencing
> it is freed.   At runqueue selection time, IFF a task has no cgroup assignment,
> it's current autogroup is used.

Mike,

IIUC, this automatically created task group is invisible to user space? I
mean generally there is a task group associated with a cgroup and user space
tools can walk through cgroup hierarchy to figure out how system is
configured. Will that be possible with this patch. 

I am wondering what will happen to things like some kind of per cgroup
stats. For example block controller keeps track of number of sectors
transferred per cgroup. Hence this information will not be available for
these internal task groups?

Looks like everybody likes the idea but let me still ask the following
question.

Should this kind of thing be done in user space? I mean what we are 
essentially doing providing isolation between two groups. That's why
this cgroup infrastructure is in place. Just that currently how cgroups
are created is fully depends on user space and kernel does not create
cgroups of its own by default (ecept root cgroup).

I think systemd does something similar in the sense every system service
it puts in a cgroup of its own on system startup.

libcgroup daemon has the facility to listen for kernel events (through
netlink socket), and then put newly created tasks in cgroups as per
the user spcefied rules in a config file. For example, if one wants 
isolation between tasks of two user ids, one can just write a rule and
once the user logs in, its login session will be automatically placed
in right cgroup. Hence one will be able to achieve isolation between
two users. I think now it also has rules for classifying executables
based on names/paths. So one can put "firefox" in one cgroup and say
"make -j64" in a separate cgroup and provide isolation between two
applications. It is just a matter of putting right rule in the config file.

This patch sounds like an extension to user id problem where we want
isolation between the processes of same user (process groups using
different terminals). Would it make sense to generate some kind of kernel
event for this and let user space execute the rules instead of creating
this functionality in kernel.

This way once we extend this functionality to other subsystems, we can
make it more flexible in user space. For example, create these groups
for cpu controller but lets say not for block controller. Otherwise
we will end up creating more kernel tunables for achieving same effect.

Thanks
Vivek
