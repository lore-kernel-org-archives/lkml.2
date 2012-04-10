Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758317Ab2DJAwy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 20:52:54 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57275 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130Ab2DJAwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 20:52:53 -0400
Date: Mon, 9 Apr 2012 17:52:50 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Tejun Heo <tj@kernel.org>,
        Mike Galbraith <mgalbraith@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Menage <paul@paulmenage.org>,
        LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>
Subject: Re: [patch 0/2] cpusets, cpu_cgroup: disallow attaching kthreadd
In-Reply-To: <CABEgKgopoHYiisCQnqeFc4qT-Y4Md1b6enTcZdomoKn0vGv_RQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1204091747470.4449@chino.kir.corp.google.com>
References: <20120405160829.GA12854@google.com> <alpine.DEB.2.00.1204051417490.17852@chino.kir.corp.google.com> <20120405213704.GA29517@google.com> <alpine.DEB.2.00.1204051454070.17852@chino.kir.corp.google.com> <20120405222400.GC29517@google.com>
 <alpine.DEB.2.00.1204051542280.25838@chino.kir.corp.google.com> <20120405225854.GE29517@google.com> <alpine.DEB.2.00.1204051559480.25838@chino.kir.corp.google.com> <20120405231306.GF29517@google.com> <alpine.DEB.2.00.1204051630400.25838@chino.kir.corp.google.com>
 <20120406155203.GA4798@dhcp-172-17-108-109.mtv.corp.google.com> <1333736770.2960.114.camel@laptop> <alpine.DEB.2.00.1204061347180.23328@chino.kir.corp.google.com> <CABEgKgopoHYiisCQnqeFc4qT-Y4Md1b6enTcZdomoKn0vGv_RQ@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Apr 2012, Hiroyuki Kamezawa wrote:

> I'm sorry if I didn't read e-mails while a trip....let me understand...
> 
>  - Tejun at el, tries to disallow to move kthreadd into cgroups other than root.
>  - You wants to account kthreadd's activity under memg at el.
> 

memcg isn't the only use case, you can also use it for cpuacct and any 
other future cgroup that wants to do so.

> Then, 2 question from me is....
> 1. If this patch only affects kthreadd, you can move other
>     kthread. Is this correct ?
> 

Yes, but not those that are forked by kthreadd at runtime without some 
delay between the fork and attaching it to a different cgroup.  With memcg 
slab accounting, for example, allocating the task_struct for the kthread 
should appropriately be accounted for in a non-root memcg.

Keep in mind that this isn't only limited to memcg, I've just used it to 
illustrate how account for slab is useful.  I don't know everybody's use 
cases where they may want to do the same thing so I've been arguing 
against unnecessarily restricting it from all cgroups other than those 
that require it (cpuset and cpu).

Using cpusets as an example, we can even completely remove the restriction 
on attaching all PF_THREAD_BOUND threads by not allowing them only if the 
destination cpuset has mems that are disjoint from the bound cpu and 
disallow changing the mems to be disjoint from a member's bound cpu.

So then we won't even need the restriction for some PF_THREAD_BOUND 
threads for cpusets.  It's not even a rare restriction: users can easily 
use sched_setaffinity() to restrict their scheduling to a subset of their 
set of allowed mems.

I haven't looked at the changes needed for the cpu cgroup, but I'm 
assuming it will be even easier: disallow attaching kthreadd without rt 
allocation.
