Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746Ab1LVXQy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 18:16:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45988 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab1LVXQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 18:16:50 -0500
Date: Thu, 22 Dec 2011 15:16:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: avi@redhat.com, nate@cpanel.net, cl@linux-foundation.org, oleg@redhat.com,
        axboe@kernel.dk, vgoyal@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] block, mempool, percpu: implement percpu mempool and
 fix blkcg percpu alloc deadlock
Message-Id: <20111222151649.de57746f.akpm@linux-foundation.org>
In-Reply-To: <20111222230047.GN17084@google.com>
References: <1324590326-10135-1-git-send-email-tj@kernel.org>
	<20111222135925.de3221c8.akpm@linux-foundation.org>
	<20111222220911.GK17084@google.com>
	<20111222142058.41316ee0.akpm@linux-foundation.org>
	<20111222224117.GL17084@google.com>
	<20111222145426.5844df96.akpm@linux-foundation.org>
	<20111222230047.GN17084@google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Dec 2011 15:00:47 -0800
Tejun Heo <tj@kernel.org> wrote:

> Hello, Andrew.
> 
> On Thu, Dec 22, 2011 at 02:54:26PM -0800, Andrew Morton wrote:
> > > These stats are userland visible and quite useful ones if blkcg is in
> > > use.  I don't really see how these can be removed.
> > 
> > What stats?
> 
> The ones allocated in the last patch.  blk_group_cpu_stats.

What last patch.

I can find no occurence of "blk_group_cpu_stats" on linux-kernel or in
the kernel tree.

> > For starters, doing pagetable allocation on the I/O path sounds nutty.
> > 
> > Secondly, GFP_NOIO is a *weaker* allocation mode than GFP_KERNEL.  By
> > permitting it with this patchset, we have a kernel which is more likely
> > to get oom failures.  Fixing the kernel to not perform GFP_NOIO
> > allocations for these counters will result in a more robust kernel. 
> > This is a good thing, which improves the kernel while avoiding adding
> > more compexity elsewhere.
> > 
> > This patchset is the worst option and we should try much harder to avoid
> > applying it!
> 
> The stats are per cgroup - request_queue pair.  We don't want to
> allocate for all of them for each combination as there are
> configurations with stupid number of request_queues and silly many
> cgroups and #cgroups * #request_queue * #cpus can be huge.  So, we
> want on-demand allocation.  While the stats are important, they are
> not critical and allocations can be opportunistic.  If the allocation
> fails this time, we can try it for the next time.

Without code to look at I am at a loss.

request_queues are allocated in blk_alloc_queue_node(), which uses
GFP_KERNEL (and also mysteriously takes a gfp_t arg).

> So, yeah, the suggested solution fits the problem.  If you have a
> better idea, please don't be shy.

Unsure which solution you're referring to here.

