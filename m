Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab1DKMMe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 08:12:34 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:50718 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754143Ab1DKMMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 08:12:32 -0400
X-ASG-Debug-ID: 1302523950-01de284cf812b260001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DA2F02D.2000903@fusionio.com>
Date: Mon, 11 Apr 2011 14:12:29 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: Mike Snitzer <snitzer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>	<1295659049-2688-6-git-send-email-jaxboe@fusionio.com>	<AANLkTin8FoXX6oqUyW+scwhadyX-TfW16_oKjvngU9-m@mail.gmail.com>	<20110303221353.GA10366@redhat.com>	<4D761E0D.8050200@fusionio.com>	<20110308202100.GA31744@redhat.com>	<4D76912C.9040705@fusionio.com>	<20110308220526.GA393@redhat.com>	<20110310005810.GA17911@redhat.com>	<20110405130541.6c2b5f86@notabene.brown>	<20110411145022.710c30e9@notabene.brown>	<4DA2C7BE.6060804@fusionio.com>	<20110411205928.13915719@notabene.brown> <20110411215521.78c87573@notabene.brown>
X-ASG-Orig-Subj: Re: [PATCH 05/10] block: remove per-queue plugging
In-Reply-To: <20110411215521.78c87573@notabene.brown>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1302523950
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.60541
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-11 13:55, NeilBrown wrote:
> On Mon, 11 Apr 2011 20:59:28 +1000 NeilBrown <neilb@suse.de> wrote:
> 
>> On Mon, 11 Apr 2011 11:19:58 +0200 Jens Axboe <jaxboe@fusionio.com> wrote:
>>
>>> On 2011-04-11 06:50, NeilBrown wrote:
>>
>>>> The only explanation I can come up with is that very occasionally schedule on
>>>> 2 separate cpus calls blk_flush_plug for the same task.  I don't understand
>>>> the scheduler nearly well enough to know if or how that can happen.
>>>> However with this patch in place I can write to a RAID1 constantly for half
>>>> an hour, and without it, the write rarely lasts for 3 minutes.
>>>
>>> Or perhaps if the request_fn blocks, that would be problematic. So the
>>> patch is likely a good idea even for that case.
>>>
>>> I'll merge it, changing it to list_splice_init() as I think that would
>>> be more clear.
>>
>> OK - though I'm not 100% the patch fixes the problem - just that it hides the
>> symptom for me.
>> I might try instrumenting the code a bit more and see if I can find exactly
>> where it is re-entering flush_plug_list - as that seems to be what is
>> happening.
> 
> OK, I found how it re-enters.
> 
> The request_fn doesn't exactly block, but when scsi_request_fn calls
> spin_unlock_irq, this calls preempt_enable which can call schedule, which is
> a recursive call.
> 
> The patch I provided will stop that from recursing again as the blk_plug.list
> will be empty.
> 
> So it is almost what you suggested, however the request_fn doesn't block, it
> just enabled preempt.
> 
> 
> So the comment I would put at the top of that patch would be something like:

Ah, so it was pretty close. That does explain it. I've already queued up
the patch, I'll ammend the commit message.

-- 
Jens Axboe

