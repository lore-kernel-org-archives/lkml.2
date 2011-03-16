Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005Ab1CPISm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 04:18:42 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49624 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab1CPISb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 04:18:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=lg02sEOA/0y4Ay3maBHNsucxMZi4BTH+IDokVFsSswWxmwPFWdv1GnS3BKJY3i80sL
         pLO2pXof+Qi6V50oy6GP/f11kTYn4jWohYFsbaBqo8J0WD7H+SraG0bLD6lecOx0At28
         4SpSdjAVeCMXs5WRquh5zvX7Oh/+6vInC5Dbw=
MIME-Version: 1.0
In-Reply-To: <1295659049-2688-5-git-send-email-jaxboe@fusionio.com>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
	<1295659049-2688-5-git-send-email-jaxboe@fusionio.com>
Date: Wed, 16 Mar 2011 16:18:30 +0800
X-Google-Sender-Auth: khwiuVqxnKyyo_LOLMuo8r-oo64
Message-ID: <AANLkTimEyLdYhCc7Ft4i-=us5kTVDAB5GtNOnvabhmUH@mail.gmail.com>
Subject: Re: [PATCH 04/10] block: initial patch for on-stack per-task plugging
From: Shaohua Li <shli@kernel.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
        Vivek Goyal <vgoyal@redhat.com>, jmoyer@redhat.com,
        shaohua.li@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/1/22 Jens Axboe <jaxboe@fusionio.com>:
> Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
> ---
>  block/blk-core.c          |  357 ++++++++++++++++++++++++++++++++------------
>  block/elevator.c          |    6 +-
>  include/linux/blk_types.h |    2 +
>  include/linux/blkdev.h    |   30 ++++
>  include/linux/elevator.h  |    1 +
>  include/linux/sched.h     |    6 +
>  kernel/exit.c             |    1 +
>  kernel/fork.c             |    3 +
>  kernel/sched.c            |   11 ++-
>  9 files changed, 317 insertions(+), 100 deletions(-)
>
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 960f12c..42dbfcc 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -27,6 +27,7 @@
>  #include <linux/writeback.h>
>  #include <linux/task_io_accounting_ops.h>
>  #include <linux/fault-inject.h>
> +#include <linux/list_sort.h>
>
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/block.h>
> @@ -213,7 +214,7 @@ static void blk_delay_work(struct work_struct *work)
>
>        q = container_of(work, struct request_queue, delay_work.work);
>        spin_lock_irq(q->queue_lock);
> -       q->request_fn(q);
> +       __blk_run_queue(q);
>        spin_unlock_irq(q->queue_lock);
>  }
Hi Jens,
I have some questions about the per-task plugging. Since the request
list is per-task, and each task delivers its requests at finish flush
or schedule. But when one cpu delivers requests to global queue, other
cpus don't know. This seems to have problem. For example:
1. get_request_wait() can only flush current task's request list,
other cpus/tasks might still have a lot of requests, which aren't sent
to request_queue. your ioc-rq-alloc branch is for this, right? Will it
be pushed to 2.6.39 too? I'm wondering if we should limit per-task
queue length. If there are enough requests there, we force a flush
plug.
2. some APIs like blk_delay_work, which call __blk_run_queue() might
not work. because other CPUs might not dispatch their requests to
request queue. So __blk_run_queue will eventually find no requests,
which might stall devices.
Since one cpu doesn't know other cpus' request list, I'm wondering if
there are other similar issues.

Thanks,
Shaohua
