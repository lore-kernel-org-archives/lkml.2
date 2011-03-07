Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab1CGTj3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 14:39:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701Ab1CGTj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 14:39:28 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, Mike Snitzer <snitzer@gmail.com>,
        Jan Beulich <JBeulich@novell.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH v2.6.38-rc5 2/2] block: blk-flush shouldn't call directly into q->request_fn() __blk_run_queue()
References: <20110217111511.GQ19830@htj.dyndns.org>
	<20110217111619.GR19830@htj.dyndns.org>
	<AANLkTi=rPKN25yZTziv1dz=Ke0db8ZOwUgKFNzWn9+x7@mail.gmail.com>
	<20110218094903.GF21209@htj.dyndns.org> <4D6E4A46.1040709@kernel.dk>
	<20110304182507.GY20499@htj.dyndns.org>
	<x49r5aisp23.fsf@segfault.boston.devel.redhat.com>
	<4D7533B1.3070308@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 07 Mar 2011 14:39:19 -0500
In-Reply-To: <4D7533B1.3070308@kernel.dk> (Jens Axboe's message of "Mon, 07
	Mar 2011 20:36:17 +0100")
Message-ID: <x49mxl6sot4.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> On 2011-03-07 20:33, Jeff Moyer wrote:
>> Tejun Heo <tj@kernel.org> writes:
>> 
>>> Hello, Jens.
>>>
>>> On Wed, Mar 02, 2011 at 08:46:46AM -0500, Jens Axboe wrote:
>>>>> Right, thanks.  Jens, after you apply the two fixes for 2.6.38, I can
>>>>> create a merge branch for for-2.6.39/core which you can pull.  Would
>>>>> that work for you?
>>>>
>>>> Thanks, that would be great. I'm applying them now.
>>>
>>> Okay, please pull from the following branch to receive the merge
>>> between linux-2.6-block:for-linus and :for-2.6.39/core.
>>>
>>>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-for-2.6.39-core
>>>
>>> HEAD is e83a46bbb1d4c03defd733a64b727632a40059ad but git.korg seems a
>>> bit slow to sync, so if you don't see the commit there, please pull
>>> from master.korg.
>>>
>>>  ssh://master.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-for-2.6.39-core
>>>
>>> Thanks.
>> 
>> I know I'm coming to the party late (and maybe wrong), but I've got some
>> questions here.
>> 
>> Tejun, you introduced a commit to the ide driver that made it block in
>> its request function.  As far as I know, that's not allowed.  For scsi,
>> at least, it has always allowed calling back into the request function
>> from the completion handler, and I think this is actully the common case
>> (not some corner case).
>> 
>> So, why doesn't the ide driver see calls back into its request function
>> from the completion handler?  It's clear that it calls blk_end_request
>> from ide_end_rq, which can definitely call __blk_run_queue.  In other
>> words, why is it that the flush requests are triggerring this problem
>> while normal I/O isn't?
>> 
>> I think the real issue may just be that the ide driver is blocking in
>> its request function.  What have I missed?
>
> So the only case where the request_fn is called and you cannot block, is
> if you call it from your completion function. Any other invocation
> should be from process context. As long as you remember to drop the
> queue lock and re-enable interrupts, it should work. It's not great
> style and I would not recommend it for a performance environment, but it
> should work.

So are you agreeing with me or disagreeing?  ;-)  It sounds to me like
you're saying that the ide driver should be able to cope with being
called from softirq context.

Cheers,
Jeff
