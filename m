Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab2GPKIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 06:08:42 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:47734 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753119Ab2GPKIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 06:08:31 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19qsUgk9hZq7RDP/SG1uyDH6MwMF9iIzte29OAW8t
	+epvILIhkagtid
Message-ID: <1342433303.7659.42.camel@marge.simpson.net>
Subject: Re: Deadlocks due to per-process plugging
From: Mike Galbraith <efault@gmx.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jan Kara <jack@suse.cz>, Jeff Moyer <jmoyer@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        mgalbraith@suse.com
Date: Mon, 16 Jul 2012 12:08:23 +0200
In-Reply-To: <1342432094.7659.39.camel@marge.simpson.net>
References: <20120711133735.GA8122@quack.suse.cz>
	 <x49ehoii8ps.fsf@segfault.boston.devel.redhat.com>
	 <20120711201601.GB9779@quack.suse.cz>
	 <alpine.LFD.2.02.1207121552111.32033@ionos>
	 <20120713123318.GB20361@quack.suse.cz>
	 <alpine.LFD.2.02.1207131444490.32033@ionos>
	 <20120713144622.GB28715@quack.suse.cz>
	 <alpine.LFD.2.02.1207151057010.32033@ionos>
	 <1342343673.28142.2.camel@marge.simpson.net>
	 <1342405366.7659.35.camel@marge.simpson.net>
	 <alpine.LFD.2.02.1207161058550.32033@ionos>
	 <1342432094.7659.39.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hm, wonder how bad this sucks.. and if I should go hide under a big
sturdy rock after I poke xmit :)

---
 block/blk-core.c |    1 +
 kernel/rtmutex.c |   11 +++++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2782,6 +2782,7 @@ void blk_flush_plug_list(struct blk_plug
 	if (q)
 		queue_unplugged(q, depth, from_schedule);
 }
+EXPORT_SYMBOL(blk_flush_plug_list);
 
 void blk_finish_plug(struct blk_plug *plug)
 {
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -20,6 +20,7 @@
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/timer.h>
+#include <linux/blkdev.h>
 
 #include "rtmutex_common.h"
 
@@ -647,8 +648,11 @@ static inline void rt_spin_lock_fastlock
 
 	if (likely(rt_mutex_cmpxchg(lock, NULL, current)))
 		rt_mutex_deadlock_account_lock(lock, current);
-	else
+	else {
+		if (blk_needs_flush_plug(current))
+			blk_schedule_flush_plug(current);
 		slowfn(lock);
+	}
 }
 
 static inline void rt_spin_lock_fastunlock(struct rt_mutex *lock,
@@ -1104,8 +1108,11 @@ rt_mutex_fastlock(struct rt_mutex *lock,
 	if (!detect_deadlock && likely(rt_mutex_cmpxchg(lock, NULL, current))) {
 		rt_mutex_deadlock_account_lock(lock, current);
 		return 0;
-	} else
+	} else {
+		if (blk_needs_flush_plug(current))
+			blk_schedule_flush_plug(current);
 		return slowfn(lock, state, NULL, detect_deadlock);
+	}
 }
 
 static inline int


