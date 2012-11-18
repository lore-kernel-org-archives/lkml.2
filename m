Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab2KRUgN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 15:36:13 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:41179 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab2KRUgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 15:36:11 -0500
Message-ID: <50A946BC.7010308@googlemail.com>
Date: Sun, 18 Nov 2012 20:36:12 +0000
From: Chris Clayton <chris2553@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121030 Thunderbird/16.0.2
MIME-Version: 1.0
To: Jiang Liu <liuj97@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Wen Congyang <wency@cn.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFT PATCH v1 0/5] fix up inaccurate zone->present_pages
References: <20121115112454.e582a033.akpm@linux-foundation.org> <1353254850-27336-1-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <1353254850-27336-1-git-send-email-jiang.liu@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gerry.

On 11/18/12 16:07, Jiang Liu wrote:
> The commit 7f1290f2f2a4 ("mm: fix-up zone present pages") tries to
> resolve an issue caused by inaccurate zone->present_pages, but that
> fix is incomplete and causes regresions with HIGHMEM. And it has been
> reverted by commit
> 5576646 revert "mm: fix-up zone present pages"
>
> This is a following-up patchset for the issue above. It introduces a
> new field named "managed_pages" to struct zone, which counts pages
> managed by the buddy system from the zone. And zone->present_pages
> is used to count pages existing in the zone, which is
> 	spanned_pages - absent_pages.
>
> But that way, zone->present_pages will be kept in consistence with
> pgdat->node_present_pages, which is sum of zone->present_pages.
>
> This patchset has only been tested on x86_64 with nobootmem.c. So need
> help to test this patchset on machines:
> 1) use bootmem.c
> 2) have highmem
>
> This patchset applies to "f4a75d2e Linux 3.7-rc6" from
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>

I've applied the five patches to Linus' 3.7.0-rc6 and can confirm that 
the kernel allows my system to resume from a suspend to disc. Although 
my laptop is 64 bit, I run a 32 bit kernel with HIGHMEM (I have 8GB RAM):

[chris:~/kernel/tmp/linux-3.7-rc6-resume]$ grep -E HIGHMEM\|X86_32 .config
CONFIG_X86_32=y
CONFIG_X86_32_SMP=y
CONFIG_X86_32_LAZY_GS=y
# CONFIG_X86_32_IRIS is not set
# CONFIG_NOHIGHMEM is not set
# CONFIG_HIGHMEM4G is not set
CONFIG_HIGHMEM64G=y
CONFIG_HIGHMEM=y

I can also say that a quick browse of the output of dmesg, shows nothing 
out of the ordinary. I have insufficient knowledge to comment on the 
patches, but I will run the kernel over the next few days and report 
back later in the week.

Chris

> Any comments and helps are welcomed!
>
> Jiang Liu (5):
>    mm: introduce new field "managed_pages" to struct zone
>    mm: replace zone->present_pages with zone->managed_pages if
>      appreciated
>    mm: set zone->present_pages to number of existing pages in the zone
>    mm: provide more accurate estimation of pages occupied by memmap
>    mm: increase totalram_pages when free pages allocated by bootmem
>      allocator
>
>   include/linux/mmzone.h |    1 +
>   mm/bootmem.c           |   14 ++++++++
>   mm/memory_hotplug.c    |    6 ++++
>   mm/mempolicy.c         |    2 +-
>   mm/nobootmem.c         |   15 ++++++++
>   mm/page_alloc.c        |   89 +++++++++++++++++++++++++++++++-----------------
>   mm/vmscan.c            |   16 ++++-----
>   mm/vmstat.c            |    8 +++--
>   8 files changed, 108 insertions(+), 43 deletions(-)
>
