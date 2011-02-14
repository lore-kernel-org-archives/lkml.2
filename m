Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab1BNSHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 13:07:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:45628 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406Ab1BNSH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 13:07:29 -0500
Date: Mon, 14 Feb 2011 13:55:30 GMT
From: tip-bot for David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jj@chaosbits.net, tj@kernel.org, tglx@linutronix.de,
        rientjes@google.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jj@chaosbits.net, tj@kernel.org, tglx@linutronix.de,
        rientjes@google.com, mingo@elte.hu
In-Reply-To: <alpine.DEB.2.00.1102071407250.7812@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1102071407250.7812@chino.kir.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/numa] x86, numa: Add error handling for bad cpu-to-node mappings
Message-ID: <tip-14392fd329eca9b59d51c0aa5d0acfb4965424d1@git.kernel.org>
Git-Commit-ID: 14392fd329eca9b59d51c0aa5d0acfb4965424d1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 14 Feb 2011 18:06:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  14392fd329eca9b59d51c0aa5d0acfb4965424d1
Gitweb:     http://git.kernel.org/tip/14392fd329eca9b59d51c0aa5d0acfb4965424d1
Author:     David Rientjes <rientjes@google.com>
AuthorDate: Mon, 7 Feb 2011 14:08:53 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 14 Feb 2011 13:29:27 +0100

x86, numa: Add error handling for bad cpu-to-node mappings

CONFIG_DEBUG_PER_CPU_MAPS may return NUMA_NO_NODE when an
early_cpu_to_node() mapping hasn't been initialized.  In such a
case, it emits a warning and continues without an issue but
callers may try to use the return value to index into an array.

We can catch those errors and fail silently since a warning has
already been emitted.  No current user of numa_add_cpu()
requires this error checking to avoid a crash, but it's better
to be proactive in case a future user happens to have a bug and
a user tries to diagnose it with CONFIG_DEBUG_PER_CPU_MAPS.

Reported-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Tejun Heo <tj@kernel.org>
LKML-Reference: <alpine.DEB.2.00.1102071407250.7812@chino.kir.corp.google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/numa.c    |    4 ++++
 arch/x86/mm/numa_64.c |    4 ++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index bf60715..9559d36 100644
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
index f548fbf..3f9411e 100644
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
 
