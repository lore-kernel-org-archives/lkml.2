Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab2ADCi2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 21:38:28 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41907 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab2ADCiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 21:38:25 -0500
Message-ID: <4F03BBA1.7090606@gmail.com>
Date: Tue, 03 Jan 2012 21:38:25 -0500
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <jweiner@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] mm,mlock: drain pagevecs asynchronously
References: <CAHGf_=qA3Pnb00n_smhJVKDDCDDr0d-a3E03Rrhnb-S4xK8_fQ@mail.gmail.com> <1325403025-22688-1-git-send-email-kosaki.motohiro@gmail.com> <20120104011715.GA18399@barrios-laptop.redhat.com>
In-Reply-To: <20120104011715.GA18399@barrios-laptop.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> @@ -704,10 +747,23 @@ static void ____pagevec_lru_add_fn(struct page *page, void *arg)
>>   	VM_BUG_ON(PageLRU(page));
>>
>>   	SetPageLRU(page);
>> -	if (active)
>> -		SetPageActive(page);
>> -	update_page_reclaim_stat(zone, page, file, active);
>> -	add_page_to_lru_list(zone, page, lru);
>> + redo:
>> +	if (page_evictable(page, NULL)) {
>> +		if (active)
>> +			SetPageActive(page);
>> +		update_page_reclaim_stat(zone, page, file, active);
>> +		add_page_to_lru_list(zone, page, lru);
>> +	} else {
>> +		SetPageUnevictable(page);
>> +		add_page_to_lru_list(zone, page, LRU_UNEVICTABLE);
>> +		smp_mb();
>
> Why do we need barrier in here? Please comment it.

To cut-n-paste a comment from putback_lru_page() is good idea? :)

+               /*
+                * When racing with an mlock clearing (page is
+                * unlocked), make sure that if the other thread does
+                * not observe our setting of PG_lru and fails
+                * isolation, we see PG_mlocked cleared below and move
+                * the page back to the evictable list.
+                *
+                * The other side is TestClearPageMlocked().
+                */
+               smp_mb();



>> +		if (page_evictable(page, NULL)) {
>> +			del_page_from_lru_list(zone, page, LRU_UNEVICTABLE);
>> +			ClearPageUnevictable(page);
>> +			goto redo;
>> +		}
>> +	}
>
> I am not sure it's a good idea.
> mlock is very rare event but ____pagevec_lru_add_fn is called frequently.
> We are adding more overhead in ____pagevec_lru_add_fn.
> Is it valuable?

dunno.

Personally, I think tao's case is too artificial and I haven't observed
any real world application do such crazy mlock/munlock repeatness. But
he said he has a such application.

If my remember is correct, ltp or some test suite depend on current 
meminfo synching behavior. then I'm afraid simple removing bring us
new annoying bug report.

