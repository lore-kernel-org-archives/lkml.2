Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936152Ab0GQLNu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 07:13:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:41467 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755701Ab0GQLNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 07:13:40 -0400
Date: Sat, 17 Jul 2010 11:13:16 GMT
From: tip-bot for Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com, cpw@sgi.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        cpw@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <E1OZmZN-0006cW-RC@eag09.americas.sgi.com>
References: <E1OZmZN-0006cW-RC@eag09.americas.sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86, UV: Initialize BAU MMRs only on hubs with cpus
Message-ID: <tip-93a7ca0c3ebe5d931126f1fb732cb9c4518383d4@git.kernel.org>
Git-Commit-ID: 93a7ca0c3ebe5d931126f1fb732cb9c4518383d4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 17 Jul 2010 11:13:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  93a7ca0c3ebe5d931126f1fb732cb9c4518383d4
Gitweb:     http://git.kernel.org/tip/93a7ca0c3ebe5d931126f1fb732cb9c4518383d4
Author:     Cliff Wickman <cpw@sgi.com>
AuthorDate: Fri, 16 Jul 2010 10:11:21 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 17 Jul 2010 12:11:48 +0200

x86, UV: Initialize BAU MMRs only on hubs with cpus

Remove the initialization of MMRs
UVH_LB_BAU_SB_ACTIVATION_CONTROL and UVH_BAU_DATA_BROADCAST on
UV hubs that have no active cpus. Such initialization on hubs
with no active cpus would result in a kernel page fault.

This is not of real high priority, because we don't have any
such systems (with UV hubs that have no active cpus).  But they
will be coming.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
LKML-Reference: <E1OZmZN-0006cW-RC@eag09.americas.sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/tlb_uv.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index abf3c31..59efb53 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -1635,12 +1635,16 @@ static int __init uv_bau_init(void)
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
