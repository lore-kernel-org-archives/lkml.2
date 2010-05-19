Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757702Ab0ESLbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 07:31:09 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:58543 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754347Ab0ESLbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 07:31:06 -0400
Date: Wed, 19 May 2010 13:31:02 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Andr?? Goddard Rosa <andre.goddard@gmail.com>,
       Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH] [x86] NUMA implied when DISCONTIGMEM
Message-ID: <20100519113101.GA4218@faui49.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

	As part of the VAMOS[0] research project at the University of
Erlangen we are looking at multiple integrity errors in linux'
configuration system.

	x86 Kconfig implies NUMA if DISCONTIGMEM is selected (the
dependency is as [1] -- excerpt from our tool's output) meaning a
check for NUMA inside a DISCONTIGMEM is useless (in x86 specific code
not in general), so this part can be simplified as in the below patch.

	Please keep me informed of this patch getting confirmed /
merged so we can keep track of it.

Regards

	Christoph Egger

[0] http://vamos1.informatik.uni-erlangen.de/
[1]
 (DISCONTIGMEM -> !SELECT_MEMORY_MODEL & ARCH_DISCONTIGMEM_ENABLE |DISCONTIGMEM_MANUAL)
 &
 (DISCONTIGMEM_MANUAL -> CHOICE_11 & ARCH_DISCONTIGMEM_ENABLE)
 &
 (ARCH_DISCONTIGMEM_ENABLE -> NUMA & X86_32)
[2]
 config ARCH_DISCONTIGMEM_ENABLE
    def_bool y
    depends on NUMA && X86_32
----
>From e1e14a373f7ec346c0c51f36713c4a60d087f573 Mon Sep 17 00:00:00 2001
From: Christoph Egger <siccegge@cs.fau.de>
Date: Wed, 19 May 2010 13:11:30 +0200
Subject: [PATCH] on x86 NUMA is implied on DISCONTIGMEM

There's a specialization on whether NUMA is selected inside a ifdef
CONFIG_DISCONTIGMEM block in arch/x86/include/asm/mmzone_32.h, however
the Kconfig model for x86 only alows DISCONTIGMEM when NUMA is set so
the !NUMA block is effectively unreachable.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 arch/x86/include/asm/mmzone_32.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/mmzone_32.h b/arch/x86/include/asm/mmzone_32.h
index 91df7c5..993ed50 100644
--- a/arch/x86/include/asm/mmzone_32.h
+++ b/arch/x86/include/asm/mmzone_32.h
@@ -61,11 +61,7 @@ extern s8 physnode_map[];
 
 static inline int pfn_to_nid(unsigned long pfn)
 {
-#ifdef CONFIG_NUMA
 	return((int) physnode_map[(pfn) / PAGES_PER_ELEMENT]);
-#else
-	return 0;
-#endif
 }
 
 /*
-- 
1.6.3.3






