Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073Ab0FHU6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 16:58:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:39580 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700Ab0FHU6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 16:58:40 -0400
Date: Tue, 8 Jun 2010 20:58:20 GMT
From: tip-bot for Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com, cpw@sgi.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       cpw@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <E1OJvNy-0004ad-BV@eag09.americas.sgi.com>
References: <E1OJvNy-0004ad-BV@eag09.americas.sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86, UV: Remove BAU check for stay-busy
Message-ID: <tip-90cc7d944981a6d06b49bb26fde1b490e28c90e5@git.kernel.org>
Git-Commit-ID: 90cc7d944981a6d06b49bb26fde1b490e28c90e5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 08 Jun 2010 20:58:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  90cc7d944981a6d06b49bb26fde1b490e28c90e5
Gitweb:     http://git.kernel.org/tip/90cc7d944981a6d06b49bb26fde1b490e28c90e5
Author:     Cliff Wickman <cpw@sgi.com>
AuthorDate: Wed, 2 Jun 2010 16:22:02 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 8 Jun 2010 21:13:47 +0200

x86, UV: Remove BAU check for stay-busy

Remove a faulty assumption that a long running BAU request has
encountered a hardware problem and will never finish.

Numalink congestion can make a request appear to have
encountered such a problem, but it is not safe to cancel the
request.  If such a cancel is done but a reply is later received
we can miss a TLB shootdown.

We depend upon the max_bau_concurrent 'throttle' to prevent the
stay-busy case from happening.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Cc: gregkh@suse.de
LKML-Reference: <E1OJvNy-0004ad-BV@eag09.americas.sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/uv/uv_bau.h |    1 -
 arch/x86/kernel/tlb_uv.c         |   23 -----------------------
 2 files changed, 0 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv_bau.h b/arch/x86/include/asm/uv/uv_bau.h
index 1c8f1e9..c19b870 100644
--- a/arch/x86/include/asm/uv/uv_bau.h
+++ b/arch/x86/include/asm/uv/uv_bau.h
@@ -402,7 +402,6 @@ struct bau_control {
 	unsigned short uvhub_quiesce;
 	short socket_acknowledge_count[DEST_Q_SIZE];
 	cycles_t send_message;
-	spinlock_t masks_lock;
 	spinlock_t uvhub_lock;
 	spinlock_t queue_lock;
 	/* tunables */
diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index ab929e9..dc962b5 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -405,12 +405,10 @@ static int uv_wait_completion(struct bau_desc *bau_desc,
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
@@ -450,26 +448,6 @@ static int uv_wait_completion(struct bau_desc *bau_desc,
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
