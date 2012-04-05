Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187Ab2DEWDK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 18:03:10 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42043 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755741Ab2DEWDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 18:03:08 -0400
Date: Thu, 5 Apr 2012 15:03:06 -0700 (PDT)
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
In-Reply-To: <20120405213704.GA29517@google.com>
Message-ID: <alpine.DEB.2.00.1204051454070.17852@chino.kir.corp.google.com>
References: <20120404230922.GC2173@dhcp-172-17-108-109.mtv.corp.google.com> <1333601231.7783.31.camel@marge.simpson.net> <alpine.DEB.2.00.1204042157530.31186@chino.kir.corp.google.com> <1333604949.7783.76.camel@marge.simpson.net>
 <alpine.DEB.2.00.1204042303510.7035@chino.kir.corp.google.com> <1333608177.7783.106.camel@marge.simpson.net> <alpine.DEB.2.00.1204042344090.8991@chino.kir.corp.google.com> <alpine.DEB.2.00.1204050011550.9466@chino.kir.corp.google.com> <20120405160829.GA12854@google.com>
 <alpine.DEB.2.00.1204051417490.17852@chino.kir.corp.google.com> <20120405213704.GA29517@google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Apr 2012, Tejun Heo wrote:

> Ambitious and I'm not even sure that's even possible without fallback
> default group.  There just are things which are system-wide.  What's
> wrong with using root cgroup for that?
> 

Yes, they act system-wide but that doesn't mean their memory usage or cpu 
need to be accounted together.  The key is that all cgroups, current or 
future, aren't necessarily for limiting those system-wide resources but 
rather can provide useful insight into their cost by monitoring either 
their memory or cpu through these two cgroups.

kthreadd certainly is not the only system-wide resource on the kernel; so 
why are you not arguing that all PF_KTHREAD threads not be allowed into 
non-root cgroups?  We actually have many kthreads in a memcg that _is_ 
limited to a specific amount of memory together with other system daemons 
that are killable if it becomes oom.

The reason we're discussing kthreadd here is because it has the funny 
ability to fork other kthreads that become PF_THREAD_BOUND.  Usually the 
only PF_THREAD_BOUND threads are ones created at boot.  However, if a 
kthread is started for a specific cpu, it gets this bit set to stay on 
that cpu via kthread_bind().  That's what causes an inconsistency for only 
two types of cgroups: cpusets and cpu and we don't allow them to move 
amongst them because of that.

That's what this patch series addresses.  Please don't unnecessarily limit 
our ability with kthreadd or kthreads in general for accounting of system 
activity.
