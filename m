Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab1KQXiq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 18:38:46 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60643 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab1KQXip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 18:38:45 -0500
Message-ID: <4EC59B02.7060804@gmail.com>
Date: Thu, 17 Nov 2011 15:38:42 -0800
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v2 2/2] hugetlb: Provide safer dummy values for HPAGE_MASK
 and HPAGE_SIZE
References: <1321567050-13197-1-git-send-email-ddaney.cavm@gmail.com>	<1321567050-13197-3-git-send-email-ddaney.cavm@gmail.com> <20111117152841.dc962d9d.akpm@linux-foundation.org>
In-Reply-To: <20111117152841.dc962d9d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2011 03:28 PM, Andrew Morton wrote:
> On Thu, 17 Nov 2011 13:57:30 -0800
> David Daney<ddaney.cavm@gmail.com>  wrote:
>
>> From: David Daney<david.daney@cavium.com>
>>
>> It was pointed out by David Rientjes that the dummy values for
>> HPAGE_MASK and HPAGE_SIZE are quite unsafe.  It they are inadvertently
>> used with !CONFIG_HUGETLB_PAGE, compilation would succeed, but the
>> resulting code would surly not do anything sensible.
>>
>> Place BUG() in the these dummy definitions, as we do in similar
>> circumstances in other places, so any abuse can be easily detected.
>>
>> Since the only sane place to use these symbols when
>> !CONFIG_HUGETLB_PAGE is on dead code paths, the BUG() cause any actual
>> code to be emitted by the compiler.
>
> I assume you meant "omitted" here.

I jumbled it up.  It should read:

... the BUG() will not cause any actual code to be emitted by the 
compiler.  In fact I have verified this on both MIPS64 and x86_64 kernels.

I could re-spin the patch with a corrected changelog if desired.

>
> But I don't think it's true.  Any such code would occur after testing
> is_vm_hugetlb_page() or similar, and would have been omitted anyway.
>

The point being that we are doing:

if (is_vm_hugetlb_page(vma)) {
	/* Do something with HPAGE_MASK*/
} else {
	/* Do something with PAGE_MASK */
}

In the !CONFIG_HUGETLB_PAGE case we have:
static inline int is_vm_hugetlb_page(struct vm_area_struct *vma)
{
	return 0;
}

The compiler sees that the usage of the dummy definitions is in a dead 
code path and nothing is emitted.

>> --- a/include/linux/hugetlb.h
>> +++ b/include/linux/hugetlb.h
>> @@ -111,8 +111,9 @@ static inline void copy_huge_page(struct page *dst, struct page *src)
>>   #define hugetlb_change_protection(vma, address, end, newprot)
>>
>>   #ifndef HPAGE_MASK
>> -#define HPAGE_MASK	PAGE_MASK		/* Keep the compiler happy */
>> -#define HPAGE_SIZE	PAGE_SIZE
>> +/* Keep the compiler happy with some dummy (but BUGgy) values */
>
> That's a quite poor comment.  This?

I was trying to communicate the presence of the BUG() in the definition. 
  Perhaps it is more confusing than it was before.

>
> --- a/include/linux/hugetlb.h~hugetlb-provide-safer-dummy-values-for-hpage_mask-and-hpage_size-fix
> +++ a/include/linux/hugetlb.h
> @@ -111,7 +111,11 @@ static inline void copy_huge_page(struct
>   #define hugetlb_change_protection(vma, address, end, newprot)
>
>   #ifndef HPAGE_MASK
> -/* Keep the compiler happy with some dummy (but BUGgy) values */
> +/*
> + * HPAGE_MASK and friends are defined if !CONFIG_HUGETLB_PAGE as an
> + * ifdef-avoiding convenience.  However they should never be evaluated at
> + * runtime if !CONFIG_HUGETLB_PAGE.
> + */
>   #define HPAGE_MASK	({BUG(); 0; })
>   #define HPAGE_SIZE	({BUG(); 0; })
>   #define HPAGE_SHIFT	({BUG(); 0; })
> _
>
>> +#define HPAGE_MASK	({BUG(); 0; })
>> +#define HPAGE_SIZE	({BUG(); 0; })
>>   #define HPAGE_SHIFT	({BUG(); 0; })
>
> This change means that HPAGE_* cannot be evaluated at compile time.  So
>
> int foo = HPAGE_SIZE;
>
> outside functions will explode.  I guess that's OK - actually desirable
> - as such code shouldn't have been compiled anyway.
>

The exact point of the patch.

Thanks,
David Daney


