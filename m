Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758724Ab0D3R3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:29:32 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:42496 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933292Ab0D3R3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:29:13 -0400
Date: Fri, 30 Apr 2010 13:24:51 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/8] padata: Flush the padata queues actively
Message-ID: <20100430112451.GN5275@secunet.com>
References: <20100429123636.GD5275@secunet.com>
 <20100429124426.GK5275@secunet.com>
 <20100429161112.f4bb67a3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100429161112.f4bb67a3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 30 Apr 2010 11:19:43.0875 (UTC) FILETIME=[08ABB530:01CAE857]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 29, 2010 at 04:11:12PM -0700, Andrew Morton wrote:
> On Thu, 29 Apr 2010 14:44:26 +0200
> Steffen Klassert <steffen.klassert@secunet.com> wrote:
> 
> > +static void padata_flush_queues(struct parallel_data *pd)
> > +{
> > +	int cpu;
> > +	struct padata_queue *queue;
> > +
> > +	for_each_cpu(cpu, pd->cpumask) {
> > +		queue = per_cpu_ptr(pd->queue, cpu);
> > +		flush_work(&queue->pwork);
> > +	}
> > +
> > +	del_timer_sync(&pd->timer);
> > +
> > +	if (atomic_read(&pd->reorder_objects))
> > +		padata_reorder(pd);
> 
> padata_reorder() can fail to do anything, if someone else is holding
> pd->lock.  What happens then?
> 

padata does not accept new objects for parallelization if padata_flush_queues
is called. The way of the data objects throught the padata queues is

--> parallelization queue -> reorder queue -> serialization queue -->

So padata_flush_queues processes the objects in the parallelization queue
by doing flush_work(&queue->pwork). Then we delete the timer and wait on a
potentially running timer function. We are not accepting new objects
and the parallelization queue is empty, so the lock must be free then.

> 
> > +	for_each_cpu(cpu, pd->cpumask) {
> > +		queue = per_cpu_ptr(pd->queue, cpu);
> > +		flush_work(&queue->swork);
> > +	}
> > +	BUG_ON(atomic_read(&pd->refcnt) != 0);
> > +}
> 
> Are we safe against cpu hot-unplug in this code?

padata_flush_queues is called after a call to get_online_cpus in all but
one cases. I just noticed that I forgot to add the
get_online_cpus/put_online_cpus in padata_free. I'll update the
get_online_cpus/put_online_cpus patch accordingly, then it should be save in
all cases.
