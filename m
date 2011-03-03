Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab1CCAtd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 19:49:33 -0500
Received: from mga11.intel.com ([192.55.52.93]:3168 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551Ab1CCAtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 19:49:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,256,1297065600"; 
   d="scan'208";a="893190487"
Subject: Re: cfq-iosched preempt issues
From: Shaohua Li <shaohua.li@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        "czoccolo@gmail.com" <czoccolo@gmail.com>,
        "guijianfeng@cn.fujitsu.com" <guijianfeng@cn.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20110302202118.GA2547@redhat.com>
References: <20110302124341.GA23940@sli10-conroe.sh.intel.com>
	 <20110302202118.GA2547@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Mar 2011 08:49:30 +0800
Message-ID: <1299113370.19589.71.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-03 at 04:21 +0800, Vivek Goyal wrote:
> On Wed, Mar 02, 2011 at 08:43:41PM +0800, Shaohua Li wrote:
> > queue preemption is good for some workloads and not for others. With commit
> > f8ae6e3eb825, the impact is amplified. I currently have two issues with it:
> > 1. In a multi-threaded workload, each thread runs a random read/write (for
> > example, mmap write) with iodepth 1. I found the queue depth gets smaller
> > with commit f8ae6e3eb825. The reason is write gets preempted, so more threads
> > are waitting for write, and on the other hand, there are less threads doing
> > read. This will make the queue depth small, so performance drops a little.
> > So in this case, speed up write can speed up read too, but we can't detect
> > it.
> > 2. cfq_may_dispatch doesn't limit queue depth if the queue is the sole queue.
> > What about if there are two queues, one sync and one async? If the sync queue's
> > think time is small, we can treat it as the sole queue, because the sync queue
> > will preempt async queue, so we don't need care about the async queue's latency.
> > The issue exists before, but f8ae6e3eb825 amplifies it. Below is a patch for it.
> > 
> > Any idea?
> 
> CFQ is already very complicated, lets try to keep it simple. Because it
> is complicated, making it hierarchical for cgroup becomes even harder.
> 
> IIUC, you are saying that cfqd->busy_queues check is not sufficient as
> it takes async queues also in account.
> 
> So we can keep another count say, cfqd->busy_sync_queues and if there
> are no busy_sync_queues, allow unlimited depth and that should be
> a really simple few lines change.
sure, this is ok too.

> But lets do it only if you have a real life workload. Similiarly we can
> worry about RT case when there is a real workload behind it.
aiostress is the workload. but I haven't real workload for the RT case.

Thanks,
Shaohua

