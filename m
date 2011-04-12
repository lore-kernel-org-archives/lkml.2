Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133Ab1DLQt5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 12:49:57 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:59777 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754684Ab1DLQt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 12:49:56 -0400
X-ASG-Debug-ID: 1302626994-01de284cf8135cc0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DA482B1.5000005@fusionio.com>
Date: Tue, 12 Apr 2011 18:49:53 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: "hch@infradead.org" <hch@infradead.org>
CC: Dave Chinner <david@fromorbit.com>, NeilBrown <neilb@suse.de>,
        Mike Snitzer <snitzer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
References: <20110411220505.1028816e@notabene.brown> <4DA2F00E.6010907@fusionio.com> <20110411223623.4278fad1@notabene.brown> <4DA2F8AD.1060605@fusionio.com> <20110412011255.GA29236@infradead.org> <4DA40F0E.1070903@fusionio.com> <20110412122248.GC31057@dastard> <4DA4456F.3070301@fusionio.com> <20110412124134.GD31057@dastard> <4DA44C86.3090305@fusionio.com> <20110412164417.GA13890@infradead.org>
X-ASG-Orig-Subj: Re: [PATCH 05/10] block: remove per-queue plugging
In-Reply-To: <20110412164417.GA13890@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1302626994
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.60654
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-12 18:44, hch@infradead.org wrote:
> On Tue, Apr 12, 2011 at 02:58:46PM +0200, Jens Axboe wrote:
>> Supposedly it's faster to do it inline rather than punt the dispatch.
>> But that may actually not be true, if you have multiple plugs going (and
>> thus multiple contenders for the queue lock on dispatch). So lets play
>> it safe and punt to kblockd, we can always revisit this later.
> 
> Note that this can be optimized further by adding a new helper that just
> queues up work on kblockd without taking the queue lock, e.g. adding a
> new
> 
> void blk_run_queue_async(struct request_queue *q)
> {
> 	if (likely(!blk_queue_stopped(q)))
> 		queue_delayed_work(kblockd_workqueue, &q->delay_work, 0);
> }
> 
> And replacing all
> 
> 	__blk_run_queue(q, true);
> 
> callers with that, at which point they won't need the queuelock any
> more.

I realize that, in fact it's already safe as long as you pass in 'true'
for __blk_run_queue(). Before I had rewritten it to move the running
out, so that makes the trick a little difficult. This afternoon I also
tested it and saw no noticable difference, but I'll probably just do it
anyway as it makes sense.

-- 
Jens Axboe

