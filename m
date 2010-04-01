Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131Ab0DAWAv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 18:00:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58418 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758134Ab0DAWAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 18:00:48 -0400
Date: Thu, 1 Apr 2010 14:59:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       Henrik Kretzschmar <henne@nachtwindheim.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] padata: section cleanup
Message-Id: <20100401145953.c626d731.akpm@linux-foundation.org>
In-Reply-To: <20100401081126.GC23247@secunet.com>
References: <1269672826-1102-1-git-send-email-henne@nachtwindheim.de>
	<20100329081550.GA22334@gondor.apana.org.au>
	<20100331145817.bd0a1a08.akpm@linux-foundation.org>
	<20100401081126.GC23247@secunet.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Apr 2010 10:11:26 +0200
Steffen Klassert <steffen.klassert@secunet.com> wrote:

> On Wed, Mar 31, 2010 at 02:58:17PM -0700, Andrew Morton wrote:
> > 
> > What is it for, how does it work, where might it otherwise be used,
> > what are the dynamics, why does it use softirqs rather than (say)
> > kernel threads and how do we stop it from using yield()?
> > 
> 
> padata can be used to spread cpu intensive work over multiple cpus. It came
> into being with the idea to parallelize IPsec. We separated the generic
> parts out to padata in the hope it can be useful to others too.
> So padata is used to parallelize cpu intensive codepaths, like crypto
> operations. As soon as the cpu intensive work is done, it is possible to
> serialize again without getting reorder of the parallelized objects.
> This is in particular important for IPsec to keep the network packets
> in the right order.
> 
> To achieve a parallelization of the cpu intensive parts of IPsec, we
> created the pcrypt parallel crypto template (crypto/pcrypt.c). This
> wraps around an existing crypto algorithm and does the
> parallelization/serialization by using padata. So pcrypt is an example on
> how to use padata.
> 
> I'm about to write some documentation for padata/pcrypt.

Documentation is always appreciated.

> The big picture
> is as follows. A user can allocate a padata instance by using padata_alloc().
> The user can specify the cpumask of the cpus and the workqueue he wants to
> use for the parallel codepath on allocation time. After allocation it is
> possible to start/stop the padata instance with padata_start() padata_stop().
> The actual parallel codepath is entered by calling padata_do_parallel().
> The parallelized objects, in case of pcrypt the crypto requests, need to
> embed padata's control structure of type struct padata_priv. This structure
> is the anchor for padata to handle the object. padata_do_parallel() takes
> three parameters, the padata instance on which to parallelize, the control
> structure that is embedded in the object and a callback cpu on which the
> object will appear after serialization. Once the cpu intensive work is done,
> it is possible to serialize by calling padata_do_serial(). This function
> takes the padata control structure as parameter. It brings the parallelized
> objects back to the order they were before the parallelization and sends
> them to the cpu which was specified as the callback cpu.
> 
> Internally padata uses a workqueue to do the parallelization/serialization,
> not softirqs (some earlier versions used softirqs).

OK.  Doing it in threads is better because it lets the CPU scheduler
regulate things and the load becomes visible and correctly attributed
in per-process accounting.

> I was not aware that using yield() is considered to be a bad thing, it is
> of course possible to do it without yield() if this is wanted.

yield() is a bit problematic - it can sometimes take enormous amounts
of time.  It wasn't always that way - it changed vastly in 2002 and has
since got a bit better (I think).  But generally a yield-based busywait
is a concern and it'd be better to use some more well-defined primitive
such as a lock or wait_for_completion(), etc.

I'd suggest at least loading the system up with 100 busywait processes
and verify that the padata code still behaves appropriately.


Some other stuff:

- The code does

	might_sleep()
	mutex_lock()

  in a lot of places.  But mutex_lock() does might_sleep() too, so
  it's a waste of space and will cause a double-warning if it triggers.

- The code does local_bh_disable() and spin_trylock_bh().  I assume
  that this is to support this code being used from networking
  softirqs.  So the code is usable frmo softirq context and from
  process context but not from hard IRQ context?

  It'd be useful if these designed decisions were described somewhere:
  what's the thinking behind it and what are the implications.

- padata_reorder() does a trylock.  It's quite unobvious to the
  reader why it didn't just do spin_lock().  Needs a code comment.

- the try-again loop in that function would benefit from a comment
  too.  Why is it there, and in what circumstances will the goto be
  taken?

  Once that's understood, we can see under which conditions the code
  will livelock ;)

- did __padata_add_cpu() need to test cpu_active_mask?  Wouldn't it
  be a bug for this to be called against an inactive CPU?

- similarly, does __padata_remove_cpu() need to test cpu_online_mask?

- It appears that the cpu-hotplug support in this code will be
  compiled-in even if the kernel doesn't support CPU hotplug.  It's a
  sneaky feature of the hotcpu_notifier()->cpu_notifier() macros that
  (when used with a modern gcc), the notifier block and the (static)
  notifier handler all get stripped away by the compiler/linker.  I
  suspect the way padata is organized doesn't permit that.  Fixable
  with ifdefs if once wishes to.

- It'd be nice if the internal functions had a bit of documentation. 
  I'm sitting here trying to work out why padata_alloc_pd() goes and
  touches all possible CPUs, and whether it could only touch online
  CPUs.  But I don't really know what padata_alloc_pd() _does_, in the
  overall scheme of things.

- It's expecially useful to document the data structures and the
  relationships between them.  Particularly when they are attached
  together via anonymous list_head's rather than via typed C pointers. 
  What are the structural relationships between the various structs in
  padata.h?  Needs a bit of head-scratching to work out.

- Example: parallel_data.seq_nr.  What does it actually do, and how
  is it managed and how does it tie in to padata_priv.seq_nr?  This is
  all pretty key to the implementation and reverse-engineering your
  intent from the implementation isn't trivial, and can lead to errors.

- What's all this reordering stuff?

- The distinction between serial work and parallel work is somewhat
  lost on me.  I guess that'd be covered in overall documentation.

- Please add comments to padata_get_next() explaining what's
  happening when this returns -ENODATA or -EINPROGRESS.

- If the padata is in the state PADATA_INIT, padata_do_parallel()
  returns 0, which seems odd.  Shouldn't it tell the caller that he
  goofed?

- padata_do_parallel() returns -EINPROGRESS on success, which is
  either a bug, or is peculiar.

- If I have one set of kernel threads and I use then to process
  multiple separate apdata's, it seems that the code will schedule my
  work in a FIFO, run-to-completion fashion?  So I might have been
  better off creating separate workqueues and letting the CPU scheduler
  work it out?  Worthy of discussion in the padata doc?

- Why is parallel work hashed onto a random CPU?  For crude
  load-balancing, I guess?

- Why would I want to specify which CPU the parallel completion
  callback is to be executed on?

  - What happens if that CPU isn't online any more?

- The code looks generally a bit fragile against CPU hotpug.  Maybe
  sprinkling get_online_cpus()/put_online_cpus() in strategic places
  would make things look better ;)

  You can manually online and offline CPUs via
  /sys/devices/system/cpu/cpu*/online (I think).  Thrashing away on
  those files provides a good way to test for hotplug racinesses.



I guess the major question in my mind is: in what other kernel-coding
scenarios might this code be reused?  What patterns should reviwers be
looking out for?  Thoughts on that?

Thanks.
