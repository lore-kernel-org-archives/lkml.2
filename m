Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605Ab2IURuA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 13:50:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47164 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932517Ab2IURt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 13:49:56 -0400
Date: Fri, 21 Sep 2012 10:49:52 -0700
From: Tejun Heo <tj@kernel.org>
To: Dinky Verma <dverma249@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Work queue questions
Message-ID: <20120921174952.GF7264@google.com>
References: <CAHCeSFpar4ykz5cr9dLrO5J4r3ZXkwbNkU1O3q=QZs9rFEyB6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHCeSFpar4ykz5cr9dLrO5J4r3ZXkwbNkU1O3q=QZs9rFEyB6w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 06:35:25PM +0100, Dinky Verma wrote:
> I have one question regarding concurrency managed workqueue. In the
> previous kernel versions, I was using
> create_singlethread_workqueue("driver_wq") e.g workqueue name is
> driver_wq. In my device driver with the latest kernel version, I am
> doing the same to have a support in my device driver for previous
> kernel versions and new kernel version, I started using
> alloc_workqueue (in intention to create single threaded workqueue)
> e.g.
> 
> wq = alloc_workqueue("driver_wq", WQ_UNBOUND,1);
> 
> create_singlethread_workqueue (Depricated) and alloc_workqueue creates
> work queue both work on the newer kernel versions.

You can use alloc_ordered_workqueue() instead but do you really need
strict ordering among different work items?  If not, it's likely that
you don't need to create separate workqueues at all.

> I have created 3 single threaded workqueues. when I do ps on linux
> console, I see the workqueue thread with process id. When I am queuing
> the work simultaneously on these worker threads, I found that threads
> named with Kworker/X.Y will process the work from the work queue not
> the one that had been created create_singlethread_workqueue.
> 
> When I schedule the three works at the same time, I saw sometimes one
> Kworker/X.Y thread processes all work items.
> 
> The question is why the main worker thread that I created does not
> process the work that is intended for it why instead kworker will
> process it? I have queued the work using queue_work(wq,
> worker_struct).

The kthread named after the workqueue is the rescuer which kicks in
iff work execution can't make forward progress due to memory pressure.
Normally all work items are served by worker threads in shared worker
pool.  What kind of driver is it?  Does it sit in memory reclaim path?

Thanks.

-- 
tejun
