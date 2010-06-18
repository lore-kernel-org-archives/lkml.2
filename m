Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761309Ab0FRQiv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 12:38:51 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52786 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761300Ab0FRQir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 12:38:47 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6016"; a="44848782"
Subject: Re: Overview of concurrency managed workqueue
From: Daniel Walker <dwalker@codeaurora.org>
To: Florian Mickler <florian@mickler.org>
Cc: Tejun Heo <tj@kernel.org>, mingo@elte.hu, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
In-Reply-To: <20100618083622.6c117f3e@schatten.dmk.lab>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
	 <4C17C598.7070303@kernel.org>
	 <1276631037.6432.9.camel@c-dwalke-linux.qualcomm.com>
	 <4C18BF40.40607@kernel.org> <1276694825.9309.12.camel@m0nster>
	 <4C18D1FD.9060804@kernel.org> <1276695665.9309.17.camel@m0nster>
	 <4C18D574.1040903@kernel.org> <1276697146.9309.27.camel@m0nster>
	 <4C18DC69.10704@kernel.org> <1276698880.9309.44.camel@m0nster>
	 <4C18E4B7.5040702@kernel.org> <1276701074.9309.60.camel@m0nster>
	 <4C18F2B8.9060805@kernel.org> <1276705838.9309.94.camel@m0nster>
	 <4C1901E9.2080907@kernel.org> <1276712547.9309.172.camel@m0nster>
	 <4C191BE9.1060400@kernel.org> <4C192404.7000004@kernel.org>
	 <20100617072920.2b09912d@schatten.dmk.lab>
	 <1276797829.29614.42.camel@c-dwalke-linux.qualcomm.com>
	 <20100618083622.6c117f3e@schatten.dmk.lab>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Jun 2010 09:38:38 -0700
Message-ID: <1276879118.30433.20.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-18 at 08:36 +0200, Florian Mickler wrote:
> On Thu, 17 Jun 2010 11:03:49 -0700
> Daniel Walker <dwalker@codeaurora.org> wrote:
> 
> > 
> > I don't agree with your analogy here .. It's more like you have two
> > items in the vending machine item A and item B. Tejun is saying he likes
> > item A, his friends like item A so that must mean item B is not
> > interesting so he removes it (without knowing how many people want it). 
> > So what happens? People use another vending machine. (Linux is the
> > vending machine) ..
> 
> fair enough. let's stop the analogies here, i'm already sorry I
> started with it. :)

Glad that's over ;)

> > >From my perspective this is like using Linux only for throughput which
> > is what Tejun is maximizing. In addition Tejun is blowing up the
> > alternative which is to prioritize the work items and sticking you with
> > strictly a throughput based system.
> 
> No, the fact that multiple workers work on a workqueue decreases
> latency as well...  (worst case latency would be the same, if there were
> a minimum limit for worker threads per queue. I'm not shure if this is
> implemented.. )

Your right it would reduce system wide latency .. The issues isn't
latency in the entire system tho, the issue is latency that specifically
matters to me as a user. Tejun's patches maximize throughput across all
work items regardless of my given system priorities ..

> > Do you thing maybe it's possible that the work items aren't all created
> > equal? Maybe one item _is_ more important than another one. Maybe on a
> > given system Tejun's workqueues runs a 1000 useless pointless work items
> > before he gets to the valuable one .. Yet the user is powerless to
> > dictate what is or is not important.
> 
> you have a point here. I think the priority should go with the
> work-item though. Or do you think that is not a good solution? 

I do agree that we would want the work items to continue having
priorities .. The current system does that by using specific threads.

> one priority-inheritance would be to increase the priority of all
> work-items queued before the "valuable" work item. another way is to
> just have enough worker-threads so that all work-items are executed
> as fast as possible (if necessary summoning new workers).  a third is to
> have a separate worker-pool and workqueue for high-priority work. and
> i'm guessing there are more solutions...

I don't think there is an easy way to add that into Tejun's system tho.
He could raise and low the thread priorities of the worker threads
depending on the work item, but you would also have to sort the work
items by priority .. 

> > > Once you have the priority in the driver you could pass it to the
> > > workqueue subsystem (i.e. set the priority of the work) and the worker
> > > could then assume the priority of its work.
> > > 
> > > The tricky part is probably to pass the priority from the userspace
> > > thread to the kernel?
> > 
> > Threads are designed to have priorities tho, and threads are pervasive
> > throughout Linux .. It seems like setting a priorities to drivers would
> > be like re-inventing the wheel ..
> 
> No, no. Not setting priorities to drivers. What I wanted to get at, is
> that the one who shedules the work has to/can decide what priority that
> work should run as. I.e. the priority has to go with the work. 
> 
> Because you are upping the priority of a thread not for the thread's
> sake but for the work the thread is going to execute/executing? 

Sounds like priority inheritance which is ideal I think, but it's not
part of mainline. I've been trying to avoid talking about features not
already part of the mainline implementation ..

Daniel

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

