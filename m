Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab1JDGSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 02:18:23 -0400
Received: from mx2.parallels.com ([64.131.90.16]:43257 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563Ab1JDGSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 02:18:22 -0400
Message-ID: <4E8AA508.5000707@parallels.com>
Date: Tue, 4 Oct 2011 10:17:44 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge.hallyn@canonical.com>
CC: Daniel Lezcano <daniel.lezcano@free.fr>, <linux-kernel@vger.kernel.org>,
        Balbir Singh <bsingharora@gmail.com>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: cgroup information proc file format
References: <4E4441C3.5020603@free.fr> <4E4449F5.3010909@parallels.com> <4E444D96.7080206@free.fr> <20110811215238.GC17349@peqn> <4E896F18.4010705@parallels.com> <20111004024202.GB14469@sergelap>
In-Reply-To: <20111004024202.GB14469@sergelap>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2011 06:42 AM, Serge E. Hallyn wrote:
> Quoting Glauber Costa (glommer@parallels.com):
>> On 08/12/2011 01:52 AM, Serge Hallyn wrote:
>>> Quoting Daniel Lezcano (daniel.lezcano@free.fr):
>>>> On 08/11/2011 11:30 PM, Glauber Costa wrote:
>>>>> On 08/11/2011 05:55 PM, Daniel Lezcano wrote:
>>>>>> Hi all,
>>>>>>
>>>>>> the cgroup cpuset and memory reduce access to a part of the resources on
>>>>>> the system. Some applications use the /proc/cpuinfo and /proc/meminfo to
>>>>>> allocate the resources. For instance, HPC jobs look at /proc/cpuinfo to
>>>>>> fork the number of cpu found in this file either look at /proc/meminfo
>>>>>> to allocate a big chunk of memory. Each process set the affinity on each
>>>>>> cpu, which in case a subset of cpus is used, some affinity will fail.
>>>>>>
>>>>>> In the case of the container, the cgroup is used to reduce the memory or
>>>>>> to assign a cpu to the container. Unfortunately, as this partitioning is
>>>>>> not reflected in /proc, the different system tools (ps, top, free, ...)
>>>>>> show a wrong information.
>>>>>>
>>>>>> I was wondering if that would make sense to create for the different
>>>>>> cgroup subsystem, when it is relevant, a proc formatted file we can bind
>>>>>> mount /proc.
>>>>>>
>>>>>> For example: /cgroup/memory.proc and /cgroup/cpuset.proc
>>>
>>> I think it's a great idea.
>>>
>>> -serge
>>
>> [ sorry for those who are getting this twice:
>>    The containers mailing list seems to be still not working, and Paul
>>    and Balbir changed their addresses in the mean time. So I am resending
>>    it to lkml and the right addrs instead. ]
>>
>> Food for thought:
>>
>> In my last /proc-related series, in which most of you were copied, I
>> tried to implement my understanding of this idea for /proc/stat.
>>
>> For whoever didn't see it, you can find a slightly outdated but
>> still valid version of it at http://lwn.net/Articles/460310/
>>
>> While doing it, however, something occurred to me. I'd like to know
>> what you think.
>>
>> As much as I like the idea proposed by Daniel (bind-mounting proc
>> files from the cgroup to inside the container namespace), what I
>> dislike about it is the amount of setup involved - one bind mount
>> per file -, and the fact that we need to know in advance which files
>> to expect (which I more or less tried to work around by
>> conventioning a directory-like naming).
>>
>> In general, we are doing containers, using both namespaces and
>> cgroups, two entities that are very loosely coupled. While I agree
>> that such a loose coupling is not the end of the world - and quite
>> desirable in the general case -  so far I don't feel 100 %
>> comfortable with that. So, here it is: feel free to shoot to kill if
>> you dislike the idea.
>>
>> What if we try to couple them a bit more strongly ? My idea is:
>>
>> 1) Naming a certain namespace. For starters, we could use any pid inside
>> a namespace to name it, usually the first one to be created, but
>> really, any of them. (Or any other mechanism in the future)
>
> Naming namespaces is something we've been trying to avoid (because that
> introduces a new namespace), but note that /proc/self/ns/ now has
> files which you can use for comparing and entering some, and soon all,
> namespaces.  Hopefully we can somehow use these rather than using pids
> to identify namespaces?
>
> But actually... :

