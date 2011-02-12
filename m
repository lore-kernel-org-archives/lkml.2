Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab1BLRLn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 12:11:43 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51602 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab1BLRLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 12:11:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=MUdh1HY30UKYzDP4tZB6TdTlpprdXcGcPHs3c9xMDcIfjjXz7fQLxM58Z6gBbWiUQK
         9oH7CEqMXK3buIXZSbRz+m1oYroyy1nzCNPMtnCR9IaLDSrmOT0FDfYdgTNS78D9ZhYg
         /7FVAFiRxJSA/AzKp5LpSLV86XvfAsGyyvetQ=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, mingo@elte.hu, hpa@linux.intel.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/26] x86-64, NUMA: Make dummy node initialization path similar to non-dummy ones
Date: Sat, 12 Feb 2011 18:10:38 +0100
Message-Id: <1297530663-26234-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297530663-26234-1-git-send-email-tj@kernel.org>
References: <1297530663-26234-1-git-send-email-tj@kernel.org>
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
Cc: Yinghai Lu <yinghai@kernel.org>
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
index f548fbf..ea5dd48 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -623,10 +623,11 @@ void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn,
 	memnodemap[0] = 0;
 	node_set_online(0);
 	node_set(0, node_possible_map);
-	for (i = 0; i < nr_cpu_ids; i++)
-		numa_set_node(i, 0);
+	for (i = 0; i < MAX_LOCAL_APIC; i++)
+		set_apicid_to_node(i, NUMA_NO_NODE);
 	memblock_x86_register_active_regions(0, start_pfn, last_pfn);
 	setup_node_bootmem(0, start_pfn << PAGE_SHIFT, last_pfn << PAGE_SHIFT);
+	numa_init_array();
 }
 
 unsigned long __init numa_free_all_bootmem(void)
-- 
1.7.1

