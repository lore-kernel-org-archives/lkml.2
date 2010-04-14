Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab0DNTvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 15:51:33 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:34806 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755529Ab0DNTvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 15:51:32 -0400
Date: Wed, 14 Apr 2010 15:50:03 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Nick Piggin <npiggin@suse.de>, zach.brown@oracle.com,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ipc semaphores: reduce ipc_lock contention in
 semtimedop
Message-ID: <20100414195003.GE3228@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Manfred Spraul <manfred@colorfullife.com>,
	Nick Piggin <npiggin@suse.de>, zach.brown@oracle.com,
	jens.axboe@oracle.com, linux-kernel@vger.kernel.org
References: <1271098163-3663-1-git-send-email-chris.mason@oracle.com>
 <1271098163-3663-2-git-send-email-chris.mason@oracle.com>
 <4BC4A6B2.1090906@colorfullife.com>
 <20100413173941.GI13327@think>
 <20100413180945.GD5683@laptop>
 <20100413181937.GM13327@think>
 <4BC5EA75.9090803@colorfullife.com>
 <20100414173319.GA3228@think>
 <4BC61370.7020700@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BC61370.7020700@colorfullife.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4BC61CBE.00DF:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 09:11:44PM +0200, Manfred Spraul wrote:
> On 04/14/2010 07:33 PM, Chris Mason wrote:
> >On Wed, Apr 14, 2010 at 06:16:53PM +0200, Manfred Spraul wrote:
> >>On 04/13/2010 08:19 PM, Chris Mason wrote:
> >>>On Wed, Apr 14, 2010 at 04:09:45AM +1000, Nick Piggin wrote:
> >>>>On Tue, Apr 13, 2010 at 01:39:41PM -0400, Chris Mason wrote:
> >>>>The other thing I don't know if your patch gets right is requeueing on
> >>>>of the operations. When you requeue from one list to another, then you
> >>>>seem to lose ordering with other pending operations, so that would
> >>>>seem to break the API as well (can't remember if the API strictly
> >>>>mandates FIFO, but anyway it can open up starvation cases).
> >>>I don't see anything in the docs about the FIFO order.  I could add an
> >>>extra sort on sequence number pretty easily, but is the starvation case
> >>>really that bad?
> >>>
> >>How do you want to determine the sequence number?
> >>Is atomic_inc_return() on a per-semaphore array counter sufficiently fast?
> >I haven't tried yet, but hopefully it won't be a problem.  A later patch
> >does atomics on the reference count and it doesn't show up in the
> >profiles.
> >
> >>>>I was looking at doing a sequence number to be able to sort these, but
> >>>>it ended up getting over complex (and SAP was only using simple ops so
> >>>>it didn't seem to need much better).
> >>>>
> >>>>We want to be careful not to change semantics at all. And it gets
> >>>>tricky quickly :( What about Zach's simpler wakeup API?
> >>>Yeah, that's why my patches include code to handle userland sending
> >>>duplicate semids.  Zach's simpler API is cooking too, but if I can get
> >>>this done without insane complexity it helps with more than just the
> >>>post/wait oracle workload.
> >>>
> >>What is the oracle workload, which multi-sembuf operations does it use?
> >>How many semaphores are in one array?
> >>
> >>When the last optimizations were written, I've searched a bit:
> >>- postgres uses per-process semaphores, with small semaphore arrays.
> >>     [process sleeps on it's own semaphore and is woken up by someone
> >>else when it can make progress]
> >This is similar to Oracle (and the sembench program).  Each process has
> >a semaphore and when it is waiting for a commit it goes to sleep on it.
> >They are woken up in bulk with semtimedop calls from a single process.
> >
> Hmm. Thus you have:
> - single sembuf decrease operations that are waiting frequently.
> - multi-sembuf  increase operations.
> 
> What about optimizing for that case?
> Increase operations succeed immediately. Thus complex_count is 0.

I've been wondering about that.  I can optimize the patch to special
case the increase operations.  The only problem I saw was checking or
the range overflow.  Current behavior will abort the whole set if the
range overflow happens.

> 
> If we have performed an update operation, then we can scan all
> simple_lists that have seen an increase instead of checking the
> global list - as long as there are no complex operations waiting.
> Right now, we give up if the update operation was a complex
> operation - but that does not matter.
> All that matters are the sleeping operations, not the operation that
> did the wakeup.
> I've attached an untested idea.

Zach Brown's original patch set tried just the list magic and not
the spinlocks.  I'm afraid it didn't help very much over all.

> 
> >But oracle also uses semaphores for locking in a traditional sense.
> >
> >Putting the waiters into a per-semaphore list is really only part of the
> >speedup.  The real boost comes from the patch to break up the locks into
> >a per semaphore lock.
> >
> Ok. Then simple tricks won't help.
> How many semaphores are in one array?

On a big system I saw about 4000 semaphores total.  The database will
just allocate as many as it can into a single array and keep creating
arrays until it has all it needs.

-chris

