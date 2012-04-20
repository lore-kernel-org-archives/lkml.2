Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab2DTGBX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 02:01:23 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52719 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab2DTGBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 02:01:21 -0400
Date: Fri, 20 Apr 2012 14:01:01 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        netdev@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH 1/2] workqueue: Catch more locking problems with
 flush_work()
Message-ID: <20120420060101.GA16563@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1334805958-29119-1-git-send-email-sboyd@codeaurora.org>
 <20120419081002.GB3963@zhy>
 <4F905B30.4080501@codeaurora.org>
 <20120420052633.GA16219@zhy>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120420052633.GA16219@zhy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 01:26:33PM +0800, Yong Zhang wrote:
> On Thu, Apr 19, 2012 at 11:36:32AM -0700, Stephen Boyd wrote:
> > Does looking at the second patch help? Basically schedule_work() can run
> > the callback right between the time the mutex is acquired and
> > flush_work() is called:
> > 
> > CPU0                        CPU1
> > 
> > <irq>
> >   schedule_work()           mutex_lock(&mutex)
> > <irq return>
> >     my_work()               flush_work() 
> >       mutex_lock(&mutex)    
> >       <deadlock>
> 
> Get you point. It is a problem. But your patch could introduece false
> positive since when flush_work() is called that very work may finish
> running already.
> 
> So I think we need the lock_map_acquire()/lock_map_release() only when
> the work is under processing, no?

But start_flush_work() has tried take care of this issue except it
doesn't add work->lockdep_map into the chain.

So does below patch help?

Thanks,
Yong

---
From: Yong Zhang <yong.zhang@windriver.com>
Date: Fri, 20 Apr 2012 13:44:16 +0800
Subject: [PATCH] workqueue:lockdep: make flush_work notice deadlock

Connet the lock chain by aquiring work->lockdep_map when
the tobe-flush work is running.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Reported-by: Stephen Boyd <sboyd@codeaurora.org>
---
 kernel/workqueue.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index bc867e8..c096b05 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2461,6 +2461,8 @@ static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr,
 		lock_map_acquire(&cwq->wq->lockdep_map);
 	else
 		lock_map_acquire_read(&cwq->wq->lockdep_map);
+	lock_map_acquire(&work->lockdep_map);
+	lock_map_release(&work->lockdep_map);
 	lock_map_release(&cwq->wq->lockdep_map);
 
 	return true;
-- 
1.7.5.4

