Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab1ILOGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 10:06:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46610 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774Ab1ILOGT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 10:06:19 -0400
Subject: [PATCH 8/5] llist: Remove cpu_relax() usage in cmpxchg loops
From: Peter Zijlstra <peterz@infradead.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Mon, 12 Sep 2011 16:05:58 +0200
In-Reply-To: <1315461646-1379-1-git-send-email-ying.huang@intel.com>
References: <1315461646-1379-1-git-send-email-ying.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1315836358.26517.43.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: llist: Remove cpu_relax() usage in cmpxchg loops
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon Sep 12 15:50:49 CEST 2011

Initial benchmarks show they're a net loss (2 socket wsm):

 $ for i in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor ; do echo performance > $i; done
 $ echo 4096 32000 64 128 > /proc/sys/kernel/sem
 $ ./sembench -t 2048 -w 1900 -o 0

Pre:

run time 30 seconds 778936 worker burns per second
run time 30 seconds 912190 worker burns per second
run time 30 seconds 817506 worker burns per second
run time 30 seconds 830870 worker burns per second
run time 30 seconds 845056 worker burns per second

Post:

run time 30 seconds 905920 worker burns per second
run time 30 seconds 849046 worker burns per second
run time 30 seconds 886286 worker burns per second
run time 30 seconds 822320 worker burns per second
run time 30 seconds 900283 worker burns per second

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/llist.h |    3 ---
 1 file changed, 3 deletions(-)

Index: linux-2.6/include/linux/llist.h
===================================================================
--- linux-2.6.orig/include/linux/llist.h
+++ linux-2.6/include/linux/llist.h
@@ -169,7 +169,6 @@ static inline bool llist_add(struct llis
 		entry = cmpxchg(&head->first, old_entry, new);
 		if (entry == old_entry)
 			break;
-		cpu_relax();
 	}
 
 	return old_entry == NULL;
@@ -198,7 +197,6 @@ static inline bool llist_add_batch(struc
 		entry = cmpxchg(&head->first, old_entry, new_first);
 		if (entry == old_entry)
 			break;
-		cpu_relax();
 	}
 
 	return old_entry == NULL;
@@ -233,7 +231,6 @@ static inline struct llist_node *llist_d
 		entry = cmpxchg(&head->first, old_entry, next);
 		if (entry == old_entry)
 			break;
-		cpu_relax();
 	}
 
 	return entry;

