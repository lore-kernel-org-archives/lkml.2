Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab1IOD2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 23:28:54 -0400
Received: from mail-vw0-f45.google.com ([209.85.212.45]:55956 "EHLO
	mail-vw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026Ab1IOD2x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 23:28:53 -0400
X-Greylist: delayed 459 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Sep 2011 23:28:53 EDT
MIME-Version: 1.0
In-Reply-To: <1316051535.15084.5.camel@rui>
References: <1314860114.32522.3.camel@rui>
	<1314864889.13161.4.camel@rui>
	<1314880125.8038.39.camel@mfleming-mobl1.ger.corp.intel.com>
	<CAC=cRTOzcgm+3kHGcZrHs=9Q3cs5z6vmBqb1Bn+2qcvcSZ-2Xg@mail.gmail.com>
	<1315839130.3466.6.camel@mfleming-mobl1.ger.corp.intel.com>
	<CANejiEXSvT1hGasoowf1nCc5+EWyXr8PSmfpWDJOT0d_vEiKxA@mail.gmail.com>
	<1316051535.15084.5.camel@rui>
Date: Thu, 15 Sep 2011 11:21:13 +0800
Message-ID: <CAC=cRTO8LKSOq-Div=QeyqRvbbB6WFgM3vjYWesCS7OPk+PaZw@mail.gmail.com>
Subject: Re: [PATCH] EFI: Do not use __pa() to get the physical address of an
 ioremapped memory range
From: huang ying <huang.ying.caritas@gmail.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Shaohua Li <shli@kernel.org>, Matt Fleming <matt@console-pimps.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 9:52 AM, Zhang Rui <rui.zhang@intel.com> wrote:
> On Thu, 2011-09-15 at 09:22 +0800, Shaohua Li wrote:
>> 2011/9/12 Matt Fleming <matt@console-pimps.org>:
>> > On Fri, 2011-09-02 at 13:12 +0800, huang ying wrote:
>> >> On Thu, Sep 1, 2011 at 8:28 PM, Matt Fleming <matt@console-pimps.org> wrote:
>> >> >
>> >> > Hmm.. does anyone know why we ioremap_cache() the memory on
>> >> > CONFIG_X86_32 instead of ioremap_nocache()? In the case of
>> >> > EFI_MEMORY_MAPPED_IO the memory really needs to be uncached. Then if
>> >> > we've ioremap'd the memory we should skip set_memory_uc() altogether,
>> >> > no?
>> >>
>> >> Because whether the mapping should be cached is determined by md->attr
>> >> instead of md->type.  And besides UC, we may add WC, etc support.
>> >
>> > Confused.
>> >
>> > The CONFIG_X86_64 version of efi_ioremap() looks like this,
>> >
>> > void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
>> >                                 u32 type)
>> > {
>> >        unsigned long last_map_pfn;
>> >
>> >        if (type == EFI_MEMORY_MAPPED_IO)
>> >                return ioremap(phys_addr, size);
>> >
>> > Which uses md->type to figure out if we should call ioremap(), which on
>> > x86 is #define'd to ioremap_nocache(). CONFIG_X86_32 doesn't do this,
>> > but it looks to me like it should.
>> agree. mapping it wrong and fixing it later makes no sense. we should get
>> the mapping correct at the first.
>>
> So what kinds of memory regions need ioremap_nocache?
> should we make this decision based on the memory range type or attribute
> or even both of them?

I think the decision should be made based on attribute as follow:

- attribute & EFI_MEMORY_WB --> ioremap_cache
- attribute & EFI_MEMORY_WC --> ioremap_wc
- others -> ioremap_nocache

init_memory_mapping in efi_ioremap is used to make kexec support
possible.  But ioremap is used anyway, kexec support should be done in
another way.  So I think it is ok to just use ioremap_xxx in
efi_ioremap.  The efi_ioremap definition for 32bit need to be fixed
too.

Best Regards,
Huang Ying
