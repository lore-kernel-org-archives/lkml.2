Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab0EFJYn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 05:24:43 -0400
Received: from smtp-out.google.com ([216.239.44.51]:50589 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032Ab0EFJYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 05:24:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=CDUPAsN9RT4favJG8Z6EL54Y/SvQowQePDoqnfjv4SBhnf+74ME1WoPCYk2WnqRLN
	bHSPur16iwpfZayoWdUIA==
Date: Thu, 6 May 2010 02:24:34 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@elte.hu>
cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch v2] x86: fix fake apicid to node mapping for numa emulation
In-Reply-To: <alpine.DEB.2.00.1005060222560.19473@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1005060224140.19473@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1005041659400.13683@chino.kir.corp.google.com> <20100506070732.GA32002@elte.hu> <alpine.DEB.2.00.1005060222560.19473@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With NUMA emulation, it's possible for a single cpu to be bound to
multiple nodes since more than one may have affinity if allocated on a
physical node that is local to the cpu.

APIC ids must therefore be mapped to the lowest node ids to maintain
generic kernel use of functions such as cpu_to_node() that determine
device affinity.  For example, if a device has proximity to physical node
1, for instance, and a cpu happens to be mapped to a higher emulated node
id 8, the proximity may not be correctly determined by comparison in
generic code even though the cpu may be truly local and allocated on
physical node 1.  When this happens, the true topology of the machine
isn't accurately represented in the emulated environment; although this
isn't critical to the system's uptime, any generic code that is NUMA
aware benefits from the physical topology being accurated represented.

This can affect any system that maps multiple APIC ids to a single node
and is booted with numa=fake=N where N is greater than the number of
physical nodes.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86/mm/srat_64.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
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
