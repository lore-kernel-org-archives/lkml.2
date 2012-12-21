Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab2LUOsw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 09:48:52 -0500
Received: from mga03.intel.com ([143.182.124.21]:45293 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203Ab2LUOrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 09:47:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,329,1355126400"; 
   d="scan'208";a="235197575"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "H Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Tigran Aivazian" <tigran@aivazian.fsnet.co.uk>,
        "Yinghai Lu" <yinghai@kernel.org>,
        "Andreas Herrmann" <andreas.herrmann3@amd.com>,
        "Borislav Petkov" <borislav.petkov@amd.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>
Cc: "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH v5 11/12] x86/mm/init.c: Copy ucode from initrd image to kernel memory
Date: Thu, 20 Dec 2012 23:44:31 -0800
Message-Id: <1356075872-3054-12-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1356075872-3054-1-git-send-email-fenghua.yu@intel.com>
References: <1356075872-3054-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Before initrd image is freed, copy valid ucode patches from initrd image
to kernel memory. The saved ucode will be used to update AP in resume
or hotplug.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/mm/init.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 5f59473..36bad16 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -16,6 +16,7 @@
 #include <asm/tlb.h>
 #include <asm/proto.h>
 #include <asm/dma.h>		/* for MAX_DMA_PFN */
+#include <asm/microcode.h>
 
 #include "mm_internal.h"
 
@@ -555,6 +556,15 @@ void free_initmem(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void __init free_initrd_mem(unsigned long start, unsigned long end)
 {
+#ifdef CONFIG_MICROCODE_EARLY
+	/*
+	 * Remember, initrd memory may contain microcode or other useful things.
+	 * Before we lose initrd mem, we need to find a place to hold them
+	 * now that normal virtual memory is enabled.
+	 */
+	save_microcode_in_initrd();
+#endif
+
 	/*
 	 * end could be not aligned, and We can not align that,
 	 * decompresser could be confused by aligned initrd_end
-- 
1.8.0.1

