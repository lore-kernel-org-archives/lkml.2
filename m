Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834Ab2EYWPS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 18:15:18 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:42059 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab2EYWPO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 18:15:14 -0400
MIME-Version: 1.0
In-Reply-To: <4FC0009C.5000704@zytor.com>
References: <1337754877-19759-1-git-send-email-yinghai@kernel.org>
 <1337754877-19759-3-git-send-email-yinghai@kernel.org> <CA+55aFzd1BWqidt95qZLc1x_YU=WeGS=mKUOMvO_3omOhc_5VA@mail.gmail.com>
 <CAE9FiQXx_x9M5ncLk4DyL8heYQTcsHZt2JofFMjPfUd4mympeA@mail.gmail.com>
 <CAE9FiQX=ECg5BmKm7B2ua_rZ6bOsceeHNsfFQRWBbNZx+8sBfw@mail.gmail.com>
 <20120525043651.GA1391@google.com> <CAE9FiQXvYH4zCqp_uOb2nw7jvm8B=q3yx1tCjJUT+PkdymYEuw@mail.gmail.com>
 <CAE9FiQW0rm2_sKdSCWs3TfatJB9yHwvmvt9_vBYMtOq_YBbmfw@mail.gmail.com>
 <20120525193716.GA8817@google.com> <CAE9FiQWrZaBpT1fzC_-mSBfDd4AKGrdGomPxVNSU-SFPrVNvOw@mail.gmail.com>
 <CAErSpo7d+zn-qgWKcbro7yneXRtmZQCOHi+kiGzYUTfs+aiF4g@mail.gmail.com> <4FC0009C.5000704@zytor.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 25 May 2012 16:14:53 -0600
Message-ID: <CAErSpo5-Wypc8LMfgE51=Ob0UV1ky9QxKTtaAigU8YyNcXxiQw@mail.gmail.com>
Subject: Re: [PATCH 02/11] PCI: Try to allocate mem64 above 4G at first
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
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

On Fri, May 25, 2012 at 3:58 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 05/25/2012 02:55 PM, Bjorn Helgaas wrote:
>>
>> I think we actually have a separate bug here.  On 64-bit non-x86
>> architectures, PCIBIOS_MAX_MEM_32 is a 64-bit -1, so the following
>> attempt to avoid putting a 32-bit BAR above 4G only works on x86,
>> where PCIBIOS_MAX_MEM_32 is 0xffffffff.
>>
>>         /* don't allocate too high if the pref mem doesn't support 64bit*/
>>         if (!(res->flags & IORESOURCE_MEM_64))
>>                 max = PCIBIOS_MAX_MEM_32;
>>
>> I think we should fix this with a separate patch that removes
>> PCIBIOS_MAX_MEM_32 altogether, replacing this use with an explicit
>> 0xffffffff (or some other "max 32-bit value" symbol).  I don't think
>> there's anything arch-specific about this.
>>
>> So I'd like to see two patches here:
>>   1) Avoid allocating 64-bit regions for 32-bit BARs
>>   2) Try to allocate regions above 4GB for 64-bit BARs
>
> Do we also need to track the maximum address available to the CPU?

We are allocating from the resources available on this bus, which
means the host bridge apertures or a subset.  If the arch supplies
those, that should be enough.  If it doesn't, we default to
iomem_resource.  On x86, we trim that down to only the supported
address space:

        iomem_resource.end = (1ULL << boot_cpu_data.x86_phys_bits) - 1;

But I'm sure some other architectures don't do that yet.  I guess
that's one of the risks -- if an arch is doesn't tell us the apertures
and doesn't trim iomem_resource, we could allocate a non-addressable
region.

Bjorn
