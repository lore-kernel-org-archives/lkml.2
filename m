Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007Ab1CBV1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 16:27:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756058Ab1CBV1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 16:27:38 -0500
Date: Wed, 2 Mar 2011 16:27:34 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Shaohua Li <shaohua.li@intel.com>, jaxboe@fusionio.com, czoccolo@gmail.com,
        guijianfeng@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: cfq-iosched preempt issues
Message-ID: <20110302212733.GA7824@redhat.com>
References: <20110302124341.GA23940@sli10-conroe.sh.intel.com>
 <20110302202118.GA2547@redhat.com>
 <x49bp1t2pyd.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49bp1t2pyd.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 04:05:30PM -0500, Jeff Moyer wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > On Wed, Mar 02, 2011 at 08:43:41PM +0800, Shaohua Li wrote:
> >> queue preemption is good for some workloads and not for others. With commit
> >> f8ae6e3eb825, the impact is amplified. I currently have two issues with it:
> >> 1. In a multi-threaded workload, each thread runs a random read/write (for
> >> example, mmap write) with iodepth 1. I found the queue depth gets smaller
> >> with commit f8ae6e3eb825. The reason is write gets preempted, so more threads
> >> are waitting for write, and on the other hand, there are less threads doing
> >> read. This will make the queue depth small, so performance drops a little.
> >> So in this case, speed up write can speed up read too, but we can't detect
> >> it.
> >> 2. cfq_may_dispatch doesn't limit queue depth if the queue is the sole queue.
> >> What about if there are two queues, one sync and one async? If the sync queue's
> >> think time is small, we can treat it as the sole queue, because the sync queue
> >> will preempt async queue, so we don't need care about the async queue's latency.
> >> The issue exists before, but f8ae6e3eb825 amplifies it. Below is a patch for it.
> >> 
> >> Any idea?
> >
> > CFQ is already very complicated, lets try to keep it simple. Because it
> > is complicated, making it hierarchical for cgroup becomes even harder.
> >
> > IIUC, you are saying that cfqd->busy_queues check is not sufficient as
> > it takes async queues also in account.
> >
> > So we can keep another count say, cfqd->busy_sync_queues and if there
> > are no busy_sync_queues, allow unlimited depth and that should be
> > a really simple few lines change.
> 
> That covers workload 2, but what about 1?  I'm really not sure what the
> workload there is.

But CFQ can't track that if reads are stuck behind peding writes. And the
whole philosophy is that give READS the importance and not WRITES. So I
am not sure what we can do about first case.

If we are really worried about performance and willing to loose isolation
in the process (read vs write isolation, or isolation across groups), then
may be we can think of implementing another tunables say min_queue_depth.
That tells CFQ that don't idle if you are not driving min_queue_depth.

But again, this should be backed by some real workloads.

Thanks
Vivek
