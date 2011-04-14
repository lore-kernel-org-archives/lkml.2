Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933555Ab1DNRrm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:47:42 -0400
Received: from mail.windriver.com ([147.11.1.11]:38656 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933472Ab1DNRrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:47:40 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Jack Steiner <steiner@sgi.com>,
        Ingo Molnar <mingo@elte.hu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 112/209] x86, UV: Fix initialization of max_pnode
Date: Thu, 14 Apr 2011 13:42:22 -0400
Message-Id: <1302803039-9400-113-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 36ac4b987bea9a95217e1af552252f275ca7fc44 upstream.

Fix calculation of "max_pnode" for systems where the the highest
blade has neither cpus or memory. (And, yes, although rare this
does occur).

Signed-off-by: Jack Steiner <steiner@sgi.com>
LKML-Reference: <20100910150808.GA19802@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/kernel/apic/x2apic_uv_x.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index e46f98f..25a1b3c 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -694,9 +694,11 @@ void __init uv_system_init(void)
 		for (j = 0; j < 64; j++) {
 			if (!test_bit(j, &present))
 				continue;
-			uv_blade_info[blade].pnode = (i * 64 + j);
+			pnode = (i * 64 + j);
+			uv_blade_info[blade].pnode = pnode;
 			uv_blade_info[blade].nr_possible_cpus = 0;
 			uv_blade_info[blade].nr_online_cpus = 0;
+			max_pnode = max(pnode, max_pnode);
 			blade++;
 		}
 	}
@@ -734,7 +736,6 @@ void __init uv_system_init(void)
 		uv_cpu_hub_info(cpu)->scir.offset = uv_scir_offset(apicid);
 		uv_node_to_blade[nid] = blade;
 		uv_cpu_to_blade[cpu] = blade;
-		max_pnode = max(pnode, max_pnode);
 	}
 
 	/* Add blade/pnode info for nodes without cpus */
@@ -746,7 +747,6 @@ void __init uv_system_init(void)
 		pnode = (paddr >> m_val) & pnode_mask;
 		blade = boot_pnode_to_blade(pnode);
 		uv_node_to_blade[nid] = blade;
-		max_pnode = max(pnode, max_pnode);
 	}
 
 	map_gru_high(max_pnode);
-- 
1.7.4.4

