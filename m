Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808Ab1ECAaC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 20:30:02 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:58678 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010Ab1ECAaA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 20:30:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xr0zRCaP0iharxQL8CpHqTa83XB3EfkcJDUjwvaYxwYhx3nE8p5A7SfPlUvG+uLOyY
         89Q3OMuA300gULJngFOjm918VLz1AiPrvVAFeTJFc5mNe9hCgfHioMQoqIdN6cRjKBCl
         c/T2S0bEFmSkg74RuKJnlnGtNl3eTK7uOcisQ=
MIME-Version: 1.0
In-Reply-To: <20110502193820.2D60.A69D9226@jp.fujitsu.com>
References: <cover.1304261567.git.minchan.kim@gmail.com>
	<dc54a5771cf1f580a91d16816100d4a2bcf2cdf5.1304261567.git.minchan.kim@gmail.com>
	<20110502193820.2D60.A69D9226@jp.fujitsu.com>
Date: Tue, 3 May 2011 09:29:59 +0900
Message-ID: <BANLkTika5G_7Z8t-ED4RcYfKoYpLnZsjSg@mail.gmail.com>
Subject: Re: [PATCH 2/2] Filter unevictable page out in deactivate_page
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Ying Han <yinghan@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi KOSAKI,

On Mon, May 2, 2011 at 7:37 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> It's pointless that deactive_page's pagevec operation about
>> unevictable page as it's nop.
>> This patch removes unnecessary overhead which might be a bit problem
>> in case that there are many unevictable page in system(ex, mprotect workload)
>>
>> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>> ---
>>  mm/swap.c |    9 +++++++++
>>  1 files changed, 9 insertions(+), 0 deletions(-)
>>
>> diff --git a/mm/swap.c b/mm/swap.c
>> index 2e9656d..b707694 100644
>> --- a/mm/swap.c
>> +++ b/mm/swap.c
>> @@ -511,6 +511,15 @@ static void drain_cpu_pagevecs(int cpu)
>>   */
>>  void deactivate_page(struct page *page)
>>  {
>> +
>> +     /*
>> +      * In workload which system has many unevictable page(ex, mprotect),
>> +      * unevictalge page deactivation for accelerating reclaim
>> +      * is pointless.
>> +      */
>> +     if (PageUnevictable(page))
>> +             return;
>> +
>
>        Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>

Thanks!

>
> btw, I think we should check PageLRU too.
>

Yes. I remember you advised it when we push this patch but I didn't.
That's because I think most of pages in such context would be LRU as
they are cached pages.
So IMO, PageLRU checking in deactivate_page couldn't help much.


-- 
Kind regards,
Minchan Kim
