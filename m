Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975Ab1JEHr5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 03:47:57 -0400
Received: from mx2.parallels.com ([64.131.90.16]:55905 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757895Ab1JEHr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 03:47:56 -0400
Message-ID: <4E8C0B89.6020000@parallels.com>
Date: Wed, 5 Oct 2011 11:47:21 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Serge Hallyn <serge.hallyn@canonical.com>
CC: Daniel Lezcano <daniel.lezcano@free.fr>, <linux-kernel@vger.kernel.org>,
        Balbir Singh <bsingharora@gmail.com>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: cgroup information proc file format
References: <4E4441C3.5020603@free.fr> <4E4449F5.3010909@parallels.com> <4E444D96.7080206@free.fr> <20110811215238.GC17349@peqn> <4E896F18.4010705@parallels.com> <20111004024202.GB14469@sergelap> <4E8AA508.5000707@parallels.com> <20111004140541.GA3619@peqn>
In-Reply-To: <20111004140541.GA3619@peqn>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2011 06:05 PM, Serge Hallyn wrote:
> Quoting Glauber Costa (glommer@parallels.com):
> ...
>
>>> Can't we just introduce the
>>> /sys/fs/cgroup/memory/memory.proc etc files, and have the procfs code,
>>> if cgroups are enabled and the task's memory cgroup != '/', return
>>> the data from that file?
>>
>> First: If we're doing that, why do we need that file in the first place?
>
> We might not :)  But we might, if we want to offer containers a choice of
> whether /proc/meminfo is the host's or the container's.

Hi,

Please allow me to clarify some points so we are in the same page (thus 
avoiding fragmentation =p )

Are you quoting /proc/meminfo as an example only, or are you concerned 
specifically with this file? I myself am talking about proc files in 
general.

We have to keep in mind that the myriad of them, convey different kinds 
of information, belong to different subsystems and have different 
expected behavior.

That is important because for some of them, what you state about only 
allowing a group of processes to see the resources they have makes 
sense. For others, maybe not.

>> The file is useful if we're bind mounting, but if we're
>> automatically displaying it according to any criteria, not that
>> interesting. Well, it would allow the root container to view it, so
>> maybe it is in fact interesting...
>>
>> As for cgroup != '/', I am not sure if it works. Well, for
>> containers, it works beautifully. But what we have in the kernel now
>> is a mechanism for resource control (cgroups) and a mechanism for
>> isolation (namespaces). Displaying data falls in the isolation
>> realm. There are users using just the resource control part (think
>> of systemd). I doubt they'd like to suddenly, after years expecting
>> system-wide info, read per-cgroup data when querying a /proc file.
>
> That's where the /sys/fs/cgroup/memory/memory.use_cgroup_as_proc file
> I mentioned below would come in.  The host could choose to give
> that application the host /proc/meminfo view.
I am sorry, I think I missed you mentioning this file.

Correct me if I am wrong, but it seems to me now that we agree that 
there should be a mechanism determining whether or not to automatically 
show cgroup-restrained values in proc files.

This is a key point for me. What is this mechanism, is less important, 
as long as it is a one-time shot.

>
> Still, if the applications you are thinking of are having their
> resources restricted, what harm would come of reporting their actual
> allotted resources in place of an artificially inflated number?
Think /proc/stat, the file I am working now, as an example.

Historically, this file shows, among other things, user ticks for all 
processes in the system. In a container system, we want this to 
represent only the set of processes inside a container.

But why on earth can we assume that everybody, in all use cases, 
wouldn't be harmed by having just your process' ticks displayed? I don't 
think we can.

Note that people are now using cgroups for other things, (think systemd).

They can serve as process grouping, simple restriction, etc.
So the less we assume, the better.

>
>> So, because I'm all for automatic, is that I am proposing this. I
>> think we need a mechanism to tie a cgroup to a namespace (or many,
>> one of each kind).
>>
>> I myself can settle down for:
>>    * If namespace != '/' =>  show cgroup information instead of
>>      system-wide. (What do you think?)
>
> I don't like it  :)
>
> The namespaces are about name->object relations, not just about
> isolation.  In contrast, the cgroups are precisely about resource
> limitations.
Right.

>> The only reason I proposed anything more complicated than that, is
>> that I was fearing there were weirdos out there for whom "every
>> process in a cgroup is in the same namespace" wouldn't hold, and
>
> Absolutely.
>
>> they'd want to opt this out. But I honestly think this is a very
>> sick usecase.
>
> :)
>
> Don't get me wrong, I don't think it would hurt to always give them
> the cgroup data.  I just think the check is not 'correct'.
>
>>> We might also want to have a /sys/fs/cgroup/memory/memory.show_proc_data
>>> (etc) file which defaults to 1 (show the cgroup's file data in place of
>>> /proc/meminfo), which can be set to 0 on the host so that the container,
>>> if it wants, can see the host's data.

A container can't want anything. I am more concerned here with the other 
types of use cases.

BTW, A file in each cgroup:

/sys/fs/cgroup/memory/memory.restrict_proc_data (or any other name)
/sys/fs/cgroup/cpu/cpu.restrict_proc_data (or any other name)
etc...

works for me as well.

>>>
>>>> This idea is almost setup-free (with the exception of dumping pids
>>>> into the cgroup files, but if the files are default for all cgroups,
>>>> a 3-line loop can do it in a very future-proof way). But in reality,
>>>> what appeals to me about it, is that it is a mechanism for coupling
>>>> those two
>>>> entities that in our case, should be the same. It provides stronger
>>>> guarantees that we will never be able to see any data outside the
>>>> ones we are untitled to, even we get the bind mounts setup wrongly.
>>>>
>>>> (disclaimer: wild idea ahead)
>>>> If we, for instance, code in such a way that if a certain proc-file
>>>> is per-namespace, the task could get no data at all unless a
>>>> cgroup-binding is set, providing stronger isolation guarantees.
>>>
>>> Are there good reasons to worry about guaranteeing this particular
>>> isolation?  My impression was that this stuff is useful for the
>>> application - the better it can calculate the resources available
>>> to it, the better it can get along with others avoid getting killed
>>> later.  But I didn't think our goal was to try and hide the host
>>> info from the container - we just want to give it most meaningful
>>> info.
>>
>> First of all, note that I am not overly concerned about that.
>> But it may prove useful.
>> If I am in a container side by side with yours, I'd prefer you wouldn't
>> be able to guess anything about me, including my workload type,
>> memory usage, etc, and this could be used by clever exploiters.
>>
>> Besides, /proc holds all sorts of stuff. Networking routing tables
>> and connection status, for example. Those are not just statistics,
>> and should maybe be totally hidden.
>
> I think that should be done separate from this whole discussion - using
> user namespaces.  Any task in a non-initial user namespace will only
> get the world access rights to a procfile.  So if the file isn't world
> readable, then a container won't be able to read it.

Yeah. Well, this was never part of the main discussion anyway =)
I agree with you here.

>>> (That's probably also why this stuff has been languishing - it's
>>> rather low in priority because unlike other things it won't harm
>>> the host)
>>
>> Agreed about that. But hey, at some point it has to be done...
>
> :)
>
> -serge

