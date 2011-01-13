Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772Ab1AMXFy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 18:05:54 -0500
Received: from smtp-out.google.com ([216.239.44.51]:47459 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab1AMXFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 18:05:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=HYLRnlPUTFbPf4c3hSC+0Q8lh0La33dXVzFgsEeI4EDqakrhCdy0aGWJ/8Kipmk10d
         3pjkNlTadjCJj3klXJbw==
Date: Thu, 13 Jan 2011 15:05:40 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jesper Juhl <jj@chaosbits.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [patch] x86, numa: Add error handling for bad cpu-to-node mappings
In-Reply-To: <alpine.LNX.2.00.1101132318010.11347@swampdragon.chaosbits.net>
Message-ID: <alpine.DEB.2.00.1101131450480.27760@chino.kir.corp.google.com>
References: <alpine.LNX.2.00.1101132318010.11347@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Jan 2011, Jesper Juhl wrote:

> In arch/x86/mm/numa_64.c::debug_cpumask_set_cpu() we call 
> early_cpu_to_node() which may return NUMA_NO_NODE (which has the value 
> -1). This value is subsequently used as an index into 
> the 'node_to_cpumask_map' array and '-1' is not going to fly too wel as an 
> array index here.
> 
> This code comes from commit d906f0eb2f0e6d1a24c479f69a9c39e7e45c5ae8
> "x86, numa: Fix CONFIG_DEBUG_PER_CPU_MAPS without NUMA emulation".
> 
> I must admit I have no idea what the best way to deal with this is, so 
> I'll just report it.
> 

Thanks for the report.

If generic code were actually passing cpu's to numa_add_cpu() under the 
defconfig that did not have valid early_cpu_to_node() mappings, then we'd 
see the problem already since we use early_cpu_to_node() as an index into 
an array with no error checking.

These mappings are all initialized to NUMA_NO_NODE before any mapping is 
initialized, so there's nothing new in the CONFIG_DEBUG_PER_CPU_MAPS 
variant of early_cpu_to_node() returning NUMA_NO_NODE when the cpu is not 
possible (generic code doesn't call numa_add_cpu() for non-possible cpus).

If you have a crash report for a CONFIG_DEBUG_PER_CPU_MAPS kernel, though, 
we can find why early_cpu_to_node() isn't being properly initialized prior 
to numa_add_cpu().

I agree that we should have some basic error handling in the debug case to 
check for this, though.  Please take a look at the following.



x86, numa: Add error handling for bad cpu-to-node mappings

CONFIG_DEBUG_PER_CPU_MAPS may return NUMA_NO_NODE when an
early_cpu_to_node() mapping hasn't been initialized.  In such a case, it
emits a warning and continues without an issue but callers may try to use
the return value to index into an array.

We can catch those errors and fail silently since a warning has already
been emitted.  No current user of numa_add_cpu() requires this error
checking to avoid a crash, but it's better to be proactive in case a
future user happens to have a bug and a user tries to diagnose it with 
CONFIG_DEBUG_PER_CPU_MAPS.

Reported-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86/mm/numa_64.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -839,6 +839,10 @@ static struct cpumask __cpuinit *debug_cpumask_set_cpu(int cpu, int enable)
 	struct cpumask *mask;
 	char buf[64];
 
+	if (node == NUMA_NO_NODE) {
+		/* early_cpu_to_node() already emits a warning and trace */
+		return NULL;
+	}
 	mask = node_to_cpumask_map[node];
 	if (!mask) {
 		pr_err("node_to_cpumask_map[%i] NULL\n", node);
@@ -877,6 +881,10 @@ static void __cpuinit numa_set_cpumask(int cpu, int enable)
 	struct cpumask *mask;
 	int i;
 
+	if (node == NUMA_NO_NODE) {
+		/* early_cpu_to_node() already emits a warning and trace */
+		return;
+	}
 	for_each_online_node(i) {
 		unsigned long addr;
 
