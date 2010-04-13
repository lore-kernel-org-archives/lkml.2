Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983Ab0DMS6E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 14:58:04 -0400
Received: from cantor.suse.de ([195.135.220.2]:48186 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204Ab0DMS6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 14:58:01 -0400
Date: Wed, 14 Apr 2010 04:57:56 +1000
From: Nick Piggin <npiggin@suse.de>
To: Chris Mason <chris.mason@oracle.com>,
       Manfred Spraul <manfred@colorfullife.com>, zach.brown@oracle.com,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ipc semaphores: reduce ipc_lock contention in
 semtimedop
Message-ID: <20100413185756.GE5683@laptop>
References: <1271098163-3663-1-git-send-email-chris.mason@oracle.com>
 <1271098163-3663-2-git-send-email-chris.mason@oracle.com>
 <4BC4A6B2.1090906@colorfullife.com>
 <20100413173941.GI13327@think>
 <20100413180945.GD5683@laptop>
 <20100413181937.GM13327@think>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100413181937.GM13327@think>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13, 2010 at 02:19:37PM -0400, Chris Mason wrote:
> On Wed, Apr 14, 2010 at 04:09:45AM +1000, Nick Piggin wrote:
> > On Tue, Apr 13, 2010 at 01:39:41PM -0400, Chris Mason wrote:
> > > On Tue, Apr 13, 2010 at 07:15:30PM +0200, Manfred Spraul wrote:
> > > > Hi Chris,
> > > > 
> > > > 
> > > > On 04/12/2010 08:49 PM, Chris Mason wrote:
> > > > >  /*
> > > > >+ * when a semaphore is modified, we want to retry the series of operations
> > > > >+ * for anyone that was blocking on that semaphore.  This breaks down into
> > > > >+ * a few different common operations:
> > > > >+ *
> > > > >+ * 1) One modification releases one or more waiters for zero.
> > > > >+ * 2) Many waiters are trying to get a single lock, only one will get it.
> > > > >+ * 3) Many modifications to the count will succeed.
> > > > >+ *
> > > > Have you thought about odd corner cases:
> > > > Nick noticed the last time that it is possible to wait for arbitrary values:
> > > > in one semop:
> > > >     - decrease semaphore 5 by 10
> > > >     - wait until semaphore 5 is 0
> > > >     - increase semaphore 5 by 10.
> > > 
> > > Do you mean within a single sop array doing all three of these?  I don't
> > > know if the sort is going to leave the three operations on semaphore 5
> > > in the same order (it probably won't).
> > > 
> > > But I could change that by having it include the slot in the original
> > > sop array in the sorting.  That way if we have duplicate semnums in the
> > > array, they will end up in the same position relative to each other in
> > > the sorted result.
> > > 
> > > (ewwww ;)
> > 
> > I had a bit of a hack at doing per-semaphore stuff when I was looking
> > at the first optimization, but it was tricky to make it work.
> > 
> > The other thing I don't know if your patch gets right is requeueing on
> > of the operations. When you requeue from one list to another, then you
> > seem to lose ordering with other pending operations, so that would
> > seem to break the API as well (can't remember if the API strictly
> > mandates FIFO, but anyway it can open up starvation cases).
> 
> I don't see anything in the docs about the FIFO order.  I could add an
> extra sort on sequence number pretty easily, but is the starvation case
> really that bad?

Yes, because it's not just a theoretical livelock, it can be basically
a certainty, given the right pattern of semops.

You could have two mostly-independent groups of processes, each taking
and releasing a different sem, which are always contended (eg. if it is
being used for a producer-consumer type situation, or even just mutual
exclusion with high contention).

Then you could have some overall management process for example which
tries to take both sems. It will never get it.


> > I was looking at doing a sequence number to be able to sort these, but
> > it ended up getting over complex (and SAP was only using simple ops so
> > it didn't seem to need much better).
> > 
> > We want to be careful not to change semantics at all. And it gets
> > tricky quickly :( What about Zach's simpler wakeup API?
> 
> Yeah, that's why my patches include code to handle userland sending
> duplicate semids.

Duplicate semids? What do you mean?


>  Zach's simpler API is cooking too, but if I can get
> this done without insane complexity it helps with more than just the
> post/wait oracle workload.

Iam worried about complexity and slowing other cases, given that Oracle
DB seems willing to adapt to the (better suited) new API. So I'd be
interested to know what it helps outside Oracle.

