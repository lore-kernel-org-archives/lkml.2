Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329Ab0DBLUm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 07:20:42 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:43245 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932230Ab0DBLUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 07:20:36 -0400
Date: Fri, 2 Apr 2010 13:23:26 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       Henrik Kretzschmar <henne@nachtwindheim.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] padata: section cleanup
Message-ID: <20100402112326.GA19502@secunet.com>
References: <1269672826-1102-1-git-send-email-henne@nachtwindheim.de>
 <20100329081550.GA22334@gondor.apana.org.au>
 <20100331145817.bd0a1a08.akpm@linux-foundation.org>
 <20100401081126.GC23247@secunet.com>
 <20100401145953.c626d731.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100401145953.c626d731.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 02 Apr 2010 11:20:31.0595 (UTC) FILETIME=[818C33B0:01CAD256]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 02:59:53PM -0700, Andrew Morton wrote:
> 
> yield() is a bit problematic - it can sometimes take enormous amounts
> of time.  It wasn't always that way - it changed vastly in 2002 and has
> since got a bit better (I think).  But generally a yield-based busywait
> is a concern and it'd be better to use some more well-defined primitive
> such as a lock or wait_for_completion(), etc.

Yes, wait_for_completion() is probably the better way to do the
busywait.

> 
> I'd suggest at least loading the system up with 100 busywait processes
> and verify that the padata code still behaves appropriately.
> 
> 
> Some other stuff:
> 
> - The code does
> 
> 	might_sleep()
> 	mutex_lock()
> 
>   in a lot of places.  But mutex_lock() does might_sleep() too, so
>   it's a waste of space and will cause a double-warning if it triggers.

Right, the mutex_sleep() can be removed in these cases. Will do that.

> 
> - The code does local_bh_disable() and spin_trylock_bh().  I assume
>   that this is to support this code being used from networking
>   softirqs.  So the code is usable frmo softirq context and from
>   process context but not from hard IRQ context?

Right, can be used from softirq and process, but not from hardirq context.

> 
>   It'd be useful if these designed decisions were described somewhere:
>   what's the thinking behind it and what are the implications.

Ok, will place some description to the code.

> 
> - padata_reorder() does a trylock.  It's quite unobvious to the
>   reader why it didn't just do spin_lock().  Needs a code comment.

Ok.

> 
> - the try-again loop in that function would benefit from a comment
>   too.  Why is it there, and in what circumstances will the goto be
>   taken?

The try-again loop it to handle a corner case that appears with the trylock.
Will add some comments on this too.

> 
>   Once that's understood, we can see under which conditions the code
>   will livelock ;)
> 
> - did __padata_add_cpu() need to test cpu_active_mask?  Wouldn't it
>   be a bug for this to be called against an inactive CPU?
> 
> - similarly, does __padata_remove_cpu() need to test cpu_online_mask?
> 

Well, the idea behind that was to maintain a cpumask the user wishes to
use for parallelization. The cpumask that is actually used, is the logical and
between user's cpumask and the cpu_active_mask. The reason for maintaining
such a cpumask was to keep the user supplied cpumask untouched on hotplug
events. If a cpu goes down and then up again padata can simply reuse this cpu
if it is in the user's cpumask. So this made it possible to add even offline
cpus to the user's cpumask. Once the cpu comes online, it will be used.
I guess this need a code comment too.
	
> - It appears that the cpu-hotplug support in this code will be
>   compiled-in even if the kernel doesn't support CPU hotplug.  It's a
>   sneaky feature of the hotcpu_notifier()->cpu_notifier() macros that
>   (when used with a modern gcc), the notifier block and the (static)
>   notifier handler all get stripped away by the compiler/linker.  I
>   suspect the way padata is organized doesn't permit that.  Fixable
>   with ifdefs if once wishes to.

Yes, I noticed that already. A patch that ifdef the cpu hotplug code is
already in my queue.

> 
> - It'd be nice if the internal functions had a bit of documentation. 
>   I'm sitting here trying to work out why padata_alloc_pd() goes and
>   touches all possible CPUs, and whether it could only touch online
>   CPUs.  But I don't really know what padata_alloc_pd() _does_, in the
>   overall scheme of things.

Hm, good point. For the moment I think it would be even sufficient to touch
just the logical and between the supplied and the active mask. I'll look
into this.

> 
> - It's expecially useful to document the data structures and the
>   relationships between them.  Particularly when they are attached
>   together via anonymous list_head's rather than via typed C pointers. 
>   What are the structural relationships between the various structs in
>   padata.h?  Needs a bit of head-scratching to work out.

Ok, will do.

