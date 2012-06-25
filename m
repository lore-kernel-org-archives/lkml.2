Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338Ab2FYQmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 12:42:17 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:42630 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756184Ab2FYQmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 12:42:16 -0400
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] x86: add local_tlb_flush_kernel_range()
Date: Mon, 25 Jun 2012 11:14:38 -0500
Message-Id: <1340640878-27536-4-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1340640878-27536-1-git-send-email-sjenning@linux.vnet.ibm.com>
References: <1340640878-27536-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062516-3534-0000-0000-000009C8A2AC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for a local_tlb_flush_kernel_range()
function for the x86 arch.  This function allows for CPU-local
TLB flushing, potentially using invlpg for single entry flushing,
using an arch independent function name.

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
 arch/x86/include/asm/tlbflush.h |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 36a1a2a..92a280b 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -168,4 +168,25 @@ static inline void flush_tlb_kernel_range(unsigned long start,
 	flush_tlb_all();
 }
 
+#define __HAVE_LOCAL_FLUSH_TLB_KERNEL_RANGE
+/*
+ * INVLPG_BREAK_EVEN_PAGES is the number of pages after which single tlb
+ * flushing becomes more costly than just doing a complete tlb flush.
+ * While this break even point varies among x86 hardware, tests have shown
+ * that 8 is a good generic value.
+*/
+#define INVLPG_BREAK_EVEN_PAGES 8
+static inline void local_flush_tlb_kernel_range(unsigned long start,
+		unsigned long end)
+{
+	if (cpu_has_invlpg &&
+		(end - start)/PAGE_SIZE <= INVLPG_BREAK_EVEN_PAGES) {
+		while (start < end) {
+			__flush_tlb_single(start);
+			start += PAGE_SIZE;
+		}
+	} else
+		local_flush_tlb();
+}
+
 #endif /* _ASM_X86_TLBFLUSH_H */
-- 
1.7.9.5

