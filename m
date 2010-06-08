Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab0FHGWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 02:22:25 -0400
Received: from compulab.co.il ([67.18.134.219]:58924 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753034Ab0FHGWX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 02:22:23 -0400
Message-ID: <4C0DE165.5010206@compulab.co.il>
Date: Tue, 08 Jun 2010 09:21:25 +0300
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.23 (X11/20100106)
MIME-Version: 1.0
To: Marek Vasut <marek.vasut@gmail.com>
CC: Mike Rapoport <mike.rapoport@gmail.com>,
       linux-arm-kernel@lists.infradead.org,
       Maharajan <maharajan@e-consystems.com>,
       Eric Miao <eric.y.miao@gmail.com>, linux-kernel@vger.kernel.org,
       balakrishnan <balakrishnan@e-consystems.com>
Subject: Re: pxa300 - DDRAM base value
References: <1275371058.7001.35.camel@balakrishnan-desktop>	<1275892191.3501.17.camel@balakrishnan-desktop>	<AANLkTinKc9Uc6QeKYogK3h1kHsOU1p6Qp1kWgn0J8cMA@mail.gmail.com> <201006072143.16136.marek.vasut@gmail.com>
In-Reply-To: <201006072143.16136.marek.vasut@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marek Vasut wrote:
> Dne Po 7. června 2010 21:37:16 Mike Rapoport napsal(a):
>>> hi,
>>>       Now, I can able to boot after editing following files
>>> arch/arm/mach-pxa/Makefile.boot and
>>> arch/arm/mach/pxa/include/mach/memory.h (0x80000000 changed to
>>> 0xa0000000). My doubt is
>>> 1.why 0x80000000 (DDR phy address) is aliased to 0xa0000000 in pxa
>>> architecture?
>>> 2.In my development board two DDRAMs mapped at 0x80000000-0x88000000 and
>>> 0xc0000000-0xc8000000, how can I inform to kernel about this different
>>> bank and size?.
>> enable CONFIG_HIGHMEM
> 
> Mike, that wont help him as he has PHYS_OFFSET=0xa0000000 . Selecting 
> CONFIG_HIGHMEM will only cause the pages for RAM below 0xa0000000 to have 
> incorrectly computated descriptor addresses (or maybe will be ignored).
> 
> The page descriptors for RAM at PA 0xa0000000 are at VA 0xc0000000 + some offset 
> (there's an easy linear formula to compute their offset). Now if you feed that 
> formula with 0x80000000, the page descriptors will end below 0xc0000000, which 
> isn't a valid VA, therefore the descriptors will not be valid either (in the 
> better case, but it will hang the kernel at early stage anyway).
> 
> Therefore there are two ways -- either use what I suggested earlier or wait 
> until the PHYS_OFFSET is dynamically computated (check Eric's patchset).

Not quite. I have it working with CONFIG_HIGHMEM, I've just forgotten 
about cm_x300_fixup:

static void __init cm_x300_fixup(struct machine_desc *mdesc, struct tag 
*tags,
                                  char **cmdline, struct meminfo *mi)
{
         /* Make sure that mi->bank[0].start = PHYS_ADDR */
         for (; tags->hdr.size; tags = tag_next(tags))
                 if (tags->hdr.tag == ATAG_MEM &&
                         tags->u.mem.start == 0x80000000) {
                         tags->u.mem.start = 0xa0000000;
                         break;
                 }
}


> Cheers
>>> My Boot loader details,
>>> ------------------------------
>>> =>bdi
>>> arch_number = 0x00000B04
>>> env_t       = 0x00000000
>>> boot_params = 0x80000100
>>> DRAM bank   = 0x00000000
>>> -> start    = 0x80000000
>>> -> size     = 0x08000000
>>> DRAM bank   = 0x00000001
>>> -> start    = 0xC0000000
>>> -> size     = 0x08000000
>>> ethaddr     = 08:00:3e:26:0a:5b
>>> ip_addr     = 192.168.0.21
>>> baudrate    = 115200 bps
>>> =>ver
>>> U-Boot 2010.03 (Jun 01 2010 - 14:27:43)
>>>
>>>
>>> With Thanks
>>> J.Balakrishnan
>>> _______________________________________________
>>> linux-arm-kernel mailing list
>>> linux-arm-kernel@lists.infradead.org
>>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel


-- 
Sincerely yours,
Mike.
