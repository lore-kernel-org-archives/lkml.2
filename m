Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967Ab0LGDIz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 22:08:55 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47682 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479Ab0LGDIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 22:08:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=kh3gbtPh/QGSwdqygRCfjZbTBNN/k0i5Sa1BL0q+uIQ4rIMGJo2/n80HT7MVJPoxAb
         lJWPkt0i3mhUx5JPVQDrqvNxnpVZTqyhfB5M+EpKphkbZpRSL1wyrC3sm6GW2Nk1rVfx
         M5UB0jjpdAtcggWsmAuxn3eP5/UNIMbVQllak=
Message-ID: <4CFDA542.309@gmail.com>
Date: Mon, 06 Dec 2010 19:08:50 -0800
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
CC: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        grant.likely@secretlab.ca
Subject: Re: [PATCH] of/fdt: add kernel command line option for dtb_compat
 string
References: <1291658059-383-1-git-send-email-dirk.brandewie@gmail.com> <4bb36a12-8d95-4d4e-936c-c1c74a9372cc@VA3EHSMHS025.ehs.local> <4CFD3322.1000503@gmail.com> <4CFD3371.3080807@gmail.com> <805e9139-7c09-45f5-a5a9-0ed0cbf64f2f@VA3EHSMHS025.ehs.local>
In-Reply-To: <805e9139-7c09-45f5-a5a9-0ed0cbf64f2f@VA3EHSMHS025.ehs.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2010 01:50 PM, Stephen Neuendorffer wrote:
>
>
>> -----Original Message-----
>> From: Dirk Brandewie [mailto:dirk.brandewie@gmail.com]
>> Sent: Monday, December 06, 2010 11:03 AM
>> To: Stephen Neuendorffer
>> Cc: linux-kernel@vger.kernel.org; Randy Dunlap;
> devicetree-discuss@lists.ozlabs.org; linux-
>> doc@vger.kernel.org; grant.likely@secretlab.ca
>> Subject: Re: [PATCH] of/fdt: add kernel command line option for
> dtb_compat string
>>
>> On 12/06/2010 11:01 AM, Dirk Brandewie wrote:
>>> On 12/06/2010 10:37 AM, Stephen Neuendorffer wrote:
>>>>
>>>>
>>>>> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
>>>>> index c1360e0..ca1318c 100644
>>>>> --- a/drivers/of/fdt.c
>>>>> +++ b/drivers/of/fdt.c
>>>>> @@ -15,6 +15,8 @@
>>>>> #include<linux/of_fdt.h>
>>>>> #include<linux/string.h>
>>>>> #include<linux/errno.h>
>>>>> +#include<asm-generic/vmlinux.lds.h>
>>>>> +
>>>>>
>>>>> #ifdef CONFIG_PPC
>>>>> #include<asm/machdep.h>
>>>>> @@ -604,3 +606,49 @@ void __init unflatten_device_tree(void)
>>>>>
>>>>> pr_debug("<- unflatten_device_tree()\n");
>>>>> }
>>>>> +
>>>>> +extern uint8_t __dtb_start[];
>>>>> +extern uint8_t __dtb_end[];
>>>>> +static void __init *of_flat_dt_find_compatible_dtb(char *name)
>>>>> +{
>>>>> + void *rc = NULL;
>>>>> + unsigned long root, size;
>>>>> + struct boot_param_header *orig_initial_boot_params;
>>>>> + uint8_t *blob;
>>>>> +
>>>>> + orig_initial_boot_params = initial_boot_params;
>>>>> + blob = __dtb_start;
>>>>> + initial_boot_params = (struct boot_param_header *)blob;
>>>>
>>>> Oy... can you avoid the pointer dance by using
> of_fdt_is_compatible()
>>>> from my recent set of patches?
>>>
>>> I would like to get rid of the pointer dance. Is your patch set
> going to make it
>>> into .37? I didn't see any acks.
>>>
>> Obviously I meant .38 :-)
>
> I'd like it too, but that's up to Grant.  I imagine some of the
> bottleneck is that I don't have
> an easy way to test on powerpc or microblaze at the moment, so it's not
> clear that the code doesn't
> break anything.
>
>>>> It takes a blob argument. Then the loop below goes away.
>>>>
>>>
>>> The loop will still be needed since multiple DTBs may be linked into
> the image.
>>> using your of_fdt_is_compatible() will make the loop a lot more
> readable though.
>
> Yeah, right.  Is the format just the binary concatenation of the device
> trees?

No each blob starts on a STRUCT_ALIGNMENT boundary.  If the blob does not have 
the correct alignment the code that GCC generates to reference into the 
structure breaks.

part of why I ask
> is the PTR_ALIGN code: It seems like different blob functions make
> different assumptions about the
> location of the blob. In some cases, it is assumed to be the passed
> pointer, in others,
> the pointer is scanned for OF_DT_BEGIN_NODE (using of_get_flat_dt_root).
> Is the concern about
> STRUCT_ALIGNMENT necessary if you call of_get_flat_dt_root() afterwards?
> Would it make sense to
> always call of_get_flat_dt_root in the 'generic' functions I added or
> not?
The padding between blobs is added in the assembly wrapper (zero fill) 
of_get_flat_dt_root() assumes the blob pointer (initial_boot_params) is the head 
of the blob and only skips OF_DT_NOP (0x4).  If we always hand in the pointer to 
the head of the blob the rest of fdt.c should be happy with it.

>
> BTW, PTR_ALIGN should probably be ALIGN.
Originally I used ALIGN but needed to cast the result of ALIGN blob to get rid 
of a compiler warning Grant suggested PTR_ALIGN which does the cast for you.

>
> Steve
>
> This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.
>
>

