Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634Ab2GWLnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 07:43:17 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59946 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab2GWLnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 07:43:13 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6780"; a="211099979"
Message-ID: <b09d01655db4d4aa535b9a9d310bc8f9.squirrel@www.codeaurora.org>
Date: Mon, 23 Jul 2012 04:43:12 -0700 (PDT)
Subject: Re: [PATCH v2 1/1] mmc: block: Add write packing control
From: merez@codeaurora.org
To: "Chris Ball" <cjb@laptop.org>
Cc: merez@codeaurora.org, "Muthu Kumar" <muthu.lkml@gmail.com>,
        linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        "open list" <linux-kernel@vger.kernel.org>,
        "S\, Venkatraman" <svenkatr@ti.com>,
        "Seungwon Jeon" <tgih.jun@samsung.com>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, July 18, 2012 12:26 am, Chris Ball wrote:
> Hi,  [removing Jens and the documentation list, since now we're
> talking about the MMC side only]
>
> On Wed, Jul 18 2012, merez@codeaurora.org wrote:
>> Is there anything else that holds this patch from being pushed to
mmc-next?
>
> Yes, I'm still uncomfortable with the write packing patchsets for a
couple of reasons, and I suspect that the sum of those reasons means that
we should probably plan on holding off merging it until after 3.6.
>
> Here are the open issues; please correct any misunderstandings:
>
> With Seungwon's patchset ("Support packed write command"):
>
> * I still don't have a good set of representative benchmarks showing
>   what kind of performance changes come with this patchset.  It seems
like we've had a small amount of testing on one controller/eMMC part combo
from Seungwon, and an entirely different test from Maya, and the results
aren't documented fully anywhere to the level of describing what the
hardware was, what the test was, and what the results were before and
after the patchset.

Currently, there is only one card vendor that supports packed commands.
Following are our sequential write (LMDD) test results on 2 of our targets
(in MB/s):
                       No packing        packing
Target 1 (SDR 50MHz)     15               25
Target 2 (DDR 50MHz)     20               30

>
> With the reads-during-writes regression:
>
> * Venkat still has open questions about the nature of the read
>   regression, and thinks we should understand it with blktrace before
trying to fix it.  Maya has a theory about writes overwhelming reads, but
Venkat doesn't understand why this would explain the observed
bandwidth drop.

The degradation of read due to writes is not a new behavior and exists
also without the write packing feature (which only increases the
degradation). Our investigation of this phenomenon led us to the
Conclusion that a new scheduling policy should be used for mobile devices,
but this is not related to the current discussion of the write packing
feature.

The write packing feature increases the degradation of read due to write
since it allows the MMC to fetch many write requests in a row, instead of
fetching only one at a time.  Therefore some of the read requests will
have to wait for the completion of more write requests before they can be
issued.

To overcome this behavior, the solution would be to stop the write packing
when a read request is fetched, and this is the algorithm suggested by the
write packing control.

Let's also keep in mind that lmdd benchmarking doesn't fully reflect the
real life in which there are not many scenarios that cause massive read
and write operations. In our user-common-scenarios tests we saw that in
many cases the write packing decreases the read latency. It can happen in
cases where the same amount of write requests is fetched with and without
packing. In such a case the write packing decreases the transfer time of
the write requests and causes the read request to wait for a shorter time.

>
> With Maya's patchset ("write packing control"):
>
> * Venkat thinks that HPI should be used, and the number-of-requests
>   metric is too coarse, and it doesn't let you disable packing at the
right time, and you're essentially implementing a new I/O scheduler inside
the MMC subsystem without understanding the root cause for why that's
necessary.

According to our measurements the stop transmission (CMD12) + HPI is a
heavy operation that may take up to several milliseconds. Therefore, a
massive usage of HPI can cause a degradation of performance.
In addition, it doesn’t provide a complete solution for read during write
since it doesn’t solve the problem of “what to do with the interrupted
write request remainder?”.  That is, a common interrupting read request
will usually be followed by another one. If we just continue to write the
interrupted write request remainder we will probably get another HPI due
to the second read request, so eventually we may end up with lots of HPIs
and write retries. A complete solution will be: stop the current write,
change packing mode to non-packing, serve the read request, push back the
write remainders to the block I/O scheduler and let him schedule them
again probably after the read burst ends (this requires block layer
support of course).

Regarding the packing control, there seem to be a confusion since the
number-of-requests is the trigger for *enabling* the packing (after it was
disabled), while a single read request disable packing. Therefore, the
packing is stopped at the right time.

The packing control doesn't add any scheduling policy to the MMC layer.
The write packing feature is the one changing the scheduling policy by
fetching many write requests in a row without a delay that allows read
requests to come in the middle.
By disabling the write packing, the write packing control returns the old
scheduling policy. It causes the MMC to fetch the requests one by one,
thus read requests are served as before.

It is correct that the trigger for enabling the write packing control
should be adjusted per platform and doesn't give a complete solution. As I
mentioned above, the complete solution will include the usage of write
packing control, a re-insert of the write packed to the scheduler when a
read request is fetched and usage of HPI to stop the packing that is
already transferred.

To summarize -
We recommend including the write packing in 3.6 due to the following reasons:
1. It significantly improves the write throughput
2. In some of the cases it even decreases the read latency
3. The read degradation in simultaneous read-write flows already exist,
even without this feature

As for the write packing control, it can be included in 3.6 to supply a
partial solution for the read degradation or we can postpone it to 3.7 and
integrate it as part of the complete solution.

Thanks,
Maya

>
> My sense is that there's no way we can solve all of these to
> satisfaction in the next week (which is when the merge window will
open), but that by waiting a cycle we might come up with some good answers.
>
> What do other people think?  If you're excited about these patchsets,
now would be a fine time to come forward with your benchmarking results
and to help understand the reads-during-writes regression.
>
> Thanks!
>
> - Chris.
> --
> Chris Ball   <cjb@laptop.org>   <http://printf.net/>
> One Laptop Per Child
>


-- 
Sent by consultant of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum


















