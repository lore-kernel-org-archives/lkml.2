Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab1DRI01 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 04:26:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:63186 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753607Ab1DRI0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 04:26:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,231,1301900400"; 
   d="scan'208";a="680490682"
Subject: Re: [RFC]block: add flush request at head
From: Shaohua Li <shaohua.li@intel.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Tejun Heo <htejun@gmail.com>,
        "Shi, Alex" <alex.shi@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>
In-Reply-To: <4DABF194.4010603@fusionio.com>
References: <1303112174.3981.187.camel@sli10-conroe>
	 <4DABF194.4010603@fusionio.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Apr 2011 16:25:57 +0800
Message-ID: <1303115157.3981.198.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-18 at 16:08 +0800, Jens Axboe wrote:
> On 2011-04-18 09:36, Shaohua Li wrote:
> > Alex found a regression when running sysbench fileio test with an ext4
> > filesystem in a hard disk. The hard disk is attached to an AHCI
> > controller.  The regression is about 15%. He bisected it to
> > 53d63e6b0dfb95882e.  At first glance, it's quite strange the commit
> > can cause any difference, since q->queue_head usually has just one
> > entry. It looks in SATA normal request and flush request are
> > exclusive, which causes a lot of requests requeued. From the log, a
> 
> A flush isn't queueable for SATA, NCQ essentially only really allows
> READs and WRITEs to be queued.
> 
> > flush is finished and then flowed two requests, one is a normal
> > request and the other flush request. If we let the flush run first, we
> > have a flush dispatched just after a flush finishes. Assume the second
> > flush can finish quickly, as the disk cache is already flushed at
> > least most part. Also this delays normal request, so potentially we do
> > more normal requests before a flush.  Changing the order here should
> > not impact the correctness, because filesystem should already wait for
> > required normal requests finished.  The patch below recover the
> > regression. we don't change the order if just finished request isn't
> > flush request to delay flush.
> 
> It's not about correctness, it's actually a safety concern. True head
> additions should be reserved for internal operations, things like error
> recovery or eg spinning a disk up for service, power management, etc.
> Imagine a driver needing some special operation done before it can do
> IO, that is queued at the head. If the flush happens immediately after
> and skips to the head, you could get into trouble.
then why requeue adds request at head? we could have the similar issue.

> I think we can do this safely if you check what the head request is - if
> it's a regular read/write request, then it should be safe to head
> insert. That is safe IFF we always wait on requests when they are
> ordered, which we do now. But it is a bit ugly...
hmm, don't want to do this...

> > BTW, for SATA-like controller, we can do an optimization. When the
> > running list of q->flush_queue proceeds, we can proceeds pending list
> > too (that is the two lists could be merged). Because normal request
> > and flush request are exclusive. When a flush request is running,
> > there should be no other normal request running.  Don't know if this
> > is worthy, if yes, I can work on it.
> 
> Might be worth adding something for this special case, seems like the
> NCQ restrictions will continue to be around forever (or a long time, at
> least).
I'll look at this. Optimizing this one should fix the regression too. On
the other hand, adding flush request at head if it just follows a flush
still has its advantage, because drive cache is already flushed out.

Thanks,
Shaohua

