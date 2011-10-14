Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933118Ab1JNPF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 11:05:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756915Ab1JNPFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 11:05:25 -0400
Date: Fri, 14 Oct 2011 11:05:13 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jeff Moyer <jmoyer@redhat.com>, jaxboe@fusionio.com, dm-devel@redhat.com,
        msnitzer@redhat.com, linux-kernel@vger.kernel.org, christophe@saout.de
Subject: Re: [dm-devel] [PATCH 1/2] blk-flush: move the queue kick into
 blk_insert_cloned_request
Message-ID: <20111014150513.GC4142@redhat.com>
References: <1318454562-25291-1-git-send-email-jmoyer@redhat.com>
 <1318454562-25291-2-git-send-email-jmoyer@redhat.com>
 <20111012221732.GH6281@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111012221732.GH6281@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 03:17:32PM -0700, Tejun Heo wrote:
> On Wed, Oct 12, 2011 at 05:22:41PM -0400, Jeff Moyer wrote:
> > A dm-multipath user reported[1] a problem when trying to boot
> > a kernel with commit 4853abaae7e4a2af938115ce9071ef8684fb7af4
> > (block: fix flush machinery for stacking drivers with differring
> > flush flags) applied.  It turns out that an empty flush request
> > can be sent into blk_insert_flush.  When the BUG_ON was fixed
> > to allow for this, I/O on the underlying device would stall.  The
> > reason is that blk_insert_cloned_request does not kick the queue.
> > In the aforementioned commit, I had added a special case to
> > kick the queue if data was sent down but the queue flags did
> > not require a flush.  A better solution is to push the queue
> > kick up into blk_insert_cloned_request.
> > 
> > This patch, along with a follow-on which fixes the BUG_ON, fixes
> > the issue reported.
> > 
> > [1] http://www.redhat.com/archives/dm-devel/2011-September/msg00154.html
> > 
> > Reported-by: Christophe Saout <christophe@saout.de>
> > Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> 
> Thank you for fixing this, but one curiosity, what happens for !flush
> cloned requests?  Is someone else responsible for kicking the queue?

I guess it is working for non flush requests because
blk_insert_cloned_request() inserts requests at the back (ELEVATOR_INSERT_BACK)
and elevator code is kicking the queue in that case.

        case ELEVATOR_INSERT_BACK:
                rq->cmd_flags |= REQ_SOFTBARRIER;
                elv_drain_elevator(q);
                list_add_tail(&rq->queuelist, &q->queue_head);
                /*
                 * We kick the queue here for the following reasons.
                 * - The elevator might have returned NULL previously
                 *   to delay requests and returned them now.  As the
                 *   queue wasn't empty before this request, ll_rw_blk
                 *   won't run the queue on return, resulting in hang.
                 * - Usually, back inserted requests won't be merged
                 *   with anything.  There's no point in delaying queue
                 *   processing.
                 */
                __blk_run_queue(q);
                break;

So it is really not clear who should kick the queue and when. Though extra
kick won't harm, so to me it looks that blk_insert_cloned_reqeust()
should always kick the queue after inserting any request (Either back
insert for flush insert etc.).

According to above comment we kick the queue here as elevaor might have
returned NULL in the past despite have a request. If that's the case then
somebody should have setup a timer to dispatch that request in time. What
happens if next request does not come for next 10 seconds. This request
will be sitting there for a long time.

So to me, blk_insert_cloned_request() should not rely on queue kick being
provided by ELEVATOR_INSERT_BACK. It should always kick the queue after
inserting a request. (as tejun mentioned about blk_insert_request()
kicking the queue).

Thanks
Vivek
