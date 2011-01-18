Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338Ab1ARPuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 10:50:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781Ab1ARPuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 10:50:12 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Tao Ma <tm@tao.ma>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] blktrace: Don't output messages if the user sets some action mask.
References: <1295333017-5659-1-git-send-email-tm@tao.ma>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 18 Jan 2011 10:50:01 -0500
In-Reply-To: <1295333017-5659-1-git-send-email-tm@tao.ma> (Tao Ma's message of
	"Tue, 18 Jan 2011 14:43:37 +0800")
Message-ID: <x491v4a5hzq.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tao Ma <tm@tao.ma> writes:

> From: Tao Ma <boyu.mt@taobao.com>
>
> Now if we enable blktrace, cfq has too many messages output to the
> trace buffer. It is fine if we don't specify any action mask.
> But if I do like this:
> blktrace /dev/sdb -a issue -a complete -o - | blkparse -i -
> I only want to see 'D' and 'C', while with the following command
> dd if=/mnt/ocfs2/test of=/dev/null bs=4k count=1 iflag=direct
>
> I will get(with a 2.6.37 vanilla kernel):
>   8,16   0        0     0.000000000     0  m   N cfq3805 alloced
>   8,16   0        0     0.000004126     0  m   N cfq3805 insert_request
>   8,16   0        0     0.000004884     0  m   N cfq3805 add_to_rr
>   8,16   0        0     0.000008417     0  m   N cfq workload slice:300
>   8,16   0        0     0.000009557     0  m   N cfq3805 set_active wl_prio:0 wl_type:2
>   8,16   0        0     0.000010640     0  m   N cfq3805 fifo=          (null)
>   8,16   0        0     0.000011193     0  m   N cfq3805 dispatch_insert
>   8,16   0        0     0.000012221     0  m   N cfq3805 dispatched a request
>   8,16   0        0     0.000012802     0  m   N cfq3805 activate rq, drv=1
>   8,16   0        1     0.000013181  3805  D   R 114759 + 8 [dd]
>   8,16   0        2     0.000164244     0  C   R 114759 + 8 [0]
>   8,16   0        0     0.000167997     0  m   N cfq3805 complete rqnoidle 0
>   8,16   0        0     0.000168782     0  m   N cfq3805 set_slice=100
>   8,16   0        0     0.000169874     0  m   N cfq3805 arm_idle: 8 group_idle: 0
>   8,16   0        0     0.000170189     0  m   N cfq schedule dispatch
>   8,16   0        0     0.000397938     0  m   N cfq3805 slice expired t=0
>   8,16   0        0     0.000399763     0  m   N cfq3805 sl_used=1 disp=1 charge=1 iops=0 sect=8
>   8,16   0        0     0.000400227     0  m   N cfq3805 del_from_rr
>   8,16   0        0     0.000400882     0  m   N cfq3805 put_queue
>
> See, there are 19 lines while I only need 2. I don't think it is
> appropriate for a user.
>
> So this patch will disable any messages if the user specify what he want to
> see. Now the output for the same command will look like:
>   8,16   0        1     0.000000000  4908  D   R 114759 + 8 [dd]
>   8,16   0        2     0.000146827     0  C   R 114759 + 8 [0]
>
> Yes, it is what I want to see.
>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> ---
>  kernel/trace/blktrace.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
> index 153562d..8219ffa 100644
> --- a/kernel/trace/blktrace.c
> +++ b/kernel/trace/blktrace.c
> @@ -138,6 +138,14 @@ void __trace_note_message(struct blk_trace *bt, const char *fmt, ...)
>  		     !blk_tracer_enabled))
>  		return;
>  
> +	/*
> +	 * If the user does specify some action masks, don't send any note
> +	 * message to the trace so that it won't pollute what the user really
> +	 * want to see.
> +	 */
> +	if (bt->act_mask != (u16) -1)
> +		return;
> +

I think you want to check for the BLK_TC_NOTIFY bit.

Cheers,
Jeff
