Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab2K3IuG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 03:50:06 -0500
Received: from mga01.intel.com ([192.55.52.88]:40531 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755879Ab2K3It3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 03:49:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,191,1355126400"; 
   d="scan'208";a="255459094"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "H Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Tigran Aivazian" <tigran@aivazian.fsnet.co.uk>,
        "Andreas Herrmann" <andreas.herrmann3@amd.com>,
        "Borislav Petkov" <borislav.petkov@amd.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>
Cc: "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH v2 09/10] x86/mm/init.c: Copy ucode from initrd image to memory
Date: Thu, 29 Nov 2012 17:47:47 -0800
Message-Id: <1354240068-9821-10-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1354240068-9821-1-git-send-email-fenghua.yu@intel.com>
References: <1354240068-9821-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Before initrd image is freed, copy valid ucode patches from initrd image
to kernel virtual memory. The saved ucode will be used to update AP in resume.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/mm/init.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index d7aea41..a294d4b 100644
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
+	save_microcode_in_initrd(&mc_saved_data, mc_saved_in_initrd);
+#endif
+
 	/*
 	 * end could be not aligned, and We can not align that,
 	 * decompresser could be confused by aligned initrd_end
-- 
1.7.2

