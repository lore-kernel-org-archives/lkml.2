Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847Ab1DLIgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 04:36:49 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:60746 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756817Ab1DLIgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 04:36:32 -0400
X-ASG-Debug-ID: 1302597391-03d6a5732993e70001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DA40F0E.1070903@fusionio.com>
Date: Tue, 12 Apr 2011 10:36:30 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: "hch@infradead.org" <hch@infradead.org>
CC: NeilBrown <neilb@suse.de>, Mike Snitzer <snitzer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
References: <20110411145022.710c30e9@notabene.brown> <4DA2C7BE.6060804@fusionio.com> <20110411205928.13915719@notabene.brown> <4DA2E03A.2080607@fusionio.com> <20110411212635.7959de70@notabene.brown> <4DA2E7F0.9010904@fusionio.com> <20110411220505.1028816e@notabene.brown> <4DA2F00E.6010907@fusionio.com> <20110411223623.4278fad1@notabene.brown> <4DA2F8AD.1060605@fusionio.com> <20110412011255.GA29236@infradead.org>
X-ASG-Orig-Subj: Re: [PATCH 05/10] block: remove per-queue plugging
In-Reply-To: <20110412011255.GA29236@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1302597391
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.60622
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-12 03:12, hch@infradead.org wrote:
> On Mon, Apr 11, 2011 at 02:48:45PM +0200, Jens Axboe wrote:
>> Great, once you do that and XFS kills the blk_flush_plug() calls too,
>> then we can remove that export and make it internal only.
> 
> Linus pulled the tree, so they are gone now.  Btw, there's still some
> bits in the area that confuse me:

Great!

>  - what's the point of the queue_sync_plugs?  It has a lot of comment
>    that seem to pre-data the onstack plugging, but except for that
>    it's trivial wrapper around blk_flush_plug, with an argument
>    that is not used.

There's really no point to it anymore. It's existance was due to the
older revision that had to track write requests for serializaing around
a barrier. I'll kill it, since we don't do that anymore.

>  - is there a good reason for the existance of __blk_flush_plug?  You'd
>    get one additional instruction in the inlined version of
>    blk_flush_plug when opencoding, but avoid the need for chained
>    function calls.
>  - Why is having a plug in blk_flush_plug marked unlikely?  Note that
>    unlikely is the static branch prediction hint to mark the case
>    extremly unlikely and is even used for hot/cold partitioning.  But
>    when we call it we usually check beforehand if we actually have
>    plugs, so it's actually likely to happen.

The existance and out-of-line is for the scheduler() hook. It should be
an unlikely event to schedule with a plug held, normally the plug should
have been explicitly unplugged before that happens.

>  - what is the point of blk_finish_plug?  All callers have
>    the plug on stack, and there's no good reason for adding the NULL
>    check.  Note that blk_start_plug doesn't have the NULL check either.

That one can probably go, I need to double check that part since some
things changed.

>  - Why does __blk_flush_plug call __blk_finish_plug which might clear
>    tsk->plug, just to set it back after the call? When manually inlining
>    __blk_finish_plug ino __blk_flush_plug it looks like:
> 
> void __blk_flush_plug(struct task_struct *tsk, struct blk_plug *plug)
> {
> 	flush_plug_list(plug);
> 	if (plug == tsk->plug)
> 		tsk->plug = NULL;
> 	tsk->plug = plug;
> }
> 
>    it would seem much smarted to just call flush_plug_list directly.
>    In fact it seems like the tsk->plug is not nessecary at all and
>    all remaining __blk_flush_plug callers could be replaced with
>    flush_plug_list.

It depends on whether this was an explicit unplug (eg
blk_finish_plug()), or whether it was an implicit event (eg on
schedule()). If we do it on schedule(), then we retain the plug after
the flush. Otherwise we clear it.

>  - and of course the remaining issue of why io_schedule needs an
>    expliciy blk_flush_plug when schedule() already does one in
>    case it actually needs to schedule.

Already answered in other email.

-- 
Jens Axboe

