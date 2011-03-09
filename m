Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932785Ab1CIOWP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 09:22:15 -0500
Received: from cfcafwp.sgi.com ([192.48.179.6]:38285 "HELO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932243Ab1CIOWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 09:22:14 -0500
X-Greylist: delayed 466 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Mar 2011 09:22:14 EST
To: linux-kernel@vger.kernel.org
Subject: [PATCH v2] x86: UV broadcast assist unit base destination node id
Cc: mingo@elte.hu
Message-Id: <E1PxKBB-0005F0-3U@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Wed, 09 Mar 2011 08:15:57 -0600
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Wickman <cpw@sgi.com>

> >  Diffed against 2.6.32.1
>
> Please send a version against the latest x86 tree:
>
>  http://people.redhat.com/mingo/tip.git/README
>
> Thanks,
>
>       Ingo
Oops, I sent you a distro version of the patch.


The BAU's initialization of the broadcast description header is lacking
the coherence domain (high bits) in the nasid.  This causes a catastrophic
system failure when running on a system with multiple coherence domains. 

Diffed against 2.6.38-r8

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---

 arch/x86/include/asm/uv/uv_bau.h |    2 +-
 arch/x86/platform/uv/tlb_uv.c    |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

Index: linus.current/arch/x86/platform/uv/tlb_uv.c
===================================================================
--- linus.current.orig/arch/x86/platform/uv/tlb_uv.c
+++ linus.current/arch/x86/platform/uv/tlb_uv.c
@@ -1364,11 +1364,12 @@ uv_activation_descriptor_init(int node,
 		memset(bd2, 0, sizeof(struct bau_desc));
 		bd2->header.sw_ack_flag = 1;
 		/*
-		 * base_dest_nodeid is the nasid (pnode<<1) of the first uvhub
+		 * base_dest_nodeid is the nasid of the first uvhub
 		 * in the partition. The bit map will indicate uvhub numbers,
 		 * which are 0-N in a partition. Pnodes are unique system-wide.
 		 */
-		bd2->header.base_dest_nodeid = uv_partition_base_pnode << 1;
+		bd2->header.base_dest_nodeid =
+			UV_PNODE_TO_NASID(uv_partition_base_pnode);
 		bd2->header.dest_subnodeid = 0x10; /* the LB */
 		bd2->header.command = UV_NET_ENDPOINT_INTD;
 		bd2->header.int_both = 1;
Index: linus.current/arch/x86/include/asm/uv/uv_bau.h
===================================================================
--- linus.current.orig/arch/x86/include/asm/uv/uv_bau.h
+++ linus.current/arch/x86/include/asm/uv/uv_bau.h
@@ -176,7 +176,7 @@ struct bau_msg_payload {
 struct bau_msg_header {
 	unsigned int dest_subnodeid:6;	/* must be 0x10, for the LB */
 	/* bits 5:0 */
-	unsigned int base_dest_nodeid:15; /* nasid (pnode<<1) of */
+	unsigned int base_dest_nodeid:15; /* nasid of the */
 	/* bits 20:6 */			  /* first bit in uvhub map */
 	unsigned int command:8;	/* message type */
 	/* bits 28:21 */
