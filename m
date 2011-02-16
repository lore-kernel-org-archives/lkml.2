Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759047Ab1BPMVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 07:21:21 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36104 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758880Ab1BPMVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 07:21:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=tVN4++eH/GdJlko04M2cD+uwjACdw8/bmht+lzOCVq3yHyrkoXthx76Hqs/0aQREsX
         kk4YYYPUMLm9dsb/6ap7jO2DxryfNmJs5VSdE4dtAM5eDC7PL5b+xvc4vhr2hkaLfbdf
         fMIw/qEA61HVV7khYMsjp7vE2mdX9qXHl8PEg=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, mingo@elte.hu, hpa@linux.intel.com,
        ankita@in.ibm.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/33] x86-64, NUMA: Make dummy node initialization path similar to non-dummy ones
Date: Wed, 16 Feb 2011 13:20:35 +0100
Message-Id: <1297858867-25981-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297858867-25981-1-git-send-email-tj@kernel.org>
References: <1297858867-25981-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dummy node initialization in initmem_init() didn't initialize apicid
to node mapping and set cpu to node mapping directly by caling
numa_set_node(), which is different from non-dummy init paths.

Update it such that they behave similarly.  Initialize apicid to node
mapping and call numa_init_array().  The actual cpu to node mapping is
handled by init_cpu_to_node() later.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/numa_64.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 43ad327..b7d78d7 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -624,11 +624,12 @@ void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn,
 	memnodemap[0] = 0;
 	node_set_online(0);
 	node_set(0, node_possible_map);
-	for (i = 0; i < nr_cpu_ids; i++)
-		numa_set_node(i, 0);
+	for (i = 0; i < MAX_LOCAL_APIC; i++)
+		set_apicid_to_node(i, NUMA_NO_NODE);
 	memblock_x86_register_active_regions(0, start_pfn, last_pfn);
 	init_memory_mapping_high();
 	setup_node_bootmem(0, start_pfn << PAGE_SHIFT, last_pfn << PAGE_SHIFT);
+	numa_init_array();
 }
 
 unsigned long __init numa_free_all_bootmem(void)
-- 
1.7.1

