Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418Ab0FOCeY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 22:34:24 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43642 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756044Ab0FOCeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 22:34:22 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4C16E688.3040309@jp.fujitsu.com>
Date: Tue, 15 Jun 2010 11:33:44 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org
Subject: Re: [PATCH 2/4] x86: ioremap: fix physical address check
References: <4C11FF10.4060203@jp.fujitsu.com> <4C15F2BD.9020904@jp.fujitsu.com> <4C160D27.1050809@jp.fujitsu.com> <201006142216.42864.eike-kernel@sf-tec.de>
In-Reply-To: <201006142216.42864.eike-kernel@sf-tec.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/06/15 5:16), Rolf Eike Beer wrote:
> Kenji Kaneshige wrote:
>> (2010/06/14 18:13), Kenji Kaneshige wrote:
>>> Thank you Hiroyuki.
>>>
>>> So many bugs in ioremap()...
>>>
>>> Will try with those bugs fixed.
>>>
>>> Thanks,
>>> Kenji Kaneshige
>>
>> The problem seems to be fixed by the following patch. This is still
>> under testing. I will post the patch as v2 after testing.
>>
>> Thanks,
>> Kenji Kaneshige
>>
>>
>> Current x86 ioremap() doesn't handle physical address higher than
>> 32-bit properly in X86_32 PAE mode. When physical address higher than
>> 32-bit is passed to ioremap(), higher 32-bits in physical address is
>> cleared wrongly. Due to this bug, ioremap() can map wrong address to
>> linear address space.
>>
>> In my case, 64-bit MMIO region was assigned to a PCI device (ioat
>> device) on my system. Because of the ioremap()'s bug, wrong physical
>> address (instead of MMIO region) was mapped to linear address space.
>> Because of this, loading ioatdma driver caused unexpected behavior
>> (kernel panic, kernel hangup, ...).
>>
>> Signed-off-by: Kenji Kaneshige<kaneshige.kenji@jp.fujitsu.com>
>>
>> ---
>>   arch/x86/mm/ioremap.c   |   11 +++++------
>>   include/linux/io.h      |    4 ++--
>>   include/linux/vmalloc.h |    2 +-
>>   lib/ioremap.c           |   10 +++++-----
>>   4 files changed, 13 insertions(+), 14 deletions(-)
>>
>> Index: linux-2.6.34/arch/x86/mm/ioremap.c
>> ===================================================================
>> --- linux-2.6.34.orig/arch/x86/mm/ioremap.c
>> +++ linux-2.6.34/arch/x86/mm/ioremap.c
>> @@ -62,7 +62,8 @@ int ioremap_change_attr(unsigned long va
>>   static void __iomem *__ioremap_caller(resource_size_t phys_addr,
>>   		unsigned long size, unsigned long prot_val, void *caller)
>>   {
>> -	unsigned long pfn, offset, vaddr;
>> +	u64 pfn, last_pfn;
>> +	unsigned long offset, vaddr;
>>   	resource_size_t last_addr;
>>   	const resource_size_t unaligned_phys_addr = phys_addr;
>>   	const unsigned long unaligned_size = size;
>
> Why do you use u64 and not resource_size_t for those? That way this would not
> be needlessly big for "real" 32 bit platforms.

Thank you for your comment. The reason was I found other code that uses
u64 for pfn in other code. But yes, I will change that.

Thanks,
Kenji Kaneshige


