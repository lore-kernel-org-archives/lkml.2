Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933244Ab0FBVWR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 17:22:17 -0400
Received: from relay1.sgi.com ([192.48.179.29]:39580 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932980Ab0FBVVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 17:21:35 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH 8/11] x86, UV: remove BAU check for stay-busy
Cc: mingo@elte.hu, hpa@zytor.com, gregkh@suse.de
Message-Id: <E1OJvNy-0004ad-BV@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Wed, 02 Jun 2010 16:22:02 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Remove a faulty assumption that a long running BAU request has encountered
a hardware problem and will never finish.

Numalink congestion can make a request appear to have encountered such a
problem, but it is not safe to cancel the request.  If such a cancel is
done but a reply is later received we can miss a TLB shootdown.

We depend upon the max_bau_concurrent 'throttle' to prevent the stay-busy
case from happening.

Diffed against 2.6.34 -tip

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/include/asm/uv/uv_bau.h |    1 -
 arch/x86/kernel/tlb_uv.c         |   23 -----------------------
 2 files changed, 24 deletions(-)

Index: 100531.linux-tip/arch/x86/kernel/tlb_uv.c
===================================================================
--- 100531.linux-tip.orig/arch/x86/kernel/tlb_uv.c
+++ 100531.linux-tip/arch/x86/kernel/tlb_uv.c
@@ -405,12 +405,10 @@ static int uv_wait_completion(struct bau
 	unsigned long mmr;
 	unsigned long mask;
 	cycles_t ttime;
-	cycles_t timeout_time;
 	struct ptc_stats *stat = bcp->statp;
 	struct bau_control *hmaster;
 
 	hmaster = bcp->uvhub_master;
-	timeout_time = get_cycles() + bcp->timeout_interval;
 
 	/* spin on the status MMR, waiting for it to go idle */
 	while ((descriptor_status = (((unsigned long)
@@ -450,26 +448,6 @@ static int uv_wait_completion(struct bau
 			 * descriptor_status is still BUSY
 			 */
 			cpu_relax();
-			relaxes++;
-			if (relaxes >= 10000) {
-				relaxes = 0;
-				if (get_cycles() > timeout_time) {
-					quiesce_local_uvhub(hmaster);
-
-					/* single-thread the register change */
-					spin_lock(&hmaster->masks_lock);
-					mmr = uv_read_local_mmr(mmr_offset);
-					mask = 0UL;
-					mask |= (3UL < right_shift);
-					mask = ~mask;
-					mmr &= mask;
-					uv_write_local_mmr(mmr_offset, mmr);
-					spin_unlock(&hmaster->masks_lock);
-					end_uvhub_quiesce(hmaster);
-					stat->s_busy++;
-					return FLUSH_GIVEUP;
-				}
-			}
 		}
 	}
 	bcp->conseccompletes++;
@@ -1580,7 +1558,6 @@ static void uv_init_per_cpu(int nuvhubs)
 	for_each_present_cpu(cpu) {
 		bcp = &per_cpu(bau_control, cpu);
 		memset(bcp, 0, sizeof(struct bau_control));
-		spin_lock_init(&bcp->masks_lock);
 		pnode = uv_cpu_hub_info(cpu)->pnode;
 		uvhub = uv_cpu_hub_info(cpu)->numa_blade_id;
 		uvhub_mask |= (1 << uvhub);
Index: 100531.linux-tip/arch/x86/include/asm/uv/uv_bau.h
===================================================================
--- 100531.linux-tip.orig/arch/x86/include/asm/uv/uv_bau.h
+++ 100531.linux-tip/arch/x86/include/asm/uv/uv_bau.h
@@ -402,7 +402,6 @@ struct bau_control {
 	unsigned short uvhub_quiesce;
 	short socket_acknowledge_count[DEST_Q_SIZE];
 	cycles_t send_message;
-	spinlock_t masks_lock;
 	spinlock_t uvhub_lock;
 	spinlock_t queue_lock;
 	/* tunables */
