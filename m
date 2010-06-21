Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191Ab0FUS7E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 14:59:04 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:60540 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757860Ab0FUS6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 14:58:52 -0400
Message-ID: <4C1FB66B.1030203@kernel.dk>
Date: Mon, 21 Jun 2010 20:58:51 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: trying to understand READ_META, READ_SYNC, WRITE_SYNC & co
References: <20100621094828.GA30748@lst.de> <4C1F3916.4070608@kernel.dk> <x49mxuo6ww6.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49mxuo6ww6.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/06/10 20.52, Jeff Moyer wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> On 2010-06-21 11:48, Christoph Hellwig wrote:
>>> Now how do we use these flags in the block layer?
>>>  
>>>  - REQ_META
>>>
>>> 	The only place where we ever use this flag is inside the
>>> 	cfq scheduler. In cfq_choose_req we use it to give a meta
>>> 	request priority over one that doesn't have it.  But before
>>> 	that we already do the same preference check with rw_is_sync,
>>> 	which evaluates to true for requests with that are either
>>> 	reads or have REQ_SYNC set.  So for reads the REQ_META flag
>>> 	here effectively is a no-op, and for writes it gives less
>>> 	priority than REQ_SYNC.
>>> 	In addition to that we use it to account for pending metadata
>>> 	requests in cfq_rq_enqueued/cfq_remove_request which gets
>>> 	checked in cfq_should_preempt to give priority to a meta
>>> 	request if the other queue doesn't have any pending meta
>>> 	requests.  But again this priority comes after a similar
>>> 	check for sync requests that checks if the other queue has
>>> 	been marked to have sync requests pending.
>>
>> It's also annotation for blktrace, so you can tell which parts of the IO
>> is meta data etc. The scheduler impact is questionable, I doubt it makes
>> a whole lot of difference.
> 
> Really?  Even after I showed the performance impact of setting that bit
> for journal I/O?
> 
> http://lkml.org/lkml/2010/4/1/344

It's definitely a win in some cases, as you showed there as well.
My initial testing a long time ago had some nice benefits too. So
perhaps the above wasn't worded very well, I always worry that we
have regressions doing boosts for things like that. But given that
meta data is something that needs to be done before we get to the
real data, bumping priority generally seems like a good thing to do.

-- 
Jens Axboe

