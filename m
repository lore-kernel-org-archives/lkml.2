Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474Ab1D2PSF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 11:18:05 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:53432 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab1D2PSD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 11:18:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vRw9rHlMD3PThJr2aBu5TlRpn1uiu3Oj0FYntYWzQ1DLTjP/2vo1OVG86roXETss4l
         bvQC3cqsJLkJE/6amSjmR6cT67HBrCXUXC4+z1bF2LUd7A1Ofyfn2KNvka8q5ElAEvZm
         0uAQWX6Gl3nfBbyia0udqH8rwxlU6cVOd29MQ=
MIME-Version: 1.0
In-Reply-To: <20110428103505.GS4658@suse.de>
References: <cover.1303833415.git.minchan.kim@gmail.com>
	<232562452317897b5acb1445803410d74233a923.1303833417.git.minchan.kim@gmail.com>
	<20110428103505.GS4658@suse.de>
Date: Sat, 30 Apr 2011 00:18:02 +0900
Message-ID: <BANLkTi=kLjZRp+kxrhG8Q-bEFw7x-O6vgg@mail.gmail.com>
Subject: Re: [RFC 3/8] vmscan: make isolate_lru_page with filter aware
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 7:35 PM, Mel Gorman <mgorman@suse.de> wrote:
> On Wed, Apr 27, 2011 at 01:25:20AM +0900, Minchan Kim wrote:
>> In some __zone_reclaim case, we don't want to shrink mapped page.
>> Nonetheless, we have isolated mapped page and re-add it into
>> LRU's head. It's unnecessary CPU overhead and makes LRU churning.
>>
>> Of course, when we isolate the page, the page might be mapped but
>> when we try to migrate the page, the page would be not mapped.
>> So it could be migrated. But race is rare and although it happens,
>> it's no big deal.
>>
>> Cc: Christoph Lameter <cl@linux.com>
>> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> Cc: Mel Gorman <mgorman@suse.de>
>> Cc: Rik van Riel <riel@redhat.com>
>> Cc: Andrea Arcangeli <aarcange@redhat.com>
>> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>
>> index 71d2da9..e8d6190 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -1147,7 +1147,8 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
>>
>>  static unsigned long isolate_pages_global(unsigned long nr,
>>                                       struct list_head *dst,
>> -                                     unsigned long *scanned, int order,
>> +                                     unsigned long *scanned,
>> +                                     struct scan_control *sc,
>>                                       int mode, struct zone *z,
>>                                       int active, int file)
>>  {
>> @@ -1156,8 +1157,8 @@ static unsigned long isolate_pages_global(unsigned long nr,
>>               lru += LRU_ACTIVE;
>>       if (file)
>>               lru += LRU_FILE;
>> -     return isolate_lru_pages(nr, &z->lru[lru].list, dst, scanned, order,
>> -                                     mode, file, 0, 0);
>> +     return isolate_lru_pages(nr, &z->lru[lru].list, dst, scanned, sc->order,
>> +                                     mode, file, 0, !sc->may_unmap);
>>  }
>>
>
> Why not take may_writepage into account for dirty pages?

I missed it.
I will consider it in next version.
Thanks, Mel.


-- 
Kind regards,
Minchan Kim
