Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933470Ab1EXVjn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:39:43 -0400
Received: from service87.mimecast.com ([94.185.240.25]:34608 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932767Ab1EXVjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:39:40 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH v6 03/18] ARM: LPAE: Use unsigned long for __phys_to_virt and __virt_to_phys
Date: Tue, 24 May 2011 22:39:09 +0100
Message-Id: <1306273164-18217-4-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.4.2.g597a6
In-Reply-To: <1306273164-18217-1-git-send-email-catalin.marinas@arm.com>
References: <1306273164-18217-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 24 May 2011 21:39:45.0224 (UTC) FILETIME=[1917D480:01CC1A5B]
X-MC-Unique: 111052422393702801
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id p4OLhR9b005094

The !CONFIG_ARM_PATCH_PHYS_VIRT case uses macros for __phys_to_virt and
__virt_to_phys but does not use any type casting. This causes compiler
warnings with LPAE where the phys_addr_t and dma_addr_t are 64-bit:

  CC      arch/arm/mm/dma-mapping.o
In file included from /work/Linux/linux-marc/include/linux/dma-mapping.h:93:0,
                 from /work/Linux/linux-marc/arch/arm/mm/dma-mapping.c:19:
/work/Linux/linux-marc/arch/arm/include/asm/dma-mapping.h: In function 'dma_to_virt':
/work/Linux/linux-marc/arch/arm/include/asm/dma-mapping.h:35:9: warning:
        cast to pointer from integer of different size

Note that these macros are only valid for lowmem physical addresses
where the range is within 32-bit address range.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/include/asm/memory.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
index 431077c..10e4b4c 100644
--- a/arch/arm/include/asm/memory.h
+++ b/arch/arm/include/asm/memory.h
@@ -194,8 +194,8 @@ static inline unsigned long __phys_to_virt(unsigned long x)
 	return t;
 }
 #else
-#define __virt_to_phys(x)	((x) - PAGE_OFFSET + PHYS_OFFSET)
-#define __phys_to_virt(x)	((x) - PHYS_OFFSET + PAGE_OFFSET)
+#define __virt_to_phys(x)	((unsigned long)(x) - PAGE_OFFSET + PHYS_OFFSET)
+#define __phys_to_virt(x)	((unsigned long)(x) - PHYS_OFFSET + PAGE_OFFSET)
 #endif
 #endif
 

