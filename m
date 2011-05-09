Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754Ab1EICtB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 22:49:01 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33521 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818Ab1EICs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 22:48:58 -0400
Date: Mon, 9 May 2011 12:41:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Pekka Enberg <penberg@cs.helsinki.fi>,
        Christoph Lameter <cl@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: linux-next: manual merge of the slab tree with Linus' tree
Message-Id: <20110509124158.1c099f24.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the slab tree got a conflict in mm/slub.c
between commit 30106b8ce2cc ("slub: Fix the lockless code on 32-bit
platforms with no 64-bit cmpxchg") from Linus' tree and commit
1759415e630e ("slub: Remove CONFIG_CMPXCHG_LOCAL ifdeffery") from the
slab tree.

Just context changes (maybe).  I fixed it up (see below) and can carry
the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/slub.c
index 9d2e5e4,461199f..0000000
--- a/mm/slub.c
+++ b/mm/slub.c
@@@ -1927,9 -1918,8 +1918,8 @@@ redo
  		object = __slab_alloc(s, gfpflags, node, addr, c);
  
  	else {
- #ifdef CONFIG_CMPXCHG_LOCAL
  		/*
 -		 * The cmpxchg will only match if there was no additonal
 +		 * The cmpxchg will only match if there was no additional
  		 * operation and if we are on the right processor.
  		 *
  		 * The cmpxchg does the following atomically (without lock semantics!)
@@@ -2144,8 -2103,7 +2103,7 @@@ redo
  	if (likely(page == c->page && c->node != NUMA_NO_NODE)) {
  		set_freepointer(s, object, c->freelist);
  
- #ifdef CONFIG_CMPXCHG_LOCAL
 -		if (unlikely(!this_cpu_cmpxchg_double(
 +		if (unlikely(!irqsafe_cpu_cmpxchg_double(
  				s->cpu_slab->freelist, s->cpu_slab->tid,
  				c->freelist, tid,
  				object, next_tid(tid)))) {
