Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab2E1D31 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:29:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51935 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753585Ab2E1D3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:14 -0400
Message-Id: <20120528031207.304707365@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:12:34 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Steven Rostedt <rostedt@goodmis.org>,
        David Rientjes <rientjes@google.com>
Subject: [ 032/117] Fix blocking allocations called very early during bootup
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 31a67102f4762df5544bc2dfb34a931233d2a5b2 upstream.

During early boot, when the scheduler hasn't really been fully set up,
we really can't do blocking allocations because with certain (dubious)
configurations the "might_resched()" calls can actually result in
scheduling events.

We could just make such users always use GFP_ATOMIC, but quite often the
code that does the allocation isn't really aware of the fact that the
scheduler isn't up yet, and forcing that kind of random knowledge on the
initialization code is just annoying and not good for anybody.

And we actually have a the 'gfp_allowed_mask' exactly for this reason:
it's just that the kernel init sequence happens to set it to allow
blocking allocations much too early.

So move the 'gfp_allowed_mask' initialization from 'start_kernel()'
(which is some of the earliest init code, and runs with preemption
disabled for good reasons) into 'kernel_init()'.  kernel_init() is run
in the newly created thread that will become the 'init' process, as
opposed to the early startup code that runs within the context of what
will be the first idle thread.

So by the time we reach 'kernel_init()', we know that the scheduler must
be at least limping along, because we've already scheduled from the idle
thread into the init thread.

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 init/main.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/init/main.c b/init/main.c
index 44b2433..cb54cd3 100644
--- a/init/main.c
+++ b/init/main.c
@@ -560,9 +560,6 @@ asmlinkage void __init start_kernel(void)
 	early_boot_irqs_disabled = false;
 	local_irq_enable();
 
-	/* Interrupts are enabled now so all GFP allocations are safe. */
-	gfp_allowed_mask = __GFP_BITS_MASK;
-
 	kmem_cache_init_late();
 
 	/*
@@ -842,6 +839,10 @@ static int __init kernel_init(void * unused)
 	 * Wait until kthreadd is all set-up.
 	 */
 	wait_for_completion(&kthreadd_done);
+
+	/* Now the scheduler is fully set up and can do blocking allocations */
+	gfp_allowed_mask = __GFP_BITS_MASK;
+
 	/*
 	 * init can allocate pages on any node
 	 */


