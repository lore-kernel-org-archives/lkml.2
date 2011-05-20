Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397Ab1ETXYB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 19:24:01 -0400
Received: from 173-160-34-133-colorado.hfc.comcastbusiness.net ([173.160.34.133]:46905
	"EHLO ether.astekcorp.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754331Ab1ETXXz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 19:23:55 -0400
From: Dave Carroll <dcarroll@astekcorp.com>
To: "'Benjamin Herrenschmidt'" <benh@kernel.crashing.org>
CC: "LPPC (E-mail)" <linuxppc-dev@lists.ozlabs.org>,
        "Paul Mackerras (E-mail)" <paulus@samba.org>,
        "LKML (E-mail)" <linux-kernel@vger.kernel.org>
Date: Fri, 20 May 2011 17:23:36 -0600
Subject: RE: [PATCH v2]powerpc: Force page alignment for initrd
Thread-Topic: [PATCH v2]powerpc: Force page alignment for initrd
Thread-Index: AcwXPS5vXg0enTUJRsiXIpqszo4+FgABcGsA
Message-ID: <522F24EF533FC546962ECFA2054FF777373072AB72@MAILSERVER2.cos.astekcorp.com>
In-Reply-To: <1305930459.7481.194.camel@pasglop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When using 64K pages with a separate cpio rootfs, U-Boot will align the rootfs
on a 4K page boundary. When the memory is reserved, and subsequent early
memblock_alloc is called, it will allocate memory between the 64K page alignment
and reserved memory. When the reserved memory is subsequently freed, it is done
so by pages, causing the early memblock_alloc requests to be re-used, which in
my case, caused the device-tree to be clobbered.

This patch forces initrd to be kernel page aligned, to match the mechanism used
to free reserved memory.

Signed-off-by: Dave Carroll <dcarroll@astekcorp.com>
---
 arch/powerpc/kernel/prom.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index 48aeb55..7e58f6b 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -555,7 +555,8 @@ static void __init early_reserve_mem(void)
 #ifdef CONFIG_BLK_DEV_INITRD
        /* then reserve the initrd, if any */
        if (initrd_start && (initrd_end > initrd_start))
-               memblock_reserve(__pa(initrd_start), initrd_end - initrd_start);
+               memblock_reserve(_ALIGN_DOWN(__pa(initrd_start), PAGE_SIZE),
+                       PAGE_ALIGN(initrd_end) - _ALIGN_DOWN(initrd_start, PAGE_SIZE));
 #endif /* CONFIG_BLK_DEV_INITRD */

 #ifdef CONFIG_PPC32
--
1.7.4
