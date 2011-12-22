Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab1LVV73 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 16:59:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44797 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543Ab1LVV70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 16:59:26 -0500
Date: Thu, 22 Dec 2011 13:59:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: avi@redhat.com, nate@cpanel.net, cl@linux-foundation.org, oleg@redhat.com,
        axboe@kernel.dk, vgoyal@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] block, mempool, percpu: implement percpu mempool and
 fix blkcg percpu alloc deadlock
Message-Id: <20111222135925.de3221c8.akpm@linux-foundation.org>
In-Reply-To: <1324590326-10135-1-git-send-email-tj@kernel.org>
References: <1324590326-10135-1-git-send-email-tj@kernel.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Dec 2011 13:45:19 -0800
Tejun Heo <tj@kernel.org> wrote:

> This patchset implements mempool for percpu memory and use it to solve
> allocation deadlock problem in block cgroup paths.  Percpu memory
> allocator can't be called from memory reclaim path, mostly because its
> on-demand chunk filling hooks into vmalloc area management, which in
> turn hooks into arch pagetable code.
> 
> This usually isn't a problem but block cgroup code wants to do
> opportunistic percpu allocation to track statistics in IO issue path.
> Currently, it directly calls alloc_percpu() from IO path triggering
> lockdep warning and falling into deadlocks under the right conditions.
> 
> This patchset adds percpu mempool which supports async refilling and
> uses that as allocation buffer to solve the above problem.  It solves
> the problem for the next merge window but I'm not sure about what to
> do about this window and -stable.  The mempool updates seems a bit too
> invasive.  Maybe implement a stripped down allocation buffer in
> block-cgroup?

This is taking the kernel in exactly the wrong direction.  More code,
more complexity.  Let's think of an alternative which takes us in the
right direction.


How about we just delete those statistics and then this patchset?

Or how about we change those statistics to not do percpu allocations,
then delete this patchset?

Or how about we fix the percpu memory allocation code so that it
propagates the gfp flags, then delete this patchset?


All of those things would simplify and/or improve the kernel.  Whereas
this patchset complicates the kernel while working around known
shortcomings.


