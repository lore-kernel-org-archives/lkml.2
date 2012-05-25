Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046Ab2EYVzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 17:55:25 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51261 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab2EYVzX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 17:55:23 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQWrZaBpT1fzC_-mSBfDd4AKGrdGomPxVNSU-SFPrVNvOw@mail.gmail.com>
References: <1337754877-19759-1-git-send-email-yinghai@kernel.org>
 <1337754877-19759-3-git-send-email-yinghai@kernel.org> <CA+55aFzd1BWqidt95qZLc1x_YU=WeGS=mKUOMvO_3omOhc_5VA@mail.gmail.com>
 <CAE9FiQXx_x9M5ncLk4DyL8heYQTcsHZt2JofFMjPfUd4mympeA@mail.gmail.com>
 <CAE9FiQX=ECg5BmKm7B2ua_rZ6bOsceeHNsfFQRWBbNZx+8sBfw@mail.gmail.com>
 <20120525043651.GA1391@google.com> <CAE9FiQXvYH4zCqp_uOb2nw7jvm8B=q3yx1tCjJUT+PkdymYEuw@mail.gmail.com>
 <CAE9FiQW0rm2_sKdSCWs3TfatJB9yHwvmvt9_vBYMtOq_YBbmfw@mail.gmail.com>
 <20120525193716.GA8817@google.com> <CAE9FiQWrZaBpT1fzC_-mSBfDd4AKGrdGomPxVNSU-SFPrVNvOw@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 25 May 2012 15:55:01 -0600
Message-ID: <CAErSpo7d+zn-qgWKcbro7yneXRtmZQCOHi+kiGzYUTfs+aiF4g@mail.gmail.com>
Subject: Re: [PATCH 02/11] PCI: Try to allocate mem64 above 4G at first
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Newbury <steve@snewbury.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 2:19 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Fri, May 25, 2012 at 12:37 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Fri, May 25, 2012 at 11:39:26AM -0700, Yinghai Lu wrote:
>>> On Fri, May 25, 2012 at 10:53 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> >> I don't really like the dependency on PCIBIOS_MAX_MEM_32 + 1ULL
>>> >> overflowing to zero -- that means the reader has to know what the
>>> >> value of PCIBIOS_MAX_MEM_32 is, and things would break in non-obvious
>>> >> ways if we changed it.
>>> >>
>>>
>>> please check if attached one is more clear.
>>>
>>> make max and bottom is only related to _MEM and not default one.
>>>
>>> -       if (!(res->flags & IORESOURCE_MEM_64))
>>> -               max = PCIBIOS_MAX_MEM_32;
>>> +       if (res->flags & IORESOURCE_MEM) {
>>> +               if (!(res->flags & IORESOURCE_MEM_64))
>>> +                       max = PCIBIOS_MAX_MEM_32;
>>> +               else if (PCIBIOS_MAX_MEM_32 != -1)
>>> +                       bottom = (resource_size_t)(1ULL<<32);
>>> +       }
>>>
>>> will still not affect to other arches.
>>
>> That's goofy.  You're proposing to make only x86_64 and x86-PAE try to put
>> 64-bit BARs above 4GB.  Why should this be specific to x86?  I acknowledge
>> that there's risk in doing this, but if it's a good idea for x86_64, it
>> should also be a good idea for other 64-bit architectures.
>>
>> And testing for "is this x86_32 without PAE?" with
>> "PCIBIOS_MAX_MEM_32 == -1" is just plain obtuse and hides an
>> important bit of arch-specific behavior.
>>
>> Tangential question about allocate_resource():  Is its "max" argument
>> really necessary?  We'll obviously only allocate from inside the root
>> resource, so "max" is just a way to artificially avoid the end of
>> that resource.  Is there really a case where that's required?
>>
>> "min" makes sense because in a case like this, it's valid to allocate from
>> anywhere in the root resource, but we want to try to allocate from the >4GB
>> part first, then fall back to allocating from the whole resource.  I'm not
>> sure there's a corresponding case for "max."
>>
>> Getting back to this patch, I don't think we should need to adjust "max" at
>> all.  For example, this:
>>
>> commit cb1c8e46244cfd84a1a2fe91be860a74c1cf4e25
>> Author: Bjorn Helgaas <bhelgaas@google.com>
>> Date:   Thu May 24 22:15:26 2012 -0600
>>
>>    PCI: try to allocate 64-bit mem resources above 4GB
>>
>>    If we have a 64-bit mem resource, try to allocate it above 4GB first.  If
>>    that fails, we'll fall back to allocating space below 4GB.
>>
>> diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
>> index 4ce5ef2..075e5b1 100644
>> --- a/drivers/pci/bus.c
>> +++ b/drivers/pci/bus.c
>> @@ -121,14 +121,16 @@ pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
>>  {
>>        int i, ret = -ENOMEM;
>>        struct resource *r;
>> -       resource_size_t max = -1;
>> +       resource_size_t start = 0;
>> +       resource_size_t end = MAX_RESOURCE;
>
> yeah, MAX_RESOURCE is better than -1.
>
>>
>>        type_mask |= IORESOURCE_IO | IORESOURCE_MEM;
>>
>> -       /* don't allocate too high if the pref mem doesn't support 64bit*/
>> -       if (!(res->flags & IORESOURCE_MEM_64))
>> -               max = PCIBIOS_MAX_MEM_32;
>
> can not remove this one.
> otherwise will could allocate above 4g range to non MEM64 resource.

Yeah, I convince myself of the dumbest things sometimes.  It occurred
to me while driving home that we need this, but you beat me to it :)

I think we actually have a separate bug here.  On 64-bit non-x86
architectures, PCIBIOS_MAX_MEM_32 is a 64-bit -1, so the following
attempt to avoid putting a 32-bit BAR above 4G only works on x86,
where PCIBIOS_MAX_MEM_32 is 0xffffffff.

        /* don't allocate too high if the pref mem doesn't support 64bit*/
        if (!(res->flags & IORESOURCE_MEM_64))
                max = PCIBIOS_MAX_MEM_32;

I think we should fix this with a separate patch that removes
PCIBIOS_MAX_MEM_32 altogether, replacing this use with an explicit
0xffffffff (or some other "max 32-bit value" symbol).  I don't think
there's anything arch-specific about this.

So I'd like to see two patches here:
  1) Avoid allocating 64-bit regions for 32-bit BARs
  2) Try to allocate regions above 4GB for 64-bit BARs

> also we have
>
> include/linux/range.h:#define MAX_RESOURCE ((resource_size_t)~0)
> arch/x86/kernel/e820.c:#define MAX_RESOURCE_SIZE ((resource_size_t)-1)
>
> we should merge them later?

I would support that.

Bjorn
