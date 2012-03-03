Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab2CCL1u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 06:27:50 -0500
Received: from mga01.intel.com ([192.55.52.88]:12539 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690Ab2CCL1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 06:27:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="124566185"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, asit.k.mallick@intel.com
Subject: [PATCH] x86: correct internode cache alignment
Date: Sat,  3 Mar 2012 19:27:27 +0800
Message-Id: <1330774047-18597-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently cache alignment among nodes in kernel is still 128 bytes on
NUMA machine, that get from old P4 processors. But now most of modern
CPU use the same size: 64 bytes from L1 to last level L3. so let's
remove the incorrect setting, and directly use the L1 cache size to do
SMP cache line alignment.

This patch save some memory space on kernel data. The System.map is
quite different with/without this change:

	before patched			after patched
  ...
  000000000000b000 d tlb_vector_|  000000000000b000 d tlb_vector
  000000000000b080 d cpu_loops_p|  000000000000b040 d cpu_loops_
  ...

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 arch/x86/Kconfig.cpu |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 3c57033..6443c6f 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -303,7 +303,6 @@ config X86_GENERIC
 config X86_INTERNODE_CACHE_SHIFT
 	int
 	default "12" if X86_VSMP
-	default "7" if NUMA
 	default X86_L1_CACHE_SHIFT
 
 config X86_CMPXCHG
-- 
1.6.3.3

