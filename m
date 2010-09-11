Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab0IKHHl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 03:07:41 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:49395 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069Ab0IKHHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 03:07:40 -0400
Message-ID: <4C8B2A9A.1040303@kernel.org>
Date: Sat, 11 Sep 2010 00:07:06 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Michal Simek <monstr@monstr.eu>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] microblaze, memblock: fix compiling
References: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>	 <1281071724-28740-9-git-send-email-benh@kernel.crashing.org>	 <4C5BCD41.3040501@monstr.eu> <1281135046.2168.40.camel@pasglop>	 <4C88BD8F.5080208@monstr.eu>  <20100909115445.GB16157@elte.hu> <1284106711.6515.46.camel@pasglop>
In-Reply-To: <1284106711.6515.46.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

  CC      arch/microblaze/mm/init.o
arch/microblaze/mm/init.c: In function 'mm_cmdline_setup':
arch/microblaze/mm/init.c:236: error: 'struct memblock_type' has no member named 'region'
arch/microblaze/mm/init.c: In function 'mmu_init':
arch/microblaze/mm/init.c:279: error: 'struct memblock_type' has no member named 'region'
arch/microblaze/mm/init.c:284: error: 'struct memblock_type' has no member named 'region'
arch/microblaze/mm/init.c:285: error: 'struct memblock_type' has no member named 'region'
arch/microblaze/mm/init.c:286: error: 'struct memblock_type' has no member named 'region'
make[1]: *** [arch/microblaze/mm/init.o] Error 1
make: *** [arch/microblaze/mm] Error 2

with this fix and microblaze can boot

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Index: linux-2.6/arch/microblaze/mm/init.c
===================================================================
--- linux-2.6.orig/arch/microblaze/mm/init.c
+++ linux-2.6/arch/microblaze/mm/init.c
@@ -228,7 +228,7 @@ static void mm_cmdline_setup(void)
 		if (maxmem && memory_size > maxmem) {
 			memory_size = maxmem;
 			memory_end = memory_start + memory_size;
-			memblock.memory.region[0].size = memory_size;
+			memblock.memory.regions[0].size = memory_size;
 		}
 	}
 }
@@ -271,14 +271,14 @@ asmlinkage void __init mmu_init(void)
 		machine_restart(NULL);
 	}
 
-	if ((u32) memblock.memory.region[0].size < 0x1000000) {
+	if ((u32) memblock.memory.regions[0].size < 0x1000000) {
 		printk(KERN_EMERG "Memory must be greater than 16MB\n");
 		machine_restart(NULL);
 	}
 	/* Find main memory where the kernel is */
-	memory_start = (u32) memblock.memory.region[0].base;
-	memory_end = (u32) memblock.memory.region[0].base +
-				(u32) memblock.memory.region[0].size;
+	memory_start = (u32) memblock.memory.regions[0].base;
+	memory_end = (u32) memblock.memory.regions[0].base +
+				(u32) memblock.memory.regions[0].size;
 	memory_size = memory_end - memory_start;
 
 	mm_cmdline_setup(); /* FIXME parse args from command line - not used */
