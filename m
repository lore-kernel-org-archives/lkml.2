Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab1IOBW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 21:22:26 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:40568 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab1IOBWZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 21:22:25 -0400
MIME-Version: 1.0
In-Reply-To: <1315839130.3466.6.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1314860114.32522.3.camel@rui>
	<1314864889.13161.4.camel@rui>
	<1314880125.8038.39.camel@mfleming-mobl1.ger.corp.intel.com>
	<CAC=cRTOzcgm+3kHGcZrHs=9Q3cs5z6vmBqb1Bn+2qcvcSZ-2Xg@mail.gmail.com>
	<1315839130.3466.6.camel@mfleming-mobl1.ger.corp.intel.com>
Date: Thu, 15 Sep 2011 09:22:24 +0800
X-Google-Sender-Auth: zGMPwdkFS-dS0mq4cgP-crjlx3s
Message-ID: <CANejiEXSvT1hGasoowf1nCc5+EWyXr8PSmfpWDJOT0d_vEiKxA@mail.gmail.com>
Subject: Re: [PATCH] EFI: Do not use __pa() to get the physical address of an
 ioremapped memory range
From: Shaohua Li <shli@kernel.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: huang ying <huang.ying.caritas@gmail.com>, Zhang Rui <rui.zhang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/12 Matt Fleming <matt@console-pimps.org>:
> On Fri, 2011-09-02 at 13:12 +0800, huang ying wrote:
>> On Thu, Sep 1, 2011 at 8:28 PM, Matt Fleming <matt@console-pimps.org> wrote:
>> >
>> > Hmm.. does anyone know why we ioremap_cache() the memory on
>> > CONFIG_X86_32 instead of ioremap_nocache()? In the case of
>> > EFI_MEMORY_MAPPED_IO the memory really needs to be uncached. Then if
>> > we've ioremap'd the memory we should skip set_memory_uc() altogether,
>> > no?
>>
>> Because whether the mapping should be cached is determined by md->attr
>> instead of md->type.  And besides UC, we may add WC, etc support.
>
> Confused.
>
> The CONFIG_X86_64 version of efi_ioremap() looks like this,
>
> void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
>                                 u32 type)
> {
>        unsigned long last_map_pfn;
>
>        if (type == EFI_MEMORY_MAPPED_IO)
>                return ioremap(phys_addr, size);
>
> Which uses md->type to figure out if we should call ioremap(), which on
> x86 is #define'd to ioremap_nocache(). CONFIG_X86_32 doesn't do this,
> but it looks to me like it should.
agree. mapping it wrong and fixing it later makes no sense. we should get
the mapping correct at the first.

> Zhang, I agree that calling __pa() on an ioremap()'d region is bogus,
> but I don't understand why no one is seeing this crash on x86-64. Is it
> something to do with the x86-64 memory map layout such that __pa() works
> on an ioremap()'d address?
x86-64 does identity mapping for larger space (from 0 to the last physical mem
even there is hole). Maybe this is the reason.
