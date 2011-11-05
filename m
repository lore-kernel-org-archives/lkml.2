Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab1KEBwT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 21:52:19 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59544 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab1KEBwS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 21:52:18 -0400
MIME-Version: 1.0
In-Reply-To: <201111042329.45405.rjw@sisk.pl>
References: <1320392176-3906-1-git-send-email-Barry.Song@csr.com> <201111042329.45405.rjw@sisk.pl>
From: Barry Song <21cnbao@gmail.com>
Date: Sat, 5 Nov 2011 09:51:56 +0800
Message-ID: <CAGsJ_4yx4+nxBC1P0i6QEPce60EKRouy-AhLKhPyik1T+0MtJA@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH] PM: HIBERNATION: skip the swap size check if
 the snapshot image size is anticipative
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Barry Song <Barry.Song@csr.com>, Xiangzhen Ye <Xiangzhen.Ye@csr.com>,
        linux-kernel@vger.kernel.org, Barry Song <Baohua.Song@csr.com>,
        linux-pm@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/5 Rafael J. Wysocki <rjw@sisk.pl>:
> On Friday, November 04, 2011, Barry Song wrote:
>> From: Barry Song <Baohua.Song@csr.com>
>>
>> Current swsusp requires swap partitions even larger than real saved pages
>> due to the worst compress ratio:
>> but for an embedded system, which has limited storage space, then it might
>> can't give the big size partition to save snapshot.
>> In the another way, some embedded systems can definitely know the most size
>> needed for snapshot since they run some specific application lists.
>> So this patch provides the possibility for bootloader to tell kernel even
>> the system has a little snapshot partition, but it is still enough.
>> For example, if the system need to save 120MB memory, origin swsusp will require
>> a 130MB partition to save snapshot. but if users know 30MB is enough for them(
>> compressed image will be less than 30MB), they just make a 30MB partition.
>>
>> Signed-off-by: Barry Song <Baohua.Song@csr.com>
>> Cc: Xiangzhen Ye <Xiangzhen.Ye@csr.com>
>
> I'm considering this as 3.3 material, so I'll take care of it after the current
> merge window closes.
>

ok. thanks. the idea is making swsusp support embedded systems with
limited resources better.
we can get into details after the current merge window.

> Thanks,
> Rafael
>
>
>> ---
>>  this is another patch after I provide resumewait/resumedelay kernel params
>>  to make swsusp support embedded systems better.
>>  This patch is tested on CSR SiRFprimaII platform.
>>
>>  Documentation/kernel-parameters.txt |    7 +++++++
>>  kernel/power/swap.c                 |   13 +++++++++++++
>>  2 files changed, 20 insertions(+), 0 deletions(-)
>>
>> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>> index a0c5c5f..2ad2e9c 100644
>> --- a/Documentation/kernel-parameters.txt
>> +++ b/Documentation/kernel-parameters.txt
>> @@ -2277,6 +2277,13 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>>                       in <PAGE_SIZE> units (needed only for swap files).
>>                       See  Documentation/power/swsusp-and-swap-files.txt
>>
>> +     swapenough      [SWSUSP]
>> +                     Tell kernel the swap partition size is enough and let kernel
>> +                     skip checking whether the swap partition has enough size to
>> +                     save snapshot.
>> +                     It is used for embedded systems, typically using NAND and SD
>> +                     card, which have not large space.
>> +
>>       resumedelay=    [HIBERNATION] Delay (in seconds) to pause before attempting to
>>                       read the resume files
>>
>> diff --git a/kernel/power/swap.c b/kernel/power/swap.c
>> index 11a594c..97c30b5 100644
>> --- a/kernel/power/swap.c
>> +++ b/kernel/power/swap.c
>> @@ -36,6 +36,8 @@
>>
>>  #define HIBERNATE_SIG        "S1SUSPEND"
>>
>> +static int swapenough;
>> +
>>  /*
>>   *   The swap map is a data structure used for keeping track of each page
>>   *   written to a swap partition.  It consists of many swap_map_page
>> @@ -772,6 +774,9 @@ static int enough_swap(unsigned int nr_pages, unsigned int flags)
>>       unsigned int free_swap = count_swap_pages(root_swap, 1);
>>       unsigned int required;
>>
>> +     if (swapenough)
>> +             return 1;
>> +
>>       pr_debug("PM: Free swap pages: %u\n", free_swap);
>>
>>       required = PAGES_FOR_IO + ((flags & SF_NOCOMPRESS_MODE) ?
>> @@ -1449,3 +1454,11 @@ static int swsusp_header_init(void)
>>  }
>>
>>  core_initcall(swsusp_header_init);
>> +
>> +static int __init swapenough_setup(char *str)
>> +{
>> +     swapenough = 1;
>> +     return 1;
>> +}
>> +
>> +__setup("swapenough", swapenough_setup);
>>
-barry
