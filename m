Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605Ab0IHKM2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 06:12:28 -0400
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:57230 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750959Ab0IHKM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 06:12:26 -0400
Date: Wed, 8 Sep 2010 20:12:22 +1000
From: Dave Chinner <david@fromorbit.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
        linux-fsdevel@vger.kernel.org
Subject: Re: [2.6.36-rc3] Workqueues, XFS, dependencies and deadlocks
Message-ID: <20100908101222.GY705@dastard>
References: <20100907072954.GM705@dastard>
 <4C86003B.6090706@kernel.org>
 <20100907100108.GN705@dastard>
 <4C861582.6080102@kernel.org>
 <20100907124850.GP705@dastard>
 <4C865CC4.9070701@kernel.org>
 <20100908073428.GR705@dastard>
 <4C87474B.3050405@kernel.org>
 <20100908082819.GV705@dastard>
 <4C874D55.6080402@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C874D55.6080402@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 08, 2010 at 10:46:13AM +0200, Tejun Heo wrote:
> On 09/08/2010 10:28 AM, Dave Chinner wrote:
> >> They may if necessary to keep the workqueue progressing.
> > 
> > Ok, so the normal case is that they will all be processed local to the
> > CPU they were queued on, like the old workqueue code?
> 
> Bound workqueues always process works locally.  Please consider the
> following scenario.
> 
>  w0, w1, w2 are queued to q0 on the same CPU.  w0 burns CPU for 5ms
>  then sleeps for 10ms then burns CPU for 5ms again then finishes.  w1
>  and w2 sleeps for 10ms.
> 
> The following is what happens with the original workqueue (ignoring
> all other tasks and processing overhead).
> 
>  TIME IN MSECS	EVENT
>  0		w0 burns CPU
>  5		w0 sleeps
>  15		w0 wakes and burns CPU
>  20		w0 finishes, w1 starts and sleeps
>  30		w1 finishes, w2 starts and sleeps
>  40		w2 finishes
> 
> With cmwq if @max_active >= 3,
> 
>  TIME IN MSECS	EVENT
>  0		w0 burns CPU
>  5		w0 sleeps, w1 starts and sleeps, w2 starts and sleeps
>  15		w0 wakes and burns CPU, w1 finishes, w2 finishes
>  20		w0 finishes
> 
> IOW, cmwq assigns a new worker when there are more work items to
> process but no work item is currently in progress on the CPU.  Please
> note that this behavior is across *all* workqueues.  It doesn't matter
> which work item belongs to which workqueue.

Ok, so in this case if this was on CPU 1, I'd see kworker[1:0],
kworker[1:1] and kworker[1:2] threads all accumulate CPU time?  I'm
just trying to relate your example it to behaviour I've seen to
check if I understand the example correctly.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
