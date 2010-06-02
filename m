Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933164Ab0FBVVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 17:21:50 -0400
Received: from relay2.sgi.com ([192.48.179.30]:37303 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932894Ab0FBVVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 17:21:34 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH 7/11] x86, UV: correct BAU discovery of hubs and sockets
Cc: mingo@elte.hu, hpa@zytor.com, gregkh@suse.de
Message-Id: <E1OJvNy-0004aW-9S@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Wed, 02 Jun 2010 16:22:02 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Correct the initialization-time assumption of contigous blade numbers and
of sockets numbered from zero.

There may be hubs present with no cpu's enabled.
There may be disabled sockets such that the active socket is not
number zero.

And assign a 'socket master' by assuming that a socket is a node. (it is
not safe to extract socket number from an apicid)

Diffed against 2.6.34 -tip

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/kernel/tlb_uv.c |   49 +++++++++++++++++++++++++++++------------------
 1 file changed, 31 insertions(+), 18 deletions(-)

Index: 100531.linux-tip/arch/x86/kernel/tlb_uv.c
===================================================================
--- 100531.linux-tip.orig/arch/x86/kernel/tlb_uv.c
+++ 100531.linux-tip/arch/x86/kernel/tlb_uv.c
@@ -1547,11 +1547,13 @@ calculate_destination_timeout(void)
  */
 static void uv_init_per_cpu(int nuvhubs)
 {
-	int i, j, k;
+	int i;
 	int cpu;
 	int pnode;
 	int uvhub;
 	short socket = 0;
+	unsigned short socket_mask;
+	unsigned int uvhub_mask;
 	struct bau_control *bcp;
 	struct uvhub_desc *bdp;
 	struct socket_desc *sdp;
@@ -1562,7 +1564,7 @@ static void uv_init_per_cpu(int nuvhubs)
 		short cpu_number[16];
 	};
 	struct uvhub_desc {
-		short num_sockets;
+		unsigned short socket_mask;
 		short num_cpus;
 		short uvhub;
 		short pnode;
@@ -1581,43 +1583,54 @@ static void uv_init_per_cpu(int nuvhubs)
 		spin_lock_init(&bcp->masks_lock);
 		pnode = uv_cpu_hub_info(cpu)->pnode;
 		uvhub = uv_cpu_hub_info(cpu)->numa_blade_id;
+		uvhub_mask |= (1 << uvhub);
 		bdp = &uvhub_descs[uvhub];
 		bdp->num_cpus++;
 		bdp->uvhub = uvhub;
 		bdp->pnode = pnode;
-		/* kludge: assume uv_hub.h is constant */
-		socket = (cpu_physical_id(cpu)>>5)&1;
-		if (socket >= bdp->num_sockets)
-			bdp->num_sockets = socket+1;
+		/* kludge: 'assuming' one node per socket, and assuming that
+		   disabling a socket just leaves a gap in node numbers */
+		socket = (cpu_to_node(cpu) & 1);;
+		bdp->socket_mask |= (1 << socket);
 		sdp = &bdp->socket[socket];
 		sdp->cpu_number[sdp->num_cpus] = cpu;
 		sdp->num_cpus++;
 	}
-	socket = 0;
-	for_each_possible_blade(uvhub) {
+	uvhub = 0;
+	while (uvhub_mask) {
+		if (!(uvhub_mask & 1))
+			goto nexthub;
 		bdp = &uvhub_descs[uvhub];
-		for (i = 0; i < bdp->num_sockets; i++) {
-			sdp = &bdp->socket[i];
-			for (j = 0; j < sdp->num_cpus; j++) {
-				cpu = sdp->cpu_number[j];
+		socket_mask = bdp->socket_mask;
+		socket = 0;
+		while (socket_mask) {
+			if (!(socket_mask & 1))
+				goto nextsocket;
+			sdp = &bdp->socket[socket];
+			for (i = 0; i < sdp->num_cpus; i++) {
+				cpu = sdp->cpu_number[i];
 				bcp = &per_cpu(bau_control, cpu);
 				bcp->cpu = cpu;
-				if (j == 0) {
+				if (i == 0) {
 					smaster = bcp;
-					if (i == 0)
+					if (socket == 0)
 						hmaster = bcp;
 				}
 				bcp->cpus_in_uvhub = bdp->num_cpus;
 				bcp->cpus_in_socket = sdp->num_cpus;
 				bcp->socket_master = smaster;
+				bcp->uvhub = bdp->uvhub;
 				bcp->uvhub_master = hmaster;
-				for (k = 0; k < DEST_Q_SIZE; k++)
-					bcp->socket_acknowledge_count[k] = 0;
-				bcp->uvhub_cpu =
-				  uv_cpu_hub_info(cpu)->blade_processor_id;
+				bcp->uvhub_cpu = uv_cpu_hub_info(cpu)->
+						blade_processor_id;
 			}
+nextsocket:
 			socket++;
+			socket_mask = (socket_mask >> 1);
 		}
+nexthub:
+		uvhub++;
+		uvhub_mask = (uvhub_mask >> 1);
 	}
 	kfree(uvhub_descs);
 	for_each_present_cpu(cpu) {
