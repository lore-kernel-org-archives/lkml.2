Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab2JZAsm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:48:42 -0400
Received: from mail.kernel.org ([198.145.19.201]:52442 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752816Ab2JZAFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:05:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jacob Shin <jacob.shin@amd.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [ 09/31] x86: Exclude E820_RESERVED regions and memory holes above 4 GB from direct mapping.
Date: Thu, 25 Oct 2012 17:04:16 -0700
Message-Id: <20121026000215.915269528@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000214.941721299@linuxfoundation.org>
References: <20121026000214.941721299@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/setup.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -937,8 +937,21 @@ void __init setup_arch(char **cmdline_p)
 
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


