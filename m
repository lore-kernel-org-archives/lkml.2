Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959Ab0ETTLn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 15:11:43 -0400
Received: from king.tilera.com ([72.1.168.226]:6953 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492Ab0ETTLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 15:11:41 -0400
Message-ID: <4BF5892E.5080302@tilera.com>
Date: Thu, 20 May 2010 12:10:38 -0700
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Barry Song <21cnbao@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] arch/tile: new multi-core architecture for Linux
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com> <AANLkTilpV71K2L2N1B85yRnlTc302KbMUz2P5kuvktyl@mail.gmail.com>
In-Reply-To: <AANLkTilpV71K2L2N1B85yRnlTc302KbMUz2P5kuvktyl@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 May 2010 19:11:40.0724 (UTC) FILETIME=[4716F740:01CAF850]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/20/2010 1:04 AM, Barry Song wrote:
> On Thu, May 20, 2010 at 1:43 PM, Chris Metcalf <cmetcalf@tilera.com> wrote:
>   
>> --- linux-2.6.34/include/linux/mm.h     2010-05-16 17:17:36.000000000 -0400
>> +++ tilera-source/include/linux/mm.h    2010-05-17 12:54:33.540145000 -0400
>> @@ -592,7 +592,7 @@
>>
>>  static __always_inline void *lowmem_page_address(struct page *page)
>>  {
>> -       return __va(page_to_pfn(page) << PAGE_SHIFT);
>> +       return __va((phys_addr_t)page_to_pfn(page) << PAGE_SHIFT);
>>     
> Here doesn't make sense. you give a u64 type cast, but change the
> meaning of pfn. Is pfn phys_addr_t? Anyway, page_to_pfn can be
> re-fulfilled in your arch, but not change it in common code.
> [...]
> Your patch is not compilable, and the subject doesn't match well with
> the content. I think you need re-organize patches.
>   

Where do you see the compilation failure?  I tested this with the only
other architecture I have handy (x86_64) and it built OK.  And by code
inspection, <linux/mm.h> includes <linux/mm_types.h> includes
<linux/types.h>, which always provides phys_addr_t suitably (based on
CONFIG_PHYS_ADDR_T_64BIT).

In any case, a better solution might be to #include <linux/pfn.h> in
<linux/mm.h> and write this function as:

static __always_inline void *lowmem_page_address(struct page *page)
{
        return __va(PFN_PHYS(page_to_pfn(page));
}


Note that PFN_PHYS() is already defined to include the cast to
phys_addr_t.  Jeremy Fitzhardinge added the cast in Sep 2008 with a
comment that echoes this discussion:

    generic: make PFN_PHYS explicitly return phys_addr_t
    
    PFN_PHYS, as its name suggests, turns a pfn into a physical address.
    However, it is a macro which just operates on its argument without
    modifying its type.  pfns are typed unsigned long, but an unsigned
    long may not be long enough to hold a physical address (32-bit systems
    with more than 32 bits of physcial address).
    
    Make sure we cast to phys_addr_t to return a complete result.


Linus, does this seem like the right generic answer, or would it make
more sense, as you suggested, to try to provide a new pfn_to_phys()
function in the architecture-independent code?

In any case, in the spirit of providing a complete answer, I'll provide
a proper patch in a following email.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


