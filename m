Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458Ab1ANB4p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 20:56:45 -0500
Received: from [69.28.251.93] ([69.28.251.93]:44990 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752304Ab1ANB4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 20:56:18 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: <ddaney@caviumnetworks.com>, <linux-mips@linux-mips.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/6] MIPS: pfn_valid() is broken on low memory HIGHMEM systems
Date: Thu, 13 Jan 2011 17:52:13 -0800
Message-Id: <3b5632228986cbd69eae8787dd0aad5b@localhost>
In-Reply-To: <491015d51e5d3d36c517da09e038ecaf@localhost>
References: <491015d51e5d3d36c517da09e038ecaf@localhost>
User-Agent: vim 7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pfn_valid() compares the PFN to max_mapnr:

        __pfn >= min_low_pfn && __pfn < max_mapnr;

On HIGHMEM kernels, highend_pfn is used to set the value of max_mapnr.
Unfortunately, highend_pfn is left at zero if the system does not
actually have enough RAM to reach into the HIGHMEM range.  This causes
pfn_valid() to always return false, and when debug checks are enabled
the kernel will fail catastrophically:

Memory: 22432k/32768k available (2249k kernel code, 10336k reserved, 653k data, 1352k init, 0k highmem)
NR_IRQS:128
kfree_debugcheck: out of range ptr 81c02900h.
Kernel bug detected[#1]:
Cpu 0
$ 0   : 00000000 10008400 00000034 00000000
$ 4   : 8003e160 802a0000 8003e160 00000000
$ 8   : 00000000 0000003e 00000747 00000747
...

On such a configuration, max_low_pfn should be used to set max_mapnr.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 arch/mips/mm/init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/mm/init.c b/arch/mips/mm/init.c
index 2efcbd2..45447cd 100644
--- a/arch/mips/mm/init.c
+++ b/arch/mips/mm/init.c
@@ -370,7 +370,7 @@ void __init mem_init(void)
 #ifdef CONFIG_DISCONTIGMEM
 #error "CONFIG_HIGHMEM and CONFIG_DISCONTIGMEM dont work together yet"
 #endif
-	max_mapnr = highend_pfn;
+	max_mapnr = highend_pfn ? highend_pfn : max_low_pfn;
 #else
 	max_mapnr = max_low_pfn;
 #endif
-- 
1.7.0.4

