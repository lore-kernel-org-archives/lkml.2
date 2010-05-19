Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352Ab0ESXGM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 19:06:12 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36050 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab0ESXGI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 19:06:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=t+ixhgpINzvTTBASy/wvBcyM0gt8X49dkoMsgt2ANyqXTjMlFQkkJ5RPhFLJre+b9U
         qjdbp/LgdwqePhE/hcb3cOxXh+G0Np4uMJyTQuYUFe4fFHhW6P6Z5DvDql5dOKdpVYbS
         44MEBq/oWAMDAGQ0cuAjCA6zYTTWoLB3VWuq4=
MIME-Version: 1.0
In-Reply-To: <4BF4235D.3080904@zytor.com>
References: <AANLkTimwxXtNnmBuDJxg3i72VwWuHmemjrr1iGqj4j8e@mail.gmail.com>
	 <4BF42296.1030905@oracle.com> <4BF4235D.3080904@zytor.com>
Date: Wed, 19 May 2010 15:58:33 -0700
Message-ID: <AANLkTikYcu6fM3yLoYIZOGZXgsRUfCgJeWS51Sjo-Fny@mail.gmail.com>
Subject: Re: [PATCH] Prevent reserving RAM in the region already reserved by 
	BIOS
From: Mathieu Rondonneau <mathieu.rondonneau@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai <yinghai.lu@oracle.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the feedback.

No, I don' t see any changes in the /proc/iomem.

I am trying to prevent a ioremap of a 4K size on a non aligned 4K
address that is below the ISA_START_ADDRESS.

The problem generates a oops about overlapping.
I have a fix which instruct to not to do any re-map if the section
name is "reserved".
Which is not really clean.
I am looking for a clean way to tell the ioremap function to not remap
bios reserved memory.
That' s why I thought the e820 would be a good start.

I will continue looking into this. It does not crash the systems. A
warning generates the oops.

-Mathieu


On Wed, May 19, 2010 at 10:43 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 05/19/2010 10:40 AM, Yinghai wrote:
>> On 05/18/2010 10:35 PM, Mathieu Rondonneau wrote:
>>> Does it make sense to prevent looking for stolen RAM below the ISA section.
>>>
>>>
>>> Signed-off-by: Mathieu Rondonneau <mathieu.rondonneau@gmail.com>
>>> ---
>>>  arch/x86/kernel/e820.c |    2 ++
>>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
>>> index 7bca3c6..322c9c3 100644
>>> --- a/arch/x86/kernel/e820.c
>>> +++ b/arch/x86/kernel/e820.c
>>> @@ -1156,6 +1156,8 @@ void __init e820_reserve_resources_late(void)
>>>                         end = MAX_RESOURCE_SIZE;
>>>                 if (start >= end)
>>>                         continue;
>>> +               if (end < ISA_START_ADDRESS)
>>> +                       continue;
>>>                 printk(KERN_DEBUG "reserve RAM buffer: %016llx - %016llx ",
>>>                                start, end);
>>>                 reserve_region_with_split(&iomem_resource, start, end,
>>
>> do you notice any changes in /proc/iomem?
>>
>
> It should be harmless to reserve memory which is already reserved, so
> this patch is at best a no-op.  Furthermore, it introduces another
> instance of special address space (ISA_START_ADDRESS in this case) which
> is never a good thing.
>
>        -hpa
>
>
