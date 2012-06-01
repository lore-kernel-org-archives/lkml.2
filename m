Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759618Ab2FAXZt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 19:25:49 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:36474 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759531Ab2FAXZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 19:25:47 -0400
Message-ID: <4FC94F61.20305@linaro.org>
Date: Fri, 01 Jun 2012 16:25:21 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
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
References: <1338575387-26972-1-git-send-email-john.stultz@linaro.org> <1338575387-26972-4-git-send-email-john.stultz@linaro.org> <4FC9235F.5000402@gmail.com> <4FC92E30.4000906@linaro.org> <4FC9360B.4020401@gmail.com> <4FC937AD.8040201@linaro.org> <4FC9438B.1000403@gmail.com>
In-Reply-To: <4FC9438B.1000403@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060123-3270-0000-0000-000006D5B02A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2012 03:34 PM, KOSAKI Motohiro wrote:
> (6/1/12 5:44 PM), John Stultz wrote:
>> On 06/01/2012 02:37 PM, KOSAKI Motohiro wrote:
>>> (6/1/12 5:03 PM), John Stultz wrote:
>>>> On 06/01/2012 01:17 PM, KOSAKI Motohiro wrote:
>>>>> I like this patch concept. This is cleaner than userland
>>>>> notification quirk. But I don't like you use shrinker. Because of,
>>>>> after applying this patch, normal page reclaim path can still make
>>>>> swap out. this is undesirable. 
>>>> Any recommendations for alternative approaches? What should I be hooking
>>>> into in order to get notified that tmpfs should drop volatile pages?
>>> I thought to modify shmem_write_page(). But other way is also ok to me.
>> So initially the patch used shmem_write_page(), purging ranges if a page
>> was to be swapped (and just dropping it instead). The problem there is
>> that if there's a large range that is very active, we might purge the
>> entire range just because it contains one rarely used page. This is why
>> the LRU list for unpurged volatile ranges is useful.
> ???
> But, volatile marking order is not related to access frequency.

Correct.

>  Why do you
> bother more inaccurate one? At least, pageout() should affect lru order
> of volatile ranges?

Not sure I'm following you here.

The key point is we want volatile ranges to be purged in the order they
were marked volatile.
If we use the page lru via shmem_writeout to trigger range purging, we
wouldn't necessarily get this desired behavior.

That said, Dave's idea is to still use a volatile range LRU, but to free
it via shmem_writeout. This allows us to purge volatile pages before
swapping out pages. I'll be sending a modified patchset out shortly that
does this, hopefully it helps makes this idea clear.

>> However, Dave Hansen just suggested to me on irc the idea of if we're
>> swapping any pages, we might want to just purge a volatile range
>> instead. This allows us to keep the unpurged LRU range list, but just
>> uses write_page as the flag for needing to free memory.
> Can you please elaborate more? I don't understand what's different 
> "just dropping it instead" and "just purge a volatile range instead".
So in the first implementation, on writeout we checked if the page was
in a volatile range, and if so we dropped the page (just unlocking the
page) and marked the range as purged instead of swapping the page out.
This was non-optimal since the entire range was marked purged, but other
volatile pages in that range would not be dropped until writeout was
called on them.

My next implementation purged the entire range (via
shmem_truncate_range) if we did a writeout on a page in that range. This
was better, but still left us open to purging recently marked volatile
ranges if only a single page in that range had not been accessed in awhile.

That's when I added the LRU tracking at the volatile range level (which
reverted back to the behavior ashmem has always used), and have been
using that model sense.

Hopefully this clarifies things. My apologies if I don't always use the
correct terminology, as I'm still a newbie when it comes to VM code.

thanks
-john

