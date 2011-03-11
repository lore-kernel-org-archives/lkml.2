Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab1CKOgd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 09:36:33 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:45526 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754437Ab1CKOgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 09:36:32 -0500
Message-ID: <4D7A336C.30905@kernel.dk>
Date: Fri, 11 Mar 2011 15:36:28 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Lukas Czerner <lczerner@redhat.com>
CC: Jeff Moyer <jmoyer@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH v2] block: fix mis-synchronisation in  blkdev_issue_zeroout()
References: <1299830784-6622-1-git-send-email-lczerner@redhat.com> <x49bp1hhh2g.fsf@segfault.boston.devel.redhat.com> <alpine.LFD.2.00.1103111530120.3686@dhcp-27-109.brq.redhat.com>
In-Reply-To: <alpine.LFD.2.00.1103111530120.3686@dhcp-27-109.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-11 15:31, Lukas Czerner wrote:
> On Fri, 11 Mar 2011, Jeff Moyer wrote:
> 
>> Lukas Czerner <lczerner@redhat.com> writes:
>>
>>> BZ29402
>>> https://bugzilla.kernel.org/show_bug.cgi?id=29402
>>>
>>> We can hit serious mis-synchronization in bio completion path of
>>> blkdev_issue_zeroout() leading to a panic.
>>>
>>> The problem is that when we are going to wait_for_completion() in
>>> blkdev_issue_zeroout() we check if the bb.done equals issued (number of
>>> submitted bios). If it does, we can skip the wait_for_completition()
>>> and just out of the function since there is nothing to wait for.
>>> However, there is a ordering problem because bio_batch_end_io() is
>>> calling atomic_inc(&bb->done) before complete(), hence it might seem to
>>> blkdev_issue_zeroout() that all bios has been completed and exit. At
>>> this point when bio_batch_end_io() is going to call complete(bb->wait),
>>> bb and wait does not longer exist since it was allocated on stack in
>>> blkdev_issue_zeroout() ==> panic!
>>>
>>> (thread 1)                      (thread 2)
>>> bio_batch_end_io()              blkdev_issue_zeroout()
>>>   if(bb) {                      ...
>>>     if (bb->end_io)             ...
>>>       bb->end_io(bio, err);     ...
>>>     atomic_inc(&bb->done);      ...
>>>     ...                         while (issued != atomic_read(&bb.done))
>>>     ...                         (let issued == bb.done)
>>>     ...                         (do the rest of the function)
>>>     ...                         return ret;
>>>     complete(bb->wait);
>>>     ^^^^^^^^
>>>     panic
>>>
>>> We can fix this easily by simplifying bio_batch and completion counting.
>>>
>>> Also remove bio_end_io_t *end_io since it is not used.
>>>
>>> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
>>> Reported-by: Eric Whitney <eric.whitney@hp.com>
>>> Tested-by: Eric Whitney <eric.whitney@hp.com>
>>> CC: Jens Axboe <axboe@kernel.dk>
>>> CC: Dmitry Monakhov <dmonakhov@openvz.org>
>>> CC: Jeff Moyer <jmoyer@redhat.com>
>>> ---
>>>  block/blk-lib.c |   19 +++++++------------
>>>  1 files changed, 7 insertions(+), 12 deletions(-)
>>>
>>> diff --git a/block/blk-lib.c b/block/blk-lib.c
>>> index eec78be..bd3e8df 100644
>>> --- a/block/blk-lib.c
>>> +++ b/block/blk-lib.c
>>> @@ -109,7 +109,6 @@ struct bio_batch
>>>  	atomic_t 		done;
>>>  	unsigned long 		flags;
>>>  	struct completion 	*wait;
>>> -	bio_end_io_t		*end_io;
>>>  };
>>>  
>>>  static void bio_batch_end_io(struct bio *bio, int err)
>>> @@ -122,12 +121,9 @@ static void bio_batch_end_io(struct bio *bio, int err)
>>>  		else
>>>  			clear_bit(BIO_UPTODATE, &bb->flags);
>>>  	}
>>> -	if (bb) {
>>> -		if (bb->end_io)
>>> -			bb->end_io(bio, err);
>>> -		atomic_inc(&bb->done);
>>> -		complete(bb->wait);
>>> -	}
>>> +	if (bb)
>>> +		if (atomic_dec_and_test(&bb->done))
>>> +			complete(bb->wait);
>>
>> I think bb will always be set here, no real need to check.
>>
>> Anyway, I though I already added my:
>>
>> Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
>>
>> to this.  No?
>>
>> Cheers,
>> Jeff
> 
> Yes, you did and I forgot to add it into the patch. Sorry about that.

No worries, I added it now.

-- 
Jens Axboe

