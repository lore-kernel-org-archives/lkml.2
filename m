Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab0DMSUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 14:20:38 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:19598 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab0DMSUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 14:20:37 -0400
Date: Tue, 13 Apr 2010 14:19:37 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Manfred Spraul <manfred@colorfullife.com>, zach.brown@oracle.com,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ipc semaphores: reduce ipc_lock contention in
 semtimedop
Message-ID: <20100413181937.GM13327@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Nick Piggin <npiggin@suse.de>,
	Manfred Spraul <manfred@colorfullife.com>, zach.brown@oracle.com,
	jens.axboe@oracle.com, linux-kernel@vger.kernel.org
References: <1271098163-3663-1-git-send-email-chris.mason@oracle.com>
 <1271098163-3663-2-git-send-email-chris.mason@oracle.com>
 <4BC4A6B2.1090906@colorfullife.com>
 <20100413173941.GI13327@think>
 <20100413180945.GD5683@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100413180945.GD5683@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4BC4B5E4.008E:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 04:09:45AM +1000, Nick Piggin wrote:
> On Tue, Apr 13, 2010 at 01:39:41PM -0400, Chris Mason wrote:
> > On Tue, Apr 13, 2010 at 07:15:30PM +0200, Manfred Spraul wrote:
> > > Hi Chris,
> > > 
> > > 
> > > On 04/12/2010 08:49 PM, Chris Mason wrote:
> > > >  /*
> > > >+ * when a semaphore is modified, we want to retry the series of operations
> > > >+ * for anyone that was blocking on that semaphore.  This breaks down into
> > > >+ * a few different common operations:
> > > >+ *
> > > >+ * 1) One modification releases one or more waiters for zero.
> > > >+ * 2) Many waiters are trying to get a single lock, only one will get it.
> > > >+ * 3) Many modifications to the count will succeed.
> > > >+ *
> > > Have you thought about odd corner cases:
> > > Nick noticed the last time that it is possible to wait for arbitrary values:
> > > in one semop:
> > >     - decrease semaphore 5 by 10
> > >     - wait until semaphore 5 is 0
> > >     - increase semaphore 5 by 10.
> > 
> > Do you mean within a single sop array doing all three of these?  I don't
> > know if the sort is going to leave the three operations on semaphore 5
> > in the same order (it probably won't).
> > 
> > But I could change that by having it include the slot in the original
> > sop array in the sorting.  That way if we have duplicate semnums in the
> > array, they will end up in the same position relative to each other in
> > the sorted result.
> > 
> > (ewwww ;)
> 
> I had a bit of a hack at doing per-semaphore stuff when I was looking
> at the first optimization, but it was tricky to make it work.
> 
> The other thing I don't know if your patch gets right is requeueing on
> of the operations. When you requeue from one list to another, then you
> seem to lose ordering with other pending operations, so that would
> seem to break the API as well (can't remember if the API strictly
> mandates FIFO, but anyway it can open up starvation cases).

I don't see anything in the docs about the FIFO order.  I could add an
extra sort on sequence number pretty easily, but is the starvation case
really that bad?

> 
> I was looking at doing a sequence number to be able to sort these, but
> it ended up getting over complex (and SAP was only using simple ops so
> it didn't seem to need much better).
> 
> We want to be careful not to change semantics at all. And it gets
> tricky quickly :( What about Zach's simpler wakeup API?

Yeah, that's why my patches include code to handle userland sending
duplicate semids.  Zach's simpler API is cooking too, but if I can get
this done without insane complexity it helps with more than just the
post/wait oracle workload.

-chris

