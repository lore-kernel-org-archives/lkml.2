Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab2ADHTg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 02:19:36 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:42979 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753454Ab2ADHTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 02:19:35 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjQFAMD5A095LLu4/2dsb2JhbABDggWqYYEGgXIBAQU6HCMQCAMYLhQlAyETvWgTixljBJUDkkk
Date: Wed, 4 Jan 2012 18:19:31 +1100
From: Dave Chinner <david@fromorbit.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, vgoyal@redhat.com,
        jmoyer@redhat.com
Subject: Re: [RFC 0/3]block: An IOPS based ioscheduler
Message-ID: <20120104071931.GB17026@dastard>
References: <20120104065337.230911609@sli10-conroe.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120104065337.230911609@sli10-conroe.sh.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 04, 2012 at 02:53:37PM +0800, Shaohua Li wrote:
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
> 
> Comments and suggestions are welcome!

Benchmark results?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
