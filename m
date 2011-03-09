Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222Ab1CIPk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 10:40:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:50236 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755451Ab1CIPkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 10:40:18 -0500
Date: Wed, 9 Mar 2011 15:39:56 GMT
From: tip-bot for Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com, cpw@sgi.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        cpw@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <E1PxKBB-0005F0-3U@eag09.americas.sgi.com>
References: <E1PxKBB-0005F0-3U@eag09.americas.sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, UV: Initialize the broadcast assist unit base destination node id properly
Message-ID: <tip-5471262290a6695b3300903267e0a2584f721000@git.kernel.org>
Git-Commit-ID: 5471262290a6695b3300903267e0a2584f721000
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 09 Mar 2011 15:39:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5471262290a6695b3300903267e0a2584f721000
Gitweb:     http://git.kernel.org/tip/5471262290a6695b3300903267e0a2584f721000
Author:     Cliff Wickman <cpw@sgi.com>
AuthorDate: Wed, 9 Mar 2011 08:15:57 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Mar 2011 16:36:16 +0100

x86, UV: Initialize the broadcast assist unit base destination node id properly

The BAU's initialization of the broadcast description header is
lacking the coherence domain (high bits) in the nasid.  This
causes a catastrophic system failure when running on a system
with multiple coherence domains.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
LKML-Reference: <E1PxKBB-0005F0-3U@eag09.americas.sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/uv/uv_bau.h |    2 +-
 arch/x86/platform/uv/tlb_uv.c    |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv_bau.h b/arch/x86/include/asm/uv/uv_bau.h
index ce1d54c..3e094af 100644
--- a/arch/x86/include/asm/uv/uv_bau.h
+++ b/arch/x86/include/asm/uv/uv_bau.h
@@ -176,7 +176,7 @@ struct bau_msg_payload {
 struct bau_msg_header {
 	unsigned int dest_subnodeid:6;	/* must be 0x10, for the LB */
 	/* bits 5:0 */
-	unsigned int base_dest_nodeid:15; /* nasid (pnode<<1) of */
+	unsigned int base_dest_nodeid:15; /* nasid of the */
 	/* bits 20:6 */			  /* first bit in uvhub map */
 	unsigned int command:8;	/* message type */
 	/* bits 28:21 */
diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index df58e9c..a7b38d3 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -1364,11 +1364,11 @@ uv_activation_descriptor_init(int node, int pnode)
 		memset(bd2, 0, sizeof(struct bau_desc));
 		bd2->header.sw_ack_flag = 1;
 		/*
-		 * base_dest_nodeid is the nasid (pnode<<1) of the first uvhub
+		 * base_dest_nodeid is the nasid of the first uvhub
 		 * in the partition. The bit map will indicate uvhub numbers,
 		 * which are 0-N in a partition. Pnodes are unique system-wide.
 		 */
-		bd2->header.base_dest_nodeid = uv_partition_base_pnode << 1;
+		bd2->header.base_dest_nodeid = UV_PNODE_TO_NASID(uv_partition_base_pnode);
 		bd2->header.dest_subnodeid = 0x10; /* the LB */
 		bd2->header.command = UV_NET_ENDPOINT_INTD;
 		bd2->header.int_both = 1;
