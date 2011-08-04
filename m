Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab1HDIgk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 04:36:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:36353 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984Ab1HDIge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 04:36:34 -0400
Date: Thu, 4 Aug 2011 08:36:11 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Message-ID: <tip-30765b92ada267c5395fc788623cb15233276f5c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, penberg@kernel.org, peterz@infradead.org,
        nando@ccrma.Stanford.EDU, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, peterz@infradead.org, penberg@kernel.org,
        nando@ccrma.Stanford.EDU, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1311888176.2617.379.camel@laptop>
References: <1311888176.2617.379.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] slab, lockdep: Annotate the locks before using them
Git-Commit-ID: 30765b92ada267c5395fc788623cb15233276f5c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Aug 2011 08:36:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  30765b92ada267c5395fc788623cb15233276f5c
Gitweb:     http://git.kernel.org/tip/30765b92ada267c5395fc788623cb15233276f5c
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 28 Jul 2011 23:22:56 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Aug 2011 10:18:00 +0200

slab, lockdep: Annotate the locks before using them

Fernando found we hit the regular OFF_SLAB 'recursion' before we
annotate the locks, cure this.

The relevant portion of the stack-trace:

> [    0.000000]  [<c085e24f>] rt_spin_lock+0x50/0x56
> [    0.000000]  [<c04fb406>] __cache_free+0x43/0xc3
> [    0.000000]  [<c04fb23f>] kmem_cache_free+0x6c/0xdc
> [    0.000000]  [<c04fb2fe>] slab_destroy+0x4f/0x53
> [    0.000000]  [<c04fb396>] free_block+0x94/0xc1
> [    0.000000]  [<c04fc551>] do_tune_cpucache+0x10b/0x2bb
> [    0.000000]  [<c04fc8dc>] enable_cpucache+0x7b/0xa7
> [    0.000000]  [<c0bd9d3c>] kmem_cache_init_late+0x1f/0x61
> [    0.000000]  [<c0bba687>] start_kernel+0x24c/0x363
> [    0.000000]  [<c0bba0ba>] i386_start_kernel+0xa9/0xaf

Reported-by: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Acked-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1311888176.2617.379.camel@laptop
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 mm/slab.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 0703578..6d90a09 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1666,6 +1666,9 @@ void __init kmem_cache_init_late(void)
 {
 	struct kmem_cache *cachep;
 
+	/* Annotate slab for lockdep -- annotate the malloc caches */
+	init_lock_keys();
+
 	/* 6) resize the head arrays to their final sizes */
 	mutex_lock(&cache_chain_mutex);
 	list_for_each_entry(cachep, &cache_chain, next)
@@ -1676,9 +1679,6 @@ void __init kmem_cache_init_late(void)
 	/* Done! */
 	g_cpucache_up = FULL;
 
-	/* Annotate slab for lockdep -- annotate the malloc caches */
-	init_lock_keys();
-
 	/*
 	 * Register a cpu startup notifier callback that initializes
 	 * cpu_cache_get for all new cpus
