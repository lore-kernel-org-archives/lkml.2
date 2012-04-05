Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab2DEV0i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 17:26:38 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52566 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018Ab2DEV0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 17:26:37 -0400
Date: Thu, 5 Apr 2012 14:26:34 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tejun Heo <tj@kernel.org>
cc: Mike Galbraith <mgalbraith@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Menage <paul@paulmenage.org>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [patch 0/2] cpusets, cpu_cgroup: disallow attaching kthreadd
In-Reply-To: <20120405160829.GA12854@google.com>
Message-ID: <alpine.DEB.2.00.1204051417490.17852@chino.kir.corp.google.com>
References: <1333542649.7188.40.camel@marge.simpson.net> <alpine.DEB.2.00.1204041414220.26086@chino.kir.corp.google.com> <20120404230922.GC2173@dhcp-172-17-108-109.mtv.corp.google.com> <1333601231.7783.31.camel@marge.simpson.net>
 <alpine.DEB.2.00.1204042157530.31186@chino.kir.corp.google.com> <1333604949.7783.76.camel@marge.simpson.net> <alpine.DEB.2.00.1204042303510.7035@chino.kir.corp.google.com> <1333608177.7783.106.camel@marge.simpson.net> <alpine.DEB.2.00.1204042344090.8991@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1204050011550.9466@chino.kir.corp.google.com> <20120405160829.GA12854@google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Apr 2012, Tejun Heo wrote:

> > Rebased and separated patches proposed by Mike Galbraith 
> > <mgalbraith@suse.de> in https://lkml.org/lkml/2012/1/7/17.
> 
> Umm... David, I'm with Peter on this one and don't want kthreadd to go
> anywhere other than the root cgroup.  If you know of a valid use case,
> please bring one up; otherwise, I'm applying Mike's patch.
> 

Yeah, I know a valid use case, and I'm surprised you don't.

Google is moving in a direction where nothing will be assigned to the root 
memcg.  We already have a seperate memcg for accounting of memory 
allocated by the kernel, i.e. memory not accounted toward any user job.  
We will be doing this more aggressively in the future once we have setup 
memcg hierarchies to differentiate the memory usage of the kernel 
including workqueues created by kthreadd and have complete coverage of 
memory accounting such as slab and memory allocated directly from 
__get_free_pages().  We don't want anything in the root memcg itself.

It's also possible to attach kthreadd to the cpuacct cgroup for similar 
accounting.  The idea is that not all cgroups impose limits, either for 
memcg (where memory.limit_in_bytes == ULONG_MAX) or cpuacct, but rather 
purely for accounting.

For cpusets and the cpu cgroup, I completely agree with disallowing 
kthreadd and that's why I've passed along these patches.  However, it's 
not necessary (or even preferred for our usecase) to restrict kthreadd 
from being attached to all cgroups.  Yes, it's a global resource.  We want 
to account for the memory of that global resource.

Thanks.
