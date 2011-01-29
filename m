Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab1A2Akb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 19:40:31 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:19330 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab1A2Aka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 19:40:30 -0500
Message-ID: <4D43615B.9060203@kernel.org>
Date: Fri, 28 Jan 2011 16:37:47 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH - resend] memblock: Don't adjust size in memblock_find_base()
References: <AANLkTikknHfA4TQw+SMH-EyJBHoNHXk8Rheq4=K4jNWA@mail.gmail.com> <alpine.DEB.2.00.1012291637270.6040@chino.kir.corp.google.com> <4D1BD928.50701@zytor.com> <alpine.DEB.2.00.1012291702180.7374@chino.kir.corp.google.com> <4D1BE615.4000700@zytor.com> <20101230090648.GB7306@elte.hu> <20101230102815.GA29822@elte.hu> <20101230103002.GA30020@elte.hu> <AANLkTimeqrLzDuqBoSvmkSJWMc7u3PeRf37vjzBca2Lh@mail.gmail.com> <AANLkTimpyRXS9dNFATh4GqtA46uynutAvK7Qb5S7WPFO@mail.gmail.com> <20110105134434.GA22816@elte.hu>
In-Reply-To: <20110105134434.GA22816@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


While applying patch to use memblock to find aperture for 64bit x86.
Ingo found system with 1g + force_iommu

> No AGP bridge found
> Node 0: aperture @ 38000000 size 32 MB
> Aperture pointing to e820 RAM. Ignoring.
> Your BIOS doesn't leave a aperture memory hole
> Please enable the IOMMU option in the BIOS setup
> This costs you 64 MB of RAM
> Cannot allocate aperture memory hole (0,65536K)

the corresponding code:
	addr = memblock_find_in_range(0, 1ULL<<32, aper_size, 512ULL<<20);
	if (addr == MEMBLOCK_ERROR || addr + aper_size > 0xffffffff) {
		printk(KERN_ERR
			"Cannot allocate aperture memory hole (%lx,%uK)\n",
				addr, aper_size>>10);
		return 0;
	}
	memblock_x86_reserve_range(addr, addr + aper_size, "aperture64")

it fails because memblock core code align the size with 512M. that could make
size way too big.

So don't align the size in that case.

actually __memblock_alloc_base, the another caller already align that before calling that function.

BTW. x86 does not use __memblock_alloc_base...

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 mm/memblock.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux-2.6/mm/memblock.c
===================================================================
--- linux-2.6.orig/mm/memblock.c
+++ linux-2.6/mm/memblock.c
@@ -137,8 +137,6 @@ static phys_addr_t __init_memblock membl
 
 	BUG_ON(0 == size);
 
-	size = memblock_align_up(size, align);
-
 	/* Pump up max_addr */
 	if (end == MEMBLOCK_ALLOC_ACCESSIBLE)
 		end = memblock.current_limit;
