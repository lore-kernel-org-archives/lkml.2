Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab0DMSJv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 14:09:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36598 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443Ab0DMSJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 14:09:50 -0400
Date: Wed, 14 Apr 2010 04:09:45 +1000
From: Nick Piggin <npiggin@suse.de>
To: Chris Mason <chris.mason@oracle.com>,
       Manfred Spraul <manfred@colorfullife.com>, zach.brown@oracle.com,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ipc semaphores: reduce ipc_lock contention in
 semtimedop
Message-ID: <20100413180945.GD5683@laptop>
References: <1271098163-3663-1-git-send-email-chris.mason@oracle.com>
 <1271098163-3663-2-git-send-email-chris.mason@oracle.com>
 <4BC4A6B2.1090906@colorfullife.com>
 <20100413173941.GI13327@think>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100413173941.GI13327@think>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13, 2010 at 01:39:41PM -0400, Chris Mason wrote:
> On Tue, Apr 13, 2010 at 07:15:30PM +0200, Manfred Spraul wrote:
> > Hi Chris,
> > 
> > 
> > On 04/12/2010 08:49 PM, Chris Mason wrote:
> > >  /*
> > >+ * when a semaphore is modified, we want to retry the series of operations
> > >+ * for anyone that was blocking on that semaphore.  This breaks down into
> > >+ * a few different common operations:
> > >+ *
> > >+ * 1) One modification releases one or more waiters for zero.
> > >+ * 2) Many waiters are trying to get a single lock, only one will get it.
> > >+ * 3) Many modifications to the count will succeed.
> > >+ *
> > Have you thought about odd corner cases:
> > Nick noticed the last time that it is possible to wait for arbitrary values:
> > in one semop:
> >     - decrease semaphore 5 by 10
> >     - wait until semaphore 5 is 0
> >     - increase semaphore 5 by 10.
> 
> Do you mean within a single sop array doing all three of these?  I don't
> know if the sort is going to leave the three operations on semaphore 5
> in the same order (it probably won't).
> 
> But I could change that by having it include the slot in the original
> sop array in the sorting.  That way if we have duplicate semnums in the
> array, they will end up in the same position relative to each other in
> the sorted result.
> 
> (ewwww ;)

I had a bit of a hack at doing per-semaphore stuff when I was looking
at the first optimization, but it was tricky to make it work.

The other thing I don't know if your patch gets right is requeueing on
of the operations. When you requeue from one list to another, then you
seem to lose ordering with other pending operations, so that would
seem to break the API as well (can't remember if the API strictly
mandates FIFO, but anyway it can open up starvation cases).

I was looking at doing a sequence number to be able to sort these, but
it ended up getting over complex (and SAP was only using simple ops so
it didn't seem to need much better).

We want to be careful not to change semantics at all. And it gets
tricky quickly :( What about Zach's simpler wakeup API?


