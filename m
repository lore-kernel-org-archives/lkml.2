Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab2E2XZJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 19:25:09 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48554 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab2E2XZG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 19:25:06 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQWORRjxEQwr+933ReNAAKAEoJ5B6AWte4gr33_BO+4heQ@mail.gmail.com>
References: <1337754877-19759-1-git-send-email-yinghai@kernel.org>
 <1337754877-19759-3-git-send-email-yinghai@kernel.org> <CA+55aFzd1BWqidt95qZLc1x_YU=WeGS=mKUOMvO_3omOhc_5VA@mail.gmail.com>
 <CAE9FiQXx_x9M5ncLk4DyL8heYQTcsHZt2JofFMjPfUd4mympeA@mail.gmail.com>
 <CAE9FiQX=ECg5BmKm7B2ua_rZ6bOsceeHNsfFQRWBbNZx+8sBfw@mail.gmail.com>
 <20120525043651.GA1391@google.com> <CAE9FiQXvYH4zCqp_uOb2nw7jvm8B=q3yx1tCjJUT+PkdymYEuw@mail.gmail.com>
 <CAE9FiQW0rm2_sKdSCWs3TfatJB9yHwvmvt9_vBYMtOq_YBbmfw@mail.gmail.com>
 <20120525193716.GA8817@google.com> <CAE9FiQWrZaBpT1fzC_-mSBfDd4AKGrdGomPxVNSU-SFPrVNvOw@mail.gmail.com>
 <CAErSpo7d+zn-qgWKcbro7yneXRtmZQCOHi+kiGzYUTfs+aiF4g@mail.gmail.com>
 <CAE9FiQUWWO75WP3gYRwYbyO_ZiWwyjKnzMxOGhfjY4H98w2Hbw@mail.gmail.com>
 <CAErSpo46fCCFCijNfMzGYP__pP6hkPFurMS=1=wSAZsg5z0-Lg@mail.gmail.com>
 <CAE9FiQWUrkKEpLmEn9kzkKOtEtX7-R8shdVSKGgSyHezKpzJCw@mail.gmail.com>
 <4FC50E09.4000204@zytor.com> <CAE9FiQUtio=dut3A9+jCcsgUWEeNYcpqLP6RpqGOZUfPPAtHWw@mail.gmail.com>
 <CAErSpo4ywho4UmPVAjT7yZNROc9e1zCx+UoaS5un+v4aN=akJA@mail.gmail.com> <CAE9FiQWORRjxEQwr+933ReNAAKAEoJ5B6AWte4gr33_BO+4heQ@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 29 May 2012 17:24:44 -0600
Message-ID: <CAErSpo7+7fReDEzzgjonz76FD5MZFC5trPAiKZ8hLq5Wi2j13Q@mail.gmail.com>
Subject: Re: [PATCH 02/11] PCI: Try to allocate mem64 above 4G at first
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Newbury <steve@snewbury.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 2:40 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Tue, May 29, 2012 at 12:23 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Tue, May 29, 2012 at 12:17 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> On Tue, May 29, 2012 at 10:57 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>>> On 05/29/2012 10:55 AM, Yinghai Lu wrote:
>>>>>
>>>>> x86 are using 16bits.
>>>>>
>>>>> some others use 32 bits.
>>>>> #define IO_SPACE_LIMIT 0xffffffff
>>>>>
>>>>> ia64 and sparc are using 64bits.
>>>>> #define IO_SPACE_LIMIT               0xffffffffffffffffUL
>>>>>
>>>>> but pci only support 16bits and 32bits.
>>>>>
>>>>> maybe later we can add
>>>>> PCI_MAX_RESOURCE_16
>>>>>
>>>>> to handle 16bits and 32bit io ports.
>>>>>
>>>>
>>>> Shouldn't this be dealt by root port apertures?
>>>>
>>>
>>> pci bridge could support 16bits and 32bits io port.
>>> but we did not record if 32bits is supported.
>>>
>>> so during allocating, could have allocated above 64k address to non
>>> 32bit bridge.
>>>
>>> but  x86 is ok, because ioport.end always set to 0xffff.
>>> other arches with IO_SPACE_LIMIT with 0xffffffff or
>>> 0xffffffffffffffffUL may have problem.
>>
>> I think current IO_SPACE_LIMIT usage is a little confused.  The
>> "ioport_resource.end = IO_SPACE_LIMIT" in kernel/resource.c refers to
>> a CPU-side address, not a bus address.  Other uses, e.g., in
>> __pci_read_base(), apply it to bus addresses from BARs, which is
>> wrong.  Host bridges apply I/O port offsets just like they apply
>> memory offsets.  The ia64 IO_SPACE_LIMIT of 0xffffffffffffffffUL means
>> there's no restriction on CPU-side I/O port addresses, but any given
>> host bridge will translate its I/O port aperture to bus addresses that
>> fit in 32 bits.
>>
>> None of this is really relevant to the question I asked, namely, "why
>> Yinghai's patch doesn't limit I/O BAR values to 32 bits?"  That
>> constraint is clearly a requirement because I/O BARs are only 32 bits
>> wide, but I don't think it needs to be enforced in the code here.  The
>> host bridge or upstream P2P bridge apertures should already take care
>> of that automatically.  I don't think the 16- or 32-bitness of P2P
>> bridge apertures is relevant here, because the I/O resources available
>> on the secondary bus already reflect that.
>>
>> After all that discussion, I think my objection here boils down to
>> "you shouldn't change the I/O BAR constraints in a patch that claims
>> to allocate 64-bit *memory* BARs above 4GB."
>>
>> I think the code below is still the clearest way to set the constraints:
>>
>>   if (res->flags & IORESOURCE_MEM_64) {
>>       start = (resource_size_t) (1ULL << 32);
>>       end = PCI_MAX_RESOURCE;
>>   } else {
>>       start = 0;
>>       end = PCI_MAX_RESOURCE_32;
>>   }
>>
>> It's not strictly necessary to limit I/O BARs to PCI_MAX_RESOURCE_32
>> because host bridge apertures should already enforce that, but I think
>> the code above just makes it clearer.
>
>
> ok, please check the version, that put back PCI_MAX_RESOURCE_32 for io ports.

I like the fact that this patch no longer changes anything for I/O
resources.  I assume this is part of fixing some bug (Steven's?)  I'd
like to have a pointer in the changelog to a bugzilla or discussion
about the bug.

The effect of this patch is similar to what I did earlier with
b126b4703afa4 and e7f8567db9a7 (allocate space from top down), though
this one is more limited and it won't change quite as much.  We ran
into problems (BIOS defects, I think) and had to revert my patches, so
it's quite possible that we'll run into similar problems here.

I'm a little nervous because this is a fundamental area that explores
new areas of the address space minefield.  I think we're generally
safer if we  follow a path similar to where Windows has been.  I think
Windows also prefers space above 4GB for 64-bit BARs, but I suspect
that's just a natural consequence of allocating from the top down.  So
we'll place things just above 4GB, and Windows will place things as
high as possible.

I don't know the best solution here.  This patch ("bottom-up above
4GB") is one possibility.  Another is to allocate only 64-bit BARs
top-down.  Or maybe allocate everything top-down on machines newer
than some date.  They all seem ugly.  What makes me uneasy is that
your patch strikes out on a new path that is different from what we've
done before *and* different from what Windows does.
