Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932662Ab0I0GIb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 02:08:31 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:49799 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754255Ab0I0GIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 02:08:30 -0400
Message-ID: <4CA034D5.6090901@kernel.dk>
Date: Mon, 27 Sep 2010 15:08:21 +0900
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Mike Snitzer <snitzer@gmail.com>
CC: Kyle McMartin <kyle@mcmartin.ca>, Adrian Hunter <adrian.hunter@nokia.com>,
        linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] block: prevent merges of discard and write requests
References: <1285411002-22924-1-git-send-email-adrian.hunter@nokia.com> <4C9DD1B0.9020902@kernel.dk> <20100927033030.GR13116@bombadil.infradead.org> <4CA024C8.3000203@kernel.dk> <AANLkTikxw739=mZ2UZatSS8dTBb7+wz-AAL5uGBnM73N@mail.gmail.com> <AANLkTi==tc5q7tR0OZfBtvm1KMCbVO45LRHu6Em52bOy@mail.gmail.com>
In-Reply-To: <AANLkTi==tc5q7tR0OZfBtvm1KMCbVO45LRHu6Em52bOy@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-27 14:26, Mike Snitzer wrote:
> On Mon, Sep 27, 2010 at 1:12 AM, Mike Snitzer <snitzer@redhat.com> wrote:
>> On Mon, Sep 27, 2010 at 12:59 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>> On 2010-09-27 12:30, Kyle McMartin wrote:
>>>> On Sat, Sep 25, 2010 at 12:40:48PM +0200, Jens Axboe wrote:
>>>>> On 2010-09-25 12:36, Adrian Hunter wrote:
>>>>>> Add logic to prevent two I/O requests being merged if
>>>>>> only one of them is a discard.  Ditto secure discard.
>>>>>>
>>>>>> Without this fix, it is possible for write requests
>>>>>> to transform into discard requests.  For example:
>>>>>>
>>>>>>   Submit bio 1 to discard 8 sectors from sector n
>>>>>>   Submit bio 2 to write 8 sectors from sector n + 16
>>>>>>   Submit bio 3 to write 8 sectors from sector n + 8
>>>>>>
>>>>>> Bio 1 becomes request 1.  Bio 2 becomes request 2.
>>>>>> Bio 3 is merged with request 2, and then subsequently
>>>>>> request 2 is merged with request 1 resulting in just
>>>>>> one I/O request which discards all 24 sectors.
>>>>>
>>>>> Wow, that's a disaster. We can now have requests in the
>>>>> same direction and of the same type (fs), but not mergeable.
>>>>>
>>>>> I would move the check up above the position calculations.
>>>>> I will apply this and upstream it right away. Thanks a lot!
>>>>>
>>>>
>>>> Jens, is this (the REQ_DISCARD hunk) required for stable as well? It
>>>> appears there's not much change relating to merging requests between
>>>> HEAD and v2.6.35, so I assume it is?
>>>
>>> No, 2.6.35 and earlier is safe, it's only 2.6.36-rc that is
>>> affected by this bug.
>>
>> I'm not so sure... I think 2.6.35 is affected.  Jens, what do you hold
>> to be the regression point?
> ...
>> But things really broke once we started playing games with barrier
>> flags associated with discards.  The regression point (relative to
>> discard merging) seems to have occurred when we got away from using
>> REQ_SOFTBARRIER with commit: fbbf055692aeb "block: fix DISCARD_BARRIER
>> requests".  Which was still committed to v2.6.35...
> 
> OK I take that back, with commit fbbf055692aeb REQ_HARDBARRIER is used
> for discards.. which is equally applicable to !rq_mergeable().
> 
> Anyway, I'd still like to understand what you feel is the regression point.

Looking at the end result, 2.6.35 does look like it's affected for
request-to-request merges, if those were submitted outside of
blkdev_issue_discard() (all in-kernel users have BARRIER set). But we
can't rule out of-of-tree drivers, so I suppose we should submit
the patch to stable just to be on the safe side.

Thankfully it is a very rare condition. Request-to-request merges
are fairly uncommon, and the chance of an unrelated merge (most users do
waiting issues) is small. So it's affected in the same sense that .36-rc
is, I initially thought the problem was worse there.

-- 
Jens Axboe

