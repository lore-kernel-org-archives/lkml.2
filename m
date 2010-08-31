Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100Ab0HaDrn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 23:47:43 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42657 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073Ab0HaDrm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 23:47:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pK256yqbhzB+bHUpIoMosRTJ1ilGtIaUJrTvhV0MAxaFbbQ6sGqjpkGvk2KAbhQm26
         bkhfElJS73kfRhxqZfoYWCljxAxZ3yw/eza3PygFZ1ruXnjCJZZkmvN1jV+0v63ytoJX
         +AQPAQd0YKpA3GMLQ8hbatsyPhD45MgZ5uq2s=
MIME-Version: 1.0
In-Reply-To: <20100831110815.87D9.A69D9226@jp.fujitsu.com>
References: <20100831102557.87D3.A69D9226@jp.fujitsu.com>
	<AANLkTinhVnMW8f7+jQdDyEzD=O2YPLSyTuGRE2JnRVzm@mail.gmail.com>
	<20100831110815.87D9.A69D9226@jp.fujitsu.com>
Date: Tue, 31 Aug 2010 12:47:41 +0900
Message-ID: <AANLkTi=FA=m_OqfY6LaX2dXfiHWoa9-70B=uKiuXYg4y@mail.gmail.com>
Subject: Re: [PATCH] vmscan: prevent background aging of anon page in no swap system
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ying Han <yinghan@google.com>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 11:09 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> How about this?
>>
>> (Not formal patch. If we agree, I will post it later when I have a SMTP).
>>
>>
>> Signed-off-by: Ying Han <yinghan@google.com>
>> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 3109ff7..c3c44a8 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -1579,7 +1579,7 @@ static void shrink_active_list(unsigned long
>> nr_pages, struct zone *zone,
>>         __mod_zone_page_state(zone, NR_ISOLATED_ANON + file, -nr_taken);
>>         spin_unlock_irq(&zone->lru_lock);
>>  }
>> -
>> +#if CONFIG_SWAP
>>  static int inactive_anon_is_low_global(struct zone *zone)
>>  {
>>         unsigned long active, inactive;
>> @@ -1605,12 +1605,21 @@ static int inactive_anon_is_low(struct zone
>> *zone, struct scan_control *sc)
>>  {
>>         int low;
>>
>> +       if (nr_swap_pages)
>> +               return 0;
>
> !nr_swap_pages ?

Yes. :)

>
>
>
>> +
>>         if (scanning_global_lru(sc))
>>                 low = inactive_anon_is_low_global(zone);
>>         else
>>                 low = mem_cgroup_inactive_anon_is_low(sc->mem_cgroup);
>>         return low;
>>  }
>> +#else
>> +static inline int inactive_anon_is_low(struct zone *zone, struct
>> scan_control *sc)
>> +{
>> +       return 0;
>> +}
>> +#endif
>
> Yup. I prefer this explicit #ifdef :)
>

Thanks.

-- 
Kind regards,
Minchan Kim
