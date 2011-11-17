Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab1KQRVR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 12:21:17 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54578 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822Ab1KQRVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 12:21:16 -0500
Message-ID: <4EC5428A.6030700@gmail.com>
Date: Thu, 17 Nov 2011 09:21:14 -0800
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH] hugetlb: Provide a default HPAGE_SHIFT if !CONFIG_HUGETLB_PAGE
References: <1321472611-13283-1-git-send-email-ddaney.cavm@gmail.com> <alpine.DEB.2.00.1111161327180.16596@chino.kir.corp.google.com> <4EC43488.3070400@gmail.com> <alpine.DEB.2.00.1111161512371.16596@chino.kir.corp.google.com> <4EC44AD0.5070800@gmail.com> <alpine.DEB.2.00.1111161552450.25089@chino.kir.corp.google.com> <4EC45CAE.1000704@gmail.com> <alpine.DEB.2.00.1111162047170.13603@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1111162047170.13603@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2011 08:56 PM, David Rientjes wrote:
> On Wed, 16 Nov 2011, David Daney wrote:
>
>>>> It is a well established kernel idiom to supply dummy values for symbols
>>>> that
>>>> are required to be defined in order to form a syntactically correct C
>>>> program,
>>>> but that are known by the programmer to be used only on dead code paths.
>>>>
>>>> This is exactly what we are doing here.
>>>>
>>>> To do otherwise requires that code be cluttered with #ifdefery.
>>>>
>>>
>>> You're wrong,
>>
>> Ok, then please tell me why:
>>
>> 1) the dummy version of is_vm_hugetlb_page() exists in hugetlb_inline.h?
>> 2) the dummy version of PageHuge() exists in hugetlb.h
[...]
>
> To avoid the #ifdef's,

Good, now we are on the same page.

The answer is not, as first suggested, to sprinkle #ifdefs all over the 
place, but ...

> but you'll notice that they return either NULL, 0,
> or are a no-op.  We don't substitute real values in dummy functions where
> they could be used in generic code as though they were valid.  That's the
> problem with defining HPAGE_SHIFT to be PAGE_SHIFT and, yes, defining
> HPAGE_MASK and HPAGE_SIZE as well shouldn't be done and should be removed.
>
> We expect HPAGE_* to represent hugepages, not the native page size of the
> bare metal.  This is why we do things like
>
> 	#define HPAGE_PMD_SHIFT ({ BUG(); 0; })
> 	#define HPAGE_PMD_MASK ({ BUG(); 0; })
> 	#define HPAGE_PMD_SIZE ({ BUG(); 0; })

... rather to fix HPAGE_SHIFT, HPAGE_MASK, and HPAGE_SIZE to be more 
like these.

I will generate a version of the patch that does this, noting that it 
the addition of a dummy definition of HPAGE_SHIFT is added to facilitate 
cleaner architecture specific code for MIPS patches in linux-next.

Thanks,
David Daney


>
> for CONFIG_TRANSPARENT_HUGEPAGE=n.  We don't want to pretend that they're
> valid outside the context of hugepages.
>
> We also never use HPAGE_SHIFT, HPAGE_MASK, or HPAGE_SIZE in generic code
> that isn't dependent on CONFIG_HUGETLB_PAGE.  If you'd like to submit a
> patch to fix this in the mips tree, then that would be good, and if you'd
> like to submit a patch to remove these dummy definitions all together by
> auditing other arch code, then that would be great.
>

