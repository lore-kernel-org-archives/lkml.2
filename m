Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671Ab0LHAyB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:54:01 -0500
Received: from kroah.org ([198.145.64.141]:58619 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756385Ab0LHAsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:48:04 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:34 2010
Message-Id: <20101208004434.524469952@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:44:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jack Steiner <steiner@sgi.com>, Ingo Molnar <mingo@elte.hu>,
        maximilian attems <max@stro.at>
Subject: [102/127] x86, UV: Fix initialization of max_pnode
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jack Steiner <steiner@sgi.com>

commit 36ac4b987bea9a95217e1af552252f275ca7fc44 upstream.

Fix calculation of "max_pnode" for systems where the the highest
blade has neither cpus or memory. (And, yes, although rare this
does occur).

Signed-off-by: Jack Steiner <steiner@sgi.com>
LKML-Reference: <20100910150808.GA19802@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/apic/x2apic_uv_x.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -595,9 +595,11 @@ void __init uv_system_init(void)
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
@@ -635,7 +637,6 @@ void __init uv_system_init(void)
 		uv_cpu_hub_info(cpu)->scir.offset = uv_scir_offset(apicid);
 		uv_node_to_blade[nid] = blade;
 		uv_cpu_to_blade[cpu] = blade;
-		max_pnode = max(pnode, max_pnode);
 	}
 
 	/* Add blade/pnode info for nodes without cpus */
@@ -647,7 +648,6 @@ void __init uv_system_init(void)
 		pnode = (paddr >> m_val) & pnode_mask;
 		blade = boot_pnode_to_blade(pnode);
 		uv_node_to_blade[nid] = blade;
-		max_pnode = max(pnode, max_pnode);
 	}
 
 	map_gru_high(max_pnode);


