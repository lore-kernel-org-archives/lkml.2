Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758815Ab2EUTv4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 15:51:56 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35056 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183Ab2EUTvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 15:51:54 -0400
Date: Mon, 21 May 2012 21:51:49 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core/debugobjects changes for v3.5
Message-ID: <20120521195149.GA6178@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-debugobjects-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-debugobjects-for-linus

   HEAD: 3340808cf04faad7b87d6c6e13800825e5552b51 debugobjects: Fill_pool() returns void now

Not much happened: it includes a cleanup and an irq latency 
reduction fixlet.

 Thanks,

	Ingo

------------------>
Dan Carpenter (1):
      debugobjects: Fill_pool() returns void now

Thomas Gleixner (2):
      debugobjects: Remove unused return value from fill_pool()
      debugobjects: printk with irqs enabled


 lib/debugobjects.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index 0ab9ae8..d11808c 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -79,30 +79,29 @@ static const char *obj_states[ODEBUG_STATE_MAX] = {
 	[ODEBUG_STATE_NOTAVAILABLE]	= "not available",
 };
 
-static int fill_pool(void)
+static void fill_pool(void)
 {
 	gfp_t gfp = GFP_ATOMIC | __GFP_NORETRY | __GFP_NOWARN;
 	struct debug_obj *new;
 	unsigned long flags;
 
 	if (likely(obj_pool_free >= ODEBUG_POOL_MIN_LEVEL))
-		return obj_pool_free;
+		return;
 
 	if (unlikely(!obj_cache))
-		return obj_pool_free;
+		return;
 
 	while (obj_pool_free < ODEBUG_POOL_MIN_LEVEL) {
 
 		new = kmem_cache_zalloc(obj_cache, gfp);
 		if (!new)
-			return obj_pool_free;
+			return;
 
 		raw_spin_lock_irqsave(&pool_lock, flags);
 		hlist_add_head(&new->node, &obj_pool);
 		obj_pool_free++;
 		raw_spin_unlock_irqrestore(&pool_lock, flags);
 	}
-	return obj_pool_free;
 }
 
 /*
@@ -1052,10 +1051,10 @@ static int __init debug_objects_replace_static_objects(void)
 			cnt++;
 		}
 	}
+	local_irq_enable();
 
 	printk(KERN_DEBUG "ODEBUG: %d of %d active objects replaced\n", cnt,
 	       obj_pool_used);
-	local_irq_enable();
 	return 0;
 free:
 	hlist_for_each_entry_safe(obj, node, tmp, &objects, node) {
