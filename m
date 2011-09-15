Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934177Ab1IOQOh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 12:14:37 -0400
Received: from mta1.cl.cam.ac.uk ([128.232.25.21]:51697 "EHLO
	mta1.cl.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934067Ab1IOQOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 12:14:36 -0400
Date: Thu, 15 Sep 2011 17:14:30 +0100
From: Ripduman Sohan <Ripduman.Sohan@cl.cam.ac.uk>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org
Subject: Re: [PATCH] workqueue: Restore cpus_allowed mask for sleeping
 workqueue rescue threads
Message-ID: <20110915161430.GE1548@tusker>
References: <1314884193-20454-1-git-send-email-ripduman.sohan@cl.cam.ac.uk>
 <20110902002917.GD2752@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110902002917.GD2752@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On Thu, Sep 01, 2011 at 02:36:33PM +0100, Ripduman Sohan wrote:
> > Rescuer threads may be migrated (and are bound) to particular CPUs when
> > active.  However, the allowed_cpus mask is not restored when they return
> > to sleep rendering inconsistent the presented and actual set of CPUs the
> > process may potentially run on.  This patch fixes this oversight by
> > recording the allowed_cpus mask for rescuer threads when it enters the
> > rescuer_thread() main loop and restoring it every time the thread sleeps.
> 
> Hmmm... so, currently, rescuer is left bound to the last cpu it worked
> on.  Why is this a problem?
> 
> Thanks.
> 
> -- 
> tejun

Hi,

The rescuer being left bound to the last CPU it was active on is not a
problem.  As I pointed out in the commit log the issue is that the
allowed_cpus mask is not restored when rescuers return to sleep,
rendering inconsistent the presented and actual set of CPUs the
process may potentially run on.

Perhaps an explanation is in order.  I am working on a system where we
constantly sample process run-state (including the process
Cpus_Allowed field in /proc/<pid>/status) to build a forward plan of
where the process _may_ run in the future.  In situations of high
memory pressue (common on our setup) where the rescuers ran often the
plan begun to significantly deviate from the calculated schedule
because rescuer threads were marked as only runnable on a single CPU
when in reality they would bounce across CPUs.

I've currently put in a special-case exception in our code to account
for the fact that rescuer threads may run on _any_ CPU regardless of
the current cpus_allowed mask but I thought it would be useful to
correct it.  I'm happy to continue with my current approach if you
deem the patch irrelevant.

Kind regards,

--rip
