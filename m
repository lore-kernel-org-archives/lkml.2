Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab1F3KAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 06:00:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48079 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab1F3KAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 06:00:36 -0400
Date: Thu, 30 Jun 2011 12:00:31 +0200
From: Tejun Heo <tj@kernel.org>
To: Ben Greear <greearb@candelatech.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: workqueue question.
Message-ID: <20110630100031.GP3386@htj.dyndns.org>
References: <4E0A23E7.1000606@candelatech.com>
 <20110629084329.GI3386@htj.dyndns.org>
 <4E0B4C95.6080409@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E0B4C95.6080409@candelatech.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jun 29, 2011 at 09:02:29AM -0700, Ben Greear wrote:
> On 06/29/2011 01:43 AM, Tejun Heo wrote:
> It appears that the code just wants to (re)add itself to the
> work queue with a different callback method:
> 
> static void rpc_final_put_task(struct rpc_task *task,
> 		struct workqueue_struct *q)
> {
> 	if (q != NULL) {
> 		INIT_WORK(&task->u.tk_work, rpc_async_release);
> 		queue_work(q, &task->u.tk_work);
> 	} else
> 		rpc_free_task(task);
> }

Ummm... so, at the time of INIT_WORK(), the tk_work could be already
pending or running?

> My debugging leads me to believe that the rpc_async_release
> is (very rarely) called on a task object that has already been logically
> freed.

What do you mean "logically freed"?  Do you mean the rpc_task struct
is freed twice?

> Is there a better way to queue this up that might have less chance
> of some strange race?

Why not just use a separate work item?

> >>Also, is it valid to free the memory containing foo
> >>in a workqueue callback?
> >
> >Yeap.
> 
> Is there a method that can be called from a workqueue callback
> to verify that the item has not been re-added to the work-queue?

Can you be a bit more specific?  Are you saying that queue_work() and
INIT_WORK() may race?

> I tried doing a cancel, but that caused recursive locking issues.
> 
> I'd like to call this right before freeing the object and BUG_ON()
> if the object is actually still on on a work-queue.

That may be useful as a debugging feature but is inherently racy.
Nothing guarantees the work item won't be queued after BUG_ON() but
before actual freeing.  The guarantee that the work item is no longer
in use should come from the wq user.  There are good number of use
cases where work item frees itself or the containing data structure
and they all work fine.

Thanks.

-- 
tejun
