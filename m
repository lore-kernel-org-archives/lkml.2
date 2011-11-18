Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab1KRLzd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 06:55:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753861Ab1KRLzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 06:55:32 -0500
From: Petr Holasek <pholasek@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Anton Arapov <anton@redhat.com>, Petr Holasek <pholasek@redhat.com>
Subject: [PATCH 1/2] NUMA emulation x86_64: numa=fake parameter for custom nodes distance
Date: Fri, 18 Nov 2011 12:55:07 +0100
Message-Id: <1321617308-4998-1-git-send-email-pholasek@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As default, when numa emulation is turned on, node distance table
uses physical distance, so for 4 nodes emulated on 1 physical table is

node   0   1   2   3
0:  10  10  10  10
1:  10  10  10  10
2:  10  10  10  10
3:  10  10  10  10

This patch adds new [distance] argument to

numa=fake=<number/size of nodes>[,distance]

When distance argument is used, it sets linear distance between nodes
like that:

    __distance__
___|___     ____|___     ________     ________
|       |   |        |   |        |   |        |
| node1 |---| node 2 |---| node 3 |---| node 4 |
|_______|   |________|   |________|   |________|
|                        |             |
|                        |             |
|____distance * 2________|             |
|                                      |
|____________distance * 3______________|

This feature might be useful for testing some numa awareness features in
both user and kernel spaces.

Signed-off-by: Petr Holasek <pholasek@redhat.com>
---
 arch/x86/mm/numa_emulation.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/numa_emulation.c b/arch/x86/mm/numa_emulation.c
index d0ed086..1824972 100644
--- a/arch/x86/mm/numa_emulation.c
+++ b/arch/x86/mm/numa_emulation.c
@@ -309,6 +309,8 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
 	u8 *phys_dist = NULL;
 	size_t phys_size = numa_dist_cnt * numa_dist_cnt * sizeof(phys_dist[0]);
 	int max_emu_nid, dfl_phys_nid;
+	unsigned long dist_level;
+	char *c;
 	int i, j, ret;
 
 	if (!emu_cmdline)
@@ -404,6 +406,17 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
 		if (emu_nid_to_phys[i] == NUMA_NO_NODE)
 			emu_nid_to_phys[i] = dfl_phys_nid;
 
+	/* load distance level parameter */
+	dist_level = -1;
+	c = strchr(emu_cmdline, ',');
+	if (c) {
+		c++;
+		ret = kstrtoul(c, 10, &dist_level);
+		if (ret < 0 || dist_level < LOCAL_DISTANCE ||
+				dist_level * max_emu_nid > ULONG_MAX)
+			dist_level = -1;
+	}
+
 	/* transform distance table */
 	numa_reset_distance();
 	for (i = 0; i < max_emu_nid + 1; i++) {
@@ -418,6 +431,9 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
 			else
 				dist = phys_dist[physi * numa_dist_cnt + physj];
 
+			if (dist_level != -1 && i != j)
+				dist = abs(i - j) * dist_level;
+
 			numa_set_distance(i, j, dist);
 		}
 	}
-- 
1.7.6.4

