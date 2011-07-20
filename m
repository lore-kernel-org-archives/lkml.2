Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907Ab1GTRHY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 13:07:24 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:41061 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab1GTRHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 13:07:23 -0400
Date: Wed, 20 Jul 2011 19:07:17 +0200
From: Tejun Heo <tj@kernel.org>
To: Todd Poynor <toddpoynor@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Crash in schedule path after worker thread dies
Message-ID: <20110720170717.GF9924@mtj.dyndns.org>
References: <20110720000738.GA18774@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110720000738.GA18774@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Todd.

On Tue, Jul 19, 2011 at 05:07:38PM -0700, Todd Poynor wrote:
> After a worker thread died due to a bug in a work function, a NULL
> dereference was seen when schedule calls wq_worker_sleeping calls
> kthread_data:
> 
>           return to_kthread(task)->data;
> 
> mm_release has apparently already set the task's vfork_done = NULL,
> causing to_kthread to return a bad address (on 3.0-rc7 on ARM).
> 
> I haven't tried a fix because I'm not sure if avoiding this case is
> enough to properly recover from death of a worker thread, or if this
> has already been discussed and rejected in the past.  I searched
> around a little and found some mentions of problems in worker
> functions that were probably followed by the kthread_data crash,
> but didn't turn up any specific discussion of this crash.  So I
> thought I'd start by mentioning this here, and can help fix or test if
> needed.

Hmmm... the scheduler code is oopsing after the worker already oopsed,
escalating the failure mode, right?  Avoiding the scheduler oops can
be done simply by clearing PF_WQ_WORKER in do_exit(); however, it
would still leave workqueue code assuming the worker is busy running
and may lead to workqueue stall.

Cleaning that up would require more code but at that point it isn't
really clear what we would be buying with the added complexity.
Hmmm... maybe it would still be worthwhile to at least keep scheduler
working.  Something like this?

diff --git a/kernel/exit.c b/kernel/exit.c
index 6c7fbbe..412ead0 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -915,6 +915,7 @@ NORET_TYPE void do_exit(long code)
 	 * kernel address.
 	 */
 	set_fs(USER_DS);
+	tsk->flags &= ~PF_WQ_WORKER;
 
 	ptrace_event(PTRACE_EVENT_EXIT, code);
 
-- 
tejun
