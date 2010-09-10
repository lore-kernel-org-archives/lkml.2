Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab0IJPIL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 11:08:11 -0400
Received: from relay1.sgi.com ([192.48.179.29]:46839 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754312Ab0IJPIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 11:08:10 -0400
Date: Fri, 10 Sep 2010 10:08:08 -0500
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86, UV: Fix initialization of max_pnode
Message-ID: <20100910150808.GA19802@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix calculation of "max_pnode" for systems where the the highest blade
has neither cpus or memory. (And, yes, although rare this does occur).

Signed-off-by: Jack Steiner <steiner@sgi.com>


---
 arch/x86/kernel/apic/x2apic_uv_x.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c	2010-09-10 10:01:06.365597713 -0500
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c	2010-09-10 10:01:23.993663058 -0500
@@ -698,9 +698,11 @@ void __init uv_system_init(void)
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
@@ -738,7 +740,6 @@ void __init uv_system_init(void)
 		uv_cpu_hub_info(cpu)->scir.offset = uv_scir_offset(apicid);
 		uv_node_to_blade[nid] = blade;
 		uv_cpu_to_blade[cpu] = blade;
-		max_pnode = max(pnode, max_pnode);
 	}
 
 	/* Add blade/pnode info for nodes without cpus */
@@ -750,7 +751,6 @@ void __init uv_system_init(void)
 		pnode = (paddr >> m_val) & pnode_mask;
 		blade = boot_pnode_to_blade(pnode);
 		uv_node_to_blade[nid] = blade;
-		max_pnode = max(pnode, max_pnode);
 	}
 
 	map_gru_high(max_pnode);
