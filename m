Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab0ITOPp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 10:15:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756449Ab0ITOPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 10:15:44 -0400
Date: Mon, 20 Sep 2010 10:15:41 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, jaxboe@fusionio.com,
        czoccolo@gmail.com
Subject: Re: [patch]cfq-iosched: don't idle if a deep seek queue is slow
Message-ID: <20100920141541.GE6138@redhat.com>
References: <1284972814.6598.18.camel@sli10-conroe.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284972814.6598.18.camel@sli10-conroe.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 04:53:34PM +0800, Shaohua Li wrote:
> If a deep seek queue slowly deliver requests but disk is much faster, idle
> for the queue just wastes disk throughput. If the queue delevers all requests
> before half its slice is used, the patch disable idle for it.
> In my test, application delivers 32 requests one time, the disk can accept
> 128 requests at maxium and disk is fast. without the patch, the throughput
> is just around 30m/s, while with it, the speed is about 80m/s. The disk is
> a SSD, but is detected as a rotational disk. I can configure it as SSD, but
> I thought the deep seek queue logic should be fixed too, for example,
> considering a fast raid.
> 

Hi Shaohua,

So you seem to be addressing the issue of storage being fast enough and
a single queue not being able to keep the storage busy.

But we have the same issue for non-deep queues for a fast storage. This
patch will not solve that.

I think CFQ idling in general is a problem on faster storage. For SSDs we
can statically detect non-rotational media and disable idling. For faster
RAIDs we need to find an intellligent way of detection and disable idling.

One of the suggestions at this year's LSF was to keep idling on only for
SATA disks and for any SCSI disks we can think of disabling idling by
default. May be with the help of udev rule.

Thanks
Vivek

> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> 
> ---
>  block/cfq-iosched.c |   11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> Index: linux-2.6/block/cfq-iosched.c
> ===================================================================
> --- linux-2.6.orig/block/cfq-iosched.c	2010-09-19 21:25:11.000000000 +0800
> +++ linux-2.6/block/cfq-iosched.c	2010-09-21 00:20:46.000000000 +0800
> @@ -2275,6 +2275,17 @@
>  		goto keep_queue;
>  	}
>  
> +	/*
> +	 * This is a deep seek queue, but the device is much faster than
> +	 * the queue can deliver, don't idle
> +	 **/
> +	if (CFQQ_SEEKY(cfqq) && cfq_cfqq_idle_window(cfqq) &&
> +	    (cfq_cfqq_slice_new(cfqq) ||
> +	    (cfqq->slice_end - jiffies > jiffies - cfqq->slice_start))) {
> +		cfq_clear_cfqq_deep(cfqq);
> +		cfq_clear_cfqq_idle_window(cfqq);
> +	}
> +
>  	if (cfqq->dispatched && cfq_should_idle(cfqd, cfqq)) {
>  		cfqq = NULL;
>  		goto keep_queue;
> 
