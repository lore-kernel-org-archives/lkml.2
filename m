Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933Ab2EYHbl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 03:31:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:56491 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab2EYHbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 03:31:39 -0400
Subject: Re: [tip:sched/core] sched/numa: Rewrite the CONFIG_NUMA sched
 domain support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Tony Luck <tony.luck@intel.com>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, cmetcalf@tilera.com,
        sivanich@sgi.com, akpm@linux-foundation.org, ralf@linux-mips.org,
        greg.pearson@hp.com, ink@jurassic.park.msu.ru, tglx@linutronix.de,
        rth@twiddle.net, kamezawa.hiroyu@jp.fujitsu.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com, anton@samba.org,
        lethal@linux-sh.org, davem@davemloft.net, benh@kernel.crashing.org,
        dhowells@redhat.com, mattst88@gmail.com, fenghua.yu@intel.com
In-Reply-To: <CA+8MBbJknmrUXG7U_hBaTs4vJ-1Fa-ENq5g3Qzzh6EmsNiSfXg@mail.gmail.com>
References: <tip-r74n3n8hhuc2ynbrnp3vt954@git.kernel.org>
	 <CA+8MBbJknmrUXG7U_hBaTs4vJ-1Fa-ENq5g3Qzzh6EmsNiSfXg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 May 2012 09:31:20 +0200
Message-ID: <1337931080.9783.154.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-24 at 14:23 -0700, Tony Luck wrote:
> Changing both the kzalloc_node() calls in sched_init_numa()
> into plain kzalloc() calls seems to fix things. So it looks like we are trying
> to allocate on a node before the node has been fully set up. 

Right,.. and its not too important either, so lets just use regular
allocations.

That said, I can only find the 1 alloc_node() in sched_init_numa()


---
Subject: sched: Don't try allocating memory from offline nodes
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri May 25 09:26:43 CEST 2012

Allocators don't appreciate it when you try and allocate memory from
offline nodes.

Reported-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched/core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/sched/core.c
===================================================================
--- linux-2.6.orig/kernel/sched/core.c
+++ linux-2.6/kernel/sched/core.c
@@ -6449,7 +6449,7 @@ static void sched_init_numa(void)
 			return;
 
 		for (j = 0; j < nr_node_ids; j++) {
-			struct cpumask *mask = kzalloc_node(cpumask_size(), GFP_KERNEL, j);
+			struct cpumask *mask = kzalloc(cpumask_size(), GFP_KERNEL);
 			if (!mask)
 				return;
 


