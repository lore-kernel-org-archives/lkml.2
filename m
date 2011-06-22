Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122Ab1FVJhM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 05:37:12 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34395 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242Ab1FVJhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 05:37:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pYunzVTt7sV4LxVK4fLJ4oWyc9VrzxBVjl79GqQX+OKmYRCpK13dm24DNjHEu/MfwX
         /q45mQ2HSU+4YUKxzzurWei6+9Ck0rLmF2aOgK9RpKqAtj1f2o+c86EqGp4IMsf5MFi0
         abJHPkpHeUmh71zN0AcH9u6wBFrPqxGTrWpso=
Date: Wed, 22 Jun 2011 11:37:06 +0200
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [RFC][PATCH 2/3] sched, workqueue: Move WQ-sleeper wakeup
Message-ID: <20110622093706.GB30101@htj.dyndns.org>
References: <20110621233444.094372367@chello.nl>
 <20110621233648.861571721@chello.nl>
 <20110622092430.GA30101@htj.dyndns.org>
 <1308734848.1022.16.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308734848.1022.16.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 11:27:28AM +0200, Peter Zijlstra wrote:
> On Wed, 2011-06-22 at 11:24 +0200, Tejun Heo wrote:
> > Preemption could still be enabled here, right?  What prevents
> > preemtion kicking after wq_worker_sleeping() and do it again thus
> > breaking nr_running tracking.
> 
> Aren't all PF_WQ_WORKER threads cpu-bound?

Hmmm... I don't see how that would matter.  Please consider the
following scenario.

* A work item calls schedule() for whatever reason.

* schedule() calls sched_submit_work() which in turn calls
  wq_worker_sleeping() which adjusts nr_running.  All this happens
  with preemption enabled.

* sched_submit_work() returns but before schedule() does
  preempt_disable(), an IRQ is delivered.  By the time IRQ return path
  is executed, TIF_NEED_RESCHED is set which in turn calls schedule()
  again and repeats the above two steps for the same worker.

Thanks.

-- 
tejun
