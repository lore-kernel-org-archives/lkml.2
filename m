Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760814Ab0HLV3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 17:29:31 -0400
Received: from smtp-out.google.com ([74.125.121.35]:54695 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760680Ab0HLV33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 17:29:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:x-system-of-record;
	b=sqha0/V3HqK8+6KIJPAUPKFvd3hPmJhkfXBx+3hGqFrVvc7XvPefctQzbsXegzfjB
	WReJOK3cFwEkAXzD07NRQ==
From: Venkatesh Pallipadi <venki@google.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: linux-kernel@vger.kernel.org, Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH] x86: Wrong /proc/cpuinfo core id on AMD fam_f model_9
Date: Thu, 12 Aug 2010 14:28:49 -0700
Message-Id: <1281648529-29678-1-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 4a376ec3a2599c02207cd4cbd5dbf73783548463 changes cpuinfo cpu_core_id
from an unique id in a physical package to core id within a node. And it
does not change phys_proc_id or booted_cores to reflect this new topology.

This breaks the user view of topology in /proc/cpuinfo.

With commit 4a376ec /proc/cpuinfo output (for one package) looks something like
processor: 0..11
physical id: 0..0
core id: 0..5 0..5
siblings: 12
cpu cores: 12

That is, there are processors with same "physical id" and same "core id" (which
are not SMT siblings). As I understand, if /proc/cpuinfo says there are 12
"cpu cores" per package, there should be 12 unique core ids in that package.
And same "physical id" and "core id" is supposed to indicate SMT siblings.

The change below reverts the cpu_core_id part of that commit and
/proc/cpuinfo has
processor: 0..11
physical id: 0..0
core id: 0..11
siblings: 12
cpu cores: 12


Also, if the intention of the original change was to export two node info,
then changing just the core id is not enough. User has no way to determine
which of these 6 cores out of 12 belong to same node by looking at
/proc/cpuinfo output. Both "physical id" and "cpu cores" has to change
to reflect that or one more node id needs to be added (I didn't say that :))

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 arch/x86/kernel/cpu/amd.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index e485825..80d3d80 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -281,9 +281,6 @@ static void __cpuinit amd_fixup_dcm(struct cpuinfo_x86 *c)
 
 	/* store NodeID, use llc_shared_map to store sibling info */
 	per_cpu(cpu_llc_id, cpu) = value & 7;
-
-	/* fixup core id to be in range from 0 to (cores_per_node - 1) */
-	c->cpu_core_id = c->cpu_core_id % cores_per_node;
 }
 #endif
 
-- 
1.7.1

