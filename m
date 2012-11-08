Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079Ab2KHVdF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 16:33:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756661Ab2KHVdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 16:33:03 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Lukas Czerner <lczerner@redhat.com>, axboe@kernel.dk, dchinner@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] loop: Limit the number of requests in the bio list
References: <1350379305-13858-1-git-send-email-lczerner@redhat.com>
	<20121108111418.bcaad11d.akpm@linux-foundation.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 08 Nov 2012 16:32:57 -0500
In-Reply-To: <20121108111418.bcaad11d.akpm@linux-foundation.org> (Andrew
	Morton's message of "Thu, 8 Nov 2012 11:14:18 -0800")
Message-ID: <x49obj7rd9y.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Tue, 16 Oct 2012 11:21:45 +0200
> Lukas Czerner <lczerner@redhat.com> wrote:
>
>> Currently there is not limitation of number of requests in the loop bio
>> list. This can lead into some nasty situations when the caller spawns
>> tons of bio requests taking huge amount of memory. This is even more
>> obvious with discard where blkdev_issue_discard() will submit all bios
>> for the range and wait for them to finish afterwards. On really big loop
>> devices and slow backing file system this can lead to OOM situation as
>> reported by Dave Chinner.
>> 
>> With this patch we will wait in loop_make_request() if the number of
>> bios in the loop bio list would exceed 'nr_requests' number of requests.
>> We'll wake up the process as we process the bios form the list. Some
>> threshold hysteresis is in place to avoid high frequency oscillation.
>> 
>
> What's happening with this?

Still waiting for review, I guess.  I'll have a look.

>> --- a/drivers/block/loop.c
>> +++ b/drivers/block/loop.c
>> @@ -463,6 +463,7 @@ out:
>>   */
>>  static void loop_add_bio(struct loop_device *lo, struct bio *bio)
>>  {
>> +	lo->lo_bio_count++;
>>  	bio_list_add(&lo->lo_bio_list, bio);
>>  }
>>  
>> @@ -471,6 +472,7 @@ static void loop_add_bio(struct loop_device *lo, struct bio *bio)
>>   */
>>  static struct bio *loop_get_bio(struct loop_device *lo)
>>  {
>> +	lo->lo_bio_count--;
>>  	return bio_list_pop(&lo->lo_bio_list);
>>  }
>>  
>> @@ -489,6 +491,14 @@ static void loop_make_request(struct request_queue *q, struct bio *old_bio)
>>  		goto out;
>>  	if (unlikely(rw == WRITE && (lo->lo_flags & LO_FLAGS_READ_ONLY)))
>>  		goto out;
>> +	if (lo->lo_bio_count >= lo->lo_queue->nr_requests) {
>> +		unsigned int nr;
>> +		spin_unlock_irq(&lo->lo_lock);
>> +		nr = lo->lo_queue->nr_requests - (lo->lo_queue->nr_requests/8);
>> +		wait_event_interruptible(lo->lo_req_wait,
>> +					 lo->lo_bio_count < nr);
>> +		spin_lock_irq(&lo->lo_lock);
>> +	}
>
> Two things.
>
> a) wait_event_interruptible() will return immediately if a signal is
>    pending (eg, someone hit ^C).  This is not the behaviour you want. 
>    If the calling process is always a kernel thread then
>    wait_event_interruptible() is OK and is the correct thing to use. 
>    Otherwise, it will need to be an uninterruptible sleep.

Good catch, this needs fixing.

> b) Why is it safe to drop lo_lock here?  What data is that lock protecting?

lo_lock is protecting access to state and the bio list.  Dropping the
lock looks okay to me.

Cheers,
Jeff
