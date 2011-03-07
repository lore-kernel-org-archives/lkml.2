Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab1CGSMJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 13:12:09 -0500
Received: from relay1.sgi.com ([192.48.179.29]:58390 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803Ab1CGSMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 13:12:08 -0500
To: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: UV broadcast assist unit base destination node id
Cc: mingo@elte.hu
Message-Id: <E1Pwevz-0003JE-3g@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Mon, 07 Mar 2011 12:13:31 -0600
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Wickman <cpw@sgi.com>

The BAU's initialization of the broadcast description header is lacking
the coherence domain (high bits) in the nasid.  This causes a catastrophic
system failure when running on a system with multiple coherence domains. 

Diffed against 2.6.32.12

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/include/asm/uv/uv_bau.h |    2 +-
 arch/x86/kernel/tlb_uv.c         |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

Index: linux/arch/x86/kernel/tlb_uv.c
===================================================================
--- linux.orig/arch/x86/kernel/tlb_uv.c
+++ linux/arch/x86/kernel/tlb_uv.c
@@ -1361,7 +1361,8 @@ uv_activation_descriptor_init(int node,
 		 * in the partition. The bit map will indicate uvhub numbers,
 		 * which are 0-N in a partition. Pnodes are unique system-wide.
 		 */
-		bd2->header.base_dest_nodeid = uv_partition_base_pnode << 1;
+		bd2->header.base_dest_nodeid =
+			UV_PNODE_TO_NASID(uv_partition_base_pnode);
 		bd2->header.dest_subnodeid = 0x10; /* the LB */
 		bd2->header.command = UV_NET_ENDPOINT_INTD;
 		bd2->header.int_both = 1;
Index: linux/arch/x86/include/asm/uv/uv_bau.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_bau.h
+++ linux/arch/x86/include/asm/uv/uv_bau.h
@@ -176,7 +176,7 @@ struct bau_msg_payload {
 struct bau_msg_header {
 	unsigned int dest_subnodeid:6;	/* must be 0x10, for the LB */
 	/* bits 5:0 */
-	unsigned int base_dest_nodeid:15; /* nasid (pnode<<1) of */
+	unsigned int base_dest_nodeid:15; /* nasid of the */
 	/* bits 20:6 */			  /* first bit in uvhub map */
 	unsigned int command:8;	/* message type */
 	/* bits 28:21 */