> 
> - Example: parallel_data.seq_nr.  What does it actually do, and how
>   is it managed and how does it tie in to padata_priv.seq_nr?  This is
>   all pretty key to the implementation and reverse-engineering your
>   intent from the implementation isn't trivial, and can lead to errors.

The sequence numbers are in fact the key to maintain the order of the
parallelized objects. padata_priv.seq_nr is the sequence number that
identifies a object unique. The object is equipped with this number before
it is queued for the parallel codepath. On exit of the parallel codepath
this number is used to bring the objects back to the right order.
parallel_data.seq_nr maintains the 'next free sequence number' of the
padata instance. The next object that appears will be equipped with this
number as it's private sequence number (padata_priv.seq_nr).
parallel_data.seq_nr is incremented by one and then again contains the
number for the next object.

> 
> - What's all this reordering stuff?
> 
> - The distinction between serial work and parallel work is somewhat
>   lost on me.  I guess that'd be covered in overall documentation.
> 
> - Please add comments to padata_get_next() explaining what's
>   happening when this returns -ENODATA or -EINPROGRESS.

Ok.

> 
> - If the padata is in the state PADATA_INIT, padata_do_parallel()
>   returns 0, which seems odd.  Shouldn't it tell the caller that he
>   goofed?

It is possible to start/stop the padata instance. PADATA_INIT maintains
whether the instance is running. padata_do_parallel() returns 0 if the
instance is not initialized or stopped. It's up to the caller what to
do in this case. Maybe 0 is not the right thing to return in this case,
I'll think about it.

> 
> - padata_do_parallel() returns -EINPROGRESS on success, which is
>   either a bug, or is peculiar.

It returns -EINPROGRESS because the object is queued to a workqueue and
it returns asynchronous. It's at least in the crypto layer quite common
to do this if a crypto request is queued to a workqueue for further
processing.

> 
> - If I have one set of kernel threads and I use then to process
>   multiple separate apdata's, it seems that the code will schedule my
>   work in a FIFO, run-to-completion fashion?  So I might have been
>   better off creating separate workqueues and letting the CPU scheduler
>   work it out?  Worthy of discussion in the padata doc?

Yes, exactly. A separate workqueue should be created for each padata instance.
I'll add this to the documentation.

> 
> - Why is parallel work hashed onto a random CPU?  For crude
>   load-balancing, I guess?

It is not entirely random :)
The parallelized objects are send round robin to the cpus. Starting with
the object with sequence number 0 which is send to the cpu with index 0.
So the objects are sent to the cpus round robin, modulus the number
of cpus in use. In fact this makes it possible to calculate which object
appear on which reorder queue. That's quite important to be able to
bring the objects back to the right order.

> 
> - Why would I want to specify which CPU the parallel completion
>   callback is to be executed on?

Well, for IPsec for example it is quite interesting to separate the
different flows to different cpus. pcrypt does this by choosing different
callback cpus for the requests belonging to different transforms.
Others might want to see the object on the same cpu as it was before
the parallel codepath.

> 
>   - What happens if that CPU isn't online any more?

The cpu won't go away, that's what the yield() thing is doing.

> 
> - The code looks generally a bit fragile against CPU hotpug.  Maybe
>   sprinkling get_online_cpus()/put_online_cpus() in strategic places
>   would make things look better ;)
> 
>   You can manually online and offline CPUs via
>   /sys/devices/system/cpu/cpu*/online (I think).  Thrashing away on
>   those files provides a good way to test for hotplug racinesses.

Yes, I know. I used this to test the cpu hotplug code. I used a script
that takes cpus online and offline as fast as possible and I sent
with a traffic generator bidirectional traffic at maximum rate to
put the system under pressure during the cpu hotplugs. I ran this
for several hours, so I think there are at least no obvious races.

> 
> I guess the major question in my mind is: in what other kernel-coding
> scenarios might this code be reused?  What patterns should reviwers be
> looking out for?  Thoughts on that?
> 

I thought that somebody will raise this question.
When we decided to move the hooks for the parallelization from the
networking to the crypto layer I asked whether padata should be kept
generic or moved too. Nobody had a strong opinion on this, so I decided
to keep it generic.

OTOH, if I had moved it to the crypto layer, I'm sure somebody would have
asked why this code is local to a certain subsystem.

Anyway I had to decide for the one or the other option, knowingly that
both decisions could be wrong :)

For the moment I don't know about potential other users. But I haven't
searched for it so far. Anyway, it can be used whenever a stream of data
(like network packets) needs to be processed by something cpu intensive
but also need to be kept in the original order.

Steffen
