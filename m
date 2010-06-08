Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626Ab0FHU6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 16:58:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:39560 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756554Ab0FHU6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 16:58:19 -0400
Date: Tue, 8 Jun 2010 20:58:02 GMT
From: tip-bot for Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com, cpw@sgi.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       cpw@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <E1OJvNy-0004aW-9S@eag09.americas.sgi.com>
References: <E1OJvNy-0004aW-9S@eag09.americas.sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86, UV: Correct BAU discovery of hubs and sockets
Message-ID: <tip-a8328ee58c15c9d763a67607a35bb987b38950fa@git.kernel.org>
Git-Commit-ID: a8328ee58c15c9d763a67607a35bb987b38950fa
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 08 Jun 2010 20:58:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a8328ee58c15c9d763a67607a35bb987b38950fa
Gitweb:     http://git.kernel.org/tip/a8328ee58c15c9d763a67607a35bb987b38950fa
Author:     Cliff Wickman <cpw@sgi.com>
AuthorDate: Wed, 2 Jun 2010 16:22:02 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 8 Jun 2010 21:13:46 +0200

x86, UV: Correct BAU discovery of hubs and sockets

Correct the initialization-time assumption of contigous blade
numbers and of sockets numbered from zero.

There may be hubs present with no cpu's enabled.
There may be disabled sockets such that the active socket is not
number zero.

And assign a 'socket master' by assuming that a socket is a
node. (it is not safe to extract socket number from an apicid)

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Cc: gregkh@suse.de
LKML-Reference: <E1OJvNy-0004aW-9S@eag09.americas.sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/tlb_uv.c |   49 +++++++++++++++++++++++++++++----------------
 1 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index 295a411..ab929e9 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
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
