Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933455Ab2AIXJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 18:09:35 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39910 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755858Ab2AIXJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 18:09:33 -0500
Message-ID: <4F0B73AC.7000504@gmail.com>
Date: Mon, 09 Jan 2012 18:09:32 -0500
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>,
        Shaohua Li <shaohua.li@intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michel Lespinasse <walken@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 2/2] SHM_UNLOCK: fix Unevictable pages stranded after
 swap
References: <alpine.LSU.2.00.1201061303320.12082@eggly.anvils> <alpine.LSU.2.00.1201061310340.12082@eggly.anvils> <4F0B5146.6090200@gmail.com> <alpine.LSU.2.00.1201091342300.1272@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1201091342300.1272@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(1/9/12 5:25 PM), Hugh Dickins wrote:
> On Mon, 9 Jan 2012, KOSAKI Motohiro wrote:
>> 2012/1/6 Hugh Dickins<hughd@google.com>:
>
> [ check_move_unevictable_page(s) ]
>
>>>
>>> Leave out the "rotate unevictable list" block: that's a leftover
>>> from when this was used for /proc/sys/vm/scan_unevictable_pages,
>>> whose flawed handling involved looking at pages at tail of LRU.
>>>
>>> Was there significance to the sequence first ClearPageUnevictable,
>>> then test page_evictable, then SetPageUnevictable here?  I think
>>> not, we're under LRU lock, and have no barriers between those.
>>
>> If I understand correctly, this is not exactly correct. Because of,
>
> Thank you for giving it serious thought:
> such races are hard work to think about.
>
>> PG_mlocked operation is not protected by LRU lock. So, I think we
>
> Right.  But I don't see that I've made a significant change there.
>
> I may be being lazy, and rushing back to answer you, without giving
> constructive thought to what the precise race is that you see, and
> how we might fix it.  If the case you have in mind is easy for you
> to describe in detail, please do so; but don't hesitate to tell me
> to my own work for myself!

Bah! I was moron. I now think your code is right.

spin_lock(lru_lock)
if (page_evictable(page))
	blah blah blah
spin_unlock(lru_lock)

is always safe. Counter part should have following code and
waiting spin_lock(lru_lock) in isolate_lru_page().

                 if (!isolate_lru_page(page))
                         putback_lru_page(page);

then, even if check_move_unevictable_pages() observed wrong page status,
putback_lru_page() should put back the page into right lru.

I'm very sorry for annoying you.

	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



Probably, page_evictable() might be needed some additional comments. But
I have no idea what comment clearly explain this complex rule.....
  
