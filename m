Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431Ab2LTBm0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 20:42:26 -0500
Received: from mail-da0-f43.google.com ([209.85.210.43]:48353 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab2LTBmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 20:42:20 -0500
Date: Wed, 19 Dec 2012 17:42:16 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Mel Gorman <mgorman@suse.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sasha.levin@oracle.com>,
        Petr Holasek <pholasek@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH] sched: numa: ksm: fix oops in task_numa_placment()
Message-ID: <alpine.LNX.2.00.1212191735530.25409@eggly.anvils>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

task_numa_placement() oopsed on NULL p->mm when task_numa_fault()
got called in the handling of break_ksm() for ksmd.  That might be a
peculiar case, which perhaps KSM could takes steps to avoid? but it's
more robust if task_numa_placement() allows for such a possibility.

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 kernel/sched/fair.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- 3.7+git/kernel/sched/fair.c	2012-12-16 16:35:08.724441527 -0800
+++ linux/kernel/sched/fair.c	2012-12-18 21:37:24.727964195 -0800
@@ -793,8 +793,11 @@ unsigned int sysctl_numa_balancing_scan_
 
 static void task_numa_placement(struct task_struct *p)
 {
-	int seq = ACCESS_ONCE(p->mm->numa_scan_seq);
+	int seq;
 
+	if (!p->mm)	/* for example, ksmd faulting in a user's mm */
+		return;
+	seq = ACCESS_ONCE(p->mm->numa_scan_seq);
 	if (p->numa_scan_seq == seq)
 		return;
 	p->numa_scan_seq = seq;
