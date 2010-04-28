Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459Ab0D1JpW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 05:45:22 -0400
Received: from relay3.sgi.com ([192.48.152.1]:46801 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750831Ab0D1JpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 05:45:21 -0400
Date: Wed, 28 Apr 2010 04:45:17 -0500
From: Robin Holt <holt@sgi.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Robin Holt <holt@sgi.com>, Stefani Seibold <stefani@seibold.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Weirdness in /proc/<pid>/maps and /proc/<pid>/stat.
Message-ID: <20100428094516.GG5677@sgi.com>
References: <20100427185343.GR4920@sgi.com>
 <20100428085631.F835.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100428085631.F835.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 12:19:17PM +0900, KOSAKI Motohiro wrote:
> > 
> > With commit d899bf7b, the behavior of field 28 of /proc/<pid>/stat
> > was changed as was /proc/<pid>/maps.  I don't know if that change was
> > correct, but its resulting behavior is much more difficult to explain.
> > I was wondering if we could determine what the "correct" behavior is
> > before I spend much more time trying to give it the wrong behavior.
> > 
> > My test program is attached below.  Essentially:
> > fork() -> pthread_create() -> fork()
> > 
> > x86_64 2.6.32 stable kernel:
> > Step			stat-28		maps-threadstack
> > p (parent)		0x7fff5607ddc0	N/A
> > c (child)		0x7fff55c7dc50	N/A
> > ppthread		0x7f2cf5c9bff0	0x7f2cf5c9d000:007feff0
> > ppthread+fork		0x7f2cf589be30	0x7f2cf5c9d000:003fee30
> > cpthread		0x7f2cf589be30  0x7f2cf5c9d000:007feff0
> > cpthread+fork		0x7f2cf589be30	0x7f2cf5c9d000:003fee30
> > Note: For all of the above, the /proc/<pids>/task/*/maps files had the
> > stack line like:
> > 7fff55c7d000-7fff56081000 rw-p 00000000 00:00 0                         [stack]
> > 
> > The problems I see are:
> > 1)  In the fork() case, we are using the current userland stack
> >     pointer for task->stack_start.  This appears wrong as the
> >     function which called fork() may be returned to and may
> >     further return to higher level callers, finding sp now
> >     beyond the value reported in /proc/self/stat.  Additionally,
> >     the value reported for the child of the fork has no relationship
> >     to the stack size rlimit any longer.
> 
> BUG.
> 
> 
> > 2)  In the pthread + fork case, in addition to the problem
> >     above, the size information in /proc/self/maps
> >     is incorrect as it does not take into consideration
> >     the same return paths.
> 
> BUG.
> 
> Robin, do you really need this feature? if not, I'll revert this one.

The person who reported the problem does not need the threadstack feature.
They do need a predictable way to find the start_stack value.

I do not see any way to make it consistent without finding the vma for
the stack and seeing if it covers both the task->stack_start and the
stack_start and if not, splitting the vma to fit the stack_start and
stack_size range.

As noted, that means we need to make these vma's non-mergable and also
means a heavily pthreaded application will have considerably more vmas.
Also, as pthreads exit, we need to ensure that userland takes care
of cleaning up the vmas or we are likely to have trouble when a
pthread_exit() is followed by another pthread_create().

My head is spinning.  I really feel like a revert and then clearly scoping
the intended behavior and finding a way to implement that behavior is
the best way forward.  I can be convinced otherwise, but I hope to not
do the work ;)

Thanks,
Robin
