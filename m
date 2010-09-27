Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab0I0FND (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 01:13:03 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52846 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab0I0FNB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 01:13:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=La2REVd99TsqPAKpOC1DpuNSe/IjZKNmmbr2Ed5BmkgLOWeleF6Pt8BtS1UgxqvjEQ
         nlPyoMGgRiqTRsMPAUXgoKJOP4Uyjz+s1mpRhRemKFIsVPpw0xdHRj96n+CBKRU+DdVS
         bF9utJ3+J3+dKcB0f9yVmd2Edb7Yq8Es14o5g=
MIME-Version: 1.0
In-Reply-To: <4CA024C8.3000203@kernel.dk>
References: <1285411002-22924-1-git-send-email-adrian.hunter@nokia.com>
 <4C9DD1B0.9020902@kernel.dk> <20100927033030.GR13116@bombadil.infradead.org> <4CA024C8.3000203@kernel.dk>
From: Mike Snitzer <snitzer@redhat.com>
Date: Mon, 27 Sep 2010 01:12:39 -0400
X-Google-Sender-Auth: pdOyRQSg4gHUNuC1G8oOmjgBMmI
Message-ID: <AANLkTikxw739=mZ2UZatSS8dTBb7+wz-AAL5uGBnM73N@mail.gmail.com>
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

On Mon, Sep 27, 2010 at 12:59 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2010-09-27 12:30, Kyle McMartin wrote:
>> On Sat, Sep 25, 2010 at 12:40:48PM +0200, Jens Axboe wrote:
>>> On 2010-09-25 12:36, Adrian Hunter wrote:
>>>> Add logic to prevent two I/O requests being merged if
>>>> only one of them is a discard.  Ditto secure discard.
>>>>
>>>> Without this fix, it is possible for write requests
>>>> to transform into discard requests.  For example:
>>>>
>>>>   Submit bio 1 to discard 8 sectors from sector n
>>>>   Submit bio 2 to write 8 sectors from sector n + 16
>>>>   Submit bio 3 to write 8 sectors from sector n + 8
>>>>
>>>> Bio 1 becomes request 1.  Bio 2 becomes request 2.
>>>> Bio 3 is merged with request 2, and then subsequently
>>>> request 2 is merged with request 1 resulting in just
>>>> one I/O request which discards all 24 sectors.
>>>
>>> Wow, that's a disaster. We can now have requests in the
>>> same direction and of the same type (fs), but not mergeable.
>>>
>>> I would move the check up above the position calculations.
>>> I will apply this and upstream it right away. Thanks a lot!
>>>
>>
>> Jens, is this (the REQ_DISCARD hunk) required for stable as well? It
>> appears there's not much change relating to merging requests between
>> HEAD and v2.6.35, so I assume it is?
>
> No, 2.6.35 and earlier is safe, it's only 2.6.36-rc that is
> affected by this bug.

I'm not so sure... I think 2.6.35 is affected.  Jens, what do you hold
to be the regression point?

The initial discard merge implementation (commit e17fc0a1ccf88) always
set REQ_SOFTBARRIER for discards.  As such such non-ioctl
blkdev_issue_discard() discards were always !rq_mergeable().

As commit e17fc0a1ccf88 shared: it is always possible to send a
discard without the use of a barrier (but such callers were assumed to
be safe, e.g. mkfs.* discarding entire device via ioctl?).

But things really broke once we started playing games with barrier
flags associated with discards.  The regression point (relative to
discard merging) seems to have occurred when we got away from using
REQ_SOFTBARRIER with commit: fbbf055692aeb "block: fix DISCARD_BARRIER
requests".  Which was still committed to v2.6.35...

So long story short: it seems stable's 2.6.35.y needs this fix too.

Of course I could easily be missing something.. if I got any of this
wrong please correct me ;)

Thanks,
Mike
