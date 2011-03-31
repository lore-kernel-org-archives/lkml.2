Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758887Ab1CaSKI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 14:10:08 -0400
Received: from smtp-out.google.com ([74.125.121.67]:28163 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab1CaSKF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 14:10:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=o8t7sFnnbFdLysXNCnJCpz7BxgOsLgkZMEiI5DEyKo2yon4honxsuXE8hZNwEzaRGq
         YrKB1x9zKOANpfF6Hlqw==
MIME-Version: 1.0
In-Reply-To: <20110331095306.GA30290@tiehlicka.suse.cz>
References: <20110328093957.089007035@suse.cz>
	<20110328200332.17fb4b78.kamezawa.hiroyu@jp.fujitsu.com>
	<4D920066.7000609@gmail.com>
	<20110330081853.GC15394@tiehlicka.suse.cz>
	<BANLkTinTKyqv11JPwQ1GszYv5e3xOM=b8A@mail.gmail.com>
	<20110331095306.GA30290@tiehlicka.suse.cz>
Date: Thu, 31 Mar 2011 11:10:00 -0700
Message-ID: <BANLkTik8g=VZmsn_ZybVVVVco6oNYmakGA@mail.gmail.com>
Subject: Re: [RFC 0/3] Implementation of cgroup isolation
From: Ying Han <yinghan@google.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 2:53 AM, Michal Hocko <mhocko@suse.cz> wrote:
> On Wed 30-03-11 10:59:21, Ying Han wrote:
>> On Wed, Mar 30, 2011 at 1:18 AM, Michal Hocko <mhocko@suse.cz> wrote:
>> > On Tue 29-03-11 21:23:10, Balbir Singh wrote:
>> >> On 03/28/11 16:33, KAMEZAWA Hiroyuki wrote:
>> >> > On Mon, 28 Mar 2011 11:39:57 +0200
>> >> > Michal Hocko <mhocko@suse.cz> wrote:
>> > [...]
>> >> > Isn't it the same result with the case where no cgroup is used ?
>> >> > What is the problem ?
>> >> > Why it's not a problem of configuration ?
>> >> > IIUC, you can put all logins to some cgroup by using cgroupd/libgcgroup.
>> >> >
>> >>
>> >> I agree with Kame, I am still at loss in terms of understand the use
>> >> case, I should probably see the rest of the patches
>> >
>> > OK, it looks that I am really bad at explaining the usecase. Let's try
>> > it again then (hopefully in a better way).
>> >
>> > Consider a service which serves requests based on the in-memory
>> > precomputed or preprocessed data.
>> > Let's assume that getting data into memory is rather costly operation
>> > which considerably increases latency of the request processing. Memory
>> > access can be considered random from the system POV because we never
>> > know which requests will come from outside.
>> > This workflow will benefit from having the memory resident as long as
>> > and as much as possible because we have higher chances to be used more
>> > often and so the initial costs would pay off.
>> > Why is mlock not the right thing to do here? Well, if the memory would
>> > be locked and the working set would grow (again this depends on the
>> > incoming requests) then the application would have to unlock some
>> > portions of the memory or to risk OOM because it basically cannot
>> > overcommit.
>> > On the other hand, if the memory is not mlocked and there is a global
>> > memory pressure we can have some part of the costly memory swapped or
>> > paged out which will increase requests latencies. If the application is
>> > placed into an isolated cgroup, though, the global (or other cgroups)
>> > activity doesn't influence its cgroup thus the working set of the
>> > application.
>>
>> > If we compare that to mlock we will benefit from per-group reclaim when
>> > we get over the limit (or soft limit). So we do not start evicting the
>> > memory unless somebody makes really pressure on the _application_.
>> > Cgroup limits would, of course, need to be selected carefully.
>> >
>> > There might be other examples when simply kernel cannot know which
>> > memory is important for the process and the long unused memory is not
>> > the ideal choice.
>>
>> Michal,
>>
>> Reading through your example, sounds to me you can accomplish the
>> "guarantee" of the high priority service using existing
>> memcg mechanisms.
>>
>> Assume you have the service named cgroup-A which needs memory
>> "guarantee". Meantime we want to launch cgroup-B with no memory
>> "guarantee". What you want is to have cgroup-B uses the slack memory
>> (not being allocated by cgroup-A), but also volunteer to give up under
>> system memory pressure.
>
> This would require a "guarantee" that no pages are reclaimed from a
> group if that group is under its soft limit, right?

yes.

I am thinking if we
> can achieve that without too many corner cases when cgroups (process's
> accounted memory) don't leave out much for other memory used by the
> kernel.

> That was my concern so I made that isolation rather opt-in without
> modifying the current reclaim logic too much (there are, of course,
> parts that can be improved).

So far we are discussing the memory limit only for user pages. Later
we definitely need a kernel memory slab accounting and also for
reclaim. If we put them together, do you still have the concern? Sorry
guess I am just trying to understand the concern w/ example.

>
>> So continue w/ my previous post, you can consider the following
>> configuration in 32G machine. We can only have resident size of
>> cgroup-A as much as the machine capacity.
>>
>> cgroup-A :  limit_in_bytes =32G soft_limit_in_bytes = 32G
>> cgroup-B : limit_in_bytes =20G  soft_limit_in_bytes = 0G
>>
>> To be a little bit extreme, there shouldn't be memory pressure on
>> cgroup-A unless it grows above the machine capacity. If the global
>> memory contention is triggered by cgroup-B, we should steal pages from
>> it always.
>>
>> However, the current implementation of soft_limit needs to be improved
>> for the example above. Especially when we start having lots of cgroups
>> running w/ different limit setting, we need to have soft_limit being
>> efficient and we can eliminate the global lru scanning.
>
> Lots of groups is really an issue because we can end up in a situation
> when everybody is under the limit while there is not much memory left
> for the kernel. Maybe sum(soft_limit) < kernel_treshold condition would
> solve this.
most of the kernel memory are allocated on behalf of processes in
cgroup. One way of doing that (after having kernel memory accounting)
is to count in kernel memory into usage_in_bytes. So we have the
following:

1) limit_in_bytes: cap of memory allocation (user + kernel) for cgroup-A
2) soft_limit_in_bytes: guarantee of memory allocation  (user +
kernel) for cgroup-A
3) usage_in_bytes: user pages + kernel pages (allocated on behalf of the memcg)

The above need kernel memory accounting and targeting reclaim. Then we
have sum(soft_limit) < machine capacity. Hope we can talk a bit in the
LSF on this too.





>> The later one breaks the isolation.
>
> Sorry, I don't understand. Why would elimination of the global lru
> scanning break isolation? Or am I misreading you?

Sorry, i meant the other way around. So we agree on this .

--Ying
>
> Thanks
> --
> Michal Hocko
> SUSE Labs
> SUSE LINUX s.r.o.
> Lihovarska 1060/12
> 190 00 Praha 9
> Czech Republic
>
