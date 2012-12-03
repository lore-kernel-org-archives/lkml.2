Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131Ab2LCO6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:58:54 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43537 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755257Ab2LCOfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:35:45 -0500
Message-Id: <20121203143149.695878618@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:32:04 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jacob Shin <jacob.shin@amd.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [ 18/89] x86: Exclude E820_RESERVED regions and memory holes above 4 GB from
 direct mapping.
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Shin <jacob.shin@amd.com>

commit 1bbbbe779aabe1f0768c2bf8f8c0a5583679b54a upstream.

On systems with very large memory (1 TB in our case), BIOS may report a
reserved region or a hole in the E820 map, even above the 4 GB range. Exclude
these from the direct mapping.

[ hpa: this should be done not just for > 4 GB but for everything above the legacy
  region (1 MB), at the very least.  That, however, turns out to require significant
  restructuring.  That work is well underway, but is not suitable for rc/stable. ]

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
Link: http://lkml.kernel.org/r/1319145326-13902-1-git-send-email-jacob.shin@amd.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/setup.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

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


