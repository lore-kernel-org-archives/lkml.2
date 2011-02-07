Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab1BGXwU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 18:52:20 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:25136 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177Ab1BGXwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 18:52:19 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 01/11] memblock: Don't adjust size in memblock_find_base()
Date: Mon,  7 Feb 2011 15:17:02 -0800
Message-Id: <1297120632-24933-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297120632-24933-1-git-send-email-yinghai@kernel.org>
References: <1297120632-24933-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4D508587.0043,ss=1,fgs=0
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

it failes because memblock core code align the size with 512M. that could make
size way too big.

So don't align the size in that case.

acctually __memblock_alloc_base, the another caller already align that before calling that function.

BTW. x86 does not use __memblock_alloc_base...

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 mm/memblock.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index bdba245..4618fda 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -137,8 +137,6 @@ static phys_addr_t __init_memblock memblock_find_base(phys_addr_t size,
 
 	BUG_ON(0 == size);
 
-	size = memblock_align_up(size, align);
-
 	/* Pump up max_addr */
 	if (end == MEMBLOCK_ALLOC_ACCESSIBLE)
 		end = memblock.current_limit;
-- 
1.7.1

