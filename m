Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953Ab2CFSBD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 13:01:03 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:53276 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753887Ab2CFSBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 13:01:01 -0500
Message-ID: <1331056859.2140.7.camel@joe2Laptop>
Subject: Re: [RFC PATCH] checkpatch: Warn on use of yield()
From: Joe Perches <joe@perches.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Miao Xie <miaox@cn.fujitsu.com>, Christoph Lameter <cl@linux.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>
Date: Tue, 06 Mar 2012 10:00:59 -0800
In-Reply-To: <1331056466.11248.327.camel@twins>
References: <20120302112358.GA3481@suse.de>
	 <1330723262.11248.233.camel@twins>
	 <20120305121804.3b4daed4.akpm@linux-foundation.org>
	 <1330999280.10358.3.camel@joe2Laptop> <1331037942.11248.307.camel@twins>
	 <1331055666.2140.3.camel@joe2Laptop> <1331056466.11248.327.camel@twins>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-06 at 18:54 +0100, Peter Zijlstra wrote:
> On Tue, 2012-03-06 at 09:41 -0800, Joe Perches wrote:
> > Perhaps the kernel-doc comments in sched/core.c
> > should/could be expanded/updated. 
> 
> Something like this?
> 
> ---
>  kernel/sched/core.c |   20 ++++++++++++++++++--
>  1 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 2963fbb..a05a0f7 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4577,8 +4577,24 @@ EXPORT_SYMBOL(__cond_resched_softirq);
>  /**
>   * yield - yield the current processor to other threads.
>   *
> - * This is a shortcut for kernel-space yielding - it marks the
> - * thread runnable and calls sys_sched_yield().
> + * Do not ever use this function, there's a 99% chance you're doing it wrong.
> + *
> + * The scheduler is at all times free to pick the calling task as the most
> + * eligible task to run, if removing the yield() call from your code breaks
> + * it, its already broken.
> + *
> + * Typical broken usage is:
> + *
> + * while (!event)
> + * 	yield();
> + *
> + * where one assumes that yield() will let 'the other' process run that will
> + * make event true. If the current task is a SCHED_FIFO task that will never
> + * happen. Never use yield() as a progress guarantee!!
> + *
> + * If you want to use yield() to wait for something, use wait_event().
> + * If you want to use yield() to be 'nice' for others, use cond_resched().
> + * If you still want to use yield(), do not!
>   */

Yes. I'll update the checkpatch message to say something like:

"Using yield() is generally wrong.  See yield() kernel-doc (sched/core.c)"


