Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760026Ab2BNLkB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 06:40:01 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:49518 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754275Ab2BNLj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 06:39:59 -0500
X-Authenticated: #9962044
X-Provags-ID: V01U2FsdGVkX197ViFNEKV7Jh51CKZ/w691y2Mvq/wLGHfWN/yQg0
	Bt/9av8IhbuUrg
Message-ID: <4F3A480C.9090407@gmx.de>
Date: Tue, 14 Feb 2012 12:39:56 +0100
From: Marc Dietrich <marvin24@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Marc Dietrich <marvin24@gmx.de>
CC: Seth Jennings <sjenning@linux.vnet.ibm.com>, Greg KH <greg@kroah.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH] staging: fix powerpc linux-next break on zsmalloc
References: <1329144469-8575-1-git-send-email-sjenning@linux.vnet.ibm.com> <4F3A43EC.2030209@gmx.de>
In-Reply-To: <4F3A43EC.2030209@gmx.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 14.02.2012 12:22, schrieb Marc Dietrich:
> Am 13.02.2012 15:47, schrieb Seth Jennings:
>> linux/vmalloc.h added to zsmalloc-main.c to resolve implicit
>> declaration errors.
>>
>> X86 dependency added to zsmalloc and dependent drivers zcache and zram.
>>
>> This X86 only requirement is not ideal.  Working to find portable
>> functions for __flush_tlb_one and set_pte.
>
> sorry, zcache/zram works fine one ARM here. Why not depend on !POWERPC?

ups, sorry again, I tested an older version only. flush_tlb_one and 
set_pte is only used with the new allocator as it seems.

> Marc
>
>> Signed-off-by: Seth Jennings<sjenning@linux.vnet.ibm.com>
>> ---
>>    drivers/staging/zcache/Kconfig           |    4 +++-
>>    drivers/staging/zram/Kconfig             |    4 +++-
>>    drivers/staging/zsmalloc/Kconfig         |    5 ++++-
>>    drivers/staging/zsmalloc/zsmalloc-main.c |    1 +
>>    4 files changed, 11 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/staging/zcache/Kconfig b/drivers/staging/zcache/Kconfig
>> index 94e48aa..5a36fcf 100644
>> --- a/drivers/staging/zcache/Kconfig
>> +++ b/drivers/staging/zcache/Kconfig
>> @@ -1,6 +1,8 @@
>>    config ZCACHE
>>    	tristate "Dynamic compression of swap pages and clean pagecache pages"
>> -	depends on (CLEANCACHE || FRONTSWAP)&&   CRYPTO
>> +	# X86 dependency is because zsmalloc uses non-portable pte/tlb
>> +	# functions
>> +	depends on (CLEANCACHE || FRONTSWAP)&&   CRYPTO&&   X86
>>    	select ZSMALLOC
>>    	select CRYPTO_LZO
>>    	default n
>> diff --git a/drivers/staging/zram/Kconfig b/drivers/staging/zram/Kconfig
>> index ee23a86..9d11a4c 100644
>> --- a/drivers/staging/zram/Kconfig
>> +++ b/drivers/staging/zram/Kconfig
>> @@ -1,6 +1,8 @@
>>    config ZRAM
>>    	tristate "Compressed RAM block device support"
>> -	depends on BLOCK&&   SYSFS
>> +	# X86 dependency is because zsmalloc uses non-portable pte/tlb
>> +	# functions
>> +	depends on BLOCK&&   SYSFS&&   X86
>>    	select ZSMALLOC
>>    	select LZO_COMPRESS
>>    	select LZO_DECOMPRESS
>> diff --git a/drivers/staging/zsmalloc/Kconfig b/drivers/staging/zsmalloc/Kconfig
>> index 3e7a8d4..8e2c6a0 100644
>> --- a/drivers/staging/zsmalloc/Kconfig
>> +++ b/drivers/staging/zsmalloc/Kconfig
>> @@ -1,6 +1,9 @@
>>    config ZSMALLOC
>>    	tristate "Memory allocator for compressed pages"
>> -	depends on SPARSEMEM
>> +	# X86 dependency is because of the use of __flush_tlb_one and set_pte
>> +	# in zsmalloc-main.c.
>> +	# TODO: convert these to portable functions
>> +	depends on SPARSEMEM&&   X86
>>    	default n
>>    	help
>>    	  zsmalloc is a slab-based memory allocator designed to store
>> diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
>> index 189fb42..455fc2f 100644
>> --- a/drivers/staging/zsmalloc/zsmalloc-main.c
>> +++ b/drivers/staging/zsmalloc/zsmalloc-main.c
>> @@ -26,6 +26,7 @@
>>    #include<asm/pgtable.h>
>>    #include<linux/cpumask.h>
>>    #include<linux/cpu.h>
>> +#include<linux/vmalloc.h>
>>
>>    #include "zsmalloc.h"
>>    #include "zsmalloc_int.h"
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

