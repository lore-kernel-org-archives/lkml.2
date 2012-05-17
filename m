Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761296Ab2EQIDt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 04:03:49 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:58074 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab2EQIDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 04:03:45 -0400
X-AuditID: 9c930197-b7be2ae000000ebb-1c-4fb4b0ddfff8
Message-ID: <4FB4B109.9000703@kernel.org>
Date: Thu, 17 May 2012 17:04:25 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: Guan Xuetao <gxt@mprc.pku.edu.cn>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Russell King <linux@arm.linux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>, Paul Mundt <lethal@linux-sh.org>,
        Chen Liqin <liqin.chen@sunplusct.com>
Subject: Re: [PATCH v2 1/3] zsmalloc: support zsmalloc to ARM, MIPS, SUPERH
References: <1337133919-4182-1-git-send-email-minchan@kernel.org>  <1337153329.1751.5.camel@ubuntu.ubuntu-domain>  <4FB44147.5070704@kernel.org> <1337216199.1837.11.camel@ubuntu.ubuntu-domain>
In-Reply-To: <1337216199.1837.11.camel@ubuntu.ubuntu-domain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2012 09:56 AM, Guan Xuetao wrote:

> On Thu, 2012-05-17 at 09:07 +0900, Minchan Kim wrote:
>> On 05/16/2012 04:28 PM, Guan Xuetao wrote:
>>
>>> On Wed, 2012-05-16 at 11:05 +0900, Minchan Kim wrote:
>>>> zsmalloc uses set_pte and __flush_tlb_one for performance but
>>>> many architecture don't support it. so this patch removes
>>>> set_pte and __flush_tlb_one which are x86 dependency.
>>>> Instead of it, use local_flush_tlb_kernel_range which are available
>>>> by more architectures. It would be better than supporting only x86
>>>> and last patch in series will enable again with supporting
>>>> local_flush_tlb_kernel_range in x86.
>>>>
>>>> About local_flush_tlb_kernel_range,
>>>> If architecture is very smart, it could flush only tlb entries related to vaddr.
>>>> If architecture is smart, it could flush only tlb entries related to a CPU.
>>>> If architecture is _NOT_ smart, it could flush all entries of all CPUs.
>>>> So, it would be best to support both portability and performance.
>>>>
>>>> Cc: Russell King <linux@arm.linux.org.uk>
>>>> Cc: Ralf Baechle <ralf@linux-mips.org>
>>>> Cc: Paul Mundt <lethal@linux-sh.org>
>>>> Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
>>>> Cc: Chen Liqin <liqin.chen@sunplusct.com>
>>>> Signed-off-by: Minchan Kim <minchan@kernel.org>
>>>> ---
>>>>
>>>> Need double check about supporting local_flush_tlb_kernel_range
>>>> in ARM, MIPS, SUPERH maintainers. And I will Ccing unicore32 and
>>>> score maintainers because arch directory in those arch have
>>>> local_flush_tlb_kernel_range, too but I'm very unfamiliar with those
>>>> architecture so pass it to maintainers.
>>>> I didn't coded up dumb local_flush_tlb_kernel_range which flush
>>>> all cpus. I expect someone need ZSMALLOC will implement it easily in future.
>>>> Seth might support it in PowerPC. :)
>>>>
>>>>
>>>>  drivers/staging/zsmalloc/Kconfig         |    6 ++---
>>>>  drivers/staging/zsmalloc/zsmalloc-main.c |   36 +++++++++++++++++++++---------
>>>>  drivers/staging/zsmalloc/zsmalloc_int.h  |    1 -
>>>>  3 files changed, 29 insertions(+), 14 deletions(-)
>>>>
>>>> diff --git a/drivers/staging/zsmalloc/Kconfig b/drivers/staging/zsmalloc/Kconfig
>>>> index a5ab720..def2483 100644
>>>> --- a/drivers/staging/zsmalloc/Kconfig
>>>> +++ b/drivers/staging/zsmalloc/Kconfig
>>>> @@ -1,9 +1,9 @@
>>>>  config ZSMALLOC
>>>>  	tristate "Memory allocator for compressed pages"
>>>> -	# X86 dependency is because of the use of __flush_tlb_one and set_pte
>>>> +	# arch dependency is because of the use of local_unmap_kernel_range
>>>>  	# in zsmalloc-main.c.
>>>> -	# TODO: convert these to portable functions
>>>> -	depends on X86
>>>> +	# TODO: implement local_unmap_kernel_range in all architecture.
>>>> +	depends on (ARM || MIPS || SUPERH)
>>> I suggest removing above line, so if I want to use zsmalloc, I could
>>> enable this configuration easily.
>>
>>
>> I don't get it. What do you mean?
>> If I remove above line, compile error will happen if arch doesn't support local_unmap_kernel_range.
> If I want to use zsmalloc, I will verify local_unmap_kernel_range
> function. In fact, only local_flush_tlb_kernel_range need to be
> considered. So, just keeping the default option 'n' is enough.


I don't think so.
It's terrible experience if all users have to look up local_flush_tlb_kernel_range of arch for using zsmalloc.

BTW, does unicore32 support that function?
If so, I would like to add unicore32 in Kconfig.

-- 
Kind regards,
Minchan Kim
