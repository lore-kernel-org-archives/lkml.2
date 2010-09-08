Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758469Ab0IHIW4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 04:22:56 -0400
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:35176 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758390Ab0IHIWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 04:22:53 -0400
Date: Wed, 8 Sep 2010 18:22:49 +1000
From: Dave Chinner <david@fromorbit.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
        linux-fsdevel@vger.kernel.org
Subject: Re: [2.6.36-rc3] Workqueues, XFS, dependencies and deadlocks
Message-ID: <20100908082249.GT705@dastard>
References: <20100907072954.GM705@dastard>
 <4C86003B.6090706@kernel.org>
 <20100907100108.GN705@dastard>
 <4C861582.6080102@kernel.org>
 <4C862F8E.7030507@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C862F8E.7030507@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 07, 2010 at 02:26:54PM +0200, Tejun Heo wrote:
> On 09/07/2010 12:35 PM, Tejun Heo wrote:
> > Can you please help me a bit more?  Are you saying the following?
> > 
> > Work w0 starts execution on wq0.  w0 tries locking but fails.  Does
> > delay(1) and requeues itself on wq0 hoping another work w1 would be
> > queued on wq0 which will release the lock.  The requeueing should make
> > w0 queued and executed after w1, but instead w1 never gets executed
> > while w0 hogs the CPU constantly by re-executing itself.  Also, how
> > does delay(1) help with chewing up CPU?  Are you talking about
> > avoiding constant lock/unlock ops starving other lockers?  In such
> > case, wouldn't cpu_relax() make more sense?
> 
> Ooh, almost forgot.  There was nr_active underflow bug in workqueue
> code which could lead to malfunctioning max_active regulation and
> problems during queue freezing, so you could be hitting that too.  I
> sent out pull request some time ago but hasn't been pulled into
> mainline yet.  Can you please pull from the following branch and add
> WQ_HIGHPRI as discussed before and see whether the problem is still
> reproducible?

Ok, it looks as if the WQ_HIGHPRI is all that was required to avoid
the log IO completion starvation livelocks. I haven't yet pulled
the tree below, but I've now created about a billion inodes without
seeing any evidence of the livelock occurring.

Hence it looks like I've been seeing two livelocks - one caused by
the VM that Mel's patches fix, and one caused by the workqueue
changeover that is fixed by the WQ_HIGHPRI change.

Thanks for you insights, Tejun - I'll push the workqueue change
through the XFS tree to Linus.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
