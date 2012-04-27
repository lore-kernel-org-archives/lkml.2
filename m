Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab2D0V1R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 17:27:17 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53191 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127Ab2D0V1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 17:27:16 -0400
Date: Fri, 27 Apr 2012 14:27:13 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: inux-next: Tree for Apr 27 (uml + mm/memcontrol.c)
In-Reply-To: <20120427132343.fbb443b9.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1204271420350.4631@chino.kir.corp.google.com>
References: <20120427161146.95422142968526faaff615d4@canb.auug.org.au> <4F9ABF9C.2070707@xenotime.net> <alpine.DEB.2.00.1204271141040.28516@chino.kir.corp.google.com> <20120427132343.fbb443b9.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2012, Andrew Morton wrote:

> Seems reasonable.  But the CONFIG_HUGETLB_PAGE=y,
> CONFIG_MEM_RES_CTLR_HUGETLB=n combination will cause unneeded code
> generation and space consumption in memcontrol.c.
> 
> I wonder if we can additionally do, within memcontrol.c:
> 
> /*
>  * Nice comment goes here
>  */
> #ifdef CONFIG_MEM_RES_CTLR_HUGETLB
> #define HUGE_MAX_HSTATE_FOO HUGE_MAX_HSTATE
> #else
> #define HUGE_MAX_HSTATE_FOO 0
> #endif
> 
> and s/HUGE_MAX_HSTATE/HUGE_MAX_HSTATE_FOO/ in that file.
> 

I haven't looked at the hugetlb memcg controller in-depth (yet), but I 
really think we should start considering breaking things like this off 
into its own cgroup.  The hugetlb extension seems like something that 
could be easily separtated, but perhaps I'm saying "easily" because I 
haven't looked at the implementation.

mm/memcontrol.c in linux-next is 5877 lines and, if history is any guide, 
it's going to continue growing.

If the hugetlb usage isn't charged against the memcg's 
memory.usage_in_bytes like thp is, then I really think it should be its 
own cgroup.  From the hugetlb perspective absent any cgroups, things like 
hstates (since we're talking about HUGE_MAX_HSTATE) are global resources 
and so you'd need to preallocate these on the command line or via sysfs 
before you could mmap them.  So if my assumption that the hugetlb memcg 
controller is only governing these global resources and charging a set of 
tasks for what they use, then it really has no business in mm/memcontrol.c 
to begin with, in my opinion.
