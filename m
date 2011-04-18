Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab1DRII5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 04:08:57 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:51825 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211Ab1DRIIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 04:08:53 -0400
X-ASG-Debug-ID: 1303114132-03d6a5652cc9800001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DABF194.4010603@fusionio.com>
Date: Mon, 18 Apr 2011 10:08:52 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: lkml <linux-kernel@vger.kernel.org>, Tejun Heo <htejun@gmail.com>,
        "Shi, Alex" <alex.shi@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [RFC]block: add flush request at head
References: <1303112174.3981.187.camel@sli10-conroe>
X-ASG-Orig-Subj: Re: [RFC]block: add flush request at head
In-Reply-To: <1303112174.3981.187.camel@sli10-conroe>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1303114132
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.61196
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-18 09:36, Shaohua Li wrote:
> Alex found a regression when running sysbench fileio test with an ext4
> filesystem in a hard disk. The hard disk is attached to an AHCI
> controller.  The regression is about 15%. He bisected it to
> 53d63e6b0dfb95882e.  At first glance, it's quite strange the commit
> can cause any difference, since q->queue_head usually has just one
> entry. It looks in SATA normal request and flush request are
> exclusive, which causes a lot of requests requeued. From the log, a

A flush isn't queueable for SATA, NCQ essentially only really allows
READs and WRITEs to be queued.

> flush is finished and then flowed two requests, one is a normal
> request and the other flush request. If we let the flush run first, we
> have a flush dispatched just after a flush finishes. Assume the second
> flush can finish quickly, as the disk cache is already flushed at
> least most part. Also this delays normal request, so potentially we do
> more normal requests before a flush.  Changing the order here should
> not impact the correctness, because filesystem should already wait for
> required normal requests finished.  The patch below recover the
> regression. we don't change the order if just finished request isn't
> flush request to delay flush.

It's not about correctness, it's actually a safety concern. True head
additions should be reserved for internal operations, things like error
recovery or eg spinning a disk up for service, power management, etc.
Imagine a driver needing some special operation done before it can do
IO, that is queued at the head. If the flush happens immediately after
and skips to the head, you could get into trouble.

I think we can do this safely if you check what the head request is - if
it's a regular read/write request, then it should be safe to head
insert. That is safe IFF we always wait on requests when they are
ordered, which we do now. But it is a bit ugly...

> BTW, for SATA-like controller, we can do an optimization. When the
> running list of q->flush_queue proceeds, we can proceeds pending list
> too (that is the two lists could be merged). Because normal request
> and flush request are exclusive. When a flush request is running,
> there should be no other normal request running.  Don't know if this
> is worthy, if yes, I can work on it.

Might be worth adding something for this special case, seems like the
NCQ restrictions will continue to be around forever (or a long time, at
least).


-- 
Jens Axboe

