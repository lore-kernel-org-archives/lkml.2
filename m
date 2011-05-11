Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab1EKUew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 16:34:52 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:53463 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080Ab1EKUev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 16:34:51 -0400
Date: Wed, 11 May 2011 22:34:38 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: konrad.wilk@oracle.com, stefano.stabellini@eu.citrix.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: [PATCH] arch/x86/xen/setup: Fix for incorrect xen_extra_mem_start initialization ifdef CONFIG_X86_32
Message-ID: <20110511203438.GA21034@router-fw-old.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

git commit 24bdb0b62cc82120924762ae6bc85afc8c3f2b26 (xen: do not create
the extra e820 region at an addr lower than 4G) does not take into
account that ifdef CONFIG_X86_32 instead of e820_end_of_low_ram_pfn()
find_low_pfn_range() is called (both calls are from arch/x86/kernel/setup.c).
find_low_pfn_range() behaves correctly and does not require change in
xen_extra_mem_start initialization. Additionally, if xen_extra_mem_start
is initialized in the same way as ifdef CONFIG_X86_64 then memory hotplug
support for Xen balloon driver (under development) is broken.

Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
---
 arch/x86/xen/setup.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 90bac0a..721f576 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -227,7 +227,11 @@ char * __init xen_memory_setup(void)
 
 	memcpy(map_raw, map, sizeof(map));
 	e820.nr_map = 0;
+#ifdef CONFIG_X86_32
+	xen_extra_mem_start = mem_end;
+#else
 	xen_extra_mem_start = max((1ULL << 32), mem_end);
+#endif
 	for (i = 0; i < memmap.nr_entries; i++) {
 		unsigned long long end;
 
-- 
1.5.6.5
