Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145Ab1BGWJD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 17:09:03 -0500
Received: from smtp-out.google.com ([74.125.121.67]:10387 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064Ab1BGWJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 17:09:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=KyD4wWowdHYs67nJ6utR2t5mEOox5FiGBOKjHYcuQKOErtW+3o1eJIDArcMwrLeESa
         oNXD67u2ixitXnh8kmcw==
Date: Mon, 7 Feb 2011 14:08:53 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
cc: Andrew Morton <akpm@linux-foundation.org>, Jesper Juhl <jj@chaosbits.net>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [patch] x86, numa: Add error handling for bad cpu-to-node mappings
Message-ID: <alpine.DEB.2.00.1102071407250.7812@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 arch/x86/mm/numa.c    |    4 ++++
 arch/x86/mm/numa_64.c |    4 ++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -219,6 +219,10 @@ struct cpumask __cpuinit *debug_cpumask_set_cpu(int cpu, int enable)
 	struct cpumask *mask;
 	char buf[64];
 
+	if (node == NUMA_NO_NODE) {
+		/* early_cpu_to_node() already emits a warning and trace */
+		return NULL;
+	}
 	mask = node_to_cpumask_map[node];
 	if (!mask) {
 		pr_err("node_to_cpumask_map[%i] NULL\n", node);
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -709,6 +709,10 @@ static void __cpuinit numa_set_cpumask(int cpu, int enable)
 	struct cpumask *mask;
 	int i;
 
+	if (node == NUMA_NO_NODE) {
+		/* early_cpu_to_node() already emits a warning and trace */
+		return;
+	}
 	for_each_online_node(i) {
 		unsigned long addr;
 
