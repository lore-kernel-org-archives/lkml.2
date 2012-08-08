Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933010Ab2HHVaq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 17:30:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57635 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab2HHV2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 17:28:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 02/10] ARM: ks8695: __arch_virt_to_dma type handling
Date: Wed,  8 Aug 2012 23:27:50 +0200
Message-Id: <1344461278-28245-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1344461278-28245-1-git-send-email-arnd@arndb.de>
References: <1344461278-28245-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:3Fsq7q2b9FTgdaNQGjXUaA5Ldo5tpv4TJEmC8WDDLVu
 9X6AcWOgeSsk664zEvXhZLx1jUqrFw6FFI2/M+eNwdM3sPq/t9
 6QhJhDr6AxVrj4sgoV3nHqX43tAsCcGdrXBeOziwXt2X8J/+yX
 082Lak86NWg32l/EzwjYC0+t4YPmdDXfN3JIplB4ecv8KDuxZF
 q/L3+7ySKhGJUSVEvmqaBTHS75T6cbyCRO6FbwDPKSP78scec0
 QiGhWpx89+SZ+ljiAy56ow9zzIDoq8Phoy2s71Lwmm+GMDMRiz
 KKJhCoys/jVa1Eqcn06i7QEzW/9ojCDDYoZ+WrBJOA6IfujSDe
 q8qzN0G5mM8u+dSLuGR+jOs7H9FTldKpxrlw8Y/XX+XK5JrtkT
 Dd9azYEObmTcw==
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

