Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964890Ab2FAVph (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 17:45:37 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:47890 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932925Ab2FAVp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 17:45:28 -0400
Message-ID: <4FC937AD.8040201@linaro.org>
Date: Fri, 01 Jun 2012 14:44:13 -0700
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
References: <1338575387-26972-1-git-send-email-john.stultz@linaro.org> <1338575387-26972-4-git-send-email-john.stultz@linaro.org> <4FC9235F.5000402@gmail.com> <4FC92E30.4000906@linaro.org> <4FC9360B.4020401@gmail.com>
In-Reply-To: <4FC9360B.4020401@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060121-9360-0000-0000-000006EA7C16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2012 02:37 PM, KOSAKI Motohiro wrote:
> (6/1/12 5:03 PM), John Stultz wrote:
>> On 06/01/2012 01:17 PM, KOSAKI Motohiro wrote:
>>> Hi John,
>>>
>>> (6/1/12 2:29 PM), John Stultz wrote:
>>>> This patch enables FALLOC_FL_MARK_VOLATILE/UNMARK_VOLATILE
>>>> functionality for tmpfs making use of the volatile range
>>>> management code.
>>>>
>>>> Conceptually, FALLOC_FL_MARK_VOLATILE is like a delayed
>>>> FALLOC_FL_PUNCH_HOLE.  This allows applications that have
>>>> data caches that can be re-created to tell the kernel that
>>>> some memory contains data that is useful in the future, but
>>>> can be recreated if needed, so if the kernel needs, it can
>>>> zap the memory without having to swap it out.
>>>>
>>>> In use, applications use FALLOC_FL_MARK_VOLATILE to mark
>>>> page ranges as volatile when they are not in use. Then later
>>>> if they wants to reuse the data, they use
>>>> FALLOC_FL_UNMARK_VOLATILE, which will return an error if the
>>>> data has been purged.
>>>>
>>>> This is very much influenced by the Android Ashmem interface by
>>>> Robert Love so credits to him and the Android developers.
>>>> In many cases the code&   logic come directly from the ashmem patch.
>>>> The intent of this patch is to allow for ashmem-like behavior, but
>>>> embeds the idea a little deeper into the VM code.
>>>>
>>>> This is a reworked version of the fadvise volatile idea submitted
>>>> earlier to the list. Thanks to Dave Chinner for suggesting to
>>>> rework the idea in this fashion. Also thanks to Dmitry Adamushko
>>>> for continued review and bug reporting, and Dave Hansen for
>>>> help with the original design and mentoring me in the VM code.
>>> I like this patch concept. This is cleaner than userland
>>> notification quirk. But I don't like you use shrinker. Because of,
>>> after applying this patch, normal page reclaim path can still make
>>> swap out. this is undesirable.
>> Any recommendations for alternative approaches? What should I be hooking
>> into in order to get notified that tmpfs should drop volatile pages?
> I thought to modify shmem_write_page(). But other way is also ok to me.
So initially the patch used shmem_write_page(), purging ranges if a page
was to be swapped (and just dropping it instead). The problem there is
that if there's a large range that is very active, we might purge the
entire range just because it contains one rarely used page. This is why
the LRU list for unpurged volatile ranges is useful.

However, Dave Hansen just suggested to me on irc the idea of if we're
swapping any pages, we might want to just purge a volatile range
instead. This allows us to keep the unpurged LRU range list, but just
uses write_page as the flag for needing to free memory.

I'm taking a shot at implementing this now, but let me know if it sounds
good to you.

>>>> +static
>>>> +int shmem_volatile_shrink(struct shrinker *ignored, struct shrink_control *sc)
>>>> +{
>>>> +	s64 nr_to_scan = sc->nr_to_scan;
>>>> +	const gfp_t gfp_mask = sc->gfp_mask;
>>>> +	struct address_space *mapping;
>>>> +	loff_t start, end;
>>>> +	int ret;
>>>> +	s64 page_count;
>>>> +
>>>> +	if (nr_to_scan&&   !(gfp_mask&   __GFP_FS))
>>>> +		return -1;
>>>> +
>>>> +	volatile_range_lock(&shmem_volatile_head);
>>>> +	page_count = volatile_range_lru_size(&shmem_volatile_head);
>>>> +	if (!nr_to_scan)
>>>> +		goto out;
>>>> +
>>>> +	do {
>>>> +		ret = volatile_ranges_get_last_used(&shmem_volatile_head,
>>>> +							&mapping,&start,&end);
>>> Why drop last used region? Not recently used region is better?
>>>
>> Sorry, that function name isn't very good. It does return the
>> least-recently-used range, or more specifically: the
>> least-recently-marked-volatile-range.
> Ah, I misunderstood. thanks for correction.
>
>
>> I'll improve that function name, but if I misunderstood you and you have
>> a different suggestion for the purging order, let me know.
> No, please just rename.
Will do.

Thanks for the feedback!
-john

