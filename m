Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388Ab1EYVio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 17:38:44 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:48946 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755818Ab1EYVin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 17:38:43 -0400
From: Konrad@dumpdata.com, Rzeszutek@dumpdata.com, Wilk@dumpdata.com
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: Daniel Kiper <dkiper@net-space.pl>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/2] xen/setup: Fix for incorrect xen_extra_mem_start initialization under 32-bit
Date: Wed, 25 May 2011 17:37:36 -0400
Message-Id: <1306359456-3627-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1306359456-3627-1-git-send-email-konrad.wilk@oracle.com>
References: <1306359456-3627-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090202.4DDD76B6.00D5,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Kiper <dkiper@net-space.pl>

git commit 24bdb0b62cc82120924762ae6bc85afc8c3f2b26 (xen: do not create
the extra e820 region at an addr lower than 4G) does not take into
account that ifdef CONFIG_X86_32 instead of e820_end_of_low_ram_pfn()
find_low_pfn_range() is called (both calls are from arch/x86/kernel/setup.c).
find_low_pfn_range() behaves correctly and does not require change in
xen_extra_mem_start initialization. Additionally, if xen_extra_mem_start
is initialized in the same way as ifdef CONFIG_X86_64 then memory hotplug
support for Xen balloon driver (under development) is broken.

Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/setup.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index fba4a6c..ca6297b 100644
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
1.7.4.1

