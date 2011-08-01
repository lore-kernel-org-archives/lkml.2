Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689Ab1HAS0A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 14:26:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54007 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563Ab1HASZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 14:25:53 -0400
Message-ID: <4E36EF88.6040704@suse.de>
Date: Mon, 01 Aug 2011 23:55:12 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110616 SUSE/3.1.11 Thunderbird/3.1.11
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>,
        Moyer Jeff Moyer <jmoyer@redhat.com>,
        Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH] cfq-iosched: Add some more documentation about idling
References: <20110801155523.GE3805@redhat.com>
In-Reply-To: <20110801155523.GE3805@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2011 09:25 PM, Vivek Goyal wrote:
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
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  Documentation/block/cfq-iosched.txt |   70 +++++++++++++++++++++++++++++++++++
>  1 files changed, 70 insertions(+), 0 deletions(-)

The patch looks good and documents idling nicely. A few minor nits...

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
                                                  ^^ the ?
> +same queue after completion of a request. In this process CFQ will not
> +dispatch requests from other cfq queues even if requests are pending
> +there.
> +
> +The rationale behind idling is that it can cut down on number of seeks
> +on rotational media. For example, if a process is doing dependent
> +sequential reads (next read will come on only after completion of previous
> +one), then not dispatching request from other queue sould help as we
                                                      ^^ should
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
                    ^^ extraneous "tree" ?

There seems to be some redundant information between the paragraph above
and below.. More room for brevity?

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

> +FAQ
> +===
> +Q1. Why to idle at all on queues marked with REQ_NOIDLE.
> +
> +A1. We only do group idle on queues marked with REQ_NOIDLE. This helps in
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
> +    provides isolation from multiple sequntial readers and at the same
> +    time we do not idle on individual threads. 
> +
> +Q2. When to specify REQ_NOIDLE
> +A2. I would think whenever one is doing synchronous write and not expecting
> +    more writes to be dispatched from same context soon, should be able
> +    to specify REQ_NOIDLE on writes and that probably should work well for
> +    most of the cases. 


-- 
Suresh Jayaraman
