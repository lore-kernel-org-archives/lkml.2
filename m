Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759225Ab2EIM62 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 08:58:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40177 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab2EIM60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 08:58:26 -0400
Date: Wed, 9 May 2012 05:58:10 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-e1136ef7kdffj7yf9tjhydln@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, a.p.zijlstra@chello.nl, tj@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, a.p.zijlstra@chello.nl, tj@kernel.org,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] x86/numa: Allow specifying node_distance()
  for numa=fake
Git-Commit-ID: 94c0dd3278dd3eae52eabf0fb77d472d0dd3e373
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 09 May 2012 05:58:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  94c0dd3278dd3eae52eabf0fb77d472d0dd3e373
Gitweb:     http://git.kernel.org/tip/94c0dd3278dd3eae52eabf0fb77d472d0dd3e373
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 18 Apr 2012 19:04:17 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 May 2012 13:28:59 +0200

x86/numa: Allow specifying node_distance() for numa=fake

Allows emulating more interesting NUMA configurations like a quad
socket AMD Magny-Cour:

 "numa=fake=8:10,16,16,22,16,22,16,22,
              16,10,22,16,22,16,22,16,
              16,22,10,16,16,22,16,22,
              22,16,16,10,22,16,22,16,
              16,22,16,22,10,16,16,22,
              22,16,22,16,16,10,22,16,
              16,22,16,22,16,22,10,16,
              22,16,22,16,22,16,16,10"

Which has a non-fully-connected topology.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: x86@kernel.org
Link: http://lkml.kernel.org/n/tip-e1136ef7kdffj7yf9tjhydln@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/mm/numa_emulation.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/numa_emulation.c b/arch/x86/mm/numa_emulation.c
index 53489ff..871dd88 100644
--- a/arch/x86/mm/numa_emulation.c
+++ b/arch/x86/mm/numa_emulation.c
@@ -339,9 +339,11 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
 	} else {
 		unsigned long n;
 
-		n = simple_strtoul(emu_cmdline, NULL, 0);
+		n = simple_strtoul(emu_cmdline, &emu_cmdline, 0);
 		ret = split_nodes_interleave(&ei, &pi, 0, max_addr, n);
 	}
+	if (*emu_cmdline == ':')
+		emu_cmdline++;
 
 	if (ret < 0)
 		goto no_emu;
@@ -418,7 +420,9 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
 			int physj = emu_nid_to_phys[j];
 			int dist;
 
-			if (physi >= numa_dist_cnt || physj >= numa_dist_cnt)
+			if (get_option(&emu_cmdline, &dist) == 2)
+				;
+			else if (physi >= numa_dist_cnt || physj >= numa_dist_cnt)
 				dist = physi == physj ?
 					LOCAL_DISTANCE : REMOTE_DISTANCE;
 			else
