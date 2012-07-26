Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520Ab2GZP2u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:28:50 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:38879 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752005Ab2GZP2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:28:49 -0400
MIME-Version: 1.0
In-Reply-To: <34e29d774773a7dfa3e1b57232249b68.squirrel@www.codeaurora.org>
References: <34e29d774773a7dfa3e1b57232249b68.squirrel@www.codeaurora.org>
From: "S, Venkatraman" <svenkatr@ti.com>
Date: Thu, 26 Jul 2012 20:58:24 +0530
Message-ID: <CANfBPZ9NZAdK4tEDJ8wiNKNjRUuqaLKk3qqVZVgod8vwYVuOYw@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] mmc: block: Add write packing control
To: merez@codeaurora.org
Cc: Chris Ball <cjb@laptop.org>, Muthu Kumar <muthu.lkml@gmail.com>,
        linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Seungwon Jeon <tgih.jun@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 2:14 PM,  <merez@codeaurora.org> wrote:
> On Mon, July 23, 2012 5:22 am, S, Venkatraman wrote:
>> On Mon, Jul 23, 2012 at 5:13 PM,  <merez@codeaurora.org> wrote:
>>> On Wed, July 18, 2012 12:26 am, Chris Ball wrote:
>>>> Hi,  [removing Jens and the documentation list, since now we're
> talking about the MMC side only]
>>>> On Wed, Jul 18 2012, merez@codeaurora.org wrote:
>>>>> Is there anything else that holds this patch from being pushed to
>>> mmc-next?
>>>> Yes, I'm still uncomfortable with the write packing patchsets for a
>>> couple of reasons, and I suspect that the sum of those reasons means that
>>> we should probably plan on holding off merging it until after 3.6.
>>>> Here are the open issues; please correct any misunderstandings: With
> Seungwon's patchset ("Support packed write command"):
>>>> * I still don't have a good set of representative benchmarks showing
>>>>   what kind of performance changes come with this patchset.  It seems
>>> like we've had a small amount of testing on one controller/eMMC part combo
>>> from Seungwon, and an entirely different test from Maya, and the
> results
>>> aren't documented fully anywhere to the level of describing what the
> hardware was, what the test was, and what the results were before and
> after the patchset.
>>> Currently, there is only one card vendor that supports packed commands.
> Following are our sequential write (LMDD) test results on 2 of our
> targets
>>> (in MB/s):
>>>                        No packing        packing
>>> Target 1 (SDR 50MHz)     15               25
>>> Target 2 (DDR 50MHz)     20               30
>>>> With the reads-during-writes regression:
>>>> * Venkat still has open questions about the nature of the read
>>>>   regression, and thinks we should understand it with blktrace before
>>> trying to fix it.  Maya has a theory about writes overwhelming reads, but
>>> Venkat doesn't understand why this would explain the observed
>>> bandwidth drop.
>>> The degradation of read due to writes is not a new behavior and exists
> also without the write packing feature (which only increases the
> degradation). Our investigation of this phenomenon led us to the
> Conclusion that a new scheduling policy should be used for mobile
> devices,
>>> but this is not related to the current discussion of the write packing
> feature.
>>> The write packing feature increases the degradation of read due to
> write
>>> since it allows the MMC to fetch many write requests in a row, instead of
>>> fetching only one at a time.  Therefore some of the read requests will
> have to wait for the completion of more write requests before they can
> be
>>> issued.
>>
>> I am a bit puzzled by this claim. One thing I checked carefully when
> reviewing write packing patches from SJeon was that the code didn't
> plough through a mixed list of reads and writes and selected only
> writes.
>> This section of the code in "mmc_blk_prep_packed_list()", from v8
> patchset..
>> <Quote>
>> +               if (rq_data_dir(cur) != rq_data_dir(next)) {
>> +                       put_back = 1;
>> +                       break;
>> +               }
>> </Quote>
>>
>> means that once a read is encountered in the middle of write packing,
> the packing is stopped at that point and it is executed. Then the next
> blk_fetch_request should get the next read and continue as before.
>>
>> IOW, the ordering of reads and writes is _not_ altered when using packed
> commands.
>> For example if there were 5 write requests, followed by 1 read,
>> followed by 5 more write requests in the request_queue, the first 5
> writes will be executed as one "packed command", then the read will be
> executed, and then the remaining 5 writes will be executed as one
> "packed command". So the read does not have to wait any more than it
> waited before (packing feature)
>
> Let me try to better explain with your example.
> Without packing the MMC layer will fetch 2 write requests and wait for the
> first write request completion before fetching another write request.
> During this time the read request could be inserted into the CFQ and since
> it has higher priority than the async write it will be dispatched in the
> next fetch. So, the result would be 2 write requests followed by one read
> request and the read would have to wait for completion of only 2 write
> requests.
> With packing, all the 5 write requests will be fetched in a row, and then
> the read will arrive and be dispatched in the next fetch. Then the read
> will have to wait for the completion of 5 write requests.
>
> Few more clarifications:
> Due to the plug list mechanism in the block layer the applications can
> "aggregate" several requests to be inserted into the scheduler before
> waking the MMC queue thread.
> This leads to a situation where there are several write requests in the
> CFQ queue when MMC starts to do the fetches.
>
> If the read was inserted while we are building the packed command then I
> agree that we should have seen less effect on the read performance.
> However, the write packing statistics show that in most of the cases the
> packing stopped due to an empty queue, meaning that the read was inserted
> to the CFQ after all the pending write requests were fetched and packed.
>
> Following is an example for write packing statistics of a READ/WRITE
> parallel scenario:
> write packing statistics:
> Packed 1 reqs - 448 times
> Packed 2 reqs - 38 times
> Packed 3 reqs - 23 times
> Packed 4 reqs - 30 times
> Packed 5 reqs - 14 times
> Packed 6 reqs - 8 times
> Packed 7 reqs - 4 times
> Packed 8 reqs - 1 times
> Packed 10 reqs - 1 times
> Packed 34 reqs - 1 times
> stopped packing due to the following reasons:
> 2 times: wrong data direction (meaning a READ was fetched and stopped the
> packing)
> 1 times: flush or discard
> 565 times: empty queue (meaning blk_fetch_request returned NULL)
>
>>
>> And I requested blktrace to confirm that this is indeed the behaviour.
>
> The trace logs show that in case of no packing, there are maximum of 3-4
> requests issued before a read request, while with packing there are also
> cases of 6 and 7 requests dispatched before a read request.
>
> I'm waiting for an approval for sharing the block trace logs.
> Since this is a simple test to run you can collect the trace logs and let
> us know if you reach other conclusions.
>
Thanks for the brief. I don't have the eMMC4.5 device with me yet, so
I can't reproduce the result. The problem you describe is most likely
applicable
to any block device driver with a large queue depth ( any queue depth >1).
I'll check to see what knobs in block affect the result.
Speaking of it, what is the host controller you use to test this ?
I was wondering if host->max_seg_size is taken into account while packed command
is in use. If not, shouldn't it be ?  - it could act as a better
throttle for "packing density".

Thanks,
Venkat.
