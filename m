Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151Ab1IGVaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 17:30:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56208 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757108Ab1IGVaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 17:30:18 -0400
Date: Wed, 7 Sep 2011 14:30:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Frank van Maarseveen <frankvm@frankvm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: 3.0.3 kernel BUG at kernel/timer.c:1035
Message-Id: <20110907143006.0d0922dd.akpm@linux-foundation.org>
In-Reply-To: <1315398979.2938.0.camel@hp6530s>
References: <20110824130238.GA24543@janus>
	<20110902011058.c5bad476.akpm@linux-foundation.org>
	<20110905123813.GA29763@janus>
	<CAF1ivSYui_=tHbxHiy15a9wfiphHcpoY+J1MmAJ=dMQsAfEVLw@mail.gmail.com>
	<1315320518.4235.3.camel@hp6530s>
	<20110907102425.GA3423@janus>
	<1315398979.2938.0.camel@hp6530s>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Sep 2011 20:36:19 +0800
Lin Ming <ming.m.lin@intel.com> wrote:

> On Wed, 2011-09-07 at 18:24 +0800, Frank van Maarseveen wrote:
> > On Tue, Sep 06, 2011 at 10:48:38PM +0800, Lin Ming wrote:
> > > Does below patch help?
> > > 
> > > >From a98b874437f871d5ecc3f6fe409b2b474b1f2731 Mon Sep 17 00:00:00 2001
> > > From: Lin Ming <ming.m.lin@intel.com>
> > > Date: Tue, 6 Sep 2011 22:45:43 +0800
> > > Subject: [PATCH] block: delete bdi writeback wakup_timer in blk_cleanup_queue()
> > > 
> > > Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> > > ---
> > >  block/blk-core.c |    1 +
> > >  1 files changed, 1 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/block/blk-core.c b/block/blk-core.c
> > > index 90e1ffd..22529a3 100644
> > > --- a/block/blk-core.c
> > > +++ b/block/blk-core.c
> > > @@ -363,6 +363,7 @@ void blk_cleanup_queue(struct request_queue *q)
> > >  	blk_sync_queue(q);
> > >  
> > >  	del_timer_sync(&q->backing_dev_info.laptop_mode_wb_timer);
> > > +	del_timer_sync(&q->backing_dev_info.wb.wakeup_timer);
> > >  	mutex_lock(&q->sysfs_lock);
> > >  	queue_flag_set_unlocked(QUEUE_FLAG_DEAD, q);
> > >  	mutex_unlock(&q->sysfs_lock);
> > > -- 
> > > 1.7.2.3
> > > 
> > 
> > No, bug still present. Stack trace is the same and I double checked that
> > it was the new kernel (this time with a lot more debug enabled).
> 
> Thanks for test.
> I'll try to reproduce this bug.

Probably this will "fix" it:

--- a/block/blk-sysfs.c~a
+++ a/block/blk-sysfs.c
@@ -4,6 +4,7 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/timer.h>
 #include <linux/bio.h>
 #include <linux/blkdev.h>
 #include <linux/blktrace_api.h>
@@ -486,7 +487,7 @@ static void blk_release_queue(struct kob
 		__blk_queue_free_tags(q);
 
 	blk_trace_shutdown(q);
-
+	del_timer_sync(&q->backing_dev_info.wb.wakeup_timer);
 	bdi_destroy(&q->backing_dev_info);
 	kmem_cache_free(blk_requestq_cachep, q);
 }
_

Jens, can you please take a look at this regression? 
blk_release_queue() is freeing a pending timer.
