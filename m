Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466Ab0FUUZO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 16:25:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3574 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753945Ab0FUUZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 16:25:10 -0400
Date: Mon, 21 Jun 2010 16:25:04 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: trying to understand READ_META, READ_SYNC, WRITE_SYNC & co
Message-ID: <20100621202504.GA6474@redhat.com>
References: <20100621094828.GA30748@lst.de>
 <4C1F3916.4070608@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C1F3916.4070608@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 12:04:06PM +0200, Jens Axboe wrote:

[..]
> > Now how do we use these flags in the block layer?
> >  
> >  - REQ_META
> > 
> > 	The only place where we ever use this flag is inside the
> > 	cfq scheduler. In cfq_choose_req we use it to give a meta
> > 	request priority over one that doesn't have it.  But before
> > 	that we already do the same preference check with rw_is_sync,
> > 	which evaluates to true for requests with that are either
> > 	reads or have REQ_SYNC set.  So for reads the REQ_META flag
> > 	here effectively is a no-op, and for writes it gives less
> > 	priority than REQ_SYNC.
> > 	In addition to that we use it to account for pending metadata
> > 	requests in cfq_rq_enqueued/cfq_remove_request which gets
> > 	checked in cfq_should_preempt to give priority to a meta
> > 	request if the other queue doesn't have any pending meta
> > 	requests.  But again this priority comes after a similar
> > 	check for sync requests that checks if the other queue has
> > 	been marked to have sync requests pending.
> 
> It's also annotation for blktrace, so you can tell which parts of the IO
> is meta data etc. The scheduler impact is questionable, I doubt it makes
> a whole lot of difference.

In my testing in the past, this was helping if lots of sequential readers
are running in a system (with 100ms slice each) and if there is another
reader doing small file reads. Without meta data based preemption check,
latency of opening small file used to be very high (Because all the sync
sequntial reader gets to consume their 100ms slices first).

Situation should be somewhat better now after corrado's changes of
reducing slice length dynamically. But I suspect that we will still
experience significantly reduced latency for small file reads in presece
of multiple sequntial reads going on.

Thanks
Vivek
