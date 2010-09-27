Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab0I0F02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 01:26:28 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34032 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab0I0F01 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 01:26:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=l+PqYE9leo5CiQLTkSniEyHda7WbdWTVYc4tjE1+nVFU0CPAUsNpws9BYATEbZLXNT
         O4dq+feLlrlfAOSmxud9V0fVMFNAQZPNw60kh1Sl8Bx4jGyF0H2iuf+bdd/UmvfhWB4x
         l5i0kQi2nVfRjldJz2h7Ykw9Psqlyod4XTYU8=
MIME-Version: 1.0
In-Reply-To: <AANLkTikxw739=mZ2UZatSS8dTBb7+wz-AAL5uGBnM73N@mail.gmail.com>
References: <1285411002-22924-1-git-send-email-adrian.hunter@nokia.com>
 <4C9DD1B0.9020902@kernel.dk> <20100927033030.GR13116@bombadil.infradead.org>
 <4CA024C8.3000203@kernel.dk> <AANLkTikxw739=mZ2UZatSS8dTBb7+wz-AAL5uGBnM73N@mail.gmail.com>
From: Mike Snitzer <snitzer@gmail.com>
Date: Mon, 27 Sep 2010 01:26:06 -0400
Message-ID: <AANLkTi==tc5q7tR0OZfBtvm1KMCbVO45LRHu6Em52bOy@mail.gmail.com>
Subject: Re: [PATCH] block: prevent merges of discard and write requests
To: Jens Axboe <axboe@kernel.dk>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Adrian Hunter <adrian.hunter@nokia.com>,
        linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@kernel.org, Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 1:12 AM, Mike Snitzer <snitzer@redhat.com> wrote:
> On Mon, Sep 27, 2010 at 12:59 AM, Jens Axboe <axboe@kernel.dk> wrote:
>> On 2010-09-27 12:30, Kyle McMartin wrote:
>>> On Sat, Sep 25, 2010 at 12:40:48PM +0200, Jens Axboe wrote:
>>>> On 2010-09-25 12:36, Adrian Hunter wrote:
>>>>> Add logic to prevent two I/O requests being merged if
>>>>> only one of them is a discard.  Ditto secure discard.
>>>>>
>>>>> Without this fix, it is possible for write requests
>>>>> to transform into discard requests.  For example:
>>>>>
>>>>>   Submit bio 1 to discard 8 sectors from sector n
>>>>>   Submit bio 2 to write 8 sectors from sector n + 16
>>>>>   Submit bio 3 to write 8 sectors from sector n + 8
>>>>>
>>>>> Bio 1 becomes request 1.  Bio 2 becomes request 2.
>>>>> Bio 3 is merged with request 2, and then subsequently
>>>>> request 2 is merged with request 1 resulting in just
>>>>> one I/O request which discards all 24 sectors.
>>>>
>>>> Wow, that's a disaster. We can now have requests in the
>>>> same direction and of the same type (fs), but not mergeable.
>>>>
>>>> I would move the check up above the position calculations.
>>>> I will apply this and upstream it right away. Thanks a lot!
>>>>
>>>
>>> Jens, is this (the REQ_DISCARD hunk) required for stable as well? It
>>> appears there's not much change relating to merging requests between
>>> HEAD and v2.6.35, so I assume it is?
>>
>> No, 2.6.35 and earlier is safe, it's only 2.6.36-rc that is
>> affected by this bug.
>
> I'm not so sure... I think 2.6.35 is affected.  Jens, what do you hold
> to be the regression point?
...
> But things really broke once we started playing games with barrier
> flags associated with discards.  The regression point (relative to
> discard merging) seems to have occurred when we got away from using
> REQ_SOFTBARRIER with commit: fbbf055692aeb "block: fix DISCARD_BARRIER
> requests".  Which was still committed to v2.6.35...

OK I take that back, with commit fbbf055692aeb REQ_HARDBARRIER is used
for discards.. which is equally applicable to !rq_mergeable().

Anyway, I'd still like to understand what you feel is the regression point.

Mike
