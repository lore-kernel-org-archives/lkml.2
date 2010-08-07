Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab0HGWrq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 18:47:46 -0400
Received: from tuxonice.net ([74.207.252.127]:59782 "EHLO mail.tuxonice.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690Ab0HGWrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 18:47:45 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4C5DE296.6080509@tuxonice.net>
Date: Sun, 08 Aug 2010 08:47:50 +1000
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Mark Lord <kernel@teksavvy.com>, LKML <linux-kernel@vger.kernel.org>,
        pm list <linux-pm@lists.linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.35 Regression: Ages spent discarding blocks that weren't
 	used!
References: <4C58C528.4000606@tuxonice.net>	<4C5960B0.7020003@teksavvy.com>	<4C59DA16.4020500@tuxonice.net>	<AANLkTik_PH-7T7OFtzaCtPbAHE6pqnYMUsjP25KtsRnR@mail.gmail.com>	<4C5A59FC.1030304@tuxonice.net>	<AANLkTi=NMHkKduZzsLiiYt3=w8++8epb5aGrqv7V3-vB@mail.gmail.com>	<4C5B925A.5000409@tuxonice.net> <AANLkTinU24v6Mty54YL3gv3M5S+4jdN5vHD54KknchAG@mail.gmail.com>
In-Reply-To: <AANLkTinU24v6Mty54YL3gv3M5S+4jdN5vHD54KknchAG@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 07/08/10 08:07, Hugh Dickins wrote:
> On Thu, Aug 5, 2010 at 9:40 PM, Nigel Cunningham<nigel@tuxonice.net>  wrote:
>> On 06/08/10 11:15, Hugh Dickins wrote:
>>> On Wed, Aug 4, 2010 at 11:28 PM, Nigel Cunningham<nigel@tuxonice.net>
>>>   wrote:
>>>>>> On 05/08/10 13:58, Hugh Dickins wrote:
>>>>>
>>>>> I agree it would make more sense to discard swap when freeing rather
>>>>> than when allocating, I wish we could.  But at the freeing point we're
>>>>> often holding a page_table spinlock at an outer level, and it's just
>>>>> one page we're given to free.  Freeing is an operation you want to be
>>>>> comfortable doing when you're short of resources, whereas discard is a
>>>>> kind of I/O operation which needs resources.
>>
>> The more I think about this, the more it seems to me that doing the discard
>> at allocation time is just wrong. How about a strategy in which you do the
>> discard immediately if resources permit, or flag it as in need of doing (at
>> a future swap free of that page or swap off time) if things are too
>> pressured at the moment? I haven't put thought into what data structures
>> could be used for that - just want to ask for now if you'd be happy with the
>> idea of looking into a strategy like that.
>
> We're going round in circles here.  I have already agreed with you
> that doing it at swap free time seems more natural, but explained that
> there are implementation difficulties there, so doing it at allocation
> time proved both much less messy and more efficient.  I can imagine
> advances that would sway me to putting in more effort there
> (duplicating the scan for a free 1MB every time a page of swap is
> freed? doesn't sound efficient to me, but if it saves us from an
> inefficiency of too many or too late discards, perhaps it could work
> out).  However, a recently introduced regression does not make a
> strong case for adding in hacks - not yet anyway.

Okay; sorry.

>> I've done the bisect now - spent the time today instead of on the place, and
>
> That's great, many thanks!
>
>> it took me to fbbf055692aeb25c54c49d9ca84532de836fbba0. This is Christoph's
>> Hellwig's patch "block: fix DISCARD_BARRIER requests".
>
> That's
>      block: fix DISCARD_BARRIER requests
>
>      Filesystems assume that DISCARD_BARRIER are full barriers, so that they
>      don't have to track in-progress discard operation when submitting new I/O.
>      But currently we only treat them as elevator barriers, which don't
>      actually do the nessecary queue drains.
>
> where the discard barrier changes from REQ_SOFTBARRIER to REQ_HARDBARRIER.
>
> If REQ_SOFTBARRIER means that the device is still free to reorder a
> write, which was issued after discard completion was reported, before
> the discard (so later discarding the data written), then certainly I
> agree with Christoph (now Cc'ed) that the REQ_HARDBARRIER is
> unavoidable there; but if not, then it's not needed for the swap case.
>   I hope to gain a little more enlightenment on such barriers shortly.
>
> What does seem over the top to me, is for mm/swapfile.c's
> blkdev_issue_discard()s to be asking for both BLKDEV_IFL_WAIT and
> BLKDEV_IFL_BARRIER: those swap discards were originally written just
> to use barriers, without needing to wait for completion in there.  I'd
> be interested to hear if cutting out the BLKDEV_IFL_WAITs makes the
> swap discards behave acceptably again for you - but understand that
> you won't have a chance to try that until later next week.

Well, I've just arrived at the hotel, and I want to delay going to bed 
until a 'proper' hour local time, so I expect I'll do it this evening - 
especially a one liner like that. Might even give it a go now...

Nigel
