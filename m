Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab0IMAwZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 20:52:25 -0400
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:58869 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754065Ab0IMAwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 20:52:23 -0400
Date: Mon, 13 Sep 2010 10:51:51 +1000
From: Dave Chinner <david@fromorbit.com>
To: Tejun Heo <tj@kernel.org>
Cc: Florian Mickler <florian@mickler.org>, lkml <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH UPDATED] workqueue: add documentation
Message-ID: <20100913005151.GB411@dastard>
References: <4C87AE52.70401@kernel.org>
 <4C87B101.2080608@kernel.org>
 <20100909100229.250900f0@schatten.dmk.lab>
 <4C88B55E.90203@kernel.org>
 <20100909205056.1ac7989a@schatten.dmk.lab>
 <4C8A07B3.1050603@kernel.org>
 <20100910162658.254b224a@schatten.dmk.lab>
 <4C8A46D9.5020303@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C8A46D9.5020303@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

A couple more queustions on cmwq.

On Fri, Sep 10, 2010 at 04:55:21PM +0200, Tejun Heo wrote:
.....
> +  WQ_HIGHPRI
> +
> +	Work items of a highpri wq are queued at the head of the
> +	worklist of the target gcwq and start execution regardless of
> +	the current concurrency level.  In other words, highpri work
> +	items will always start execution as soon as execution
> +	resource is available.
> +
> +	Ordering among highpri work items is preserved - a highpri
> +	work item queued after another highpri work item will start
> +	execution after the earlier highpri work item starts.
> +
> +	Although highpri work items are not held back by other
> +	runnable work items, they still contribute to the concurrency
> +	level.  Highpri work items in runnable state will prevent
> +	non-highpri work items from starting execution.
> +
> +	This flag is meaningless for unbound wq.

We talked about this for XFS w.r.t. the xfslogd IO completion
work items to be promoted ahead of data IO completion items and
that has worked fine. This appears to gives us only two
levels of priority, or from an user point of view, two levels of
dependency between workqueue item execution.

Thinking about the XFS situation more, we actually have three levels
of dependency: xfslogd -> xfsdatad -> xfsconvertd. That is, we defer
long running, blocking items from xfsdatad to xfsconvertd so we
don't block the xfsdatad from continuing to process data IO
completion items. How do we guarantee that the xfsconvertd work
items won't prevent/excessively delay processing of xfsdatad items?


> +@max_active determines the maximum number of execution contexts per
> +CPU which can be assigned to the work items of a wq.  For example,
> +with @max_active of 16, at most 16 work items of the wq can be
> +executing at the same time per CPU.

I think the reason you were seeing XFS blow this out of the water is
that every IO completion for a write beyond EOF (i.e. every single
one for an extending streaming write) will require inode locking to
update file size. If the inode is locked, then the item will
delay(1), and the cmwq controller will run the next item in a new
worker. That will then block in delay(1) 'cause it can't get the
inode lock, as so on....

As such, I can't see that increasing the max_active count for XFS is
a good thing - all it will do is cause larger blockages to occur....

> +6. Guidelines
> +
> +* Do not forget to use WQ_RESCUER if a wq may process work items which
> +  are used during memory reclaim.  Each wq with WQ_RESCUER set has one
> +  rescuer thread reserved for it.  If there is dependency among
> +  multiple work items used during memory reclaim, they should be
> +  queued to separate wq each with WQ_RESCUER.
> +
> +* Unless strict ordering is required, there is no need to use ST wq.
> +
> +* Unless there is a specific need, using 0 for @nr_active is
                                                  max_active?


Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
