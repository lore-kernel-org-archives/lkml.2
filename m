Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234Ab1GAQhi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 12:37:38 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49268 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757139Ab1GAQhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 12:37:37 -0400
Date: Fri, 1 Jul 2011 18:37:33 +0200
From: Tejun Heo <tj@kernel.org>
To: Ben Greear <greearb@candelatech.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: workqueue question.
Message-ID: <20110701163733.GZ3386@htj.dyndns.org>
References: <4E0A23E7.1000606@candelatech.com>
 <20110629084329.GI3386@htj.dyndns.org>
 <4E0B4C95.6080409@candelatech.com>
 <20110630100031.GP3386@htj.dyndns.org>
 <4E0CAFFC.4000902@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E0CAFFC.4000902@candelatech.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jun 30, 2011 at 10:18:52AM -0700, Ben Greear wrote:
> >>Is there a method that can be called from a workqueue callback
> >>to verify that the item has not been re-added to the work-queue?
> >
> >Can you be a bit more specific?  Are you saying that queue_work() and
> >INIT_WORK() may race?
> 
> No, I don't think that is racing.  Basically, when I'm about
> to logically free (put back into mempool) the task struct, I
> would like to add a sanity check to make sure it's not currently
> scheduled on a work queue.  If it were, that would explain the
> backtraces I was seeing from slub memory debugging logic and
> I'd be closer to understanding the problem.

Ah, okay.  When a work is in pending state, work_pending() is always
true; however, whether a work item is currently being executed is a
bit more complicated.  You'll need to implement a function which looks
similar to the following.

 bool is_work_executing(work)
 {
	for_each_gcwq_cpu(cpu) {
		gcwq = get_gcwq(cpu);
		lock gcwq;
		if (find_worker_executing_work(gcwq, work)) {
			unlock gcwq;
			return true;
		}
		unlock gcwq;
	}
	return false;
 }

But I would recommend watching workqueue tracing points first.

 $ grep workqueue /sys/kernel/debug/tracing/available_events
 workqueue:workqueue_queue_work
 workqueue:workqueue_activate_work
 workqueue:workqueue_execute_start
 workqueue:workqueue_execute_end

You should be able to tell which work is doing what on which CPU.

Thanks.

-- 
tejun
