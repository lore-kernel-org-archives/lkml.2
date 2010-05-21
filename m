Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab0EUEwv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 00:52:51 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:49883 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab0EUEwu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 00:52:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=CAGtqXCUDsHEnVfyHrcP6nREUG6XznMInC1q7DIVG31TFgUwa3oIa2/hqYkHHloBL8
         oacf98uJEfzRN2oAaT3LVrikvATRHj/wCXw3Z4rgt4mGFBw6aMxMpxsg7PWFhNWWnsvC
         mY5tE3/EXv4Uxk2rhNXox5fPUbVZLb6IT9BWA=
MIME-Version: 1.0
In-Reply-To: <4BF5892E.5080302@tilera.com>
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com> 
	<AANLkTilpV71K2L2N1B85yRnlTc302KbMUz2P5kuvktyl@mail.gmail.com> 
	<4BF5892E.5080302@tilera.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 21 May 2010 12:52:27 +0800
Message-ID: <AANLkTikN6S2nMLAw0uQ9_BosJ0i3_vdpajVrVq0Kllp7@mail.gmail.com>
Subject: Re: [PATCH] arch/tile: new multi-core architecture for Linux
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 3:10 AM, Chris Metcalf <cmetcalf@tilera.com> wrote:
> On 5/20/2010 1:04 AM, Barry Song wrote:
>> On Thu, May 20, 2010 at 1:43 PM, Chris Metcalf <cmetcalf@tilera.com> wrote:
>>
>>> --- linux-2.6.34/include/linux/mm.h     2010-05-16 17:17:36.000000000 -0400
>>> +++ tilera-source/include/linux/mm.h    2010-05-17 12:54:33.540145000 -0400
>>> @@ -592,7 +592,7 @@
>>>
>>>  static __always_inline void *lowmem_page_address(struct page *page)
>>>  {
>>> -       return __va(page_to_pfn(page) << PAGE_SHIFT);
>>> +       return __va((phys_addr_t)page_to_pfn(page) << PAGE_SHIFT);
>>>
>> Here doesn't make sense. you give a u64 type cast, but change the
>> meaning of pfn. Is pfn phys_addr_t? Anyway, page_to_pfn can be
>> re-fulfilled in your arch, but not change it in common code.
>> [...]
>> Your patch is not compilable, and the subject doesn't match well with
>> the content. I think you need re-organize patches.

Where does the blade_pci symbol come from? "No matches found" by a
grep. Is it exported in your local codes?
Why not just use #if CONFIG_TILE to cover your quirk_tile_blade. And
where is CONFIG_TILE?
I guess all will be explained by your arch codes, but this patch
depends on your arch codes, so it shouldn't be here by itself.

>>
>
> Where do you see the compilation failure?  I tested this with the only
> other architecture I have handy (x86_64) and it built OK.  And by code
> inspection, <linux/mm.h> includes <linux/mm_types.h> includes
> <linux/types.h>, which always provides phys_addr_t suitably (based on
> CONFIG_PHYS_ADDR_T_64BIT).
>
> In any case, a better solution might be to #include <linux/pfn.h> in
> <linux/mm.h> and write this function as:
>
> static __always_inline void *lowmem_page_address(struct page *page)
> {
>        return __va(PFN_PHYS(page_to_pfn(page));
> }
>
>
> Note that PFN_PHYS() is already defined to include the cast to
> phys_addr_t.  Jeremy Fitzhardinge added the cast in Sep 2008 with a
> comment that echoes this discussion:
>
>    generic: make PFN_PHYS explicitly return phys_addr_t
>
>    PFN_PHYS, as its name suggests, turns a pfn into a physical address.
>    However, it is a macro which just operates on its argument without
>    modifying its type.  pfns are typed unsigned long, but an unsigned
>    long may not be long enough to hold a physical address (32-bit systems
>    with more than 32 bits of physcial address).
>
>    Make sure we cast to phys_addr_t to return a complete result.
>
>
> Linus, does this seem like the right generic answer, or would it make
> more sense, as you suggested, to try to provide a new pfn_to_phys()
> function in the architecture-independent code?
>
> In any case, in the spirit of providing a complete answer, I'll provide
> a proper patch in a following email.
>
> --
> Chris Metcalf, Tilera Corp.
> http://www.tilera.com
>
>
>
