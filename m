Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab0KXSJE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 13:09:04 -0500
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:22213 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752190Ab0KXSJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 13:09:03 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: mmtbEOAVM1myFW.0kA43SvnL_BCfcRkl1aMJHR.G.i4cksS
 LN5fZ4JBTZFUq.PKLS5FvSOeehWfkbARaO4mUdnp.LHwqCPCKW4XuihKg642
 1FTAhN4u2j9x3QwWIjD94PQ85Kss4gWP4MrYJKncBfEc5NqMcychedDUKe.F
 bmzAK8WSV3bpUxa8SQTOXd.84m.vYMhDvsh0BUUsqdSx.Q6tIN8TDCIn26ig
 MHnjBrhT9xcX9z8am_bkAgEuQe.dMnWrtZW.Mf2U-
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 24 Nov 2010 12:08:59 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Peter Zijlstra <peterz@infradead.org>
cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [thiscpuops upgrade 10/10] Lockless (and preemptless) fastpaths
 for slub
In-Reply-To: <1290619610.2072.500.camel@laptop>
Message-ID: <alpine.DEB.2.00.1011241204440.20545@router.home>
References: <20101123235139.908255844@linux.com>  <20101123235201.758191189@linux.com> <1290586512.2072.423.camel@laptop>  <alpine.DEB.2.00.1011241013240.14268@router.home> <1290619610.2072.500.camel@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Nov 2010, Peter Zijlstra wrote:

> On Wed, 2010-11-24 at 10:14 -0600, Christoph Lameter wrote:
> > On Wed, 24 Nov 2010, Peter Zijlstra wrote:
> >
> > > This thing still relies on disabling IRQs in the slow path, which means
> > > its still going to be a lot of work to make it work on -rt.
> >
> > The disabling of irqs is because slab operations are used from interrupt
> > context. If we can avoid slab operations from interrupt contexts then we
> > can drop the interrupt disable in the slab allocators.
>
> That's not so much the point, there's per-cpu assumptions due to that.

Sure the exclusive access to per cpu area is exploited during
irq off sections. That would have to change.

> Not everything is under a proper lock, see for example this bit:
>
>         new = new_slab(s, gfpflags, node);
>
>         if (gfpflags & __GFP_WAIT)
>                 local_irq_disable();
>
>         if (new) {
>                 c = __this_cpu_ptr(s->cpu_slab);
>                 stat(s, ALLOC_SLAB);
>                 if (c->page)
>                         flush_slab(s, c);
>                 slab_lock(new);
>                 __SetPageSlubFrozen(new);
>                 c->page = new;
>                 goto load_freelist;
>         }
>
> There we have the __this_cpu_ptr, c->page deref and flush_slab()->stat()
> call all before we take a lock.

All per cpu data and therefore would have get different treatment
if we wanted to drop the processing in interrupt off mode.

Disabling preempt may be initially sufficient there.



