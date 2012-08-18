Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab2HRIbw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 04:31:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:4511 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158Ab2HRIaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 04:30:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,790,1336374000"; 
   d="scan'208";a="182264784"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "H Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Tigran Aivazian" <tigran@aivazian.fsnet.co.uk>,
        "Andreas Herrmann" <andreas.herrmann3@amd.com>,
        "Borislav Petkov" <borislav.petkov@amd.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>
Cc: "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 10/11] x86/mm/init.c: Copy ucode from initrd image to memory
Date: Sat, 18 Aug 2012 01:15:28 -0700
Message-Id: <1345277729-8399-11-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1345277729-8399-1-git-send-email-fenghua.yu@intel.com>
References: <1345277729-8399-1-git-send-email-fenghua.yu@intel.com>
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
index e0e6990..58ceb82 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -16,6 +16,7 @@
 #include <asm/tlb.h>
 #include <asm/proto.h>
 #include <asm/dma.h>		/* for MAX_DMA_PFN */
+#include <asm/microcode.h>
 
 unsigned long __initdata pgt_buf_start;
 unsigned long __meminitdata pgt_buf_end;
@@ -387,6 +388,15 @@ void free_initmem(void)
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

