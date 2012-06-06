Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960Ab2FFTwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 15:52:32 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44490 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab2FFTwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 15:52:31 -0400
Message-ID: <4FCFB4F6.6070308@gmail.com>
Date: Wed, 06 Jun 2012 15:52:22 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>,
        Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Taras Glek <tgek@mozilla.com>, Mike Hommey <mh@glandium.org>,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/3] [RFC] tmpfs: Add FALLOC_FL_MARK_VOLATILE/UNMARK_VOLATILE
 handlers
References: <1338575387-26972-1-git-send-email-john.stultz@linaro.org> <1338575387-26972-4-git-send-email-john.stultz@linaro.org> <4FC9235F.5000402@gmail.com> <4FC92E30.4000906@linaro.org> <4FC9360B.4020401@gmail.com> <4FC937AD.8040201@linaro.org> <4FC9438B.1000403@gmail.com> <4FC94F61.20305@linaro.org>
In-Reply-To: <4FC94F61.20305@linaro.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>>> I like this patch concept. This is cleaner than userland
>>>>>> notification quirk. But I don't like you use shrinker. Because of,
>>>>>> after applying this patch, normal page reclaim path can still make
>>>>>> swap out. this is undesirable.
>>>>> Any recommendations for alternative approaches? What should I be hooking
>>>>> into in order to get notified that tmpfs should drop volatile pages?
>>>> I thought to modify shmem_write_page(). But other way is also ok to me.
>>> So initially the patch used shmem_write_page(), purging ranges if a page
>>> was to be swapped (and just dropping it instead). The problem there is
>>> that if there's a large range that is very active, we might purge the
>>> entire range just because it contains one rarely used page. This is why
>>> the LRU list for unpurged volatile ranges is useful.
>> ???
>> But, volatile marking order is not related to access frequency.
> 
> Correct.
>
>>   Why do you
>> bother more inaccurate one? At least, pageout() should affect lru order
>> of volatile ranges?
> 
> Not sure I'm following you here.
> 
> The key point is we want volatile ranges to be purged in the order they
> were marked volatile.
> If we use the page lru via shmem_writeout to trigger range purging, we
> wouldn't necessarily get this desired behavior.

Ok, so can you please explain your ideal order to reclaim. your last mail
described old and new volatiled region. but I'm not sure regular tmpfs pages
vs volatile pages vs regular file cache order. That said, when using shrink_slab(),
we choose random order to drop against page cache. I'm not sure why you sure
it is ideal.

And, now I guess you think nobody touch volatiled page, yes? because otherwise
volatile marking order is silly choice. If yes, what's happen if anyone touch
a patch which volatiled. no-op? SIGBUS? 



> 
> That said, Dave's idea is to still use a volatile range LRU, but to free
> it via shmem_writeout. This allows us to purge volatile pages before
> swapping out pages. I'll be sending a modified patchset out shortly that
> does this, hopefully it helps makes this idea clear.
> 
>>> However, Dave Hansen just suggested to me on irc the idea of if we're
>>> swapping any pages, we might want to just purge a volatile range
>>> instead. This allows us to keep the unpurged LRU range list, but just
>>> uses write_page as the flag for needing to free memory.
>> Can you please elaborate more? I don't understand what's different
>> "just dropping it instead" and "just purge a volatile range instead".
> So in the first implementation, on writeout we checked if the page was
> in a volatile range, and if so we dropped the page (just unlocking the
> page) and marked the range as purged instead of swapping the page out.
> This was non-optimal since the entire range was marked purged, but other
> volatile pages in that range would not be dropped until writeout was
> called on them.
> 
> My next implementation purged the entire range (via
> shmem_truncate_range) if we did a writeout on a page in that range. This
> was better, but still left us open to purging recently marked volatile
> ranges if only a single page in that range had not been accessed in awhile.

Which worklord didn't work. Usually, anon pages reclaim are only happen when
1) tmpfs streaming io workload or 2) heavy vm pressure. So, this scenario
are not so inaccurate to me.


> That's when I added the LRU tracking at the volatile range level (which
> reverted back to the behavior ashmem has always used), and have been
> using that model sense.
> 
> Hopefully this clarifies things. My apologies if I don't always use the
> correct terminology, as I'm still a newbie when it comes to VM code.

I think your code is enough clean. But I'm still not sure your background
design. Please help me to understand clearly.

btw, Why do you choice fallocate instead of fadvise? As far as I skimmed,
fallocate() is an operation of a disk layout, not of a cache. And, why
did you choice fadvise() instead of madvise() at initial version. vma
hint might be useful than fadvise() because it can be used for anonymous
pages too.

