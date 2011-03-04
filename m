Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759585Ab1CDObu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 09:31:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:49762 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267Ab1CDObt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 09:31:49 -0500
Date: Fri, 4 Mar 2011 14:31:15 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, tj@kernel.org, tglx@linutronix.de,
        rientjes@google.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tj@kernel.org, tglx@linutronix.de,
        rientjes@google.com, mingo@elte.hu
In-Reply-To: <4D6ECF72.5010308@kernel.org>
References: <4D6ECF72.5010308@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, numa: Fix numa_emulation code with memory-less node0
Message-ID: <tip-3b28cf32cc32594710590685ee478f697ed4f328@git.kernel.org>
Git-Commit-ID: 3b28cf32cc32594710590685ee478f697ed4f328
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 04 Mar 2011 14:31:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3b28cf32cc32594710590685ee478f697ed4f328
Gitweb:     http://git.kernel.org/tip/3b28cf32cc32594710590685ee478f697ed4f328
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Wed, 2 Mar 2011 15:14:58 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 4 Mar 2011 15:20:19 +0100

x86, numa: Fix numa_emulation code with memory-less node0

This crash happens on a system that does not have RAM on node0.

When numa_emulation is compiled in, and:

 1. we boot the system without numa=fake...
 2. or we boot the system with numa=fake=128 to make emulation fail

we will get:

[    0.076025] ------------[ cut here ]------------
[    0.080004] kernel BUG at arch/x86/mm/numa_64.c:788!
[    0.080004] invalid opcode: 0000 [#1] SMP
[...]

need to use early_cpu_to_node() directly, because cpu_to_apicid
and apicid_to_node will return node0 that is not onlined.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
LKML-Reference: <4D6ECF72.5010308@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/numa_64.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 95ea155..1337c51 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -780,11 +780,7 @@ void __cpuinit numa_add_cpu(int cpu)
 	int physnid;
 	int nid = NUMA_NO_NODE;
 
-	apicid = early_per_cpu(x86_cpu_to_apicid, cpu);
-	if (apicid != BAD_APICID)
-		nid = apicid_to_node[apicid];
-	if (nid == NUMA_NO_NODE)
-		nid = early_cpu_to_node(cpu);
+	nid = early_cpu_to_node(cpu);
 	BUG_ON(nid == NUMA_NO_NODE || !node_online(nid));
 
 	/*
