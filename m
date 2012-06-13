Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab2FMNhc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 09:37:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52719 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106Ab2FMNh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 09:37:29 -0400
Date: Wed, 13 Jun 2012 06:36:22 -0700
From: tip-bot for David Rientjes <rientjes@google.com>
Message-ID: <tip-1f49a99116069a8d9dc6027862277a766c2ef17e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        lee.schermerhorn@hp.com, tglx@linutronix.de, sfr@canb.auug.org.au,
        rientjes@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        lee.schermerhorn@hp.com, tglx@linutronix.de, sfr@canb.auug.org.au,
        rientjes@google.com
In-Reply-To: <alpine.DEB.2.00.1205222116160.32649@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1205222116160.32649@chino.kir.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] sched/numa: Allocate 'struct node_queue'
  on any node for offline nodes
Git-Commit-ID: 1f49a99116069a8d9dc6027862277a766c2ef17e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 13 Jun 2012 06:36:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1f49a99116069a8d9dc6027862277a766c2ef17e
Gitweb:     http://git.kernel.org/tip/1f49a99116069a8d9dc6027862277a766c2ef17e
Author:     David Rientjes <rientjes@google.com>
AuthorDate: Tue, 22 May 2012 21:17:56 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 13 Jun 2012 15:25:37 +0200

sched/numa: Allocate 'struct node_queue' on any node for offline nodes

'struct node_queue' must be allocated with NUMA_NO_NODE for nodes
that are not (yet) online, otherwise the page allocator has a
bad zonelist and results in an early crash.

Tested-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/alpine.DEB.2.00.1205222116160.32649@chino.kir.corp.google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/numa.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/numa.c b/kernel/sched/numa.c
index 77fa7d4..002f71c 100644
--- a/kernel/sched/numa.c
+++ b/kernel/sched/numa.c
@@ -829,7 +829,8 @@ static __init int numa_init(void)
 
 	for_each_node(node) {
 		struct node_queue *nq = kmalloc_node(sizeof(*nq),
-				GFP_KERNEL | __GFP_ZERO, node);
+				GFP_KERNEL | __GFP_ZERO,
+				node_online(node) ? node : NUMA_NO_NODE);
 		BUG_ON(!nq);
 
 		spin_lock_init(&nq->lock);
