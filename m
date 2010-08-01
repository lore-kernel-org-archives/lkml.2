Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270Ab0HAItO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 04:49:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:57929 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753898Ab0HAItM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 04:49:12 -0400
Date: Sun, 1 Aug 2010 08:48:47 GMT
From: tip-bot for Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com, cpw@sgi.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        cpw@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <E1Oeuyt-0004XS-0y@eag09.americas.sgi.com>
References: <E1Oeuyt-0004XS-0y@eag09.americas.sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86, UV: Initialize BAU hub map
Message-ID: <tip-c4026cfd8febcd63dd278894108839f30e525a0e@git.kernel.org>
Git-Commit-ID: c4026cfd8febcd63dd278894108839f30e525a0e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 01 Aug 2010 08:48:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c4026cfd8febcd63dd278894108839f30e525a0e
Gitweb:     http://git.kernel.org/tip/c4026cfd8febcd63dd278894108839f30e525a0e
Author:     Cliff Wickman <cpw@sgi.com>
AuthorDate: Fri, 30 Jul 2010 14:10:55 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 1 Aug 2010 09:18:41 +0200

x86, UV: Initialize BAU hub map

Fix uninitialized uvhub_mask:

- An unitialized bit map variable was causing initialization of
  non-existant hubs (this one causes boot panics).

- And the bit map was too small for large machines.  This patch
  makes it dynamic in size.

- Fix the case where socket 0 has no enabled cpu's. Don't assume
  every hub has a socket 0.

- uv_init_per_cpu() should be __init.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Cc: <stable@kernel.org> # for .35.x
LKML-Reference: <E1Oeuyt-0004XS-0y@eag09.americas.sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/tlb_uv.c |   26 ++++++++++++++------------
 1 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index 59efb53..312ef02 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
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
