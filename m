Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab0K1WwA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 17:52:00 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33801 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097Ab0K1Wv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 17:51:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=dK8y3okniLgyhltV6mcTErHXlDOpTLSZgoCFGZ27whvpLM7W8rnTUEEnd+I6D7PPtX
         MNr54M8Y4NSLBmV1ij5qpV9AHflz9UwRtv4vN/mTxe6cYsBA6lyLwk1MNXTwvQjpqWQN
         J19J8q8fZQDRkYup5cTGosUEgTE6Prq1nIWAg=
Subject: Re: [PATCH] kthread: NUMA aware kthread_create_on_cpu()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <20101128224024.GA12300@basil.fritz.box>
References: <1290972833.29196.90.camel@edumazet-laptop>
	 <20101128224024.GA12300@basil.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 28 Nov 2010 23:51:51 +0100
Message-ID: <1290984712.29196.100.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 28 novembre 2010 à 23:40 +0100, Andi Kleen a écrit :
> On Sun, Nov 28, 2010 at 08:33:53PM +0100, Eric Dumazet wrote:
> > @@ -101,7 +103,15 @@ static int kthread(void *_create)
> >  static void create_kthread(struct kthread_create_info *create)
> >  {
> >  	int pid;
> > -
> > +	static int last_cpu_pref = -1;
> > +
> > +	if (create->cpu != last_cpu_pref) {
> 
> Is that actually thread-safe?

Yes, we use one dedicated task to create all kthreads.

This task runs kthreadd(void *unused) in kernel/kthread.c

This only duty is to create tasks.


> 
> > +void numa_cpubind_policy(int cpu)
> > +{
> > +	nodemask_t mask;
> > +
> > +	init_nodemask_of_node(&mask, cpu_to_node(cpu));
> > +	do_set_mempolicy(MPOL_BIND, 0, &mask);
> 
> You don't want bind, you want preferred, otherwise this
> will explode if the node is empty.
> 

OK thanks, I'll test the patch with BIND or PREFERRED on x86_32 mode
since I have one machine with two sockets, 2GB on each socket, so 2nd
node only have HIGHMEM, no LOWMEM.

> Also this messes up the policy of the caller process. You really
> need to save/restore it.

Well, caller process duty is to create kthreads in a loop.

> 
> And if the slab is configured for slab interleaving in
> the cpuset this will be ignored I think.
> 



> Also I think the slab fast path ignores the policy anyways,
> the policy only acts when slab has to grab new pages.
> Are you sure this works at all?
> 

It works on x86 at least, I tested this patch and got correct stacks for
pktgen and ksoftirqd kthreads for sure.

> It would be probably better to pass through the node
> to the low level allocation functions and use them
> there directly.
> 

It would be difficult, because do_fork() is arch dependant

> Problem is that this ends up in architecture specific code
> for the stack, so may be a larger patch.

I suggest arches that need slab to allocate kthread stacks do the
appropriate changes, because I am not able to make them myself.

On x86, we use page allocator only, so NUMA mempolicy is used.



