Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608Ab0EFKHo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 06:07:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:41269 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360Ab0EFKHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 06:07:42 -0400
Date: Thu, 6 May 2010 10:07:17 GMT
From: tip-bot for David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
       rientjes@google.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
       rientjes@google.com, mingo@elte.hu
In-Reply-To: <alpine.DEB.2.00.1005060224140.19473@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1005060224140.19473@chino.kir.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix fake apicid to node mapping for numa emulation
Message-ID: <tip-b0c4d952a158a6a2547672cf4fc9d55e415410de@git.kernel.org>
Git-Commit-ID: b0c4d952a158a6a2547672cf4fc9d55e415410de
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 06 May 2010 10:07:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b0c4d952a158a6a2547672cf4fc9d55e415410de
Gitweb:     http://git.kernel.org/tip/b0c4d952a158a6a2547672cf4fc9d55e415410de
Author:     David Rientjes <rientjes@google.com>
AuthorDate: Thu, 6 May 2010 02:24:34 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 6 May 2010 12:02:05 +0200

x86: Fix fake apicid to node mapping for numa emulation

With NUMA emulation, it's possible for a single cpu to be bound
to multiple nodes since more than one may have affinity if
allocated on a physical node that is local to the cpu.

APIC ids must therefore be mapped to the lowest node ids to
maintain generic kernel use of functions such as cpu_to_node()
that determine device affinity.  For example, if a device has
proximity to physical node 1, for instance, and a cpu happens to
be mapped to a higher emulated node id 8, the proximity may not
be correctly determined by comparison in generic code even
though the cpu may be truly local and allocated on physical node 1.

When this happens, the true topology of the machine isn't
accurately represented in the emulated environment; although
this isn't critical to the system's uptime, any generic code
that is NUMA aware benefits from the physical topology being
accurately represented.

This can affect any system that maps multiple APIC ids to a
single node and is booted with numa=fake=N where N is greater
than the number of physical nodes.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <alpine.DEB.2.00.1005060224140.19473@chino.kir.corp.google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/srat_64.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index 28c6876..38512d0 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -461,7 +461,8 @@ void __init acpi_fake_nodes(const struct bootnode *fake_nodes, int num_nodes)
 		 * node, it must now point to the fake node ID.
 		 */
 		for (j = 0; j < MAX_LOCAL_APIC; j++)
-			if (apicid_to_node[j] == nid)
+			if (apicid_to_node[j] == nid &&
+			    fake_apicid_to_node[j] == NUMA_NO_NODE)
 				fake_apicid_to_node[j] = i;
 	}
 	for (i = 0; i < num_nodes; i++)
