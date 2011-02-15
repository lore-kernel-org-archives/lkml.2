Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab1BODK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 22:10:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:52193 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192Ab1BODKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 22:10:54 -0500
Date: Tue, 15 Feb 2011 03:10:19 GMT
From: tip-bot for Borislav Petkov <bp@amd64.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        andreas.herrmann3@amd.com, bp@amd64.org, akpm@linux-foundation.org,
        tglx@linutronix.de, mingo@elte.hu, borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andreas.herrmann3@amd.com, bp@amd64.org, akpm@linux-foundation.org,
        tglx@linutronix.de, mingo@elte.hu, borislav.petkov@amd.com
In-Reply-To: <20110214171451.GB10076@kryptos.osrc.amd.com>
References: <20110214171451.GB10076@kryptos.osrc.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/amd-nb] x86, amd: Initialize variable properly
Message-ID: <tip-9e81509efc4fefcdd75cc6a4121672fa71ae8745@git.kernel.org>
Git-Commit-ID: 9e81509efc4fefcdd75cc6a4121672fa71ae8745
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 15 Feb 2011 03:10:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9e81509efc4fefcdd75cc6a4121672fa71ae8745
Gitweb:     http://git.kernel.org/tip/9e81509efc4fefcdd75cc6a4121672fa71ae8745
Author:     Borislav Petkov <bp@amd64.org>
AuthorDate: Mon, 14 Feb 2011 18:14:51 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Feb 2011 03:03:19 +0100

x86, amd: Initialize variable properly

Commit d518573de63f ("x86, amd: Normalize compute unit IDs on
multi-node processors") introduced compute unit normalization
but causes a compiler warning:

 arch/x86/kernel/cpu/amd.c: In function 'amd_detect_cmp':
 arch/x86/kernel/cpu/amd.c:268: warning: 'cores_per_cu' may be used uninitialized in this function
 arch/x86/kernel/cpu/amd.c:268: note: 'cores_per_cu' was declared here

The compiler is right - initialize it with a proper value.

Also, fix up a comment while at it.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
LKML-Reference: <20110214171451.GB10076@kryptos.osrc.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/amd.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 990cc48..589bdd7 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -261,7 +261,7 @@ static int __cpuinit nearby_node(int apicid)
 #ifdef CONFIG_X86_HT
 static void __cpuinit amd_get_topology(struct cpuinfo_x86 *c)
 {
-	u32 nodes, cores_per_cu;
+	u32 nodes, cores_per_cu = 1;
 	u8 node_id;
 	int cpu = smp_processor_id();
 
@@ -276,7 +276,7 @@ static void __cpuinit amd_get_topology(struct cpuinfo_x86 *c)
 		/* get compute unit information */
 		smp_num_siblings = ((ebx >> 8) & 3) + 1;
 		c->compute_unit_id = ebx & 0xff;
-		cores_per_cu = ((ebx >> 8) & 3) + 1;
+		cores_per_cu += ((ebx >> 8) & 3);
 	} else if (cpu_has(c, X86_FEATURE_NODEID_MSR)) {
 		u64 value;
 
@@ -298,7 +298,7 @@ static void __cpuinit amd_get_topology(struct cpuinfo_x86 *c)
 		/* store NodeID, use llc_shared_map to store sibling info */
 		per_cpu(cpu_llc_id, cpu) = node_id;
 
-		/* core id to be in range from 0 to (cores_per_node - 1) */
+		/* core id has to be in the [0 .. cores_per_node - 1] range */
 		c->cpu_core_id %= cores_per_node;
 		c->compute_unit_id %= cus_per_node;
 	}
