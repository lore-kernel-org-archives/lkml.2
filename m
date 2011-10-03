Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab1JCIQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 04:16:33 -0400
Received: from mx2.parallels.com ([64.131.90.16]:49930 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271Ab1JCIQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 04:16:27 -0400
Message-ID: <4E896F18.4010705@parallels.com>
Date: Mon, 3 Oct 2011 12:15:20 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Serge Hallyn <serge.hallyn@canonical.com>
CC: Daniel Lezcano <daniel.lezcano@free.fr>, <linux-kernel@vger.kernel.org>,
        Balbir Singh <bsingharora@gmail.com>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: cgroup information proc file format
References: <4E4441C3.5020603@free.fr> <4E4449F5.3010909@parallels.com> <4E444D96.7080206@free.fr> <20110811215238.GC17349@peqn>
In-Reply-To: <20110811215238.GC17349@peqn>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2011 01:52 AM, Serge Hallyn wrote:
> Quoting Daniel Lezcano (daniel.lezcano@free.fr):
>> On 08/11/2011 11:30 PM, Glauber Costa wrote:
>>> On 08/11/2011 05:55 PM, Daniel Lezcano wrote:
>>>> Hi all,
>>>>
>>>> the cgroup cpuset and memory reduce access to a part of the resources on
>>>> the system. Some applications use the /proc/cpuinfo and /proc/meminfo to
>>>> allocate the resources. For instance, HPC jobs look at /proc/cpuinfo to
>>>> fork the number of cpu found in this file either look at /proc/meminfo
>>>> to allocate a big chunk of memory. Each process set the affinity on each
>>>> cpu, which in case a subset of cpus is used, some affinity will fail.
>>>>
>>>> In the case of the container, the cgroup is used to reduce the memory or
>>>> to assign a cpu to the container. Unfortunately, as this partitioning is
>>>> not reflected in /proc, the different system tools (ps, top, free, ...)
>>>> show a wrong information.
>>>>
>>>> I was wondering if that would make sense to create for the different
>>>> cgroup subsystem, when it is relevant, a proc formatted file we can bind
>>>> mount /proc.
>>>>
>>>> For example: /cgroup/memory.proc and /cgroup/cpuset.proc
>
> I think it's a great idea.
>
> -serge

[ sorry for those who are getting this twice:
   The containers mailing list seems to be still not working, and Paul
   and Balbir changed their addresses in the mean time. So I am resending
   it to lkml and the right addrs instead. ]

Food for thought:

In my last /proc-related series, in which most of you were copied, I 
tried to implement my understanding of this idea for /proc/stat.

For whoever didn't see it, you can find a slightly outdated but still 
valid version of it at http://lwn.net/Articles/460310/

While doing it, however, something occurred to me. I'd like to know what 
you think.

As much as I like the idea proposed by Daniel (bind-mounting proc files 
from the cgroup to inside the container namespace), what I dislike about 
it is the amount of setup involved - one bind mount per file -, and the 
fact that we need to know in advance which files to expect (which I more 
or less tried to work around by conventioning a directory-like naming).

In general, we are doing containers, using both namespaces and cgroups, 
two entities that are very loosely coupled. While I agree that such a 
loose coupling is not the end of the world - and quite desirable in the 
general case -  so far I don't feel 100 % comfortable with that. So, 
here it is: feel free to shoot to kill if you dislike the idea.

What if we try to couple them a bit more strongly ? My idea is:

1) Naming a certain namespace. For starters, we could use any pid inside
a namespace to name it, usually the first one to be created, but really, 
any of them. (Or any other mechanism in the future)

2) Create standard cgroup files, like pid_namespace, net_namespace, etc.

3) If those files are empty, no coupling takes place (Or maybe we forget 
about this special case, and just have '1' as its default content.

4) If there is a pid number written on it, that particular namespace is 
considered tied to a cgroup. proc files that shows per-ns information 
are already displayed per-ns. We would then proceed to classify the 
remainder according to the type of information they convey: net file, 
cpu file, memory file, io file, etc.

5) When a task inside a cgroup reads a file, it gets the data according 
to the namespace it belongs.

This idea is almost setup-free (with the exception of dumping pids into 
the cgroup files, but if the files are default for all cgroups, a 3-line 
loop can do it in a very future-proof way). But in reality, what appeals 
to me about it, is that it is a mechanism for coupling those two
entities that in our case, should be the same. It provides stronger 
guarantees that we will never be able to see any data outside the ones 
we are untitled to, even we get the bind mounts setup wrongly.

(disclaimer: wild idea ahead)
If we, for instance, code in such a way that if a certain proc-file is 
per-namespace, the task could get no data at all unless a cgroup-binding 
is set, providing stronger isolation guarantees.

It is also easy to check if a task that do not belong to a namespace is 
present in a namespaced cgroup. We can easily disallow that, preventing 
rogue process to escape and eat resources from a container.

The list goes on.

Please tell me what you think.
