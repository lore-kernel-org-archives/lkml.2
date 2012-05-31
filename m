Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456Ab2EaKid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 06:38:33 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47590 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab2EaKib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 06:38:31 -0400
Subject: [PATCH] block: avoid infinite loop in get_task_io_context()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1338410107.2760.544.camel@edumazet-glaptop>
References: <4FC6189B.9080909@fusionio.com>
	 <1338402812.2760.413.camel@edumazet-glaptop>
	 <4FC66D3D.6080509@fusionio.com>
	 <1338404902.2760.451.camel@edumazet-glaptop>
	 <1338410107.2760.544.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 31 May 2012 12:38:26 +0200
Message-ID: <1338460706.2760.1330.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

On Wed, 2012-05-30 at 22:35 +0200, Eric Dumazet wrote:
> On Wed, 2012-05-30 at 21:08 +0200, Eric Dumazet wrote:
> > On Wed, 2012-05-30 at 20:55 +0200, Jens Axboe wrote:
> > > On 05/30/2012 08:33 PM, Eric Dumazet wrote:
> > > > On Wed, 2012-05-30 at 14:54 +0200, Jens Axboe wrote:
> > > >> Hi Linus,
> > > >>
> > > >> On top of the for-3.5/core pull request, here are the driver related
> > > >> changes for 3.5. It contains:
> > > > 
> > > > Hi Jens
> > > > 
> > > > Not sure if this is related, but latest Linus tree cannot boot anymore
> > > > here...
> > > > 
> > > > BUG: soft lockup - CPU#3 stuck for 22s ! [mountall.1603]
> > > 
> > > Hrmpf, can you attach your .config?
> > > 
> > 
> > I can do a bisection pretty fast I think
> 
> Not sure if bisection was good, but result is :

Bisection gave nothing, because its an old bug ?

Following patch cures it.

[PATCH] block: avoid infinite loop in get_task_io_context()

Calling get_task_io_context() on a exiting task which isn't %current can
loop forever. This triggers at boot time on my dev machine.

BUG: soft lockup - CPU#3 stuck for 22s ! [mountall.1603]

Fix this by making create_task_io_context() returns -EBUSY in this case
to break the loop.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@linux.intel.com>
---
 block/blk-ioc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index 1e2d53b..893b800 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -235,6 +235,7 @@ void ioc_clear_queue(struct request_queue *q)
 int create_task_io_context(struct task_struct *task, gfp_t gfp_flags, int node)
 {
 	struct io_context *ioc;
+	int ret;
 
 	ioc = kmem_cache_alloc_node(iocontext_cachep, gfp_flags | __GFP_ZERO,
 				    node);
@@ -262,9 +263,12 @@ int create_task_io_context(struct task_struct *task, gfp_t gfp_flags, int node)
 		task->io_context = ioc;
 	else
 		kmem_cache_free(iocontext_cachep, ioc);
+
+	ret = task->io_context ? 0 : -EBUSY;
+
 	task_unlock(task);
 
-	return 0;
+	return ret;
 }
 
 /**


