Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab2DRJMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 05:12:42 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:43825 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab2DRJMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 05:12:40 -0400
Date: Wed, 18 Apr 2012 11:12:34 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Glauber Costa <glommer@parallels.com>, Tejun Heo <tj@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Walsh <dwalsh@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [RFD] Merge task counter into memcg
Message-ID: <20120418091231.GA26594@somewhere>
References: <20120412153055.GL1787@cmpxchg.org>
 <20120412163825.GB13069@google.com>
 <20120412172309.GM1787@cmpxchg.org>
 <20120412174155.GC13069@google.com>
 <4F878480.60505@jp.fujitsu.com>
 <20120417154117.GE32402@google.com>
 <4F8D9FC4.3080800@parallels.com>
 <4F8E646B.1020807@jp.fujitsu.com>
 <CAFTL4hw3C4s6VS07pJzdBawv0ugKJJa+Vnb-Q_9FrWEq4=ka9Q@mail.gmail.com>
 <4F8E7E76.3020202@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F8E7E76.3020202@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 05:42:30PM +0900, KAMEZAWA Hiroyuki wrote:
> (2012/04/18 16:53), Frederic Weisbecker wrote:
> 
> > 2012/4/18 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>:
> >> (2012/04/18 1:52), Glauber Costa wrote:
> >>
> >>>
> >>>>> In short, I don't think it's better to have task-counting and fd-counting in memcg.
> >>>>> It's kmem, but it's more than that, I think.
> >>>>> Please provide subsys like ulimit.
> >>>>
> >>>> So, you think that while kmem would be enough to prevent fork-bombs,
> >>>> it would still make sense to limit in more traditional ways
> >>>> (ie. ulimit style object limits).  Hmmm....
> >>>>
> >>>
> >>> I personally think this is namespaces business, not cgroups.
> >>> If you have a process namespace, an interface that works to limit the
> >>> number of processes should keep working given the constraints you are
> >>> given.
> >>>
> >>> What doesn't make sense, is to create a *new* interface to limit
> >>> something that doesn't really need to be limited, just because you
> >>> limited a similar resource before.
> >>>
> >>
> >>
> >> Ok, limitiing forkbomb is unnecessary. ulimit+namespace should work.
> >> What we need is user-id namespace, isn't it ? If we have that, ulimit
> >> works enough fine, no overheads.
> > 
> > I have considered using NR_PROC rlimit on top of user namespaces to
> > fight forkbombs inside a container.
> > ie: one user namespace per container with its own rlimit.
> > 
> > But it doesn't work because we can have multiuser apps running in a
> > single container.
> > 
> 
> Ok, then, requirements is different from ulimit. ok, please forget my words.
> 
> My concern for using 'kmem' is that size of object can be changed, and set up
> may be more complicated than limiting 'number' of tasks.
> It's very architecture dependent....But hmm... 

Sure. But I believe the user can easily cope with that. One just need
to create a cgroup, move a task there and look at the accounted kmem.kernel_stack
to get the size used by one task.

That's less intuitive for the user than a task counter of course. But that
may be more generally useful than just forkbomb protection. At least I hope
because I haven't heard about other possible usecases.

> 
> If slab accounting can handle task_struct accounting, all you wants can be
> done by it (maybe). And implementation can be duplicated.
> (But another aspect of the problem will be speed of development..)
> 
> One idea is (I'm not sure good or bad)...having following control files.
> 
>  - memory.kmem.task_struct.limit_in_bytes
>  - memory.kmem.task_struct.usage_in_bytes
>  - memory.kmem.task_struct.size_in_bytes   # size of task struct.

I'm fine either way. Counting task_struct memory usage is also a way
to count the tasks for me. But is it going to be more generally useful
than counting kernel stack?

> 
> At 1st, implement this by accounting task struct(or some) directly.
> Later, if we can, replace the implementation with slab(kmem) cgroup..
> and unify interfaces.....a long way to go.
> 
> 2nd idea is
> 
>  - memory.object.task.limit_in_number	# limit the number of tasks.
>  - memory.object.task.usage_in_number   # usage
> 
> 
> If I'm a user, I prefer #2.

People seem to object on defining the number of task as a relevant unit of resource.
It's indeed a semantic resource on top of the more lower level one memory resource
(could be CPU as well).

And if it can be mapped back to memory resource, it might be more generally
useful to limit at that level.

At least I hope...

> 
> Hmm, 
>    global kmem limiting           -> done by bytes.
>    special kernel object limiting -> done by the number of objects.
> 
> is...complicated ?
> 
> Thanks,
> -Kame
> 
