Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650Ab2JQTRa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 15:17:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36541 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756511Ab2JQTR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 15:17:29 -0400
Date: Wed, 17 Oct 2012 12:17:16 -0700
From: tip-bot for Jacob Shin <jacob.shin@amd.com>
Message-ID: <tip-1bbbbe779aabe1f0768c2bf8f8c0a5583679b54a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jacob.shin@amd.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jacob.shin@amd.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1319145326-13902-1-git-send-email-jacob.shin@amd.com>
References: <1319145326-13902-1-git-send-email-jacob.shin@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86:
  Exclude E820_RESERVED regions and memory holes above 4 GB from direct mapping
 .
Git-Commit-ID: 1bbbbe779aabe1f0768c2bf8f8c0a5583679b54a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 17 Oct 2012 12:17:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1bbbbe779aabe1f0768c2bf8f8c0a5583679b54a
Gitweb:     http://git.kernel.org/tip/1bbbbe779aabe1f0768c2bf8f8c0a5583679b54a
Author:     Jacob Shin <jacob.shin@amd.com>
AuthorDate: Thu, 20 Oct 2011 16:15:26 -0500
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 17 Oct 2012 10:59:39 -0700

x86: Exclude E820_RESERVED regions and memory holes above 4 GB from direct mapping.

On systems with very large memory (1 TB in our case), BIOS may report a
reserved region or a hole in the E820 map, even above the 4 GB range. Exclude
these from the direct mapping.

[ hpa: this should be done not just for > 4 GB but for everything above the legacy
  region (1 MB), at the very least.  That, however, turns out to require significant
  restructuring.  That work is well underway, but is not suitable for rc/stable. ]

Cc: stable@kernel.org   # > 2.6.32
Signed-off-by: Jacob Shin <jacob.shin@amd.com>
Link: http://lkml.kernel.org/r/1319145326-13902-1-git-send-email-jacob.shin@amd.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/setup.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f4b9b80..198e774 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -919,8 +919,21 @@ void __init setup_arch(char **cmdline_p)
 
 #ifdef CONFIG_X86_64
 	if (max_pfn > max_low_pfn) {
-		max_pfn_mapped = init_memory_mapping(1UL<<32,
-						     max_pfn<<PAGE_SHIFT);
+		int i;
+		for (i = 0; i < e820.nr_map; i++) {
+			struct e820entry *ei = &e820.map[i];
+
+			if (ei->addr + ei->size <= 1UL << 32)
+				continue;
+
+			if (ei->type == E820_RESERVED)
+				continue;
+
+			max_pfn_mapped = init_memory_mapping(
+				ei->addr < 1UL << 32 ? 1UL << 32 : ei->addr,
+				ei->addr + ei->size);
+		}
+
 		/* can we preseve max_low_pfn ?*/
 		max_low_pfn = max_pfn;
 	}
