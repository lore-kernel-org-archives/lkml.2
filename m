Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584Ab2DEVha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 17:37:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53770 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab2DEVhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 17:37:08 -0400
Date: Thu, 5 Apr 2012 14:37:04 -0700
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Mike Galbraith <mgalbraith@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Menage <paul@paulmenage.org>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [patch 0/2] cpusets, cpu_cgroup: disallow attaching kthreadd
Message-ID: <20120405213704.GA29517@google.com>
References: <20120404230922.GC2173@dhcp-172-17-108-109.mtv.corp.google.com>
 <1333601231.7783.31.camel@marge.simpson.net>
 <alpine.DEB.2.00.1204042157530.31186@chino.kir.corp.google.com>
 <1333604949.7783.76.camel@marge.simpson.net>
 <alpine.DEB.2.00.1204042303510.7035@chino.kir.corp.google.com>
 <1333608177.7783.106.camel@marge.simpson.net>
 <alpine.DEB.2.00.1204042344090.8991@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1204050011550.9466@chino.kir.corp.google.com>
 <20120405160829.GA12854@google.com>
 <alpine.DEB.2.00.1204051417490.17852@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1204051417490.17852@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, David.

On Thu, Apr 05, 2012 at 02:26:34PM -0700, David Rientjes wrote:
> Yeah, I know a valid use case, and I'm surprised you don't.

Yeah, I'm pretty good at surprising people that way.

> Google is moving in a direction where nothing will be assigned to the root 
> memcg.  We already have a seperate memcg for accounting of memory 
> allocated by the kernel, i.e. memory not accounted toward any user job.  
> We will be doing this more aggressively in the future once we have setup 
> memcg hierarchies to differentiate the memory usage of the kernel 
> including workqueues created by kthreadd and have complete coverage of 
> memory accounting such as slab and memory allocated directly from 
> __get_free_pages().  We don't want anything in the root memcg itself.

Ambitious and I'm not even sure that's even possible without fallback
default group.  There just are things which are system-wide.  What's
wrong with using root cgroup for that?

> It's also possible to attach kthreadd to the cpuacct cgroup for similar 
> accounting.  The idea is that not all cgroups impose limits, either for 
> memcg (where memory.limit_in_bytes == ULONG_MAX) or cpuacct, but rather 
> purely for accounting.
> 
> For cpusets and the cpu cgroup, I completely agree with disallowing 
> kthreadd and that's why I've passed along these patches.  However, it's 
> not necessary (or even preferred for our usecase) to restrict kthreadd 
> from being attached to all cgroups.  Yes, it's a global resource.  We want 
> to account for the memory of that global resource.

Unfortunately, mainline cgroup is moving towards single hierarchy -
well, that's the plan anyway - and in that light ->can_attach() is
essentially broken and will thus be grdually phased out.  From the
look of the current users, I don't think it's gonna be hard.  cpu
cgroup would have to learn to ignore tasks with special scheduling
class and the blkcg silliness needs to go away but that seems to be
it.

So, hmmm, how about just using root cgroup for the fallback?

Thanks.

-- 
tejun
