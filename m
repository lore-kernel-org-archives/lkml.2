Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751056Ab0GMELV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 00:11:21 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:65418 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab0GMELU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 00:11:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=l9DISiki/HeripkdVQM4sOd8mzj0W+uOnySsuOX9D2Nhg3Bcydx0csMwqLLjqogPZk
         WD/Kng8mEzcvdkkFDcAD55ZxioRcsXJpEn5XB4vIkcJKzisBENpUmmxoyT6f3dAbPHqC
         DQrTMVRMs+GR+c6YW/t0+btX3yYfH1elnpDcY=
MIME-Version: 1.0
In-Reply-To: <20100713121947.612bd656.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100712155348.GA2815@barrios-desktop>
	<20100713121947.612bd656.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 13 Jul 2010 13:11:14 +0900
Message-ID: <AANLkTiny7dz8ssDknI7y4JFcVP9SV1aNM7f0YMUxafv7@mail.gmail.com>
Subject: Re: [RFC] Tight check of pfn_valid on sparsemem
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux@arm.linux.org.uk, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shaohua Li <shaohua.li@intel.com>, Yakui Zhao <yakui.zhao@intel.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        Mel Gorman <mel@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 12:19 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Tue, 13 Jul 2010 00:53:48 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
>
>> Kukjin, Could you test below patch?
>> I don't have any sparsemem system. Sorry.
>>
>> -- CUT DOWN HERE --
>>
>> Kukjin reported oops happen while he change min_free_kbytes
>> http://www.spinics.net/lists/arm-kernel/msg92894.html
>> It happen by memory map on sparsemem.
>>
>> The system has a memory map following as.
>>      section 0             section 1              section 2
>> 0x20000000-0x25000000, 0x40000000-0x50000000, 0x50000000-0x58000000
>> SECTION_SIZE_BITS 28(256M)
>>
>> It means section 0 is an incompletely filled section.
>> Nontheless, current pfn_valid of sparsemem checks pfn loosely.
>>
>> It checks only mem_section's validation.
>> So in above case, pfn on 0x25000000 can pass pfn_valid's validation check.
>> It's not what we want.
>>
>> The Following patch adds check valid pfn range check on pfn_valid of sparsemem.
>>
>> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>> Reported-by: Kukjin Kim <kgene.kim@samsung.com>
>>
>> P.S)
>> It is just RFC. If we agree with this, I will make the patch on mmotm.
>>
>> --
>>
>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>> index b4d109e..6c2147a 100644
>> --- a/include/linux/mmzone.h
>> +++ b/include/linux/mmzone.h
>> @@ -979,6 +979,8 @@ struct mem_section {
>>         struct page_cgroup *page_cgroup;
>>         unsigned long pad;
>>  #endif
>> +       unsigned long start_pfn;
>> +       unsigned long end_pfn;
>>  };
>>
>
> I have 2 concerns.
>  1. This makes mem_section twice. Wasting too much memory and not good for cache.
>    But yes, you can put this under some CONFIG which has small number of mem_section[].
>

I think memory usage isn't a big deal. but for cache, we can move
fields into just after section_mem_map.

>  2. This can't be help for a case where a section has multiple small holes.

I agree. But this(not punched hole but not filled section problem)
isn't such case. But it would be better to handle it altogether. :)

>
> Then, my proposal for HOLES_IN_MEMMAP sparsemem is below.
> ==
> Some architectures unmap memmap[] for memory holes even with SPARSEMEM.
> To handle that, pfn_valid() should check there are really memmap or not.
> For that purpose, __get_user() can be used.

Look at free_unused_memmap. We don't unmap pte of hole memmap.
Is __get_use effective, still?




-- 
Kind regards,
Minchan Kim
