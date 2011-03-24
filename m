Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932629Ab1CXGcx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 02:32:53 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50675 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab1CXGcw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 02:32:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AgEQupWqJE55cW48jbenr3H+FU9QcvDWEiDlVAhuszTN+tigg73mvDInFlKZ3+S+7K
         k14dikKKr/wHouz+fVmVILaBqw7c7e8RdD5KbxfllEC+Ogdl4TV52q9ts+jbii0YMelz
         /Zck1iyxWt76t96N3t3YegEZE3T1of3MHckGk=
MIME-Version: 1.0
In-Reply-To: <20110324151701.CC7F.A69D9226@jp.fujitsu.com>
References: <20110324143541.CC78.A69D9226@jp.fujitsu.com>
	<AANLkTik0AUXX2O9-=7dpF2-_CovqXtqenieZA9HRanEc@mail.gmail.com>
	<20110324151701.CC7F.A69D9226@jp.fujitsu.com>
Date: Thu, 24 Mar 2011 15:32:51 +0900
Message-ID: <AANLkTim_C+aKtFAt6XWd9KHHmsA7JBMFWxmScZKRjknk@mail.gmail.com>
Subject: Re: [PATCH 1/5] vmscan: remove all_unreclaimable check from direct
 reclaim path completely
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-mm <linux-mm@kvack.org>, Andrey Vagin <avagin@openvz.org>,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Nick Piggin <npiggin@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 3:16 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> Hi
>
>> Thanks for your effort, Kosaki.
>> But I still doubt this patch is good.
>>
>> This patch makes early oom killing in hibernation as it skip
>> all_unreclaimable check.
>> Normally,  hibernation needs many memory so page_reclaim pressure
>> would be big in small memory system. So I don't like early give up.
>
> Wait. When occur big pressure? hibernation reclaim pressure
> (sc->nr_to_recliam) depend on physical memory size. therefore
> a pressure seems to don't depend on the size.

It depends on physical memory size and /sys/power/image_size.
If you want to tune image size bigger, reclaim pressure would be big.

>
>
>> Do you think my patch has a problem? Personally, I think it's very
>> simple and clear. :)
>
> To be honest, I dislike following parts. It's madness on madness.
>
>        static bool zone_reclaimable(struct zone *zone)
>        {
>                if (zone->all_unreclaimable)
>                        return false;
>
>                return zone->pages_scanned < zone_reclaimable_pages(zone) * 6;
>        }
>
>
> The function require a reviewer know
>
>  o pages_scanned and all_unreclaimable are racy

Yes. That part should be written down of comment.

>  o at hibernation, zone->all_unreclaimable can be false negative,
>   but can't be false positive.

The comment of all_unreclaimable already does explain it well, I think.

>
> And, a function comment of all_unreclaimable() says
>
>         /*
>          * As hibernation is going on, kswapd is freezed so that it can't mark
>          * the zone into all_unreclaimable. It can't handle OOM during hibernation.
>          * So let's check zone's unreclaimable in direct reclaim as well as kswapd.
>          */
>
> But, now it is no longer copy of kswapd algorithm.

The comment don't say it should be a copy of kswapd.

>
> If you strongly prefer this idea even if you hear above explanation,
> please consider to add much and much comments. I can't say
> current your patch is enough readable/reviewable.

My patch isn't a formal patch for merge but just a concept to show.
If you agree the idea, of course, I will add more concrete comment
when I send formal patch.

Before, I would like to get a your agreement. :)
If you solve my concern(early give up in hibernation) in your patch, I
don't insist on my patch, either.

Thanks for the comment, Kosaki.

>
> Thanks.
>
>
>



-- 
Kind regards,
Minchan Kim
