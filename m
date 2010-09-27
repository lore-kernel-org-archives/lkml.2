Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab0I0E77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 00:59:59 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:37119 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287Ab0I0E76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 00:59:58 -0400
Message-ID: <4CA024C8.3000203@kernel.dk>
Date: Mon, 27 Sep 2010 13:59:52 +0900
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Kyle McMartin <kyle@mcmartin.ca>
CC: Adrian Hunter <adrian.hunter@nokia.com>,
        linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@kernel.org
Subject: Re: [PATCH] block: prevent merges of discard and write requests
References: <1285411002-22924-1-git-send-email-adrian.hunter@nokia.com> <4C9DD1B0.9020902@kernel.dk> <20100927033030.GR13116@bombadil.infradead.org>
In-Reply-To: <20100927033030.GR13116@bombadil.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-27 12:30, Kyle McMartin wrote:
> On Sat, Sep 25, 2010 at 12:40:48PM +0200, Jens Axboe wrote:
>> On 2010-09-25 12:36, Adrian Hunter wrote:
>>> Add logic to prevent two I/O requests being merged if
>>> only one of them is a discard.  Ditto secure discard.
>>>
>>> Without this fix, it is possible for write requests
>>> to transform into discard requests.  For example:
>>>
>>>   Submit bio 1 to discard 8 sectors from sector n
>>>   Submit bio 2 to write 8 sectors from sector n + 16
>>>   Submit bio 3 to write 8 sectors from sector n + 8
>>>
>>> Bio 1 becomes request 1.  Bio 2 becomes request 2.
>>> Bio 3 is merged with request 2, and then subsequently
>>> request 2 is merged with request 1 resulting in just
>>> one I/O request which discards all 24 sectors.
>>
>> Wow, that's a disaster. We can now have requests in the
>> same direction and of the same type (fs), but not mergeable.
>>
>> I would move the check up above the position calculations.
>> I will apply this and upstream it right away. Thanks a lot!
>>
> 
> Jens, is this (the REQ_DISCARD hunk) required for stable as well? It
> appears there's not much change relating to merging requests between
> HEAD and v2.6.35, so I assume it is?

No, 2.6.35 and earlier is safe, it's only 2.6.36-rc that is
affected by this bug.

-- 
Jens Axboe

