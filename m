Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab2HLReZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 13:34:25 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40438 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab2HLReY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 13:34:24 -0400
Message-ID: <5027E90E.2000604@ti.com>
Date: Sun, 12 Aug 2012 13:34:06 -0400
From: Cyril Chemparathy <cyril@ti.com>
Reply-To: <cyril@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 03/22] ARM: use late patch framework for phys-virt
 patching
References: <1344648306-15619-1-git-send-email-cyril@ti.com> <1344648306-15619-4-git-send-email-cyril@ti.com> <alpine.LFD.2.02.1208112238270.5231@xanadu.home>
In-Reply-To: <alpine.LFD.2.02.1208112238270.5231@xanadu.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/12 23:03, Nicolas Pitre wrote:
> On Fri, 10 Aug 2012, Cyril Chemparathy wrote:
>
>> This patch replaces the original physical offset patching implementation
>> with one that uses the newly added patching framework.  In the process, we now
>> unconditionally initialize the __pv_phys_offset and __pv_offset globals in the
>> head.S code.
>
> This last sentence is now wrong.
>

Removed.

[...]
>> -extern unsigned long __pv_phys_offset;
>> -#define PHYS_OFFSET __pv_phys_offset
[...]
>> +#define PHYS_OFFSET	__virt_to_phys(PAGE_OFFSET)
>
> What was wrong with the former PHYS_OFFSET = __pv_phys_offset ?
>
> If you really want to have it optimized at run time, you could simply
> use your new stub to patch a mov instruction instead of going through
> __virt_to_phys which uses and add on top of a constant.
>

The intent was to optimize out the load(s) on references to PHYS_OFFSET, 
but is it worth it?  If so, we could go with a patched mov (or two) with 
the necessary endian fixups.  If not, we could revert to 
__pv_phys_offset loads as before.

[...]
>>   	s = find_mod_section(hdr, sechdrs, ".runtime.patch.table");
>>   	if (s)
>>   		runtime_patch((void *)s->sh_addr, s->sh_size);
>
> I missed this in the previous patch, but could you fail the module
> loading by returning an error if runtime_patch() fails?  That would take
> care of not accepting modules that might have been compiled with future
> runtime patching extensions that are not yet supported in an earlier
> kernel.
>

Sure.  Thanks.

> You also should remove the MODULE_ARCH_VERMAGIC_P2V definitions now that
> the corresponding code is no longer there.
>

Hmm...

"rt-patch" needs to be in vermagic to prevent modules built against the 
new code from being loaded on older kernels that used the traditional 
patch code.

"p2v" needs to be in there as well, because it should be possible to 
build without PATCH_PHYS_VIRT, but with RUNTIME_PATCH as and when there 
are other users for this.

Thanks
-- Cyril.
