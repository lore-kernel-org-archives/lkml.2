Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806Ab2FOMbw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 08:31:52 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:37099 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756725Ab2FOMbv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 08:31:51 -0400
MIME-Version: 1.0
In-Reply-To: <4FDAE3CC.60801@kernel.org>
References: <1339661592-3915-1-git-send-email-kosaki.motohiro@gmail.com>
	<20120614145716.GA2097@barrios>
	<CAHGf_=qcA5OfuNgk0BiwyshcLftNWoPfOO_VW9H6xQTX2tAbuA@mail.gmail.com>
	<4FDAE3CC.60801@kernel.org>
Date: Fri, 15 Jun 2012 20:31:50 +0800
Message-ID: <CAJd=RBBSa2TuRDVGrY9JT9m3K68N1LWiZKyo3Y1mdQRo5TxBLQ@mail.gmail.com>
Subject: Re: [resend][PATCH] mm, vmscan: fix do_try_to_free_pages() livelock
From: Hillf Danton <dhillf@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org,
        Nick Piggin <npiggin@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Minchan and KOSAKI

On Fri, Jun 15, 2012 at 3:27 PM, Minchan Kim <minchan@kernel.org> wrote:
> On 06/15/2012 01:10 AM, KOSAKI Motohiro wrote:
>
>> On Thu, Jun 14, 2012 at 10:57 AM, Minchan Kim <minchan@kernel.org> wrote:
>>> Hi KOSAKI,
>>>
>>> Sorry for late response.
>>> Let me ask a question about description.
>>>
>>> On Thu, Jun 14, 2012 at 04:13:12AM -0400, kosaki.motohiro@gmail.com wrote:
>>>> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>>>>
>>>> Currently, do_try_to_free_pages() can enter livelock. Because of,
>>>> now vmscan has two conflicted policies.
>>>>
>>>> 1) kswapd sleep when it couldn't reclaim any page when reaching
>>>>    priority 0. This is because to avoid kswapd() infinite
>>>>    loop. That said, kswapd assume direct reclaim makes enough
>>>>    free pages to use either regular page reclaim or oom-killer.
>>>>    This logic makes kswapd -> direct-reclaim dependency.
>>>> 2) direct reclaim continue to reclaim without oom-killer until
>>>>    kswapd turn on zone->all_unreclaimble. This is because
>>>>    to avoid too early oom-kill.
>>>>    This logic makes direct-reclaim -> kswapd dependency.
>>>>
>>>> In worst case, direct-reclaim may continue to page reclaim forever
>>>> when kswapd sleeps forever.
>>>
>>> I have tried imagined scenario you mentioned above with code level but
>>> unfortunately I got failed.
>>> If kswapd can't meet high watermark on order-0, it doesn't sleep if I don't miss something.
>>
>> pgdat_balanced() doesn't recognized zone. Therefore kswapd may sleep
>> if node has multiple zones. Hm ok, I realized my descriptions was
>> slightly misleading. priority 0 is not needed. bakance_pddat() calls
>> pgdat_balanced()
>> every priority. Most easy case is, movable zone has a lot of free pages and
>> normal zone has no reclaimable page.
>>
>> btw, current pgdat_balanced() logic seems not correct. kswapd should
>> sleep only if every zones have much free pages than high water mark
>> _and_ 25% of present pages in node are free.
>>
>
>
> Sorry. I can't understand your point.
> Current kswapd doesn't sleep if relevant zones don't have free pages above high watermark.
> It seems I am missing your point.
> Please anybody correct me.
>

Who left comment on unreclaimable there, and why?
		/*
		 * balance_pgdat() skips over all_unreclaimable after
		 * DEF_PRIORITY. Effectively, it considers them balanced so
		 * they must be considered balanced here as well if kswapd
		 * is to sleep
		 */

BTW, are you still using prefetch_prev_lru_page?

Good Weekend
Hillf
