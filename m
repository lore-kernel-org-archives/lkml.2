Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292Ab1JDOFy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 10:05:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51565 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756833Ab1JDOFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 10:05:52 -0400
Date: Tue, 4 Oct 2011 09:05:41 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Glauber Costa <glommer@parallels.com>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>, linux-kernel@vger.kernel.org,
        Balbir Singh <bsingharora@gmail.com>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: cgroup information proc file format
Message-ID: <20111004140541.GA3619@peqn>
References: <4E4441C3.5020603@free.fr>
 <4E4449F5.3010909@parallels.com>
 <4E444D96.7080206@free.fr>
 <20110811215238.GC17349@peqn>
 <4E896F18.4010705@parallels.com>
 <20111004024202.GB14469@sergelap>
 <4E8AA508.5000707@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8AA508.5000707@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Glauber Costa (glommer@parallels.com):
...

> >Can't we just introduce the
> >/sys/fs/cgroup/memory/memory.proc etc files, and have the procfs code,
> >if cgroups are enabled and the task's memory cgroup != '/', return
> >the data from that file?
> 
> First: If we're doing that, why do we need that file in the first place?

We might not :)  But we might, if we want to offer containers a choice of
whether /proc/meminfo is the host's or the container's.

> The file is useful if we're bind mounting, but if we're
> automatically displaying it according to any criteria, not that
> interesting. Well, it would allow the root container to view it, so
> maybe it is in fact interesting...
> 
> As for cgroup != '/', I am not sure if it works. Well, for
> containers, it works beautifully. But what we have in the kernel now
> is a mechanism for resource control (cgroups) and a mechanism for
> isolation (namespaces). Displaying data falls in the isolation
> realm. There are users using just the resource control part (think
> of systemd). I doubt they'd like to suddenly, after years expecting
> system-wide info, read per-cgroup data when querying a /proc file.

That's where the /sys/fs/cgroup/memory/memory.use_cgroup_as_proc file
I mentioned below would come in.  The host could choose to give
that application the host /proc/meminfo view.

Still, if the applications you are thinking of are having their
resources restricted, what harm would come of reporting their actual
allotted resources in place of an artificially inflated number?

> So, because I'm all for automatic, is that I am proposing this. I
> think we need a mechanism to tie a cgroup to a namespace (or many,
> one of each kind).
> 
> I myself can settle down for:
>   * If namespace != '/' => show cgroup information instead of
>     system-wide. (What do you think?)

I don't like it  :)

The namespaces are about name->object relations, not just about
isolation.  In contrast, the cgroups are precisely about resource
limitations.

> The only reason I proposed anything more complicated than that, is
> that I was fearing there were weirdos out there for whom "every
> process in a cgroup is in the same namespace" wouldn't hold, and

Absolutely.

> they'd want to opt this out. But I honestly think this is a very
> sick usecase.

:)

Don't get me wrong, I don't think it would hurt to always give them
the cgroup data.  I just think the check is not 'correct'.

> >We might also want to have a /sys/fs/cgroup/memory/memory.show_proc_data
> >(etc) file which defaults to 1 (show the cgroup's file data in place of
> >/proc/meminfo), which can be set to 0 on the host so that the container,
> >if it wants, can see the host's data.
> >
> >>This idea is almost setup-free (with the exception of dumping pids
> >>into the cgroup files, but if the files are default for all cgroups,
> >>a 3-line loop can do it in a very future-proof way). But in reality,
> >>what appeals to me about it, is that it is a mechanism for coupling
> >>those two
> >>entities that in our case, should be the same. It provides stronger
> >>guarantees that we will never be able to see any data outside the
> >>ones we are untitled to, even we get the bind mounts setup wrongly.
> >>
> >>(disclaimer: wild idea ahead)
> >>If we, for instance, code in such a way that if a certain proc-file
> >>is per-namespace, the task could get no data at all unless a
> >>cgroup-binding is set, providing stronger isolation guarantees.
> >
> >Are there good reasons to worry about guaranteeing this particular
> >isolation?  My impression was that this stuff is useful for the
> >application - the better it can calculate the resources available
> >to it, the better it can get along with others avoid getting killed
> >later.  But I didn't think our goal was to try and hide the host
> >info from the container - we just want to give it most meaningful
> >info.
> 
> First of all, note that I am not overly concerned about that.
> But it may prove useful.
> If I am in a container side by side with yours, I'd prefer you wouldn't
> be able to guess anything about me, including my workload type,
> memory usage, etc, and this could be used by clever exploiters.
> 
> Besides, /proc holds all sorts of stuff. Networking routing tables
> and connection status, for example. Those are not just statistics,
> and should maybe be totally hidden.

I think that should be done separate from this whole discussion - using
user namespaces.  Any task in a non-initial user namespace will only
get the world access rights to a procfile.  So if the file isn't world
readable, then a container won't be able to read it.

> >(That's probably also why this stuff has been languishing - it's
> >rather low in priority because unlike other things it won't harm
> >the host)
> 
> Agreed about that. But hey, at some point it has to be done...

:)

-serge
