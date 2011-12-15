Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607Ab1LOQlJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 11:41:09 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:55278 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932308Ab1LOQlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 11:41:02 -0500
Date: Thu, 15 Dec 2011 11:40:49 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Shaohua Li <shli@kernel.org>, Dave Kleikamp <dave.kleikamp@oracle.com>,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] AIO: Don't plug the I/O queue in do_io_submit()
Message-ID: <20111215164049.GH18252@shiny>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@kernel.org>,
	Dave Kleikamp <dave.kleikamp@oracle.com>, linux-aio@kvack.org,
	linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
	Jeff Moyer <jmoyer@redhat.com>
References: <4EE7C74D.1020306@oracle.com>
 <CANejiEU3v9EwhBaL6+nWLrsp-jetV=TVWU7v4vy1cU34qA92gw@mail.gmail.com>
 <4EEA1D1E.8030008@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EEA1D1E.8030008@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090204.4EEA2316.00B3,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 05:15:26PM +0100, Jens Axboe wrote:
> On 2011-12-15 02:09, Shaohua Li wrote:
> > 2011/12/14 Dave Kleikamp <dave.kleikamp@oracle.com>:
> >> Asynchronous I/O latency to a solid-state disk greatly increased
> >> between the 2.6.32 and 3.0 kernels. By removing the plug from
> >> do_io_submit(), we observed a 34% improvement in the I/O latency.
> >>
> >> Unfortunately, at this level, we don't know if the request is to
> >> a rotating disk or not.
> >>
> >> Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
> >> Cc: linux-aio@kvack.org
> >> Cc: Chris Mason <chris.mason@oracle.com>
> >> Cc: Jens Axboe <axboe@kernel.dk>
> >> Cc: Andi Kleen <ak@linux.intel.com>
> >> Cc: Jeff Moyer <jmoyer@redhat.com>
> >>
> >> diff --git a/fs/aio.c b/fs/aio.c
> >> index 78c514c..d131a2c 100644
> >> --- a/fs/aio.c
> >> +++ b/fs/aio.c
> >> @@ -1696,7 +1696,6 @@ long do_io_submit(aio_context_t ctx_id, long nr,
> >>        struct kioctx *ctx;
> >>        long ret = 0;
> >>        int i = 0;
> >> -       struct blk_plug plug;
> >>        struct kiocb_batch batch;
> >>
> >>        if (unlikely(nr < 0))
> >> @@ -1716,8 +1715,6 @@ long do_io_submit(aio_context_t ctx_id, long nr,
> >>
> >>        kiocb_batch_init(&batch, nr);
> >>
> >> -       blk_start_plug(&plug);
> >> -
> >>        /*
> >>         * AKPM: should this return a partial result if some of the IOs were
> >>         * successfully submitted?
> >> @@ -1740,7 +1737,6 @@ long do_io_submit(aio_context_t ctx_id, long nr,
> >>                if (ret)
> >>                        break;
> >>        }
> >> -       blk_finish_plug(&plug);
> >>
> >>        kiocb_batch_free(&batch);
> >>        put_ioctx(ctx);
> > can you explain why this can help? Note, in 3.1 kernel we now force flush
> > plug list if the list is too long, which will remove a lot of latency.
> 
> I think that would indeed be an interesting addition to test on top of
> the 3.0 kernel being used.
> 
> This is a bit of a sticky situation. We want the plugging and merging on
> rotational storage, and on SSDs we want the batch addition to the queue
> to avoid hammering on the queue lock. At this level, we have no idea.
> But we don't want to introduce longer latencies. So the question is, are
> these latencies due to long queues (and hence would be helped with the
> auto-replug on 3.1 and newer), or are they due to the submissions
> running for too long. If the latter, then we can either look into
> reducing the time spent between submitting the individual pieces. Or at
> least not holding up too long.

Each io_submit call is sending down about 34K of IO to two different devices.
The latencies were measured just on the process writing the redo
logs, so it is a very specific subset of the overall benchmark.

The patched kernel only does 4x more iops for the redo logs than the
unpatched kernel, so we're talking ~8K ios here.

-chris

