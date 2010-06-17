Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504Ab0FQE4K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 00:56:10 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42763 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab0FQE4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 00:56:08 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4C19AABA.8000706@jp.fujitsu.com>
Date: Thu, 17 Jun 2010 13:55:22 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <matthew@wil.cx>
CC: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, macro@linux-mips.org,
       kamezawa.hiroyu@jp.fujitsu.com, eike-kernel@sf-tec.de
Subject: Re: [PATCH 1/2] x86: ioremap: fix wrong physical address handling
References: <4C197A49.6020400@jp.fujitsu.com> <4C197A9E.5040509@jp.fujitsu.com> <20100617025052.GH9298@parisc-linux.org> <4C19A2EE.2010203@zytor.com>
In-Reply-To: <4C19A2EE.2010203@zytor.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/06/17 13:22), H. Peter Anvin wrote:
> On 06/16/2010 07:50 PM, Matthew Wilcox wrote:
>> On Thu, Jun 17, 2010 at 10:30:06AM +0900, Kenji Kaneshige wrote:
>>> Index: linux-2.6.34/arch/x86/mm/ioremap.c
>>> ===================================================================
>>> --- linux-2.6.34.orig/arch/x86/mm/ioremap.c 2010-06-15 
>>> 04:43:00.978332015 +0900
>>> +++ linux-2.6.34/arch/x86/mm/ioremap.c 2010-06-15 05:32:59.291693007 
>>> +0900
>>> @@ -62,8 +62,8 @@
>>> static void __iomem *__ioremap_caller(resource_size_t phys_addr,
>>> unsigned long size, unsigned long prot_val, void *caller)
>>> {
>>> - unsigned long pfn, offset, vaddr;
>>> - resource_size_t last_addr;
>>> + unsigned long offset, vaddr;
>>> + resource_size_t pfn, last_pfn, last_addr;
>>
>> I have a hard time understanding this change. pfn is always a physical
>> address shifted by PAGE_SHIFT. So a 32-bit pfn supports up to 44-bit
>> physical addresses. Are your addresses above 44-bits?
>>
> 
> I think they might be. Kenji?

No. My addresses are in the 44-bits range (around fc000000000). So it is
not required for my problem. This change assumes that phys_addr can be
above 44-bits (up to 52-bits (and higher in the future?)).

By the way, is there linux kernel limit regarding above 44-bits physical
address in x86_32 PAE? For example, pfn above 32-bits is not supported?

#ifdef CONFIG_X86_PAE
/* 44=32+12, the limit we can fit into an unsigned long pfn */
#define __PHYSICAL_MASK_SHIFT   44
#define __VIRTUAL_MASK_SHIFT    32

If there is 44-bits physical address limit, I think it's better to use
PHYSICAL_PAGE_MASK for masking physical address, instead of "(phys_addr
>> PAGE_SHIFT) << PAGE_SHIFT)". The PHYSICAL_PAGE_MASK would become
greater value when 44-bits physical address limit is eliminated. And
maybe we need to change phys_addr_valid() returns error if physical
address is above (1 << __PHYSICAL_MASK_SHIFT)?

Thanks,
Kenji Kaneshige

