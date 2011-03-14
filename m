Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab1CNMhy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 08:37:54 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36908 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab1CNMhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 08:37:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=edVpVcnx0emvvWtSVqSlVDPbCyRx7rIlv45ZN3aO3b5l4M1m/VzvzpknBi2Urr6Nmh
         r/+bTRLrdjb8EQ+FqbWMy513bpZ8Urh0N15dago6xAQyr0coIGF7eXek5hVrIcWwD11r
         +9g/Gfma5IR3DgBq5DnJkGK99Sg6InxGMSEkQ=
MIME-Version: 1.0
In-Reply-To: <201103111700.17373.arnd@arndb.de>
References: <1299229274-9753-4-git-send-email-m.szyprowski@samsung.com>
	<201103111615.01829.arnd@arndb.de>
	<000201cbe002$768d9de0$63a8d9a0$%szyprowski@samsung.com>
	<201103111700.17373.arnd@arndb.de>
Date: Mon, 14 Mar 2011 21:37:51 +0900
X-Google-Sender-Auth: LxjztE8xmRIW1a_UnMXxe_qaKPE
Message-ID: <AANLkTimagS1vBXEYjXQDx=OGhTRm=n0yO4n+kHTAqBOz@mail.gmail.com>
Subject: Re: [PATCH 3/7] ARM: Samsung: update/rewrite Samsung SYSMMU (IOMMU) driver
From: KyongHo Cho <pullip.cho@samsung.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Tomasz Stanislawski <t.stanislaws@samsung.com>, k.debski@samsung.com,
        kgene.kim@samsung.com, kyungmin.park@samsung.com,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        =?EUC-KR?B?tOvAzrHi?= <inki.dae@samsung.com>,
        =?EUC-KR?B?sK25zrHU?= <mk7.kang@samsung.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/12 Arnd Bergmann <arnd@arndb.de>:
> On Friday 11 March 2011, Marek Szyprowski wrote:
>> > > > does not support IOMMUs, but that could be changed by wrapping it
>> > > > using the include/asm-generic/dma-mapping-common.h infrastructure.
>> > >
>> > > ARM dma-mapping framework also requires some additional research for better DMA
>> > > support (there are still issues with multiple mappings to be resolved).
>> >
>> > You mean mapping the same memory into multiple devices, or a different problem?
>>
>> Mapping the same memory area multiple times with different cache settings is not
>> legal on ARMv7+ systems. Currently the problems might caused by the low-memory
>> kernel linear mapping and second mapping created for example by dma_alloc_coherent()
>> function.
>
> Yes, I know this problem, but I don't think the case you describe is a serious
> limitation (there are more interesting cases, though): dma_map_single() etc
> will create additional *bus* addresses for a physical address, not additional
> virtual addresses.
>
> dma_alloc_coherent should allocate memory that is not also mapped cached,
> which is what I thought we do correctly.

I have also noticed that dma_map_single/page/sg() can map physical
memory into an arbitrary device address region.
But it is not enough solution for various kinds of IOMMUs.
As Kukjin Kim addressed, we need to support larger page size than 4KB
because we can reduce TLB miss when we have larger page size.

Our IOMMU(system mmu) supports all page size of ARM architecture
including 16MB, 1MB, 64KB and 4KB.
Since the largest size supported by buddy system of 32-bit architecture is 4MB,
our system support all page sizes except 16MB.
We proved that larger page size is helpful for DMA performance
significantly (more than 10%, approximately).
Big page size is not a problem for peripheral devices
because their address space is not suffer from external fragmentation.

Thanks to Arnd, I never knew about include/linux/iommu.h

Similar to dma-mappings.h, however, It is not enough for our
requirements even though it allows private data to be stored in
iommu_domain for platform-specific requirements.

I think we can consider another solution for the various requirements.
I think one of the most possible solutions is VCMM.
Or we can enhance include/linux/iommu.h with reference of VCMM.

You can find the most recent VCMM submitted at
http://marc.info/?l=linux-kernel&m=129255948319341&w=2

It looks somewhat complex but includes most of required features for
various IOMMUs
which will not be easily solved by include/linux/iommu.h

You can find VCMM core in
http://git.kernel.org/?p=linux/kernel/git/kki_ap/linux-2.6-samsung.git;a=blob;f=mm/vcm.c;h=9fff0106ec0078fad1488308305c8486adbed9c0;hb=refs/heads/2.6.36-samsung

and platform specific implementation of VCMM in
http://git.kernel.org/?p=linux/kernel/git/kki_ap/linux-2.6-samsung.git;a=blob;f=arch/arm/plat-s5p/s5p-vcm.c;h=7498c800aef8b01082e1b1c3ea0f66cefe3c85a1;hb=refs/heads/2.6.36-samsung

Cho KyongHo.
