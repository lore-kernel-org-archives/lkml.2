Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab1DRIK1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 04:10:27 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:37144 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211Ab1DRIKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 04:10:22 -0400
X-ASG-Debug-ID: 1303114218-01de284cf815be60001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DABF1EA.3070301@fusionio.com>
Date: Mon, 18 Apr 2011 10:10:18 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: Mike Snitzer <snitzer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>	<1295659049-2688-6-git-send-email-jaxboe@fusionio.com>	<AANLkTin8FoXX6oqUyW+scwhadyX-TfW16_oKjvngU9-m@mail.gmail.com>	<20110303221353.GA10366@redhat.com>	<4D761E0D.8050200@fusionio.com>	<20110308202100.GA31744@redhat.com>	<4D76912C.9040705@fusionio.com>	<20110308220526.GA393@redhat.com>	<20110310005810.GA17911@redhat.com>	<20110405130541.6c2b5f86@notabene.brown>	<20110411145022.710c30e9@notabene.brown>	<4DA2C7BE.6060804@fusionio.com>	<20110411205928.13915719@notabene.brown>	<4DA2E03A.2080607@fusionio.com>	<20110411212635.7959de70@notabene.brown>	<4DA2E7F0.9010904@fusionio.com>	<20110411220505.1028816e@notabene.brown>	<4DA2F00E.6010907@fusionio.com>	<20110418081922.1651474a@notabene.brown>	<4DABDC60.2090009@fusionio.com> <20110418172551.55629fc6@notabene.brown>
X-ASG-Orig-Subj: Re: [PATCH 05/10] block: remove per-queue plugging
In-Reply-To: <20110418172551.55629fc6@notabene.brown>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1303114218
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.61197
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-18 09:25, NeilBrown wrote:
> On Mon, 18 Apr 2011 08:38:24 +0200 Jens Axboe <jaxboe@fusionio.com> wrote:
> 
>> On 2011-04-18 00:19, NeilBrown wrote:
>>> On Mon, 11 Apr 2011 14:11:58 +0200 Jens Axboe <jaxboe@fusionio.com> wrote:
>>>
>>>>> Yes.  But I need to know when to release the requests that I have stored.
>>>>> I need to know when ->write_pages or ->read_pages or whatever has finished
>>>>> submitting a pile of pages so that I can start processing the request that I
>>>>> have put aside.  So I need a callback from blk_finish_plug.
>>>>
>>>> OK fair enough, I'll add your callback patch.
>>>>
>>>
>>> But you didn't did you?  You added a completely different patch which is
>>> completely pointless.
>>> If you don't like my patch I would really prefer you said so rather than
>>> silently replace it with something completely different (and broken).
>>
>> First of all, you were CC'ed on all that discussion, yet didn't speak up
>> until now. This was last week. Secondly, please change your tone.
> 
> Yes, I was CC'ed on a discussion.  In that discussion it was never mentioned
> that you had completely changed the patch I sent you, and it never contained
> the new patch in-line for review.   Nothing that was discussed was
> particularly relevant to md's needs so there was nothing to speak up about.
> 
> Yes- there were 'git pull' requests and I could have done a pull myself to
> review the code but there seemed to be no urgency because you had already
> agreed to apply my patch.
> When I did finally pull the patches (after all the other issues had settle
> down and I had time to finish of the RAID side) I found ... what I found.
> 
> I apologise for my tone, but I was very frustrated.
> 
>>
>>> I'll try to explain again.
>>>
>>> md does not use __make_request.  At all.
>>> md does not use 'struct request'.  At all.
>>>
>>> The 'list' in 'struct blk_plug' is a list of 'struct request'.
>>
>> I'm well aware of how these facts, but thanks for bringing it up.
>>
>>> Therefore md cannot put anything useful on the list in 'struct blk_plug'.
>>>
>>> So when blk_flush_plug_list calls queue_unplugged() on a queue that belonged
>>> to a request found on the blk_plug list, that queue cannot possibly ever be
>>> for an 'md' device (because no 'struct request' ever belongs to an md device,
>>> because md doesn't not use 'struct request').
>>>
>>> So your patch (commit f75664570d8b) doesn't help MD at all.
>>>
>>> For md, I need to attach something to blk_plug which somehow identifies an md
>>> device, so that blk_finish_plug can get to that device and let it unplug.
>>> The most sensible thing to have is a completely generic callback.  That way
>>> different block devices (which choose not to use __make_request) can attach
>>> different sorts of things to blk_plug.
>>>
>>> So can we please have my original patch applied? (Revised version using
>>> list_splice_init included below).
>>>
>>> Or if not, a clear explanation of why not?
>>
>> So correct me if I'm wrong here, but the _only_ real difference between
>> this patch and the current code in the tree, is the checking of the
>> callback list indicating a need to flush the callbacks. And that's
>> definitely an oversight. It should be functionally equivelant if md
>> would just flag this need to get a callback, eg instead of queueing a
>> callback on the list, just set plug->need_unplug from md instead of
>> queuing a callback and have blk_needs_flush_plug() do:
>>
>>         return plug && (!list_empty(&plug->list) || plug->need_unplug);
>>
>> instead. Something like the below, completely untested.
>>
> 
> No, that is not the only real difference.
> 
> The real difference is that in the current code, md has no way to register
> anything with a blk_plug because you can only register a 'struct request' on a
> blk_plug, and md doesn't make any use of 'struct request'.
> 
> As I said in the Email you quote above:
> 
>>> Therefore md cannot put anything useful on the list in 'struct blk_plug'.
> 
> That is the heart of the problem.

Hmm, I don't really see a way to avoid the list in that case. You really
do need some way to queue items, a single callback or flag or pointer
will not suffice.

I've added the patch and removed the (now) useless ->unplugged_fn
callback. I suggest you base your md changes on top of my for-linus
branch and tell me when you are confident it looks good, then I'll pull
in your MD changes and submit them later today.

OK with you?

-- 
Jens Axboe

