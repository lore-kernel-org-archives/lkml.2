Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932702Ab1CDW1L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 17:27:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932620Ab1CDW1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 17:27:10 -0500
Date: Fri, 4 Mar 2011 17:27:02 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Shaohua Li <shli@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        hch@infradead.org
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
Message-ID: <20110304222702.GB18921@redhat.com>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
 <1295659049-2688-6-git-send-email-jaxboe@fusionio.com>
 <AANLkTin8FoXX6oqUyW+scwhadyX-TfW16_oKjvngU9-m@mail.gmail.com>
 <20110303221353.GA10366@redhat.com>
 <AANLkTi=MfDzf+-eLbysoP-ZiXX6cV_tVxYE14Vr8FSak@mail.gmail.com>
 <20110304214359.GA18442@redhat.com>
 <4D715E8A.5070006@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D715E8A.5070006@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04 2011 at  4:50pm -0500,
Jens Axboe <jaxboe@fusionio.com> wrote:

> On 2011-03-04 22:43, Mike Snitzer wrote:
> > On Fri, Mar 04 2011 at  8:02am -0500,
> > Shaohua Li <shli@kernel.org> wrote:
> > 
> >> 2011/3/4 Mike Snitzer <snitzer@redhat.com>:
> >>> I'm now hitting a lockdep issue, while running a 'for-2.6.39/stack-plug'
> >>> kernel, when I try an fsync heavy workload to a request-based mpath
> >>> device (the kernel ultimately goes down in flames, I've yet to look at
> >>> the crashdump I took)
> >>>
> >>>
> >>> =======================================================
> >>> [ INFO: possible circular locking dependency detected ]
> >>> 2.6.38-rc6-snitm+ #2
> >>> -------------------------------------------------------
> >>> ffsb/3110 is trying to acquire lock:
> >>>  (&(&q->__queue_lock)->rlock){..-...}, at: [<ffffffff811b4c4d>] flush_plug_list+0xbc/0x135
> >>>
> >>> but task is already holding lock:
> >>>  (&rq->lock){-.-.-.}, at: [<ffffffff8137132f>] schedule+0x16a/0x725
> >>>
> >>> which lock already depends on the new lock.
> >> I hit this too. Can you check if attached debug patch fixes it?
> > 
> > Fixes it for me.
> 
> The preempt bit in block/ should not be needed. Can you check whether
> it's the moving of the flush in sched.c that does the trick?

It works if I leave out the blk-core.c preempt change too.

> The problem with the current spot is that it's under the runqueue lock.
> The problem with the modified variant is that we flush even if the task
> is not going to sleep. We really just want to flush when it is going to
> move out of the runqueue, but we want to do that outside of the runqueue
> lock as well.

OK. So we still need a proper fix for this issue.
