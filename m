Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab2D1SCN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 14:02:13 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:39851 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171Ab2D1SCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 14:02:12 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: inux-next: Tree for Apr 27 (uml + mm/memcontrol.c)
In-Reply-To: <20120427143646.8209627e.akpm@linux-foundation.org>
References: <20120427161146.95422142968526faaff615d4@canb.auug.org.au> <4F9ABF9C.2070707@xenotime.net> <alpine.DEB.2.00.1204271141040.28516@chino.kir.corp.google.com> <20120427132343.fbb443b9.akpm@linux-foundation.org> <alpine.DEB.2.00.1204271420350.4631@chino.kir.corp.google.com> <20120427143646.8209627e.akpm@linux-foundation.org>User-Agent: Notmuch/0.11.1+346~g13d19c3 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Sat, 28 Apr 2012 23:31:45 +0530
Message-ID: <87fwbnag6u.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12042807-0260-0000-0000-000000F46969
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Fri, 27 Apr 2012 14:27:13 -0700 (PDT)
> David Rientjes <rientjes@google.com> wrote:
>
>> On Fri, 27 Apr 2012, Andrew Morton wrote:
>> 
>> > Seems reasonable.  But the CONFIG_HUGETLB_PAGE=y,
>> > CONFIG_MEM_RES_CTLR_HUGETLB=n combination will cause unneeded code
>> > generation and space consumption in memcontrol.c.
>> > 
>> > I wonder if we can additionally do, within memcontrol.c:
>> > 
>> > /*
>> >  * Nice comment goes here
>> >  */
>> > #ifdef CONFIG_MEM_RES_CTLR_HUGETLB
>> > #define HUGE_MAX_HSTATE_FOO HUGE_MAX_HSTATE
>> > #else
>> > #define HUGE_MAX_HSTATE_FOO 0
>> > #endif
>> > 
>> > and s/HUGE_MAX_HSTATE/HUGE_MAX_HSTATE_FOO/ in that file.
>> > 
>> 
>> I haven't looked at the hugetlb memcg controller in-depth (yet), but I 
>> really think we should start considering breaking things like this off 
>> into its own cgroup.  The hugetlb extension seems like something that 
>> could be easily separtated, but perhaps I'm saying "easily" because I 
>> haven't looked at the implementation.
>> 
>> mm/memcontrol.c in linux-next is 5877 lines and, if history is any guide, 
>> it's going to continue growing.
>> 
>> If the hugetlb usage isn't charged against the memcg's 
>> memory.usage_in_bytes like thp is, then I really think it should be its 
>> own cgroup.  From the hugetlb perspective absent any cgroups, things like 
>> hstates (since we're talking about HUGE_MAX_HSTATE) are global resources 
>> and so you'd need to preallocate these on the command line or via sysfs 
>> before you could mmap them.  So if my assumption that the hugetlb memcg 
>> controller is only governing these global resources and charging a set of 
>> tasks for what they use, then it really has no business in mm/memcontrol.c 
>> to begin with, in my opinion.
>

My first version was to do it as a seperate controller 

http://thread.gmane.org/gmane.linux.kernel.mm/73826

But the feedback I received was to do it as a part of memcg extension,
because what the controller is limiting is memory albeit a different
type. AFAIU there is also this goal of avoiding controller proliferation.

-aneesh

