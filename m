Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab1GZQ0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 12:26:43 -0400
Received: from mga05.intel.com ([192.55.52.89]:38165 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751431Ab1GZQ0g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 12:26:36 -0400
X-Greylist: delayed 631 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Jul 2011 12:26:36 EDT
MIME-Version: 1.0
In-Reply-To: <20110726105603.GA3298@swordfish.minsk.epam.com>
References: <1311672726.2700.5.camel@menhir>
	<20110726105603.GA3298@swordfish.minsk.epam.com>
Date: Tue, 26 Jul 2011 09:15:56 -0700
Message-ID: <CABE8wwsZe+MMVPXDrNsT8ORM+n29x--1+4+qTCyct7BWAgSpgw@mail.gmail.com>
Subject: Re: Preempt & smp_processor_id in __make_request
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Roland Dreier <roland@purestorage.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 3:56 AM, Sergey Senozhatsky
<sergey.senozhatsky@gmail.com> wrote:
> On (07/26/11 10:32), Steven Whitehouse wrote:
>> Jul 26 09:54:04 chywoon kernel: BUG: using smp_processor_id() in preemptible [00
>> 000000] code: jbd2/dm-0-8/1546
>> Jul 26 09:54:04 chywoon kernel: caller is __make_request+0x209/0x350
>> Jul 26 09:54:04 chywoon kernel: Pid: 1546, comm: jbd2/dm-0-8 Tainted: G        W
>>    3.0.0+ #252
>> Jul 26 09:54:04 chywoon kernel: Call Trace:
>> Jul 26 09:54:04 chywoon kernel: [<ffffffff813db897>] debug_smp_processor_id+0xe7
>> /0x100
>> Jul 26 09:54:04 chywoon kernel: [<ffffffff813b6f29>] __make_request+0x209/0x350
>> Jul 26 09:54:04 chywoon kernel: [<ffffffff8154635e>] ? dm_request+0x2e/0x280
>> Jul 26 09:54:04 chywoon kernel: [<ffffffff813b3ffb>] generic_make_request+0x27b/
>> 0x550
>> Jul 26 09:54:04 chywoon kernel: [<ffffffff8123ef7e>] ? jbd2_journal_file_buffer+
>> 0x8e/0x130
>> Jul 26 09:54:04 chywoon kernel: [<ffffffff813b432f>] submit_bio+0x5f/0xd0
>> Jul 26 09:54:04 chywoon kernel: [<ffffffff811b14a6>] submit_bh+0xe6/0x120
>> etc.
>>
>> The (trivial) fix appears to be the following:
>>
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index f8cb099..f925581 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -1283,7 +1283,7 @@ get_rq:
>>
>>       if (test_bit(QUEUE_FLAG_SAME_COMP, &q->queue_flags) ||
>>           bio_flagged(bio, BIO_CPU_AFFINE))
>> -             req->cpu = smp_processor_id();
>> +             req->cpu = raw_smp_processor_id();
>>
>>       plug = current->plug;
>>       if (plug) {
>>
>> However this fixes the symptoms, rather than the cause, so I'm not at
>> all sure that this is the correct solution,

I did not realize smp_processor_id() enforced that restriction.  It
seems like we want raw_smp_processor_id() since it is an affinity
hint, and not an affinity guarantee.

--
Dan