Well, that is what I meant by "naming". Basically anything that would
let us compare and identify that we're in a given namespace. 
/proc/self/ns is good enough.

But actually... :
>
>> 2) Create standard cgroup files, like pid_namespace, net_namespace, etc.
>>
>> 3) If those files are empty, no coupling takes place (Or maybe we
>> forget about this special case, and just have '1' as its default
>> content.
>>
>> 4) If there is a pid number written on it, that particular namespace
>> is considered tied to a cgroup. proc files that shows per-ns
>> information are already displayed per-ns. We would then proceed to
>> classify the remainder according to the type of information they
>> convey: net file, cpu file, memory file, io file, etc.
>>
>> 5) When a task inside a cgroup reads a file, it gets the data
>> according to the namespace it belongs.
>
> I think Daniel has thought a bit along these lines as well.  I don't
> think it needs to be particularly complicated.
+1
> We don't really need
> userspace involved, so actually we shouldn't need (userspace-visible)
> namespace identifiers, right?

Ideally, right. But...
> Can't we just introduce the
> /sys/fs/cgroup/memory/memory.proc etc files, and have the procfs code,
> if cgroups are enabled and the task's memory cgroup != '/', return
> the data from that file?

First: If we're doing that, why do we need that file in the first place?
The file is useful if we're bind mounting, but if we're automatically 
displaying it according to any criteria, not that interesting. Well, it 
would allow the root container to view it, so maybe it is in fact 
interesting...

As for cgroup != '/', I am not sure if it works. Well, for containers, 
it works beautifully. But what we have in the kernel now is a mechanism 
for resource control (cgroups) and a mechanism for isolation 
(namespaces). Displaying data falls in the isolation realm. There are 
users using just the resource control part (think of systemd). I doubt 
they'd like to suddenly, after years expecting system-wide info, read 
per-cgroup data when querying a /proc file.

So, because I'm all for automatic, is that I am proposing this. I think 
we need a mechanism to tie a cgroup to a namespace (or many, one of each 
kind).

I myself can settle down for:
   * If namespace != '/' => show cgroup information instead of
     system-wide. (What do you think?)

The only reason I proposed anything more complicated than that, is that 
I was fearing there were weirdos out there for whom "every process in a 
cgroup is in the same namespace" wouldn't hold, and they'd want to opt 
this out. But I honestly think this is a very sick usecase.


> We might also want to have a /sys/fs/cgroup/memory/memory.show_proc_data
> (etc) file which defaults to 1 (show the cgroup's file data in place of
> /proc/meminfo), which can be set to 0 on the host so that the container,
> if it wants, can see the host's data.
>
>> This idea is almost setup-free (with the exception of dumping pids
>> into the cgroup files, but if the files are default for all cgroups,
>> a 3-line loop can do it in a very future-proof way). But in reality,
>> what appeals to me about it, is that it is a mechanism for coupling
>> those two
>> entities that in our case, should be the same. It provides stronger
>> guarantees that we will never be able to see any data outside the
>> ones we are untitled to, even we get the bind mounts setup wrongly.
>>
>> (disclaimer: wild idea ahead)
>> If we, for instance, code in such a way that if a certain proc-file
>> is per-namespace, the task could get no data at all unless a
>> cgroup-binding is set, providing stronger isolation guarantees.
>
> Are there good reasons to worry about guaranteeing this particular
> isolation?  My impression was that this stuff is useful for the
> application - the better it can calculate the resources available
> to it, the better it can get along with others avoid getting killed
> later.  But I didn't think our goal was to try and hide the host
> info from the container - we just want to give it most meaningful
> info.

First of all, note that I am not overly concerned about that.
But it may prove useful.
If I am in a container side by side with yours, I'd prefer you wouldn't
be able to guess anything about me, including my workload type, memory 
usage, etc, and this could be used by clever exploiters.

Besides, /proc holds all sorts of stuff. Networking routing tables and 
connection status, for example. Those are not just statistics, and 
should maybe be totally hidden.
>
> (That's probably also why this stuff has been languishing - it's
> rather low in priority because unlike other things it won't harm
> the host)

Agreed about that. But hey, at some point it has to be done...

>> It is also easy to check if a task that do not belong to a namespace
>> is present in a namespaced cgroup. We can easily disallow that,
>> preventing rogue process to escape and eat resources from a
>> container.
>>
>> The list goes on.
>>
>> Please tell me what you think.
>
> thanks,
> -serge

