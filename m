Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab2D0HpZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 03:45:25 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:42084 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756081Ab2D0HpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 03:45:23 -0400
Message-ID: <4F9A4E8E.4040700@openvz.org>
Date: Fri, 27 Apr 2012 11:45:18 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Firefox/10.0.2 Iceape/2.7.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH next 00/12] mm: replace struct mem_cgroup_zone with struct
 lruvec
References: <20120426074632.18961.17803.stgit@zurg> <20120426162546.90991b7c.akpm@linux-foundation.org>
In-Reply-To: <20120426162546.90991b7c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 26 Apr 2012 11:53:44 +0400
> Konstantin Khlebnikov<khlebnikov@openvz.org>  wrote:
>
>> This patchset depends on Johannes Weiner's patch
>> "mm: memcg: count pte references from every member of the reclaimed hierarchy".
>>
>> bloat-o-meter delta for patches 2..12
>>
>> add/remove: 6/6 grow/shrink: 6/14 up/down: 4414/-4625 (-211)
>
> That's the sole effect and intent of the patchset?  To save 211 bytes?

This is almost last bunch of cleanups for lru_lock splitting,
code reducing is only nice side-effect.
Also this patchset removes many redundant lruvec relookups.

Now mostly all page-to-lruvec translations are located at the same level
as zone->lru_lock locking. So lru-lock splitting patchset can something like this:

-zone = page_zone(page)
-spin_lock_irq(&zone->lru_lock)
-lruvec = mem_cgroup_page_lruvec(page)
+lruvec = lock_page_lruvec_irq(page)

>
>> ...
>>
>>   include/linux/memcontrol.h |   16 +--
>>   include/linux/mmzone.h     |   14 ++
>>   mm/memcontrol.c            |   33 +++--
>>   mm/mmzone.c                |   14 ++
>>   mm/page_alloc.c            |    8 -
>>   mm/vmscan.c                |  277 ++++++++++++++++++++------------------------
>>   6 files changed, 177 insertions(+), 185 deletions(-)
>
> If so, I'm not sure that it is worth the risk and effort?

After lumpy-reclaim removal there a lot of dead or redundant code, maybe someone else
wants to cleanup this code, I specifically sent this set early to avoid conflicts.

>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email:<a href=mailto:"dont@kvack.org">  email@kvack.org</a>

