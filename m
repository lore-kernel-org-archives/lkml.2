Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760301Ab0I0WhI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 18:37:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757411Ab0I0WhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 18:37:06 -0400
Date: Mon, 27 Sep 2010 18:37:01 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        Lennart Poettering <lennart@poettering.net>
Subject: Re: Request starvation with CFQ
Message-ID: <20100927223701.GF2377@redhat.com>
References: <20100927190024.GF3610@quack.suse.cz>
 <20100927200232.GA2377@redhat.com>
 <4CA114F8.8000102@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CA114F8.8000102@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 07:04:40AM +0900, Jens Axboe wrote:

[..]
> >>   I can provide the full traces for download if someone is interested
> >> in some part I didn't include here. The kernel is 2.6.36-rc4.
> >>   Now I agree that the above program is about as bad as it can get but
> >> Lennart would like to implement readahead during boot on background and
> >> I believe that could starve other IO in a similar way. So any idea how
> >> to solve this? To me it seems as if we also needed to somehow limit the
> >> number of allocated requests per cfqq but OTOH we have to be really careful
> >> to not harm common workloads where we benefit from having lots of requests
> >> queued...
> > 
> > Hi Jan,
> > 
> > True that during request allocation, there is no consideration for ioprio.
> > I think the whole logic is round robin, where after getting a bunch of
> > request each process is put to sleep in the queue and then we do round
> > robin on all waiters. This should in general be an issue with request
> > queue and not just CFQ.
> > 
> > So if there are bunch of threads which are very bullish on doing IO, and 
> > there is a dependent reader, read latencies will shoot up.
> > 
> > In fact current implementation of blkio controller also suffers with this
> > limitation because we don't yet have per group request descriptors and
> > once request queue is congested, requests from one group can get stuck
> > behind the requests from other group.
> > 
> > One way forward could be to implement per cgroup request descriptors and
> > put this readahead thread into a separate cgroup of low weight.
> > 
> > Other could be to implemnet some kind of request quota per priority level.
> > This is similar to per cgroup quota I talked above, just one level below.
> > 
> > Third could be ad-hoc way of putting some limit on per cfqq. But I think a
> > process can easily circumvent that by forking off child which are not
> > sharing cfq context and then we are back to same situaiton.
> > 
> > A very hackish solution could be to try to increase nr_requests on the 
> > queue to say 1024. This will work only if you know that read-ahead process
> > does some limited amount of read-ahead and does not overwhelm the queue
> > with more than 1024 requets.  And then use ioprio with low prio for
> > read-ahead process.
> 
> I don't think that is necessarily hackish.

> The current rq allocation batching and accounting is pretty horrible imho

Agreed.

> patches I ripped that out. The vm copes a lot better with larger depths
> these days, so what I want to add is just a per-ioc queue limit instead.

Will you get rid of nr_requests altogether or will keep both nr_requests
as well as per-ioc queue limits?

per-ioc queue limits will help that one io context can not monopolize the
queue but IMHO, it does not protect against some program forking multiple
threads and submitting bunch of IO (processes not sharing ioc).

But I guess that's a separate issue altogether. Per-ioc limit is at least
one step forward.

Thanks
Vivek
