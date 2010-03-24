Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab0CXAQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 20:16:11 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41519 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab0CXAQJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 20:16:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=C3eay8QLGtfi7nirKeLVDI6tBtXvYk0/VXsG1MYRx1Iz0/Sf/GEbYtjFWyEJdzYkVz
         Rm3EN3INlR9Lt3OFDVb9aAHR1tenpqLC+bDhczDmyMjNxFBTyu77XW54qjdPQ0LJcigA
         T9f1JDIOBXdu07Sa6FZZ5Kc1jOs9EHEaEDlQQ=
MIME-Version: 1.0
In-Reply-To: <20100324090312.4e1cc725.kamezawa.hiroyu@jp.fujitsu.com>
References: <1269347146-7461-1-git-send-email-mel@csn.ul.ie>
	 <1269347146-7461-6-git-send-email-mel@csn.ul.ie>
	 <20100324090312.4e1cc725.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 24 Mar 2010 09:16:07 +0900
Message-ID: <28c262361003231716k54ca1ae8u92793be7f2fdf374@mail.gmail.com>
Subject: Re: [PATCH 05/11] Export unusable free space index via 
	/proc/unusable_index
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Kame.

On Wed, Mar 24, 2010 at 9:03 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Tue, 23 Mar 2010 12:25:40 +0000
> Mel Gorman <mel@csn.ul.ie> wrote:
>
>> Unusable free space index is a measure of external fragmentation that
>> takes the allocation size into account. For the most part, the huge page
>> size will be the size of interest but not necessarily so it is exported
>> on a per-order and per-zone basis via /proc/unusable_index.
>>
>> The index is a value between 0 and 1. It can be expressed as a
>> percentage by multiplying by 100 as documented in
>> Documentation/filesystems/proc.txt.
>>
>> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
>> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
>> Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> Acked-by: Rik van Riel <riel@redhat.com>
>> ---
>>  Documentation/filesystems/proc.txt |   13 ++++-
>>  mm/vmstat.c                        |  120 +++++++++++++++++++++++++++++++++
>>  2 files changed, 132 insertions(+), 1 deletions(-)
>>
>> diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
>> index 5e132b5..5c4b0fb 100644
>> --- a/Documentation/filesystems/proc.txt
>> +++ b/Documentation/filesystems/proc.txt
>> @@ -452,6 +452,7 @@ Table 1-5: Kernel info in /proc
>>   sys         See chapter 2
>>   sysvipc     Info of SysVIPC Resources (msg, sem, shm)               (2.4)
>>   tty      Info of tty drivers
>> + unusable_index Additional page allocator information (see text)(2.5)
>>   uptime      System uptime
>>   version     Kernel version
>>   video            bttv info of video resources                       (2.4)
>> @@ -609,7 +610,7 @@ ZONE_DMA, 4 chunks of 2^1*PAGE_SIZE in ZONE_DMA, 101 chunks of 2^4*PAGE_SIZE
>>  available in ZONE_NORMAL, etc...
>>
>>  More information relevant to external fragmentation can be found in
>> -pagetypeinfo.
>> +pagetypeinfo and unusable_index
>>
>>  > cat /proc/pagetypeinfo
>>  Page block order: 9
>> @@ -650,6 +651,16 @@ unless memory has been mlock()'d. Some of the Reclaimable blocks should
>>  also be allocatable although a lot of filesystem metadata may have to be
>>  reclaimed to achieve this.
>>
>> +> cat /proc/unusable_index
>> +Node 0, zone      DMA 0.000 0.000 0.000 0.001 0.005 0.013 0.021 0.037 0.037 0.101 0.230
>> +Node 0, zone   Normal 0.000 0.000 0.000 0.001 0.002 0.002 0.005 0.015 0.028 0.028 0.054
>> +
>> +The unusable free space index measures how much of the available free
>> +memory cannot be used to satisfy an allocation of a given size and is a
>> +value between 0 and 1. The higher the value, the more of free memory is
>> +unusable and by implication, the worse the external fragmentation is. This
>> +can be expressed as a percentage by multiplying by 100.
>> +
>>  ..............................................................................
>>
>>  meminfo:
>> diff --git a/mm/vmstat.c b/mm/vmstat.c
>> index 7f760cb..ca42e10 100644
>> --- a/mm/vmstat.c
>> +++ b/mm/vmstat.c
>> @@ -453,6 +453,106 @@ static int frag_show(struct seq_file *m, void *arg)
>>       return 0;
>>  }
>>
>> +
>> +struct contig_page_info {
>> +     unsigned long free_pages;
>> +     unsigned long free_blocks_total;
>> +     unsigned long free_blocks_suitable;
>> +};
>> +
>> +/*
>> + * Calculate the number of free pages in a zone, how many contiguous
>> + * pages are free and how many are large enough to satisfy an allocation of
>> + * the target size. Note that this function makes to attempt to estimate
>> + * how many suitable free blocks there *might* be if MOVABLE pages were
>> + * migrated. Calculating that is possible, but expensive and can be
>> + * figured out from userspace
>> + */
>> +static void fill_contig_page_info(struct zone *zone,
>> +                             unsigned int suitable_order,
>> +                             struct contig_page_info *info)
>> +{
>> +     unsigned int order;
>> +
>> +     info->free_pages = 0;
>> +     info->free_blocks_total = 0;
>> +     info->free_blocks_suitable = 0;
>> +
>> +     for (order = 0; order < MAX_ORDER; order++) {
>> +             unsigned long blocks;
>> +
>> +             /* Count number of free blocks */
>> +             blocks = zone->free_area[order].nr_free;
>> +             info->free_blocks_total += blocks;
>
> ....for what this free_blocks_total is ?

It's used by fragmentation_index in [06/11].

>
> Thanks,
> -Kame
>
>



-- 
Kind regards,
Minchan Kim
