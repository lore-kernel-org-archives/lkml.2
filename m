Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab2H2TEh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 15:04:37 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:17238
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754498Ab2H2TEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 15:04:33 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275dhz2dh668h839hd24he5bhf0ah107ah1155h)
X-WSS-ID: 0M9J6BB-01-8HO-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: X86-ML <x86@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
        Dave Young <dyoung@redhat.com>, Chao Wang <chaowang@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 2/6] x86, mm: Split out split_mem_range
Date: Wed, 29 Aug 2012 14:04:02 -0500
Message-ID: <1346267046-6724-3-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1346267046-6724-1-git-send-email-jacob.shin@amd.com>
References: <1346267046-6724-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>

from init_memory_mapping, so make init_memory_mapping readable.

Suggested-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/init.c |   42 ++++++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 16 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 838e9bc..41e615b 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -143,25 +143,13 @@ static int __meminit save_mr(struct map_range *mr, int nr_range,
 	return nr_range;
 }
 
-/*
- * Setup the direct mapping of the physical memory at PAGE_OFFSET.
- * This runs before bootmem is initialized and gets pages directly from
- * the physical memory. To access them they are temporarily mapped.
- */
-unsigned long __init_refok init_memory_mapping(unsigned long start,
-					       unsigned long end)
+static int __meminit split_mem_range(struct map_range *mr, int nr_range,
+				     unsigned long start,
+				     unsigned long end)
 {
 	unsigned long start_pfn, end_pfn;
-	unsigned long ret = 0;
 	unsigned long pos;
-	struct map_range mr[NR_RANGE_MR];
-	int nr_range, i;
-
-	printk(KERN_INFO "init_memory_mapping: [mem %#010lx-%#010lx]\n",
-	       start, end - 1);
-
-	memset(mr, 0, sizeof(mr));
-	nr_range = 0;
+	int i;
 
 	/* head if not big page alignment ? */
 	start_pfn = start >> PAGE_SHIFT;
@@ -255,6 +243,28 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 			(mr[i].page_size_mask & (1<<PG_LEVEL_1G))?"1G":(
 			 (mr[i].page_size_mask & (1<<PG_LEVEL_2M))?"2M":"4k"));
 
+	return nr_range;
+}
+
+/*
+ * Setup the direct mapping of the physical memory at PAGE_OFFSET.
+ * This runs before bootmem is initialized and gets pages directly from
+ * the physical memory. To access them they are temporarily mapped.
+ */
+unsigned long __init_refok init_memory_mapping(unsigned long start,
+					       unsigned long end)
+{
+	struct map_range mr[NR_RANGE_MR];
+	unsigned long ret = 0;
+	int nr_range, i;
+
+	printk(KERN_INFO "init_memory_mapping: [mem %#010lx-%#010lx]\n",
+	       start, end - 1);
+
+	memset(mr, 0, sizeof(mr));
+	nr_range = 0;
+	nr_range = split_mem_range(mr, nr_range, start, end);
+
 	/*
 	 * Find space for the kernel direct mapping tables.
 	 *
-- 
1.7.9.5


