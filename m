Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578Ab2EWESH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 00:18:07 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37355 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab2EWESF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 00:18:05 -0400
Date: Tue, 22 May 2012 21:17:56 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [patch] sched, numa: Allocate node_queue on any node for offline
 nodes
In-Reply-To: <20120522130354.fdb335eb294f4206b4b2fed5@canb.auug.org.au>
Message-ID: <alpine.DEB.2.00.1205222116160.32649@chino.kir.corp.google.com>
References: <20120522114051.0c9db9a7c2d660bc9e0e1be2@canb.auug.org.au> <alpine.DEB.2.00.1205211846120.20916@chino.kir.corp.google.com> <20120522130354.fdb335eb294f4206b4b2fed5@canb.auug.org.au>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct node_queue must be allocated with NUMA_NO_NODE for nodes that are 
not (yet) online, otherwise the page allocator has a bad zonelist and 
results in an early crash.

Tested-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 kernel/sched/numa.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/numa.c b/kernel/sched/numa.c
--- a/kernel/sched/numa.c
+++ b/kernel/sched/numa.c
@@ -885,7 +885,8 @@ static __init int numa_init(void)
 
 	for_each_node(node) {
 		struct node_queue *nq = kmalloc_node(sizeof(*nq),
-				GFP_KERNEL | __GFP_ZERO, node);
+				GFP_KERNEL | __GFP_ZERO,
+				node_online(node) ? node : NUMA_NO_NODE);
 		BUG_ON(!nq);
 
 		spin_lock_init(&nq->lock);
