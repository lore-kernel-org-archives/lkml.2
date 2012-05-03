Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605Ab2ECU4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 16:56:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63386 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494Ab2ECU4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 16:56:51 -0400
Date: Thu, 3 May 2012 13:56:49 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: inux-next: Tree for Apr 27 (uml + mm/memcontrol.c)
In-Reply-To: <CABEgKgqWo=b=o7PwOLc=QqCWXQxUaYvMX99GP9cR_Y-RoTEW3g@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1205031343300.1631@chino.kir.corp.google.com>
References: <20120427161146.95422142968526faaff615d4@canb.auug.org.au> <4F9ABF9C.2070707@xenotime.net> <alpine.DEB.2.00.1204271141040.28516@chino.kir.corp.google.com> <20120427132343.fbb443b9.akpm@linux-foundation.org> <alpine.DEB.2.00.1204271420350.4631@chino.kir.corp.google.com>
 <20120427143646.8209627e.akpm@linux-foundation.org> <87fwbnag6u.fsf@skywalker.in.ibm.com> <alpine.DEB.2.00.1205030208120.21476@chino.kir.corp.google.com> <CABEgKgqWo=b=o7PwOLc=QqCWXQxUaYvMX99GP9cR_Y-RoTEW3g@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 May 2012, Hiroyuki Kamezawa wrote:

> I think hugetlb should be handled under memcg.
> 
> 1. I think Hugetlb is memory.
> 

Agreed, but hugetlb control is done in a very different way than regular 
memory in terms of implementation and preallocation.  Just because it's 
called "memory controller" doesn't mean it must control all types of 
memory; hugetlb has always been considered a seperate type of VM that 
diverges quite radically from the VM implementation.  Forcing users into 
an all-or-nothing approach is a lousy solution when its simpler, cleaner, 
more extendable, and doesn't lose any functionality when seperated.

> 2. The characteristics of hugetlb usage you pointed out is
> characteristics comes from
>    "current" implementation.
>     Yes, it's now unreclaimable and should be allocated by hands of
> admin. But,
>     considering recent improvements, memory-defrag, CMA, it can be less
>     hard-to-use thing by updating implementation and on-demand allocation
>     can be allowed.
> 

You're describing transparent hugepages which are already supported by 
memcg specifically because they are transparent.  I haven't seen any 
proposals on how to change hugetlb when it comes to preallocation and 
mmaping the memory because it would break the API with userspace.  
Userspace packages like hugeadm are actually used in a wide variety of 
places.

 [ I would love to see hugetlb be deprecated entirely and move in a 
   direction where transparent hugepages can make that happen, but we're 
   not there yet because we're missing key functionality such as pagecache 
   support. ]

> 3. If overhead is the problem, and it's better to disable memcg,
>     Please show numbers with HPC apps. I didn't think memcg has very
> bad overhead
>     with Bull's presentation in collaboration summit, this April.
> 

Is this a claim that memory-intensive workloads will have the exact same 
performance with and without memcg enabled?  That would be quite an 
amazing feat, I agree, since tracking user pages would have absolutely 
zero cost.  Please clarify your answer here and whether memcg is not 
expected to cause even the slightest performance degradation on any 
workload, I want to make sure I'm understanding it correctly.  I'll follow 
up after that.

Even if there's the slightest performance degradation, these are what 
users of hugetlb are concerned with already.  They use hugetlb for 
performance and it would be a shame for it to regress because you have to 
enable memcg.

> 4. I guess a user who uses hugetlbfs will use usual memory at the same time.
>     Having 2 hierarchy for memory and hugetlb will bring him a confusion.
> 

Cgroups is moving to a single hierarchy for simplification, this isn't the 
only example of where this is currently suboptimal and it would be 
disappointing to solidify hugetlb control as part of memcg because of this 
current limitation that will be addressed by generic cgroups development.

Folks, once these things are merged they become an API that can't easily 
be shifted around and seperated out later.  The decision now is either to 
join hugetlb control with memcg forever when they act in very different 
ways or to seperate them so they can be used and configured individually.
