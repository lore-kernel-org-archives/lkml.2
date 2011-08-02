Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab1HBAqc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 20:46:32 -0400
Received: from mga03.intel.com ([143.182.124.21]:12418 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753145Ab1HBAq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 20:46:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,303,1309762800"; 
   d="scan'208";a="3218314"
Subject: Re: [patch]block: document blk_plug
From: Shaohua Li <shaohua.li@intel.com>
To: Suresh Jayaraman <sjayaraman@suse.de>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <4E32A409.6060707@suse.de>
References: <1311909215.15392.418.camel@sli10-conroe>
	 <4E32A409.6060707@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Aug 2011 08:46:10 +0800
Message-ID: <1312245970.15392.446.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-29 at 20:14 +0800, Suresh Jayaraman wrote:
> On 07/29/2011 08:43 AM, Shaohua Li wrote:
> > Andrew Morton is asking to document blk_plug, so here is my attempt.
> > 
> > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> > ---
> >  include/linux/blkdev.h |   11 +++++++++++
> >  1 file changed, 11 insertions(+)
> > 
> > Index: linux/include/linux/blkdev.h
> > ===================================================================
> > --- linux.orig/include/linux/blkdev.h	2011-07-29 10:51:29.000000000 +0800
> > +++ linux/include/linux/blkdev.h	2011-07-29 11:07:49.000000000 +0800
> > @@ -858,6 +858,17 @@ struct request_queue *blk_alloc_queue_no
> >  extern void blk_put_queue(struct request_queue *);
> >  
> >  /*
> > + * blk_plug gives each task a request list. Since blk_start_plug() called,
> > + * requests from the task will be added to the per-task list and then moved
> > + * to global request_queue in a batch way at appropriate time(either
> > + * blk_finish_plug() is called or task goes to sleep). blk_plug has some
> > + * advantages:
> > + * 1. Better request merge. The assumption here is requests from a task have
> > + *    better chances to be merged.
> > + * 2. Better scalability. Requests are moved from per-task list to global
> > + *    request_queue in a batch way, so the total times grabing global
> > + *    request_queue lock are reduced.
> > + *
> 
> Hi Shaohua,
> 
> This seems too brief atleast for someone like me who has not spent much
> time with the code and also is not in kerneldoc format. Here's my attempt:
Hi Suresh,
I like the blk_start_plug part below. The blk_plug part needs more
description to explain why we need it.


> From: Suresh Jayaraman <sjayaraman@suse.de>
> Subject: [PATCH] block: document blk-plug
> 
> Thus spake Andrew Morton:
> 
> "And I have the usual maintainability whine.  If someone comes up to
> vmscan.c and sees it calling blk_start_plug(), how are they supposed to
> work out why that call is there?  They go look at the blk_start_plug()
> definition and it is undocumented.  I think we can do better than this?"
> 
> Shaohua Li attempted to document it. But, I think it was too brief and
> was not in kerneldoc format. Here's my attempt to document it. 
> 
> Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
> ---
> 
>  block/blk-core.c       |   10 ++++++++++
>  include/linux/blkdev.h |   13 ++++++++-----
>  2 files changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index b850bed..355aa2c 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -2620,6 +2620,16 @@ EXPORT_SYMBOL(kblockd_schedule_delayed_work);
>  
>  #define PLUG_MAGIC	0x91827364
>  
> +/**
> + * blk_start_plug - initialize blk_plug and track it inside the task_struct
> + * @plug:	The &struct blk_plug that needs to be initialized
> + *
> + * Description:
> + *   Tracking blk_plug inside the task_struct will help with flushing the
> + *   pending I/O should the task end up blocking between blk_start_plug() and
> + *   blk_finish_plug() and is important for deadlock avoidance and for the
> + *   performance.
> + */
I'm not aware blk_plug is to avoid deadlock. It's most for performance
to me. Jens, any idea?

Thanks,
Shaohua

