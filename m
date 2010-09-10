Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115Ab0IJPsj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 11:48:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:46995 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754909Ab0IJPs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 11:48:29 -0400
Date: Fri, 10 Sep 2010 15:47:59 GMT
From: tip-bot for Jack Steiner <steiner@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100910150808.GA19802@sgi.com>
References: <20100910150808.GA19802@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, UV: Fix initialization of max_pnode
Message-ID: <tip-36ac4b987bea9a95217e1af552252f275ca7fc44@git.kernel.org>
Git-Commit-ID: 36ac4b987bea9a95217e1af552252f275ca7fc44
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 10 Sep 2010 15:47:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  36ac4b987bea9a95217e1af552252f275ca7fc44
Gitweb:     http://git.kernel.org/tip/36ac4b987bea9a95217e1af552252f275ca7fc44
Author:     Jack Steiner <steiner@sgi.com>
AuthorDate: Fri, 10 Sep 2010 10:08:08 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Sep 2010 17:15:49 +0200

x86, UV: Fix initialization of max_pnode

Fix calculation of "max_pnode" for systems where the the highest
blade has neither cpus or memory. (And, yes, although rare this
does occur).

Signed-off-by: Jack Steiner <steiner@sgi.com>
LKML-Reference: <20100910150808.GA19802@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/x2apic_uv_x.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 7b598b8..f744f54 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
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
