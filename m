Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab1HBAlO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 20:41:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:44998 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753190Ab1HBAlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 20:41:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,303,1309762800"; 
   d="scan'208";a="34447586"
Subject: Re: [PATCH] cfq-iosched: Add some more documentation about idling
From: Shaohua Li <shaohua.li@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>,
        Moyer Jeff Moyer <jmoyer@redhat.com>
In-Reply-To: <20110801155523.GE3805@redhat.com>
References: <20110801155523.GE3805@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Aug 2011 08:41:05 +0800
Message-ID: <1312245665.15392.441.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-01 at 23:55 +0800, Vivek Goyal wrote:
> There are always questions about why CFQ is idling on various conditions.
> Recent ones is Christoph asking again why to idle on REQ_NOIDLE. His
> assertion is that XFS is relying more and more on workqueues and is
> concerned that CFQ idling on IO from every workqueue will impact
> XFS badly.
> 
> So he suggested that I add some more documentation about CFQ idling
> and that can provide more clarity on the topic and also gives an
> opprotunity to poke a hole in theory and lead to improvements.
> 
> So here is my attempt at that. Any comments are welcome.
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  Documentation/block/cfq-iosched.txt |   70 +++++++++++++++++++++++++++++++++++
>  1 files changed, 70 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/block/cfq-iosched.txt b/Documentation/block/cfq-iosched.txt
> index e578fee..7ce81b8 100644
> --- a/Documentation/block/cfq-iosched.txt
> +++ b/Documentation/block/cfq-iosched.txt
> @@ -43,3 +43,73 @@ If one sets slice_idle=0 and if storage supports NCQ, CFQ internally switches
>  to IOPS mode and starts providing fairness in terms of number of requests
>  dispatched. Note that this mode switching takes effect only for group
>  scheduling. For non-cgroup users nothing should change.
> +
> +CFQ IO scheduler Idling Theory
> +==============================
> +Idling on a queue is primarily about waiting for next request to come on
> +same queue after completion of a request. In this process CFQ will not
> +dispatch requests from other cfq queues even if requests are pending
> +there.
> +
> +The rationale behind idling is that it can cut down on number of seeks
> +on rotational media. For example, if a process is doing dependent
> +sequential reads (next read will come on only after completion of previous
> +one), then not dispatching request from other queue sould help as we
> +did not move the disk head and kept on dispatching sequential IO from
> +one queue.
> +
> +CFQ does not do idling on all the queues. It primarily tries to do idling
> +on queues which are doing synchronous sequential IO. The synchronous
> +queues which are not doing sequential IO are put on a separate service
> +tree (called sync-noidle tree) where we do not idle on individual
> +cfq queue, but idle on the whole tree or IOW, idle on a group of cfq
> +queues.
> +
> +CFQ has following tree service trees and various queues are put on these
> +trees.
> +
> +	sync-idle	sync-noidle	async 
> +
> +All cfq queues doing synchronous sequential IO go on to sync-idle tree.
> +On this tree we idle on each queue individually.
> +
> +All synchronous non-sequential queues go on sync-noidle tree. Also any
> +request which are marked with REQ_NOIDLE go on this service tree.
> +
> +All async writes go on async service tree. There is no idling on async
> +queues.
Maybe mention CFQ don't do idle for SSD too.

> +FAQ
> +===
> +Q1. Why to idle at all on queues marked with REQ_NOIDLE.
> +
> +A1. We only do group idle on queues marked with REQ_NOIDLE. This helps in
                  ^^^^^
tree or group? I suppose you are talking about tree, as below example
doesn't mention group.
The sentence is a little confusing. we do tree/group idle for queue with
random sync I/O too even without REQ_NOIDLE if the queue is the last one
of the tree/group.

> +    providing isolation with all the sync-idle queues. Otherwise in presence
> +    of many sequential readers, other synchronous IO might not get fair
> +    share of disk.
> +
> +    For example, if there are 10 sequential readers doing IO and they get
> +    100ms each. If a REQ_NOIDLE request comes in, it will be scheduled
> +    roughly after 1 second. If after completion of REQ_NOIDLE request we
> +    do not idle, and after a couple of mili seconds a another REQ_NOIDLE
> +    request comes in, again it will be scheduled after 1second. Repeat it
> +    and notice how a workload can lose its disk share and suffer due to
> +    multiple sequnetial readers.
> +
> +    fsync can generate dependent IO where bunch of data is written in the
> +    context of fsync, and later some journaling data is written. Journaling
> +    data comes in only after fsync has finished its IO (atleast for ext4
> +    that seemed to be the case). Now if one decides not to idle on fsync
> +    thread due to REQ_NOIDLE, then next journaling write will not get
> +    scheduled for another second. A process doing small fsync, will suffer
> +    badly in presence of multiple sequntial readers.
> +
> +    Hence doing group idling on threads using REQ_NOIDLE flag on requests
                   ^^^^^ same here.
Thanks,
Shaohua

