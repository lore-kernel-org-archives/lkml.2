Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751178Ab0IGEXN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 00:23:13 -0400
Received: from [69.28.251.93] ([69.28.251.93]:48370 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750825Ab0IGEXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 00:23:03 -0400
From: Kevin Cernekee <cernekee@gmail.com>
Date: Mon, 6 Sep 2010 21:03:48 -0700
Subject: [PATCH RESEND 3/5] MIPS: pfn_valid() is broken on low memory HIGHMEM systems
To: Ralf Baechle <ralf@linux-mips.org>
Cc: <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>
Message-Id: <b4da0a0f45b83839973a64983e3feb89@localhost>
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

This was seen on 2.6.34.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 arch/mips/mm/init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/mm/init.c b/arch/mips/mm/init.c
index 2efcbd2..18183a4 100644
--- a/arch/mips/mm/init.c
+++ b/arch/mips/mm/init.c
@@ -370,7 +370,7 @@ void __init mem_init(void)
 #ifdef CONFIG_DISCONTIGMEM
 #error "CONFIG_HIGHMEM and CONFIG_DISCONTIGMEM dont work together yet"
 #endif
-	max_mapnr = highend_pfn;
+	max_mapnr = highend_pfn ? : max_low_pfn;
 #else
 	max_mapnr = max_low_pfn;
 #endif
-- 
1.7.0.4

