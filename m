Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965812Ab0GPPLR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 11:11:17 -0400
Received: from relay3.sgi.com ([192.48.152.1]:51682 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965783Ab0GPPLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 11:11:15 -0400
To: mingo@elte.hu
Subject: [PATCH] x86, UV: initialize BAU MMRs only on hubs with cpus
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1OZmZN-0006cW-RC@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Fri, 16 Jul 2010 10:11:21 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Remove the initialization of MMRs UVH_LB_BAU_SB_ACTIVATION_CONTROL and
UVH_BAU_DATA_BROADCAST on UV hubs that have no active cpus.
Such initialization on hubs with no active cpus would result in a kernel
page fault.

This is not of real high priority, because we don't have any such systems
(with UV hubs that have no active cpus).  But they will be coming.

Diffed against 2.6.35-rc4
Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/kernel/tlb_uv.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

Index: linux/arch/x86/kernel/tlb_uv.c
===================================================================
--- linux.orig/arch/x86/kernel/tlb_uv.c
+++ linux/arch/x86/kernel/tlb_uv.c
@@ -1634,12 +1634,16 @@ static int __init uv_bau_init(void)
 	alloc_intr_gate(vector, uv_bau_message_intr1);
 
 	for_each_possible_blade(uvhub) {
-		pnode = uv_blade_to_pnode(uvhub);
-		/* INIT the bau */
-		uv_write_global_mmr64(pnode, UVH_LB_BAU_SB_ACTIVATION_CONTROL,
-				      ((unsigned long)1 << 63));
-		mmr = 1; /* should be 1 to broadcast to both sockets */
-		uv_write_global_mmr64(pnode, UVH_BAU_DATA_BROADCAST, mmr);
+		if (uv_blade_nr_possible_cpus(uvhub)) {
+			pnode = uv_blade_to_pnode(uvhub);
+			/* INIT the bau */
+			uv_write_global_mmr64(pnode,
+					UVH_LB_BAU_SB_ACTIVATION_CONTROL,
+					((unsigned long)1 << 63));
+			mmr = 1; /* should be 1 to broadcast to both sockets */
+			uv_write_global_mmr64(pnode, UVH_BAU_DATA_BROADCAST,
+						mmr);
+		}
 	}
 
 	return 0;
