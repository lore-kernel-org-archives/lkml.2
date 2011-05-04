Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab1EDI0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 04:26:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34354 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab1EDI0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 04:26:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=q7zSOgG/xl70pmzVOfhnZm4xjZPAkXiqVlyf5UmTkNxpvm0tetGg9TQYAhLfcYxmQc
         9GJ/RIpm794SyOsa1FH1/+D53y9gLQdDAi1J/CkIM8VFd6mTp7xsc/gFACYTjxSo2QTI
         4Dt50v719HeFrKmwujXWTXNotXL2I7NjbD3S4=
Date: Wed, 4 May 2011 10:26:30 +0200
From: Tejun Heo <tj@kernel.org>
To: Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: Don't spin forever in
 worker_maybe_bind_and_lock
Message-ID: <20110504082630.GA8007@htj.dyndns.org>
References: <20110504014749.GA28337@drongo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110504014749.GA28337@drongo>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 11:47:49AM +1000, Paul Mackerras wrote:
> On a 48-thread POWER7 box, I often see the system hang when offlining
> processors.  What happens is that we get a rescuer thread trying to
> move to some processor at the same time that a cpu offline operation
> is happening for that processor, and we end up with one cpu spinning in
> worker_maybe_bind_and_lock() and all of the rest of the online cpus
> spinning inside the stop_machine code.  The rescuer thread is
> continually calling set_cpus_allowed_ptr() which is continually
> failing because the cpu it is trying to move to is no longer in the
> cpu_active_mask.  The result is a deadlock.
> 
> This fixes worker_maybe_bind_and_lock so that it stops trying to move
> to a cpu if that cpu is no longer in the cpu_active_mask, and instead
> returns to its caller.  With this I no longer see the deadlocks when
> offlining cpus.
> 
> Signed-off-by: Paul Mackerras <paulus@samba.org>

Hmm.. fix for the problem has already been merged into mainline and
scheduled for -stable.  Can you please verify the following fixes the
problem?

Thank you.

>From 5035b20fa5cd146b66f5f89619c20a4177fb736d Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Fri, 29 Apr 2011 18:08:37 +0200
Subject: [PATCH] workqueue: fix deadlock in worker_maybe_bind_and_lock()

If a rescuer and stop_machine() bringing down a CPU race with each
other, they may deadlock on non-preemptive kernel.  The CPU won't
accept a new task, so the rescuer can't migrate to the target CPU,
while stop_machine() can't proceed because the rescuer is holding one
of the CPU retrying migration.  GCWQ_DISASSOCIATED is never cleared
and worker_maybe_bind_and_lock() retries indefinitely.

This problem can be reproduced semi reliably while the system is
entering suspend.

 http://thread.gmane.org/gmane.linux.kernel/1122051

A lot of kudos to Thilo-Alexander for reporting this tricky issue and
painstaking testing.

stable: This affects all kernels with cmwq, so all kernels since and
        including v2.6.36 need this fix.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Thilo-Alexander Ginkel <thilo@ginkel.com>
Tested-by: Thilo-Alexander Ginkel <thilo@ginkel.com>
Cc: stable@kernel.org
---
 kernel/workqueue.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 04ef830..e3378e8 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1291,8 +1291,14 @@ __acquires(&gcwq->lock)
 			return true;
 		spin_unlock_irq(&gcwq->lock);
 
-		/* CPU has come up inbetween, retry migration */
+		/*
+		 * We've raced with CPU hot[un]plug.  Give it a breather
+		 * and retry migration.  cond_resched() is required here;
+		 * otherwise, we might deadlock against cpu_stop trying to
+		 * bring down the CPU on non-preemptive kernel.
+		 */
 		cpu_relax();
+		cond_resched();
 	}
 }
 
-- 
1.7.1
