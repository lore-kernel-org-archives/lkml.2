Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582Ab1JDCmL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 22:42:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47959 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab1JDCmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 22:42:09 -0400
Date: Mon, 3 Oct 2011 21:42:02 -0500
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
To: Glauber Costa <glommer@parallels.com>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>, linux-kernel@vger.kernel.org,
        Balbir Singh <bsingharora@gmail.com>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: cgroup information proc file format
Message-ID: <20111004024202.GB14469@sergelap>
References: <4E4441C3.5020603@free.fr>
 <4E4449F5.3010909@parallels.com>
 <4E444D96.7080206@free.fr>
 <20110811215238.GC17349@peqn>
 <4E896F18.4010705@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E896F18.4010705@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Glauber Costa (glommer@parallels.com):
> On 08/12/2011 01:52 AM, Serge Hallyn wrote:
> >Quoting Daniel Lezcano (daniel.lezcano@free.fr):
> >>On 08/11/2011 11:30 PM, Glauber Costa wrote:
> >>>On 08/11/2011 05:55 PM, Daniel Lezcano wrote:
> >>>>Hi all,
> >>>>
> >>>>the cgroup cpuset and memory reduce access to a part of the resources on
> >>>>the system. Some applications use the /proc/cpuinfo and /proc/meminfo to
> >>>>allocate the resources. For instance, HPC jobs look at /proc/cpuinfo to
> >>>>fork the number of cpu found in this file either look at /proc/meminfo
> >>>>to allocate a big chunk of memory. Each process set the affinity on each
> >>>>cpu, which in case a subset of cpus is used, some affinity will fail.
> >>>>
> >>>>In the case of the container, the cgroup is used to reduce the memory or
> >>>>to assign a cpu to the container. Unfortunately, as this partitioning is
> >>>>not reflected in /proc, the different system tools (ps, top, free, ...)
> >>>>show a wrong information.
> >>>>
> >>>>I was wondering if that would make sense to create for the different
> >>>>cgroup subsystem, when it is relevant, a proc formatted file we can bind
> >>>>mount /proc.
> >>>>
> >>>>For example: /cgroup/memory.proc and /cgroup/cpuset.proc
> >
> >I think it's a great idea.
> >
> >-serge
> 
> [ sorry for those who are getting this twice:
>   The containers mailing list seems to be still not working, and Paul
>   and Balbir changed their addresses in the mean time. So I am resending
>   it to lkml and the right addrs instead. ]
> 
> Food for thought:
> 
> In my last /proc-related series, in which most of you were copied, I
> tried to implement my understanding of this idea for /proc/stat.
> 
> For whoever didn't see it, you can find a slightly outdated but
> still valid version of it at http://lwn.net/Articles/460310/
> 
> While doing it, however, something occurred to me. I'd like to know
> what you think.
> 
> As much as I like the idea proposed by Daniel (bind-mounting proc
> files from the cgroup to inside the container namespace), what I
> dislike about it is the amount of setup involved - one bind mount
> per file -, and the fact that we need to know in advance which files
> to expect (which I more or less tried to work around by
> conventioning a directory-like naming).
> 
> In general, we are doing containers, using both namespaces and
> cgroups, two entities that are very loosely coupled. While I agree
> that such a loose coupling is not the end of the world - and quite
> desirable in the general case -  so far I don't feel 100 %
> comfortable with that. So, here it is: feel free to shoot to kill if
> you dislike the idea.
> 
> What if we try to couple them a bit more strongly ? My idea is:
> 
> 1) Naming a certain namespace. For starters, we could use any pid inside
> a namespace to name it, usually the first one to be created, but
> really, any of them. (Or any other mechanism in the future)

Naming namespaces is something we've been trying to avoid (because that
introduces a new namespace), but note that /proc/self/ns/ now has
files which you can use for comparing and entering some, and soon all,
namespaces.  Hopefully we can somehow use these rather than using pids
to identify namespaces?

But actually... :

> 2) Create standard cgroup files, like pid_namespace, net_namespace, etc.
> 
> 3) If those files are empty, no coupling takes place (Or maybe we
> forget about this special case, and just have '1' as its default
> content.
> 
> 4) If there is a pid number written on it, that particular namespace
> is considered tied to a cgroup. proc files that shows per-ns
> information are already displayed per-ns. We would then proceed to
> classify the remainder according to the type of information they
> convey: net file, cpu file, memory file, io file, etc.
> 
> 5) When a task inside a cgroup reads a file, it gets the data
> according to the namespace it belongs.

I think Daniel has thought a bit along these lines as well.  I don't
think it needs to be particularly complicated.  We don't really need
userspace involved, so actually we shouldn't need (userspace-visible)
namespace identifiers, right?  Can't we just introduce the
/sys/fs/cgroup/memory/memory.proc etc files, and have the procfs code,
if cgroups are enabled and the task's memory cgroup != '/', return
the data from that file?

We might also want to have a /sys/fs/cgroup/memory/memory.show_proc_data
(etc) file which defaults to 1 (show the cgroup's file data in place of
/proc/meminfo), which can be set to 0 on the host so that the container,
if it wants, can see the host's data.

> This idea is almost setup-free (with the exception of dumping pids
> into the cgroup files, but if the files are default for all cgroups,
> a 3-line loop can do it in a very future-proof way). But in reality,
> what appeals to me about it, is that it is a mechanism for coupling
> those two
> entities that in our case, should be the same. It provides stronger
> guarantees that we will never be able to see any data outside the
> ones we are untitled to, even we get the bind mounts setup wrongly.
>
> (disclaimer: wild idea ahead)
> If we, for instance, code in such a way that if a certain proc-file
> is per-namespace, the task could get no data at all unless a
> cgroup-binding is set, providing stronger isolation guarantees.

Are there good reasons to worry about guaranteeing this particular
isolation?  My impression was that this stuff is useful for the
application - the better it can calculate the resources available
to it, the better it can get along with others avoid getting killed
later.  But I didn't think our goal was to try and hide the host
info from the container - we just want to give it most meaningful
info.

(That's probably also why this stuff has been languishing - it's
rather low in priority because unlike other things it won't harm
the host)

> It is also easy to check if a task that do not belong to a namespace
> is present in a namespaced cgroup. We can easily disallow that,
> preventing rogue process to escape and eat resources from a
> container.
> 
> The list goes on.
> 
> Please tell me what you think.

thanks,
-serge
