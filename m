Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510Ab1ITVih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 17:38:37 -0400
Received: from mx2.parallels.com ([64.131.90.16]:39756 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167Ab1ITVif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 17:38:35 -0400
Message-ID: <4E7907AD.3030408@parallels.com>
Date: Tue, 20 Sep 2011 18:37:49 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Andi Kleen <andi@firstfloor.org>,
        <linux-kernel@vger.kernel.org>, <xemul@parallels.com>,
        <paul@paulmenage.org>, <lizf@cn.fujitsu.com>, <daniel.lezcano@free.fr>,
        <jbottomley@parallels.com>
Subject: Re: [PATCH 0/9] Per-cgroup /proc/stat
References: <1316030695-19826-1-git-send-email-glommer@parallels.com>  <1316031196.5040.46.camel@twins> <m2fwjyg9fx.fsf@firstfloor.org> <1316076989.3045.8.camel@twins> <4E77CB30.3030509@google.com>
In-Reply-To: <4E77CB30.3030509@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.134.226]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2011 08:07 PM, Paul Turner wrote:
> On 09/15/11 01:56, Peter Zijlstra wrote:
>> On Wed, 2011-09-14 at 13:23 -0700, Andi Kleen wrote:
>>> Peter Zijlstra<a.p.zijlstra@chello.nl> writes:
>>>>
>>>> Guys we should seriously trim back a lot of that code, not grow ever
>>>> more and more. The sad fact is that if you build a kernel with
>>>> cpu-cgroup support the context switch cost is more than double that
>>>> of a
>>>> kernel without, and then you haven't even started creating cgroups yet.
>>>
>>> That sounds indeed quite bad. Is it known why it is so costly?
>>
>> Mostly because all data structures grow and all code paths grow, some by
>> quite a bit, its spread all over the place, lots of little cuts etc..
>>
>> pjt and I tried trimming some of the code paths with static_branch() but
>> didn't really get anywhere.. need to get back to looking at this stuff
>> sometime soon.
>
> When I get some time I think I'm just going to post a patch[*] that
> merges the useful _field_ (usage, usage_percpu) from cpuacct into cpu
> since we are *already* doing the accounting on the entity level making
> this addition free.
agree.

> At that point we could !CONFIG_CGROUP_CPUACCT by default and deprecate
> the beast without breaking ABI for those who really need it (either
> because their applications have hard-coded paths or because they really
> like cgroup user/sys time -- which we COULD duplicate into cpu but I'm
> inclined not to).

Well, why ? Now that I look into it, one of the nice ways to achieve 
what I am proposing in this patchset is:
  1) get rid of cpuacct.
  2) do all accounting per-cpu cgroup, and then merge it to fs/proc/stat.c

> [*]: the only real caveat is how loudly people scream about the code
> duplication; I think it's worth it if it let's us kill cpuacct in the
> long run.

One way to deprecate it, is probably disallowing cpuacct to have any 
tasks written to its task file. We then expose whatever information 
there is in cpu/.

It may get ugly since we'll need to touch core cgroup code, but it is 
nice from a user PoV.

> Another unrelated optimization on this path I have sitting around in
> patches/ to push at some point is keeping the left-most entity out of
> tree; since the worst case is an entity with a lower-vruntime comes
> along and we insert the previous left-most and the best case is we get
> to pick it without futzing with the rb-tree. I think this was good for a
> percent or two when I hacked it together before.
>
> Another idea I have kicking around for this path is the introduction of
> a link_entity which bridges over nr_running=1 chains (break it
> opportunistically when an element in the chain goes to nr_running=2).
> This one requires some pretty careful accounting around the breaking of
> a chain though so I'm not touching it until I get the new load tracking
> code out. (Incidentally when I benchmarked it before LPC I had it
> working out to be a little more efficient than the current math good for
> ~2-3% on pipe_test.)
>
> - Paul

