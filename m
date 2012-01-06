Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620Ab2AFJlv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 04:41:51 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:53812 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754930Ab2AFJlt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 04:41:49 -0500
MIME-Version: 1.0
In-Reply-To: <20120104065337.230911609@sli10-conroe.sh.intel.com>
References: <20120104065337.230911609@sli10-conroe.sh.intel.com>
From: Zhu Yanhai <zhu.yanhai@gmail.com>
Date: Fri, 6 Jan 2012 17:41:27 +0800
Message-ID: <CAC8teKXs7YQSzcC151B0PRQpz0Uu9=L1mC9VfOxx-Hxc5g2SCA@mail.gmail.com>
Subject: Re: [RFC 0/3]block: An IOPS based ioscheduler
To: Shaohua Li <shaohua.li@intel.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, vgoyal@redhat.com,
        jmoyer@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2012/1/4 Shaohua Li <shaohua.li@intel.com>:
> An IOPS based I/O scheduler
>
> Flash based storage has some different characteristics against rotate disk.
> 1. no I/O seek.
> 2. read and write I/O cost usually is much different.
> 3. Time which a request takes depends on request size.
> 4. High throughput and IOPS, low latency.
>
> CFQ iosched does well for rotate disk, for example fair dispatching, idle
> for sequential read. It also has optimization for flash based storage (for
> item 1 above), but overall it's not designed for flash based storage. It's
> a slice based algorithm. Since flash based storage request cost is very
> low, and drive has big queue_depth is quite popular now which makes
> dispatching cost even lower, CFQ's slice accounting (jiffy based)
> doesn't work well. CFQ doesn't consider above item 2 & 3.
>
> FIOPS (Fair IOPS) ioscheduler is trying to fix the gaps. It's IOPS based, so
> only targets for drive without I/O seek. It's quite similar like CFQ, but
> the dispatch decision is made according to IOPS instead of slice.
>
> The algorithm is simple. Drive has a service tree, and each task lives in
> the tree. The key into the tree is called vios (virtual I/O). Every request
> has vios, which is calculated according to its ioprio, request size and so
> on. Task's vios is the sum of vios of all requests it dispatches. FIOPS
> always selects task with minimum vios in the service tree and let the task
> dispatch request. The dispatched request's vios is then added to the task's
> vios and the task is repositioned in the sevice tree.
>
> The series are orgnized as:
> Patch 1: separate CFQ's io context management code. FIOPS will use it too.
> Patch 2: The core FIOPS.
> Patch 3: request read/write vios scale. This demontrates how the vios scale.
>
> To make the code simple for easy view, some scale code isn't included here,
> some not implementated yet.
>
> TODO:
> 1. ioprio support (have patch already)
> 2. request size vios scale
> 3. cgroup support
> 4. tracing support
> 5. automatically select default iosched according to QUEUE_FLAG_NONROT.

Actually most RAID cards we have ever seen report the wrong value for
this flag, including LSI's 1078E, 9260/9265, HBA cards, etc. So it may
needs a human-being to setup it correctly to make this adaptive code
work.
Also there is a much more complicated scenario ahead :) that's the
hybrid storage. E.g, one or two SSD mixed with several SAS disks, or
one expensive FusionIO's ioDrive mixed with several SAS disks, powered
by Facebook's Flashcache. AFAIK there is not any IO bandwidth control
solution for such things. However such setups are really very popular
these days.
I'm going to take some tests with these code against the real workload
this month, hopefully we can get more ideas, and of course the
feedback data.

--
Thanks,
Zhu Yanhai
Taobao Inc.

>
> Comments and suggestions are welcome!
>
> Thanks,
> Shaohua
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
