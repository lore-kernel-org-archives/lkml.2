Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab1G2MOh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 08:14:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60958 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755804Ab1G2MOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 08:14:36 -0400
Message-ID: <4E32A409.6060707@suse.de>
Date: Fri, 29 Jul 2011 17:44:01 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110616 SUSE/3.1.11 Thunderbird/3.1.11
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch]block: document blk_plug
References: <1311909215.15392.418.camel@sli10-conroe>
In-Reply-To: <1311909215.15392.418.camel@sli10-conroe>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2011 08:43 AM, Shaohua Li wrote:
> Andrew Morton is asking to document blk_plug, so here is my attempt.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> ---
>  include/linux/blkdev.h |   11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> Index: linux/include/linux/blkdev.h
> ===================================================================
> --- linux.orig/include/linux/blkdev.h	2011-07-29 10:51:29.000000000 +0800
> +++ linux/include/linux/blkdev.h	2011-07-29 11:07:49.000000000 +0800
> @@ -858,6 +858,17 @@ struct request_queue *blk_alloc_queue_no
>  extern void blk_put_queue(struct request_queue *);
>  
>  /*
> + * blk_plug gives each task a request list. Since blk_start_plug() called,
> + * requests from the task will be added to the per-task list and then moved
> + * to global request_queue in a batch way at appropriate time(either
> + * blk_finish_plug() is called or task goes to sleep). blk_plug has some
> + * advantages:
> + * 1. Better request merge. The assumption here is requests from a task have
> + *    better chances to be merged.
> + * 2. Better scalability. Requests are moved from per-task list to global
> + *    request_queue in a batch way, so the total times grabing global
> + *    request_queue lock are reduced.
> + *

Hi Shaohua,

This seems too brief atleast for someone like me who has not spent much
time with the code and also is not in kerneldoc format. Here's my attempt:


From: Suresh Jayaraman <sjayaraman@suse.de>
Subject: [PATCH] block: document blk-plug

Thus spake Andrew Morton:

"And I have the usual maintainability whine.  If someone comes up to
vmscan.c and sees it calling blk_start_plug(), how are they supposed to
work out why that call is there?  They go look at the blk_start_plug()
definition and it is undocumented.  I think we can do better than this?"

Shaohua Li attempted to document it. But, I think it was too brief and
was not in kerneldoc format. Here's my attempt to document it. 

Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
---

 block/blk-core.c       |   10 ++++++++++
 include/linux/blkdev.h |   13 ++++++++-----
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index b850bed..355aa2c 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2620,6 +2620,16 @@ EXPORT_SYMBOL(kblockd_schedule_delayed_work);
 
 #define PLUG_MAGIC	0x91827364
 
+/**
+ * blk_start_plug - initialize blk_plug and track it inside the task_struct
+ * @plug:	The &struct blk_plug that needs to be initialized
+ *
+ * Description:
+ *   Tracking blk_plug inside the task_struct will help with flushing the
+ *   pending I/O should the task end up blocking between blk_start_plug() and
+ *   blk_finish_plug() and is important for deadlock avoidance and for the
+ *   performance.
+ */
 void blk_start_plug(struct blk_plug *plug)
 {
 	struct task_struct *tsk = current;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 0e67c45..810ad41 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -858,17 +858,20 @@ struct request_queue *blk_alloc_queue_node(gfp_t, int);
 extern void blk_put_queue(struct request_queue *);
 
 /*
+ * blk_plug allows for build up of queue of related requests by holding the I/O
+ * fragments for a short period.
+ *
  * Note: Code in between changing the blk_plug list/cb_list or element of such
  * lists is preemptable, but such code can't do sleep (or be very careful),
  * otherwise data is corrupted. For details, please check schedule() where
  * blk_schedule_flush_plug() is called.
  */
 struct blk_plug {
-	unsigned long magic;
-	struct list_head list;
-	struct list_head cb_list;
-	unsigned int should_sort;
-	unsigned int count;
+	unsigned long magic; /* detect uninitialized cases */
+	struct list_head list; /* requests */
+	struct list_head cb_list; /* support callbacks */
+	unsigned int should_sort; /*list to be sorted before flushing? */
+	unsigned int count; /* request count to avoid list getting too big */
 };
 #define BLK_MAX_REQUEST_COUNT 16
 

