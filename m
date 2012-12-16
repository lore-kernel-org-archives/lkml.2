Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab2LPRqY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 12:46:24 -0500
Received: from mga02.intel.com ([134.134.136.20]:2918 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940Ab2LPRpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 12:45:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,294,1355126400"; 
   d="scan'208";a="234790728"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "H Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Tigran Aivazian" <tigran@aivazian.fsnet.co.uk>,
        "Andreas Herrmann" <andreas.herrmann3@amd.com>,
        "Borislav Petkov" <borislav.petkov@amd.com>,
        "Yinghai Lu" <yinghai@kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>
Cc: "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH v3 09/10] x86/mm/init.c: Copy ucode from initrd image to memory
Date: Sun, 16 Dec 2012 02:43:28 -0800
Message-Id: <1355654609-16800-10-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1355654609-16800-1-git-send-email-fenghua.yu@intel.com>
References: <1355654609-16800-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Before initrd image is freed, copy valid ucode patches from initrd image
to kernel virtual memory. The saved ucode will be used to update AP in resume
or hotplug.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/mm/init.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index d7aea41..e5e7973 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -16,6 +16,7 @@
 #include <asm/tlb.h>
 #include <asm/proto.h>
 #include <asm/dma.h>		/* for MAX_DMA_PFN */
+#include <asm/microcode.h>
 
 unsigned long __initdata pgt_buf_start;
 unsigned long __meminitdata pgt_buf_end;
@@ -391,6 +392,15 @@ void free_initmem(void)
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

