Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932513Ab1C3OBo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 10:01:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754746Ab1C3OBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 10:01:43 -0400
Date: Wed, 30 Mar 2011 10:01:24 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
        hch@infradead.org
Subject: Re: block: eliminate ELEVATOR_INSERT_REQUEUE
Message-ID: <20110330140123.GA28212@redhat.com>
References: <4D8CF202.9010809@kernel.dk>
 <20110326042156.GB28458@redhat.com>
 <20110328082321.GC16530@htj.dyndns.org>
 <20110328221547.GA1118@redhat.com>
 <x49y63yvwum.fsf@segfault.boston.devel.redhat.com>
 <20110329175458.GE24485@redhat.com>
 <20110330074123.GA17523@htj.dyndns.org>
 <20110330075752.GC17523@htj.dyndns.org>
 <4D92E2CD.6000909@kernel.dk>
 <20110330080203.GD17523@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110330080203.GD17523@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30 2011 at  4:02am -0400,
Tejun Heo <tj@kernel.org> wrote:

> Hello, Jens.
> 
> On Wed, Mar 30, 2011 at 09:59:09AM +0200, Jens Axboe wrote:
> > Pure front insert should be used for requeue and internal commands (like
> > spin up this drive, or get error information). Flush should append to
> > the dispatch list.
> 
> Yeah, right.  The reason I used REQUEUE/FRONT was because BACK
> insertion involves draining the elevator and then appending the
> request at the end of the dispatch queue, which is unnecessary and
> inefficient.  So, front insertion was a quick work around that.  If
> we're removing elv_insert(), we can just append directly to the
> dispatch queue from flush code.

I'm trying to follow along but unrolling what was said above is
challenging considering we're not getting rid of elv_insert()'s
functionality; it was just folded into __elv_add_request() -- offering
no functional change AFAIK.  So placing special meaning on getting rid
of elv_insert() is confusing me.

Why can we all of a sudden append the flush to the dispatch queue _but_
not have any concern about queue draining?  Seems that avoiding use of
BACK, by using list_add_tail, is enabling that.  Couldn't we have always
done that?  The folding of elv_insert() into __elv_add_request() seems
irrelevant.

Can we take a step back and be more explicit about the implications of
having inserted the flush with REQUEUE/FRONT?  Seems to me that having
_not_ inserted the flush at the end of the dispatch queue is cause for
potential corruption (preceding data hasn't been issued to the device
yet).

And just to be clear: none of this is a concern for stable right?  It is
just the flush-merge code introduced for 2.6.39 that needs fixing?

Please advise, thanks!
Mike
