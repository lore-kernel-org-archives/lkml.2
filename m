Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281Ab2JBQhp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 12:37:45 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52523 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab2JBQhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 12:37:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@infradead.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Krzysztof Halasa <khc@pm.waw.pl>,
        Daniel Silverstone <dsilvers@simtec.co.uk>,
        Ben Dooks <ben-linux@fluff.org>
Subject: [PATCH 16/17] ARM: ks8695: __arch_virt_to_dma type handling
Date: Tue,  2 Oct 2012 18:36:55 +0200
Message-Id: <1349195816-2225-17-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349195816-2225-1-git-send-email-arnd@arndb.de>
References: <1349195816-2225-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:ePFyVg6pDwSeJiUdayjvUymbrAjbKv1IBGCeuv6WIOK
 v0OvWUCFTCOl08P14Avo/aJTSZst3xpMIuDz+TObrKl3R0BjSb
 cuWUDMiRL8rqblzaxXNbuxfQg3tIuthkXBE0Fk2PsWLiw12U4a
 7/pUogjyPBVJzYtLjTHnO2lU7WyhO015/1SSuL5YFE7pRE6Y+X
 I7HWk+G9vjW1cp7/lmMiAuzOW4ASN+/hWKRGtMAFNbljQiZQHg
 7nEn1jllxxlKfiRa6gwodamHq/juzs7MCmKQPBWAwxjKf0vMwF
 nQcE12606kIHEiqd6P2nwrpJRhhdCPereIcoGwymC0Q8DJI/zH
 iuDxvWdkGnV/a4dsTsVZgo6i+LC4STB2v9X6E4ts4gP8UfBVFt
 yUlb4CuaVNP+Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__arch_virt_to_dma expects a virtual address pointer, but
the ks8695 implementation of this macro treats it as an
integer. Adding a type cast avoids hundreds of identical
warning messages.

Without this patch, building acs5k_defconfig results in:

arch/arm/include/asm/dma-mapping.h: In function 'virt_to_dma':
arch/arm/include/asm/dma-mapping.h:60:2: warning: passing argument 1 of '__virt_to_phys' makes integer from pointer without a cast [enabled by default]
arch/arm/include/asm/memory.h:172:60: note: expected 'long unsigned int' but argument is of type 'void *'
In file included from include/linux/dma-mapping.h:73:0,
                 from include/linux/skbuff.h:33,
                 from security/commoncap.c:21:

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Daniel Silverstone <dsilvers@simtec.co.uk>
Cc: Ben Dooks <ben-linux@fluff.org>
---
 arch/arm/mach-ks8695/include/mach/memory.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-ks8695/include/mach/memory.h b/arch/arm/mach-ks8695/include/mach/memory.h
index f7e1b9b..95e731a 100644
--- a/arch/arm/mach-ks8695/include/mach/memory.h
+++ b/arch/arm/mach-ks8695/include/mach/memory.h
@@ -34,7 +34,8 @@ extern struct bus_type platform_bus_type;
 #define __arch_dma_to_virt(dev, x)	({ (void *) (is_lbus_device(dev) ? \
 					__phys_to_virt(x) : __bus_to_virt(x)); })
 #define __arch_virt_to_dma(dev, x)	({ is_lbus_device(dev) ? \
-					(dma_addr_t)__virt_to_phys(x) : (dma_addr_t)__virt_to_bus(x); })
+					(dma_addr_t)__virt_to_phys((unsigned long)x) \
+					: (dma_addr_t)__virt_to_bus(x); })
 #define __arch_pfn_to_dma(dev, pfn)	\
 	({ dma_addr_t __dma = __pfn_to_phys(pfn); \
 	   if (!is_lbus_device(dev)) \
-- 
1.7.10

