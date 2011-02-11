Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949Ab1BKAzI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 19:55:08 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:19628 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756757Ab1BKAzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 19:55:07 -0500
Message-ID: <4D5488D5.2020607@kernel.org>
Date: Thu, 10 Feb 2011 16:54:45 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <JBeulich@novell.com>
Subject: Re: [PATCH] x86/mm/init: respect memblock reserved regions when destroying
 mappings
References: <alpine.DEB.2.00.1101311514580.7277@kaball-desktop> <4D4A3782.3050702@zytor.com> <alpine.DEB.2.00.1102031114030.7277@kaball-desktop> <4D4ADFAD.7060507@zytor.com> <alpine.DEB.2.00.1102041130060.7277@kaball-desktop> <4D4CA568.70907@goop.org> <AANLkTi=nEQka_19+nKQC-yJn2Czn9GCqsUWN6Byy7rCF@mail.gmail.com> <4D4E4E0D.2080806@zytor.com> <4D4EF553.6000000@kernel.org> <alpine.DEB.2.00.1102071524140.7277@kaball-desktop> <4D50343E.1020906@kernel.org> <alpine.DEB.2.00.1102071839060.7277@kaball-desktop> <4D504161.2060900@kernel.org> <4D506A85.9030802@goop.org> <4D50B4B5.4050505@kernel.org> <4D519AAA.8070309@zytor.com> <4D547962.8040403@goop.org> <4D547B74.1030302@kernel.org> <4D54844B.4010007@zytor.com>
In-Reply-To: <4D54844B.4010007@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4D5488DD.00C4,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2011 04:35 PM, H. Peter Anvin wrote:
> On 02/10/2011 03:57 PM, Yinghai Lu wrote:
>> On 02/10/2011 03:48 PM, Jeremy Fitzhardinge wrote:
>>> On 02/08/2011 11:34 AM, H. Peter Anvin wrote:
>>>> On 02/07/2011 07:12 PM, Yinghai Lu wrote:
>>>>> why punishing native path with those checking?
>>>>>
>>>> What happens if you end up with a reserved range in an unfortunate place
>>>> on real hardware?
>>>
>>> Yes, exactly.  The reserved region code isn't very useful if you can't
>>> rely on it to reserve stuff.
>>
>> assume context is under:
>> moving cleanup_highmap() down after brk is concluded, and check memblock_reserved there.
>>
>> one case for that: native path, bootloader could put initrd under 512M. and it is with memblock reserved.
>> if we check those range with memblock_reserved, initial kernel mapping will not be cleaned up.
>>
>> or worse if we are checking if there is any range from __pa(_brk_end) to 512M is with memblock reserved to decide
>> if we need to clean-up highmap. it will skip for whole range.
>>
> 
> I'm afraid I simply can't parse the above.

1. we have patch that will move down cleanup_highmap, and it will clean initial mapping from _brk_end to 512M (before we have two steps: clear _end to 512M and then _brk_end to _end)

2. So checking memblock_reserved with _brk_end to 512M will cause problem:
   a. will check 256 times less.
   b. if bootloader put initrd ramdisk overlapped with [_brk_end++, 512M), and overlap range will make clean_highmap bail out early. because those range is memblock_reserved.

BTW: Do we really need to cleanup initial mapping between _brk_end to _end?

origin patch from jan:

commit 498343967613183611ac37dccb2846496d954c06
Author: Jan Beulich <jbeulich@novell.com>
Date:   Wed May 6 13:06:47 2009 +0100

    x86-64: finish cleanup_highmaps()'s job wrt. _brk_end
    
    With the introduction of the .brk section, special care must be taken
    that no unused page table entries remain if _brk_end and _end are
    separated by a 2M page boundary. cleanup_highmap() runs very early and
    hence cannot take care of that, hence potential entries needing to be
    removed past _brk_end must be cleared once the brk allocator has done
    its job.
    
    [ Impact: avoids undesirable TLB aliases ]
    
    Signed-off-by: Jan Beulich <jbeulich@novell.com>
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index fd3da1d..ae4f7b5 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -7,6 +7,7 @@
 #include <asm/page.h>
 #include <asm/page_types.h>
 #include <asm/sections.h>
+#include <asm/setup.h>
 #include <asm/system.h>
 #include <asm/tlbflush.h>
 
@@ -304,8 +305,23 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 #endif
 
 #ifdef CONFIG_X86_64
-       if (!after_bootmem)
+       if (!after_bootmem && !start) {
+               pud_t *pud;
+               pmd_t *pmd;
+
                mmu_cr4_features = read_cr4();
+
+               /*
+                * _brk_end cannot change anymore, but it and _end may be
+                * located on different 2M pages. cleanup_highmap(), however,
+                * can only consider _end when it runs, so destroy any
+                * mappings beyond _brk_end here.
+                */
+               pud = pud_offset(pgd_offset_k(_brk_end), _brk_end);
+               pmd = pmd_offset(pud, _brk_end - 1);
+               while (++pmd <= pmd_offset(pud, (unsigned long)_end - 1))
+                       pmd_clear(pmd);
+       }
 #endif
        __flush_tlb_all();
 

