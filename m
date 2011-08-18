Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab1HROda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 10:33:30 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57925 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755119Ab1HROd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 10:33:29 -0400
Date: Thu, 18 Aug 2011 16:33:23 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Kay Sievers <kay.sievers@vrfy.org>, Paul Menage <paul@paulmenage.org>,
        Li Zefan <lizf@cn.fujitsu.com>
Cc: Tim Hockin <thockin@hockin.org>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>
Subject: [RFD] Task counter: cgroup core feature or cgroup subsystem? (was
 Re: [PATCH 0/8 v3] cgroups: Task counter subsystem)
Message-ID: <20110818143319.GC10441@somewhere>
References: <1311956010-32076-1-git-send-email-fweisbec@gmail.com>
 <20110801161900.1fe24b76.akpm@linux-foundation.org>
 <CAAAKZwupGmw_+EaApZFAqVcXWBF885Gsjx6tUWUdMuebXrt_Mg@mail.gmail.com>
 <CAPXgP11aUfdkq-SdaHc8=tfjA4W7DYXjSXG-asoZMi6hK4iOPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPXgP11aUfdkq-SdaHc8=tfjA4W7DYXjSXG-asoZMi6hK4iOPQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 06:01:48PM +0200, Kay Sievers wrote:
> On Fri, Aug 12, 2011 at 23:11, Tim Hockin <thockin@hockin.org> wrote:
> > On Mon, Aug 1, 2011 at 4:19 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> >> On Fri, 29 Jul 2011 18:13:22 +0200
> >> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >>
> >>> Reminder:
> >>>
> >>> This patchset is aimed at reducing the impact of a forkbomb to a
> >>> cgroup boundaries, thus minimizing the consequences of such an attack
> >>> against the rest of the system.
> >>>
> >>> This can be useful when cgroups are used to stage some processes or run
> >>> untrustees.
> >>
> >> Really?  How useful?  Why is it useful enough to justify adding code
> >> such as this to the kernel?
> >>
> >> Is forkbomb-prevention the only use?  Others have proposed different
> >> ways of preventing forkbombs which were independent of cgroups - is
> >> this way better and if so, why?
> >
> > I certainly want this for exactly the proposed use - putting a bounds
> > on threads/tasks per container.  It's rlimits but more useful.
> >
> > IMHO, most every limit that can be set at a system level should be
> > settable at a cgroup level.  This is just one more isolation leak.
> 
> Such functionality in general sounds useful. System management tools
> want to be able to race-free stop a service. A 'service' in the sense
> of 'a group of processes and all the future processes it creates'.

Some background here: we got an offlist discussion where we debated
about how to safely kill all tasks in a cgroup in a race-free way.
This is also needed for containers. So that's how we found a secondary
purpose of this task counter subsystem. Setting the value 0 to tasks.limit
file would reject any future fork on the cgroup, making the whole group
of task killable without worrying against concurrent fork, which otherwise
might induce an unbounded number of iterations.

So there are now two possible uses of that task counter subsystem:

- protection against fork bombs in a container
- allow race free killing of a cgroup

And this secondary purpose is also potentially useful for systemd:


> A common problem here are user sessions that a logins creates. For
> some systems it is required, that after logout of the user, all
> processes the user has started are properly cleaned up. Common example
> for such enforcements are servers at schools universities that do not
> want to allow users to leave things like file sharing programs running
> in the background after they log out.
> 
> We currently do that in systemd by tracking these session in a cgroup
> and kill all pids in that group. This currently requires some
> cooperation of the services to be successful. If they would fork
> faster than we kill them, we would never be able to finish the task.
> 
> Such user sessions are generally untrusted code and processes, and the
> system management that cleans up after the end of the session runs
> privileged. It would be nice, to be allow trusted code to race-free
> kill all remaining processes of such an untrusted session. This is not
> so much about fork-bombs, things might not even have bad things in
> mind, this would be more like a rlimit for a 'group of pids', that
> allows race-free resource management of the services.
> 
> For the actual implementation, I think it would be nicer to use to
> have such functionality at the core of cgroups, and not require a
> specific controller to be set up. We already track every single
> service in its own cgroup in a custom hierarchy. These groups just act
> as the container for all the pids belonging to the service, so we can
> track the service properly.
> 
> Naively looking at it as a user of it, we would like to be able to
> apply these limits for every cgroup right away, not needing to create
> another controller/subsystem/hierarchy.

So the problem with the task counter as a subsystem is that you could
mount it in your systemd cgroups hierarchy but then it's not anymore
available for those who want to use containers.

It would be indeed handy to have that task counter as a cgroup core
feature so that it's usable on any hierarchy. Also it allows to
safely kill all tasks in a cgroup, and that sounds like something
that should be a cgroup core feature.

Now as a counter argument, bringing this at the cgroup core level would
bring some more overhead and complication. It implies to iterate,
on fork and exit, though all cgroups the task belongs to in every
hierachies and then charge/uncharge through all ancestors of these
cgroups.
With the subsystem, we only iterate through one cgroup and its
ancestor.

Now there are alternate ways to solve your issue. One could be
to mount a /sys/kernel/cgroups/task_counter point where anybody
interested in task counter features can use that. And systemd
could move all its task gathering there (without maintaining
a secondary mountpoint).

The other way is to use the cgroup freezer to kill your tasks.
Now I'm not aware of the overhead it implies.
