Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135Ab2AJIxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 03:53:42 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:55774 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754069Ab2AJIxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 03:53:40 -0500
Message-ID: <4F0BFC8C.7000806@tao.ma>
Date: Tue, 10 Jan 2012 16:53:32 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <jweiner@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] mm,mlock: drain pagevecs asynchronously
References: <CAHGf_=qA3Pnb00n_smhJVKDDCDDr0d-a3E03Rrhnb-S4xK8_fQ@mail.gmail.com> <1325403025-22688-1-git-send-email-kosaki.motohiro@gmail.com> <20120104011715.GA18399@barrios-laptop.redhat.com> <4F03BBA1.7090606@gmail.com>
In-Reply-To: <4F03BBA1.7090606@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 182.92.247.2 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi KOSAKI,
On 01/04/2012 10:38 AM, KOSAKI Motohiro wrote:
> 
>>> @@ -704,10 +747,23 @@ static void ____pagevec_lru_add_fn(struct page
>>> *page, void *arg)
>>>       VM_BUG_ON(PageLRU(page));
>>>
>>>       SetPageLRU(page);
>>> -    if (active)
>>> -        SetPageActive(page);
>>> -    update_page_reclaim_stat(zone, page, file, active);
>>> -    add_page_to_lru_list(zone, page, lru);
>>> + redo:
>>> +    if (page_evictable(page, NULL)) {
>>> +        if (active)
>>> +            SetPageActive(page);
>>> +        update_page_reclaim_stat(zone, page, file, active);
>>> +        add_page_to_lru_list(zone, page, lru);
>>> +    } else {
>>> +        SetPageUnevictable(page);
>>> +        add_page_to_lru_list(zone, page, LRU_UNEVICTABLE);
>>> +        smp_mb();
>>
>> Why do we need barrier in here? Please comment it.
> 
> To cut-n-paste a comment from putback_lru_page() is good idea? :)
> 
> +               /*
> +                * When racing with an mlock clearing (page is
> +                * unlocked), make sure that if the other thread does
> +                * not observe our setting of PG_lru and fails
> +                * isolation, we see PG_mlocked cleared below and move
> +                * the page back to the evictable list.
> +                *
> +                * The other side is TestClearPageMlocked().
> +                */
> +               smp_mb();
> 
> 
> 
>>> +        if (page_evictable(page, NULL)) {
>>> +            del_page_from_lru_list(zone, page, LRU_UNEVICTABLE);
>>> +            ClearPageUnevictable(page);
>>> +            goto redo;
>>> +        }
>>> +    }
>>
>> I am not sure it's a good idea.
>> mlock is very rare event but ____pagevec_lru_add_fn is called frequently.
>> We are adding more overhead in ____pagevec_lru_add_fn.
>> Is it valuable?
> 
> dunno.
> 
> Personally, I think tao's case is too artificial and I haven't observed
> any real world application do such crazy mlock/munlock repeatness. But
> he said he has a such application.
ok, I will talk more about our application here.
So it is backend of a php. And for every user request, we will have to
call libmcrypt(http://sourceforge.net/projects/mcrypt/) several times to
encrypt some information, and libmcrypt  will use mlock/munlock. As a
server can finish many requests in one second, so the total
mlock/munlock counts will sum up to around 2000 and it really means some
for us.
> 
> If my remember is correct, ltp or some test suite depend on current
> meminfo synching behavior. then I'm afraid simple removing bring us
> new annoying bug report.
So this is the only side effect for removing the lru_add_drain_all from
mlock/mlockall right? Is there any other know issues?

I have read Andrew's comment, and if we have decided to remove all these
lru_* stuff, it seems that we have a long way to go before this issue
can be completed resolved. So I will remove it from our production
kernel first and wait for your final cleanup. Great thanks for your time
and kindly help.

Thanks
Tao
