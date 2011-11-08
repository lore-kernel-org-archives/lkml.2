Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639Ab1KHN3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 08:29:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437Ab1KHN3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 08:29:19 -0500
From: Petr Holasek <pholasek@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: anton@redhat.com, Petr Holasek <pholasek@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de> (maintainer:X86
	ARCHITECTURE...),
        Ingo Molnar <mingo@redhat.com> (maintainer:X86 ARCHITECTURE... 
	,commit_signer:7/19=37%),
        "H. Peter Anvin" <hpa@zytor.com> (maintainer:X86 ARCHITECTURE...),
        x86@kernel.org (maintainer:X86 ARCHITECTURE...),
        Tejun Heo <tj@kernel.org> (commit_signer:15/19=79%),
        Pekka Enberg <penberg@kernel.org> (commit_signer:3/19=16%),
        David Rientjes <rientjes@google.com> (commit_signer:2/19=11%),
        Yinghai Lu <yinghai@kernel.org> (commit_signer:2/19=11%)
Subject: [PATCH] NUMA x86: add constraints check for nid parameters in numa.c functions
Date: Tue,  8 Nov 2011 14:28:42 +0100
Message-Id: <1320758922-7309-1-git-send-email-pholasek@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds constraints checks into __node_distance() and
numa_set_distance() functions. If from or to parameters are
lower than zero, it results into oops now.

Signed-off-by: Petr Holasek <pholasek@redhat.com>
---
 arch/x86/mm/numa.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index fbeaaf4..0f98356 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -439,6 +439,12 @@ void __init numa_set_distance(int from, int to, int distance)
 	if (!numa_distance && numa_alloc_distance() < 0)
 		return;
 
+	if (from < 0 || to < 0) {
+		pr_warn_once("NUMA: Warning: invalid from/to nid parameter, from=%d to=%d distance=%d\n",
+				from, to, distance);
+		return;
+	}
+
 	if (from >= numa_distance_cnt || to >= numa_distance_cnt) {
 		printk_once(KERN_DEBUG "NUMA: Debug: distance out of bound, from=%d to=%d distance=%d\n",
 			    from, to, distance);
@@ -457,7 +463,7 @@ void __init numa_set_distance(int from, int to, int distance)
 
 int __node_distance(int from, int to)
 {
-	if (from >= numa_distance_cnt || to >= numa_distance_cnt)
+	if (from < 0 || to < 0 || from >= numa_distance_cnt || to >= numa_distance_cnt)
 		return from == to ? LOCAL_DISTANCE : REMOTE_DISTANCE;
 	return numa_distance[from * numa_distance_cnt + to];
 }
-- 
1.7.6.4

