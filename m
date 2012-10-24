Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965336Ab2JXTCr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 15:02:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60504 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756505Ab2JXTCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 15:02:44 -0400
Date: Wed, 24 Oct 2012 12:02:27 -0700
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-1f2ff682ac951ed82cc043cf140d2851084512df@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, stable@vger.kernel.org, jacob.shin@amd.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, jacob.shin@amd.com, tglx@linutronix.de,
        stable@vger.kernel.org, hpa@linux.intel.com
In-Reply-To: <CAE9FiQVZirvaBMFYRfXMmWEcHbKSicQEHz4VAwUv0xFCk51ZNw@mail.gmail.com>
References: <CAE9FiQVZirvaBMFYRfXMmWEcHbKSicQEHz4VAwUv0xFCk51ZNw@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, mm:
  Use memblock memory loop instead of e820_RAM
Git-Commit-ID: 1f2ff682ac951ed82cc043cf140d2851084512df
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 24 Oct 2012 12:02:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1f2ff682ac951ed82cc043cf140d2851084512df
Gitweb:     http://git.kernel.org/tip/1f2ff682ac951ed82cc043cf140d2851084512df
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Mon, 22 Oct 2012 16:35:18 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 24 Oct 2012 11:52:36 -0700

x86, mm: Use memblock memory loop instead of e820_RAM

We need to handle E820_RAM and E820_RESERVED_KERNEL at the same time.

Also memblock has page aligned range for ram, so we could avoid mapping
partial pages.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/CAE9FiQVZirvaBMFYRfXMmWEcHbKSicQEHz4VAwUv0xFCk51ZNw@mail.gmail.com
Acked-by: Jacob Shin <jacob.shin@amd.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: <stable@vger.kernel.org>
---
 arch/x86/kernel/setup.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 468e98d..5d888af 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -921,18 +921,19 @@ void __init setup_arch(char **cmdline_p)
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
