Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934195Ab1KCQ7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 12:59:42 -0400
Received: from mx2.parallels.com ([64.131.90.16]:39089 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934046Ab1KCQ7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 12:59:41 -0400
Message-ID: <4EB2C852.6020706@parallels.com>
Date: Thu, 3 Nov 2011 14:58:58 -0200
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Glauber Costa <glommer@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tim Hockin <thockin@hockin.org>, LKML <linux-kernel@vger.kernel.org>,
        Paul Menage <paul@paulmenage.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Tejun Heo <tj@kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Containers <containers@lists.linux-foundation.org>,
        Paul Turner <pjt@google.com>
Subject: Re: [PATCH 00/10] cgroups: Task counter subsystem v6
References: <1317668832-10784-1-git-send-email-fweisbec@gmail.com> <20111004150111.e9337268.akpm00@gmail.com> <CAAAKZwu67VMiZgdpp=i5p7zyGbOHGHXwF_iprufGPzTLkkUF2A@mail.gmail.com> <20111028163021.1ce61f8a.akpm@linux-foundation.org> <CAA6-i6o0SPfZJDx4SRR1hY-He0L6zHuv0saH6EaE7Mrc2HF6PA@mail.gmail.com> <20111103164917.GF8198@somewhere.redhat.com>
In-Reply-To: <20111103164917.GF8198@somewhere.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.130.234]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2011 02:49 PM, Frederic Weisbecker wrote:
> On Sat, Oct 29, 2011 at 11:38:25AM +0200, Glauber Costa wrote:
>> On Sat, Oct 29, 2011 at 1:30 AM, Andrew Morton
>> <akpm@linux-foundation.org>  wrote:
>>> On Tue, 25 Oct 2011 13:06:35 -0700
>>> Tim Hockin<thockin@hockin.org>  wrote:
>>>
>>>> On Tue, Oct 4, 2011 at 3:01 PM, Andrew Morton<akpm00@gmail.com>  wrote:
>>>>> On Mon, __3 Oct 2011 21:07:02 +0200
>>>>> Frederic Weisbecker<fweisbec@gmail.com>  wrote:
>>>>>
>>>>>> Hi Andrew,
>>>>>>
>>>>>> This contains minor changes, mostly documentation and changelog
>>>>>> updates, off-case build fix, and a code optimization in
>>>>>> res_counter_common_ancestor().
>>>>>
>>>>> I'd normally duck a patch series like this when we're at -rc8 and ask
>>>>> for it to be resent late in -rc1. __But I was feeling frisky so I
>>>>> grabbed this lot for a bit of testing and will sit on it until -rc1.
>>>>>
>>>>> I'm still not convinced that the kernel has a burning need for a "task
>>>>> counter subsystem". __Someone convince me that we should merge this!
>>>>
>>>> We have real (accidental) DoS situations which happen because we don't
>>>> have this.  It usually takes the form of some library no re-joining
>>>> threads.  We end up deploying a few apps linked against this library,
>>>> and suddenly we're in trouble on a machine.  Except, this being
>>>> Google, we're in trouble on a lot of machines.
>>>
>>> This is a bit foggy.  I think you mean that machines are experiencing
>>> accidental forkbombs?
>>>
>>>> There may be other ways to cobble this sort of safety together, but
>>>> they are less appealing for various reasons.  cgroups are how we
>>>> control groups of related pids.
>>>>
>>
>> In the end of the day, all cgroups are just a group of tasks. So I don't really
>> get the need to have a cgroup to control the number of tasks in the system.
>>
>> Why don't we just allow all cgroups to have a limit on the number of
>> tasks it can hold?
>
> Not sure what you mean. You would prefer to have this as a core feature in
> cgroups rather than a subsystem?
Well, ideally, I think we should put some effort in trying to reduce the 
number of different possible cgroups subsystems.

I do see how keeping a different cgroup here adds flexibility. However, 
this flexibility very easily translate into performance losses. The 
reason is that when more than one cgroup needs to control and update 
some piece of data, because we can't assume anything about the set of 
processes they have, we have to walk hierarchies upwards multiple times 
- they are potentially different.

See for instance what happens with cpu vs cpuacct, that I am trying to 
get rid of.

Because you are controlling tasks, and tasks are the main building block 
of all cgroups, I think you should at least consider either using
a cgroup property, or bundling this into some other cgroup, like cpu - 
where there is already some need, albeit minor, to keep track of the 
number of process in a group.
