Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933544Ab0G3TKN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 15:10:13 -0400
Received: from relay1.sgi.com ([192.48.179.29]:39088 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757860Ab0G3TJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 15:09:57 -0400
To: mingo@elte.hu
Subject: [PATCH] x86, UV: initialize BAU hub map
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1Oeuyt-0004XS-0y@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Fri, 30 Jul 2010 14:10:55 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix uninitialized uvhub_mask.
- An unitialized bit map variable was causing initialization of
  non-existant hubs (this one causes boot panics).
- And the bit map was too small for large machines.  This patch makes it dynamic
  in size.
- Fix the case where socket 0 has no enabled cpu's. Don't assume every
  hub has a socket 0.
- uv_init_per_cpu() should be __init.

Diffed against 2.6.35-rc5

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/kernel/tlb_uv.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

Index: 100722.linux-tip/arch/x86/kernel/tlb_uv.c
===================================================================
--- 100722.linux-tip.orig/arch/x86/kernel/tlb_uv.c
+++ 100722.linux-tip/arch/x86/kernel/tlb_uv.c
@@ -1484,15 +1484,16 @@ calculate_destination_timeout(void)
 /*
  * initialize the bau_control structure for each cpu
  */
-static void uv_init_per_cpu(int nuvhubs)
+static void __init uv_init_per_cpu(int nuvhubs)
 {
 	int i;
 	int cpu;
 	int pnode;
 	int uvhub;
+	int have_hmaster;
 	short socket = 0;
 	unsigned short socket_mask;
-	unsigned int uvhub_mask;
+	unsigned char *uvhub_mask;
 	struct bau_control *bcp;
 	struct uvhub_desc *bdp;
 	struct socket_desc *sdp;
@@ -1516,28 +1517,29 @@ static void uv_init_per_cpu(int nuvhubs)
 	uvhub_descs = (struct uvhub_desc *)
 		kmalloc(nuvhubs * sizeof(struct uvhub_desc), GFP_KERNEL);
 	memset(uvhub_descs, 0, nuvhubs * sizeof(struct uvhub_desc));
+	uvhub_mask = kzalloc((nuvhubs+7)/8, GFP_KERNEL);
 	for_each_present_cpu(cpu) {
 		bcp = &per_cpu(bau_control, cpu);
 		memset(bcp, 0, sizeof(struct bau_control));
 		pnode = uv_cpu_hub_info(cpu)->pnode;
 		uvhub = uv_cpu_hub_info(cpu)->numa_blade_id;
-		uvhub_mask |= (1 << uvhub);
+		*(uvhub_mask + (uvhub/8)) |= (1 << (uvhub%8));
 		bdp = &uvhub_descs[uvhub];
 		bdp->num_cpus++;
 		bdp->uvhub = uvhub;
 		bdp->pnode = pnode;
 		/* kludge: 'assuming' one node per socket, and assuming that
 		   disabling a socket just leaves a gap in node numbers */
-		socket = (cpu_to_node(cpu) & 1);;
+		socket = (cpu_to_node(cpu) & 1);
 		bdp->socket_mask |= (1 << socket);
 		sdp = &bdp->socket[socket];
 		sdp->cpu_number[sdp->num_cpus] = cpu;
 		sdp->num_cpus++;
 	}
-	uvhub = 0;
-	while (uvhub_mask) {
-		if (!(uvhub_mask & 1))
-			goto nexthub;
+	for (uvhub = 0; uvhub < nuvhubs; uvhub++) {
+		if (!(*(uvhub_mask + (uvhub/8)) & (1 << (uvhub%8))))
+			continue;
+		have_hmaster = 0;
 		bdp = &uvhub_descs[uvhub];
 		socket_mask = bdp->socket_mask;
 		socket = 0;
@@ -1551,8 +1553,10 @@ static void uv_init_per_cpu(int nuvhubs)
 				bcp->cpu = cpu;
 				if (i == 0) {
 					smaster = bcp;
-					if (socket == 0)
+					if (!have_hmaster) {
+						have_hmaster++;
 						hmaster = bcp;
+					}
 				}
 				bcp->cpus_in_uvhub = bdp->num_cpus;
 				bcp->cpus_in_socket = sdp->num_cpus;
@@ -1566,11 +1570,9 @@ nextsocket:
 			socket++;
 			socket_mask = (socket_mask >> 1);
 		}
-nexthub:
-		uvhub++;
-		uvhub_mask = (uvhub_mask >> 1);
 	}
 	kfree(uvhub_descs);
+	kfree(uvhub_mask);
 	for_each_present_cpu(cpu) {
 		bcp = &per_cpu(bau_control, cpu);
 		bcp->baudisabled = 0;
