Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab1FUIEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 04:04:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63244 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752659Ab1FUIEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 04:04:32 -0400
Message-ID: <4E0051B5.1050708@cn.fujitsu.com>
Date: Tue, 21 Jun 2011 16:09:25 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Paul Menage <menage@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH 0/4] cgroups: Start a basic rlimit subsystem
References: <1308527474-20704-1-git-send-email-fweisbec@gmail.com> <4DFEE9BE.6050501@cn.fujitsu.com> <20110620191126.GB1613@somewhere>
In-Reply-To: <20110620191126.GB1613@somewhere>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-21 16:04:05,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-21 16:04:06,
	Serialize complete at 2011-06-21 16:04:06
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

03:11, Frederic Weisbecker wrote:
> On Mon, Jun 20, 2011 at 02:33:34PM +0800, Li Zefan wrote:
>> Frederic Weisbecker wrote:
>>> This starts a basic rlimit cgroup subsystem with only the
>>> equivalent of RLIMIT_NPROC yet. This can be useful to limit
>>> the global effects of a local fork bomb for example (local
>>> in term of a cgroup).
>>>
>>> The thing is further expandable to host more general resource
>>> limitations in the scope of a cgroup.
>>>
>>
>> As this subsystem is named "rlimit", I think we should have a bigger
>> picture about how this subsystem will be.
>>
>> For example, which of other RLIMIT_XXX can be make cgroup-aware in
>> a meaningful way and which can't.
>>
>> Another issue is, we can apply the limit of RLIMIT_NPROC as the sum
>> of the tasks' limit in a cgroup, but some other RLIMIT_XXX can't
>> work in this way. Take RLIMIT_NICE for example, we can apply this
>> limit to each of the tasks in the cgroup.
> 
> Looking at the other rlimit options, it seems all of them can be applied
> to a cgroup. They just won't all be implemented the same way.
> 
> Those that count and limit a global user resource, like NPROC, can be
> implemented using the res_counter charge/uncharge that propagate the
> resource consuming to the parent cgroups.
> 

res_counter seems a bit overkill while atomic should be sufficient for
NPROC? Especially when it affects the fork path.

Normally we want to make the impact minimal when cgroup is not used,
so we may treat the root cgroup somewhat special, and one choice is to
always make it resource unlimited.

> Other rlimits that are traditionally only process wide can be implemented
> here as a simple limit applied to all processes in the whole cgroup.
> 
> For example RLIMIT_CORE would be a limit in any core dump on
> the whole cgroup.
> 
> RLIMIT_NOFILE would be a limit on the number of files opened by the whole
> cgroup.
> 
> etc...
> 
> I think they all need to be treated case by case when/if users come and propose
> more rlimit options. These don't all necessary need to mirror the setrlimit
> options. We could pick existing ones but change a bit their semantics to fit
> more into the cgroups meaning (as a general rule any rlimit.* file must be a
> cgroup wide limitation), or create new rlimit options if specific needs arise.
> 
> There can be another kind of rlimit options that can be cgroup wide but apply
> per process, in which case we should tweak a bit the name of the rlimit option file.
> Consider RLIMIT_STACK for example.
> If we want a cgroup option that applies to the total of stack used by the whole
> cgroup, the file name would be rlim.stack. If we want that limitation to happen
> to the whole cgroup but per process, it would be rlim.stack_per_process.
> 

Or use a single cgroup interface for different rlimits, since all rlmits can be
applied per process.
