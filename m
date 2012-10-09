Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761Ab2JIUsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 16:48:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:59640 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794Ab2JIUsI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 16:48:08 -0400
Message-ID: <1349815676.7880.85.camel@twins>
Subject: Re: [PATCH] Do not use cpu_to_node() to find an offlined cpu's node.
From: Peter Zijlstra <peterz@infradead.org>
To: David Rientjes <rientjes@google.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>, mingo@redhat.com,
        miaox@cn.fujitsu.com, wency@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, linux-numa@vger.kernel.org
Date: Tue, 09 Oct 2012 22:47:56 +0200
In-Reply-To: <alpine.DEB.2.00.1210091328030.32588@chino.kir.corp.google.com>
References: <1349665183-11718-1-git-send-email-tangchen@cn.fujitsu.com>
	 <1349780256.7880.12.camel@twins>
	 <alpine.DEB.2.00.1210091328030.32588@chino.kir.corp.google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-09 at 13:36 -0700, David Rientjes wrote:
> On Tue, 9 Oct 2012, Peter Zijlstra wrote:
> 
> > On Mon, 2012-10-08 at 10:59 +0800, Tang Chen wrote:
> > > If a cpu is offline, its nid will be set to -1, and cpu_to_node(cpu) will
> > > return -1. As a result, cpumask_of_node(nid) will return NULL. In this case,
> > > find_next_bit() in for_each_cpu will get a NULL pointer and cause panic.
> > 
> > Hurm,. this is new, right? Who is changing all these semantics without
> > auditing the tree and informing all affected people?
> > 
> 
> I've nacked the patch that did it because I think it should be done from 
> the generic cpu hotplug code only at the CPU_DEAD level with a per-arch 
> callback to fixup whatever cpu-to-node mappings they maintain since 
> processes can reenter the scheduler at CPU_DYING.

Well the code they were patching is in the wakeup path. As I think Tang
said, we leave !runnable tasks on whatever cpu they ran on last, even if
that cpu is offlined, we try and fix up state when we get a wakeup.

On wakeup, it tries to find a cpu to run on and will try a cpu of the
same node first.

Now if that node's entirely gone away, it appears the cpu_to_node() map
will not return a valid node number.

I think that's a change in behaviour, it didn't used to do that afaik.
Certainly this code hasn't change in a while.


> The whole issue seems to be because alloc_{fair,rt}_sched_group() does an 
> iteration over all possible cpus (not all online cpus) and does 
> kzalloc_node() which references a now-offlined node.  Changing it to -1 
> makes the slab code fallback to any online node.

Right, that's because the rq structures are assumed always present. What
I cannot remember is why I'm not using per-cpu allocations there,
because that's exactly what it looks like it wants to be.

> What I think we need to do instead of hacking only the acpi code and not 
> standardizing this across the kernel is:

Right, what I don't understand is wtf ACPI has to do with anything. We
have plenty cpu hotplug code, ACPI isn't involved in any of that last
time I checked.

>  - reset cpu-to-node with a per-arch callback in generic cpu hotplug code 
>    at CPU_DEAD, and
> 
>  - do an iteration over all possible cpus for node hot-remove ensuring 
>    there are no stale references.

Why do we need to clear cpu-to-node maps? are we going to change the
topology at runtime? What are you going to do with per-cpu stuff,
per-cpu memory isn't freed on hotplug, so its node relation is static.

/me confused..

