Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761468Ab2J2Vig (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:38:36 -0400
Received: from mail.kernel.org ([198.145.19.201]:48165 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761446Ab2J2ViT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:38:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Yinghai Lu <yinghai@kernel.org>, Jacob Shin <jacob.shin@amd.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [ 099/101] x86, mm: Use memblock memory loop instead of e820_RAM
Date: Mon, 29 Oct 2012 14:35:52 -0700
Message-Id: <20121029213251.310699631@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213240.128426598@linuxfoundation.org>
References: <20121029213240.128426598@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinghai Lu <yinghai@kernel.org>

commit 1f2ff682ac951ed82cc043cf140d2851084512df upstream.

We need to handle E820_RAM and E820_RESERVED_KERNEL at the same time.

Also memblock has page aligned range for ram, so we could avoid mapping
partial pages.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/CAE9FiQVZirvaBMFYRfXMmWEcHbKSicQEHz4VAwUv0xFCk51ZNw@mail.gmail.com
Acked-by: Jacob Shin <jacob.shin@amd.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/setup.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -920,18 +920,19 @@ void __init setup_arch(char **cmdline_p)
 #ifdef CONFIG_X86_64
 	if (max_pfn > max_low_pfn) {
 		int i;
-		for (i = 0; i < e820.nr_map; i++) {
-			struct e820entry *ei = &e820.map[i];
+		unsigned long start, end;
+		unsigned long start_pfn, end_pfn;
 
-			if (ei->addr + ei->size <= 1UL << 32)
-				continue;
+		for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn,
+							 NULL) {
 
-			if (ei->type == E820_RESERVED)
+			end = PFN_PHYS(end_pfn);
+			if (end <= (1UL<<32))
 				continue;
 
+			start = PFN_PHYS(start_pfn);
 			max_pfn_mapped = init_memory_mapping(
-				ei->addr < 1UL << 32 ? 1UL << 32 : ei->addr,
-				ei->addr + ei->size);
+						max((1UL<<32), start), end);
 		}
 
 		/* can we preseve max_low_pfn ?*/


