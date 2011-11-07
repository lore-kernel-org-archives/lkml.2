Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab1KGIqN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 03:46:13 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46120 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab1KGIqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 03:46:12 -0500
Date: Mon, 7 Nov 2011 11:43:16 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>, David Rientjes <rientjes@google.com>,
        Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: WARNING: at kernel/lockdep.c:690 __lock_acquire+0x168/0x164b()
Message-ID: <20111107084316.GA3106@swordfish.waw.cen>
References: <20111020230040.GC3586@swordfish.minsk.epam.com>
 <alpine.DEB.2.00.1110210212130.12963@chino.kir.corp.google.com>
 <20111021094520.GA9884@zhy>
 <20111103071735.GA3228@swordfish.minsk.epam.com>
 <20111103072705.GA15871@zhy>
 <20111103074506.GB3228@swordfish.minsk.epam.com>
 <20111103075354.GA16666@zhy>
 <20111104092520.GA16897@gere.osrc.amd.com>
 <20111104093123.GA2957@swordfish>
 <20111107045456.GB3893@zhy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111107045456.GB3893@zhy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (11/07/11 12:54), Yong Zhang wrote:
> > > > Understood. If someone can come up with a simple patch which could
> > > > cover the case I mentioned before, that would be great.
> > > > /me goes to poke at it.
> > > 
> > > I dunno whether this is related but I get the following on 3.1:
> > >
> > 
> > I think this is different problem. Failed check that lockdep key is marked as `static'.
> 
> Actually the lockdep_init_map() in __lock_set_class could lead to
> more problem, such as: certain rq->lock could have different 'key'
> with what we give them in sched_init() because rq is defined staticly.
> 
> Given that, we could have another typical race:
> 
>           CPU A                                   CPU B
>     lock_set_subclass(lockA);
>       lock_set_class(lockA);
>                                             /* lockA->class_cache[] is not set */
>                                             register_lock_class(lockA);
>                                               look_up_lock_class(lockA); /* retrun NULL */
>         lockdep_init_map(lockA);
>           /* lockA->name is cleared */
>           memset(lockA);
>    						if (!static_obj(lock->key))
> 						  /* we get warning here */
>           lock->name = name;
>     
> 
> So memset() in lockdep_init_map() is still the culprit IMHO.
>

Hm, agreed, that still could be the reason.
I guess a little more information may be helpful in some cases.

---
Print key address when attempt to register non-static lock key detected.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index e69434b..de8a996 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -729,7 +729,7 @@ register_lock_class(struct lockdep_map *lock, unsigned int subclass, int force)
  	 */
 	if (!static_obj(lock->key)) {
 		debug_locks_off();
-		printk("INFO: trying to register non-static key.\n");
+		printk("INFO: trying to register non-static key at address %p.\n", lock->key);
 		printk("the code is fine but needs lockdep annotation.\n");
 		printk("turning off the locking correctness validator.\n");
 		dump_stack();

