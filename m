Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab1CEPua (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 10:50:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:58551 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577Ab1CEPu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 10:50:29 -0500
Date: Sat, 5 Mar 2011 15:50:09 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tj@kernel.org, tglx@linutronix.de, rientjes@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tj@kernel.org, tglx@linutronix.de, rientjes@google.com
In-Reply-To: <alpine.DEB.2.00.1103020628210.31626@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1103020628210.31626@chino.kir.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86-64, NUMA: Don't assume phys node 0 is always online in numa_emulation()
Message-ID: <tip-078a198906c796981f93ff100c210506e91aade5@git.kernel.org>
Git-Commit-ID: 078a198906c796981f93ff100c210506e91aade5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 05 Mar 2011 15:50:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  078a198906c796981f93ff100c210506e91aade5
Gitweb:     http://git.kernel.org/tip/078a198906c796981f93ff100c210506e91aade5
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Fri, 4 Mar 2011 16:32:02 +0100
Committer:  Tejun Heo <tj@kernel.org>
CommitDate: Fri, 4 Mar 2011 16:32:37 +0100

x86-64, NUMA: Don't assume phys node 0 is always online in numa_emulation()

Undetermined entries in emu_nid_to_phys[] are filled with zero
assuming that physical node 0 is always online; however, this might
not be true depending on hardware configuration.  Find a physical node
which is actually online and use it instead.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: David Rientjes <rientjes@google.com>
LKML-Reference: <alpine.DEB.2.00.1103020628210.31626@chino.kir.corp.google.com>
---
 arch/x86/mm/numa_emulation.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/numa_emulation.c b/arch/x86/mm/numa_emulation.c
index 75b31dc..3696be0 100644
--- a/arch/x86/mm/numa_emulation.c
+++ b/arch/x86/mm/numa_emulation.c
@@ -301,6 +301,7 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
 	const u64 max_addr = max_pfn << PAGE_SHIFT;
 	u8 *phys_dist = NULL;
 	size_t phys_size = numa_dist_cnt * numa_dist_cnt * sizeof(phys_dist[0]);
+	int dfl_phys_nid;
 	int i, j, ret;
 
 	if (!emu_cmdline)
@@ -357,6 +358,19 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
 					node_distance(i, j);
 	}
 
+	/* determine the default phys nid to use for unmapped nodes */
+	dfl_phys_nid = NUMA_NO_NODE;
+	for (i = 0; i < ARRAY_SIZE(emu_nid_to_phys); i++) {
+		if (emu_nid_to_phys[i] != NUMA_NO_NODE) {
+			dfl_phys_nid = emu_nid_to_phys[i];
+			break;
+		}
+	}
+	if (dfl_phys_nid == NUMA_NO_NODE) {
+		pr_warning("NUMA: Warning: can't determine default physical node, disabling emulation\n");
+		goto no_emu;
+	}
+
 	/* commit */
 	*numa_meminfo = ei;
 
@@ -377,7 +391,7 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
 	/* make sure all emulated nodes are mapped to a physical node */
 	for (i = 0; i < ARRAY_SIZE(emu_nid_to_phys); i++)
 		if (emu_nid_to_phys[i] == NUMA_NO_NODE)
-			emu_nid_to_phys[i] = 0;
+			emu_nid_to_phys[i] = dfl_phys_nid;
 
 	/*
 	 * Transform distance table.  numa_set_distance() ignores all
