Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab0FRGhG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 02:37:06 -0400
Received: from ist.d-labs.de ([213.239.218.44]:55149 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813Ab0FRGhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 02:37:04 -0400
Date: Fri, 18 Jun 2010 08:36:22 +0200
From: Florian Mickler <florian@mickler.org>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Tejun Heo <tj@kernel.org>, mingo@elte.hu, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Subject: Re: Overview of concurrency managed workqueue
Message-ID: <20100618083622.6c117f3e@schatten.dmk.lab>
In-Reply-To: <1276797829.29614.42.camel@c-dwalke-linux.qualcomm.com>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
	<4C17C598.7070303@kernel.org>
	<1276631037.6432.9.camel@c-dwalke-linux.qualcomm.com>
	<4C18BF40.40607@kernel.org>
	<1276694825.9309.12.camel@m0nster>
	<4C18D1FD.9060804@kernel.org>
	<1276695665.9309.17.camel@m0nster>
	<4C18D574.1040903@kernel.org>
	<1276697146.9309.27.camel@m0nster>
	<4C18DC69.10704@kernel.org>
	<1276698880.9309.44.camel@m0nster>
	<4C18E4B7.5040702@kernel.org>
	<1276701074.9309.60.camel@m0nster>
	<4C18F2B8.9060805@kernel.org>
	<1276705838.9309.94.camel@m0nster>
	<4C1901E9.2080907@kernel.org>
	<1276712547.9309.172.camel@m0nster>
	<4C191BE9.1060400@kernel.org>
	<4C192404.7000004@kernel.org>
	<20100617072920.2b09912d@schatten.dmk.lab>
	<1276797829.29614.42.camel@c-dwalke-linux.qualcomm.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jun 2010 11:03:49 -0700
Daniel Walker <dwalker@codeaurora.org> wrote:

> 
> I don't agree with your analogy here .. It's more like you have two
> items in the vending machine item A and item B. Tejun is saying he likes
> item A, his friends like item A so that must mean item B is not
> interesting so he removes it (without knowing how many people want it). 
> So what happens? People use another vending machine. (Linux is the
> vending machine) ..

fair enough. let's stop the analogies here, i'm already sorry I
started with it. :)

> >From my perspective this is like using Linux only for throughput which
> is what Tejun is maximizing. In addition Tejun is blowing up the
> alternative which is to prioritize the work items and sticking you with
> strictly a throughput based system.

No, the fact that multiple workers work on a workqueue decreases
latency as well...  (worst case latency would be the same, if there were
a minimum limit for worker threads per queue. I'm not shure if this is
implemented.. )

> 
> Do you thing maybe it's possible that the work items aren't all created
> equal? Maybe one item _is_ more important than another one. Maybe on a
> given system Tejun's workqueues runs a 1000 useless pointless work items
> before he gets to the valuable one .. Yet the user is powerless to
> dictate what is or is not important.

you have a point here. I think the priority should go with the
work-item though. Or do you think that is not a good solution? 

one priority-inheritance would be to increase the priority of all
work-items queued before the "valuable" work item. another way is to
just have enough worker-threads so that all work-items are executed
as fast as possible (if necessary summoning new workers).  a third is to
have a separate worker-pool and workqueue for high-priority work. and
i'm guessing there are more solutions...

> > Once you have the priority in the driver you could pass it to the
> > workqueue subsystem (i.e. set the priority of the work) and the worker
> > could then assume the priority of its work.
> > 
> > The tricky part is probably to pass the priority from the userspace
> > thread to the kernel?
> 
> Threads are designed to have priorities tho, and threads are pervasive
> throughout Linux .. It seems like setting a priorities to drivers would
> be like re-inventing the wheel ..

No, no. Not setting priorities to drivers. What I wanted to get at, is
that the one who shedules the work has to/can decide what priority that
work should run as. I.e. the priority has to go with the work. 

Because you are upping the priority of a thread not for the thread's
sake but for the work the thread is going to execute/executing? 

> 
> If you were to say make the driver use kthreads instead of workqueues,
> then you could set the priority of the kthreads .. However, you said
> this isn't part of the ABI and so your back to your original argument
> which is that you shouldn't be setting priorities in the first place.

I don't follow. What I thought about was, that the "workqueue"
interface is defined in workqueue.h. 

There is no "increase_priority_of_workqueue()" or
"increase_work_priority()" at the moment in the interface description. 

Fumbling at the threads is using _implementation knowledge_ that should
be hidden by the interface. 
I'm not saying this is a binary true/false kind of "fact", just one
view point.

Also I agree that some ability to prioritize work
items has to be enabled. And using the scheduler for that is the only
sane alternative. But I think the workqueue-implementation should do
it, so it has the freedom to dispatch threads at will. 

> 
> Daniel
> 
