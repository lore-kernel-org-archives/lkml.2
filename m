Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850Ab2LOUgj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 15:36:39 -0500
Received: from dns1.mips.com ([12.201.5.69]:55842 "EHLO dns1.mips.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448Ab2LOUgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 15:36:38 -0500
X-Greylist: delayed 3398 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Dec 2012 15:36:38 EST
X-WSS-ID: 0MF37YC-01-2VL-02
X-M-MSG: 
From: Deng-Cheng Zhu <dczhu@mips.com>
To: <linux-kernel@vger.kernel.org>
CC: <dczhu@mips.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Ralf Baechle <ralf@linux-mips.org>, "Steven J. Hill" <sjhill@mips.com>
Subject: [PATCH] asm-generic, mm: pgtable: fix include for my_zero_pfn()
Date: Sat, 15 Dec 2012 11:39:29 -0800
Message-ID: <1355600369-4156-1-git-send-email-dczhu@mips.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-EMS-Proccessed: 6LP3oGfGVdcdb8o1aBnt6w==
X-EMS-STAMP: WnmRjH5xG0KC5zAOsQGPLQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Deng-Cheng Zhu <dczhu@mips.com>

A MIPS build showed:

In file included from arch/mips/include/asm/pgtable.h:388,
                 from mm/init-mm.c:9:
include/asm-generic/pgtable.h: In function 'my_zero_pfn':
include/asm-generic/pgtable.h:462: error: 'mem_map' undeclared (first use
in this function)
include/asm-generic/pgtable.h:462: error: (Each undeclared identifier is
reported only once
include/asm-generic/pgtable.h:462: error: for each function it appears in.)

This was caused by the following commit:
816422ad76 asm-generic, mm: pgtable: consolidate zero page helpers

Changing my_zero_pfn from #define to an inline function requires the
include fix. I believe s390 has the same problem as mips.

Although Ralf has added "#include <linux/mmzone.h>" in
arch/mips/include/asm/pgtable.h in his "MIPS: Transparent Huge Pages
support" commit, and this error went away, I think this fix is needed
since asm-generic/pgtable.h is now the place of the function my_zero_pfn()
who requires the definition of mem_map and this header could be included by
others.

Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Steven J. Hill <sjhill@mips.com>
Signed-off-by: Deng-Cheng Zhu <dczhu@mips.com>
---
 include/asm-generic/pgtable.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index 284e808..628dbbb 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -4,7 +4,7 @@
 #ifndef __ASSEMBLY__
 #ifdef CONFIG_MMU
 
-#include <linux/mm_types.h>
+#include <linux/mm.h>
 #include <linux/bug.h>
 
 #ifndef __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
-- 
1.7.1

