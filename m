Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab2I0Q4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 12:56:36 -0400
Received: from mail.lang.hm ([64.81.33.126]:53179 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140Ab2I0Q4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 12:56:35 -0400
Date: Thu, 27 Sep 2012 09:55:30 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Borislav Petkov <bp@alien8.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Mel Gorman <mgorman@suse.de>,
        Nikolay Ulyanitsky <lystor@gmail.com>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
In-Reply-To: <20120927102050.GA967@liondog.tnic>
Message-ID: <alpine.DEB.2.02.1209270948300.5162@asgard.lang.hm>
References: <1348538258.7100.23.camel@marge.simpson.net> <CA+55aFxw5yab4f=+KwB59RjRNXEhQZ==QEvQeLhEczKCTQK9wg@mail.gmail.com> <1348574286.3881.40.camel@twins> <20120925131736.GA30652@x1.osrc.amd.com> <20120925170058.GC30158@x1.osrc.amd.com>
 <CA+55aFzf=CApkYn+m5omwg+9-9i=11vj=7OMxKrCKb0qc-oBgg@mail.gmail.com> <20120926163233.GA5339@x1.osrc.amd.com> <CA+55aFzC1GZG8+Gv9KmAcV=RGU+hw39hwC9AjfYVqiJ84qAYkw@mail.gmail.com> <20120926213723.GA27692@liondog.tnic> <alpine.DEB.2.02.1209270013270.5162@asgard.lang.hm>
 <20120927102050.GA967@liondog.tnic>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2012, Borislav Petkov wrote:

> On Thu, Sep 27, 2012 at 12:17:22AM -0700, david@lang.hm wrote:
>> It seems to me that trying to figure out if you are going to
>> overload the L2 is an impossible task, so just assume that it will
>> all fit, and the worst case is you have one balancing cycle where
>> you can't do as much work and then the normal balancing will kick in
>> and move something anyway.
>
> Right, and this implies that when the load balancer runs, it will
> definitely move the task away from the L2. But what do I do in the cases
> where the two tasks don't overload the L2 and it is actually beneficial
> to keep them there? How does the load balancer know that?

no, I'm saying that you should assume that the two tasks won't overload 
the L2, try it, and if they do overload the L2, move one of the tasks 
again the next balancing cycle.

there is a lot of possible sharing going on between 'cores'

shared everything (a single core)
different registers, shared everything else (HT core)
shared floating point, shared cache, different everything else
shared L2/L3/Memory, different everything else
shared L3/Memory, different everything else
shared Memory, different everything else
different everything

and just wait a couple of years and someone will add a new entry to this 
list (if I haven't already missed a few :-)

the more that is shared, the cheaper it is to move the process (the less 
cached state you throw away), so ideally you want to move the process as 
little as possible, just enough to eliminate whatever the contended 
resource it. But since you really don't know the footprint of each process 
in each of these layers, all you can measure is what percentage of the 
total core time the process used, just move it a little and see if that 
was enough.

David Lang
