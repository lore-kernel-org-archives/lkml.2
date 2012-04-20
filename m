Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874Ab2DTRzW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 13:55:22 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:65059 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025Ab2DTRzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 13:55:21 -0400
Date: Fri, 20 Apr 2012 10:55:14 -0700
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <mgalbraith@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Menage <paul@paulmenage.org>,
        LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 0/2] cpusets, cpu_cgroup: disallow attaching kthreadd
Message-ID: <20120420175514.GE32324@google.com>
References: <alpine.DEB.2.00.1204051542280.25838@chino.kir.corp.google.com>
 <20120405225854.GE29517@google.com>
 <alpine.DEB.2.00.1204051559480.25838@chino.kir.corp.google.com>
 <20120405231306.GF29517@google.com>
 <alpine.DEB.2.00.1204051630400.25838@chino.kir.corp.google.com>
 <20120406155203.GA4798@dhcp-172-17-108-109.mtv.corp.google.com>
 <1333736770.2960.114.camel@laptop>
 <alpine.DEB.2.00.1204061347180.23328@chino.kir.corp.google.com>
 <CABEgKgopoHYiisCQnqeFc4qT-Y4Md1b6enTcZdomoKn0vGv_RQ@mail.gmail.com>
 <alpine.DEB.2.00.1204091747470.4449@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1204091747470.4449@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Apr 09, 2012 at 05:52:50PM -0700, David Rientjes wrote:
> On Sun, 8 Apr 2012, Hiroyuki Kamezawa wrote:
> 
> > I'm sorry if I didn't read e-mails while a trip....let me understand...
> > 
> >  - Tejun at el, tries to disallow to move kthreadd into cgroups other than root.
> >  - You wants to account kthreadd's activity under memg at el.
> > 
> 
> memcg isn't the only use case, you can also use it for cpuacct and any 
> other future cgroup that wants to do so.
> 
> > Then, 2 question from me is....
> > 1. If this patch only affects kthreadd, you can move other
> >     kthread. Is this correct ?
> > 
> 
> Yes, but not those that are forked by kthreadd at runtime without some 
> delay between the fork and attaching it to a different cgroup.  With memcg 
> slab accounting, for example, allocating the task_struct for the kthread 
> should appropriately be accounted for in a non-root memcg.
> 
> Keep in mind that this isn't only limited to memcg, I've just used it to 
> illustrate how account for slab is useful.  I don't know everybody's use 
> cases where they may want to do the same thing so I've been arguing 
> against unnecessarily restricting it from all cgroups other than those 
> that require it (cpuset and cpu).
> 
> Using cpusets as an example, we can even completely remove the restriction 
> on attaching all PF_THREAD_BOUND threads by not allowing them only if the 
> destination cpuset has mems that are disjoint from the bound cpu and 
> disallow changing the mems to be disjoint from a member's bound cpu.

So, the scheduler / arch people don't seem too happy with the prospect
of basic system kthreads living in !root cgroups and memcg people seem
willing to fix up whatever accounting deficiency in root memcg and I'm
not convinced the left use cases are all that useful / important.
There inherently are system-wide things (things happen w/o task
context and thus w/o any cgroup associated).  Just leave them in the
rootcg.  If you have to move kthreads to !root cgroups for accounting,
then do so on your own.  The only downsides are small delays and kmem
accounting inaccuracy from kthread allocation.

Thanks.

-- 
tejun
