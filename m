Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab2K1Nhk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 08:37:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754509Ab2K1Nhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 08:37:39 -0500
Message-ID: <50B6131E.2020805@redhat.com>
Date: Wed, 28 Nov 2012 14:35:26 +0100
From: Zdenek Kabelac <zkabelac@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        George Spelvin <linux@horizon.com>,
        Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        Tomas Racek <tracek@redhat.com>, Jan Kara <jack@suse.cz>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Josh Boyer <jwboyer@gmail.com>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Jiri Slaby <jslaby@suse.cz>, Thorsten Leemhuis <fedora@leemhuis.info>,
        Bruno Wolff III <bruno@wolff.to>, linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kswapd craziness in 3.7
References: <1354049315-12874-1-git-send-email-hannes@cmpxchg.org> <CA+55aFywygqWUBNWtZYa+vk8G0cpURZbFdC7+tOzyWk6tLi=WA@mail.gmail.com>
In-Reply-To: <CA+55aFywygqWUBNWtZYa+vk8G0cpURZbFdC7+tOzyWk6tLi=WA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 27.11.2012 21:58, Linus Torvalds napsal(a):
> Note that in the meantime, I've also applied (through Andrew) the
> patch that reverts commit c654345924f7 (see commit 82b212f40059
> 'Revert "mm: remove __GFP_NO_KSWAPD"').
>
> I wonder if that revert may be bogus, and a result of this same issue.
> Maybe that revert should be reverted, and replaced with your patch?
>
> Mel? Zdenek? What's the status here?
>


I've tried for longer term:

https://lkml.org/lkml/2012/11/5/308
https://lkml.org/lkml/2012/11/12/113

these 2 seems to be now merge in -rc7
(since they disappeared after my git rebase)


and added slightly modified patch from Jiri
(https://lkml.org/lkml/2012/11/15/950
(Unsure where it still applies for -rc7??)

Also I've Jan Kara <jack@suse.cz>
fs: Fix imbalance in freeze protection in mark_files_ro()
(which is still not applied to upstream)

And I think I'm NOT seeing huge load from kswapd0.
(At least related to my not really long uptimes)


But also I'm now  frequent victim of my other report:

https://lkml.org/lkml/2012/11/15/369

Which turns into a problem, that if my T61 docking station
has enabled support for 'old hw' for docking in BIOS - i.e. serial output'
it becomes unstable and either 1st. or 2nd. resume deadlocks
machine - and serial port gives just garbage)

Zdenek


>                   Linus
>
> On Tue, Nov 27, 2012 at 12:48 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
>> Hi everyone,
>>
>> I hope I included everybody that participated in the various threads
>> on kswapd getting stuck / exhibiting high CPU usage.  We were looking
>> at at least three root causes as far as I can see, so it's not really
>> clear who observed which problem.  Please correct me if the
>> reported-by, tested-by, bisected-by tags are incomplete.
>>
>> One problem was, as it seems, overly aggressive reclaim due to scaling
>> up reclaim goals based on compaction failures.  This one was reverted
>> in 9671009 mm: revert "mm: vmscan: scale number of pages reclaimed by
>> reclaim/compaction based on failures".
>>
>> Another one was an accounting problem where a freed higher order page
>> was underreported, and so kswapd had trouble restoring watermarks.
>> This one was fixed in ef6c5be fix incorrect NR_FREE_PAGES accounting
>> (appears like memory leak).
>>
>> The third one is a problem with small zones, like the DMA zone, where
>> the high watermark is lower than the low watermark plus compaction gap
>> (2 * allocation size).  The zonelist reclaim in kswapd would do
>> nothing because all high watermarks are met, but the compaction logic
>> would find its own requirements unmet and loop over the zones again.
>> Indefinitely, until some third party would free enough memory to help
>> meet the higher compaction watermark.  The problematic code has been
>> there since the 3.4 merge window for non-THP higher order allocations
>> but has been more prominent since the 3.7 merge window, where kswapd
>> is also woken up for the much more common THP allocations.
>>
>> The following patch should fix the third issue by making both reclaim
>> and compaction code in kswapd use the same predicate to determine
>> whether a zone is balanced or not.
>>
>> Hopefully, the sum of all three fixes should tame kswapd enough for
>> 3.7.
>>
>> Johannes
>>

