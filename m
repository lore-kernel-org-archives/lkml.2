Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783Ab2BTHXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 02:23:44 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42408 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab2BTHXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 02:23:43 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
Message-ID: <4F41F50C.1010508@jp.fujitsu.com>
Date: Mon, 20 Feb 2012 16:23:56 +0900
From: Naotaka Hamaguchi <n.hamaguchi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.26) Gecko/20120129 Thunderbird/3.1.18
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Subject: Re: [PATCH] mm: mmap() sometimes succeeds even if the region to map
 is invalid.
References: <4F3E1319.6050304@jp.fujitsu.com> <D958900912E20642BCBC71664EFECE3E6DD198A7AE@BGMAIL02.nvidia.com>
In-Reply-To: <D958900912E20642BCBC71664EFECE3E6DD198A7AE@BGMAIL02.nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Venu,

>> 1. mmap() succeeds even if "offset" argument is a negative value, although
>>     it should return EINVAL in such case.
>
>> In such case, it is actually regarded as big positive value
>> because the type of "off" is "unsigned long" in the kernel.
>> For example, off=-4096 (-0x1000) is regarded as
>> off = 0xfffffffffffff000 (x86_64) and as off = 0xfffff000 (x86).
>> It results in mapping too big offset region.
>
> It is not true always.
>
> Considering your example, say if page size is 4k, then PAGE_MASK = 0xFFF
> hence (off&  ~PAGE_MASK) will be true and " -EINVAL" will be returned.

Is PAGE_MASK 0xfffffffffffff000 (x86_64) and 0xfffff000 (x86), isn't it?
Or am I missing something?

arch/x86/include/asm/page_types.h
=================================================
...
#define PAGE_SHIFT      12
#define PAGE_SIZE       (_AC(1,UL) << PAGE_SHIFT)
#define PAGE_MASK       (~(PAGE_SIZE-1))
...
=================================================

Thanks,
Naotaka Hamaguchi

(2012/02/17 18:04), Venu Byravarasu wrote:
>> The detail of these problems is as follows:
>
>> 1. mmap() succeeds even if "offset" argument is a negative value, although
>>     it should return EINVAL in such case.
>
>> In such case, it is actually regarded as big positive value
>> because the type of "off" is "unsigned long" in the kernel.
>> For example, off=-4096 (-0x1000) is regarded as
>> off = 0xfffffffffffff000 (x86_64) and as off = 0xfffff000 (x86).
>> It results in mapping too big offset region.
>
> It is not true always.
>
> Considering your example, say if page size is 4k, then PAGE_MASK = 0xFFF
> hence (off&  ~PAGE_MASK) will be true and " -EINVAL" will be returned.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>


