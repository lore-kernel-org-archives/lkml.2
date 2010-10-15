Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119Ab0JOMRW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 08:17:22 -0400
Received: from www.tglx.de ([62.245.132.106]:60301 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754301Ab0JOMRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 08:17:21 -0400
Date: Fri, 15 Oct 2010 14:16:54 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Louis Rilling <louis.rilling@kerlabs.com>
cc: LKML <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Ingo Molnar <mingo@elte.hu>,
        =?ISO-8859-15?Q?Matthieu_Fertr=E9?= <matthieu.fertre@kerlabs.com>,
        Darren Hart <darren@dvhart.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RESEND PATCH] futex: fix key reference counter in case of
 requeue.
In-Reply-To: <1287055805-18233-1-git-send-email-louis.rilling@kerlabs.com>
Message-ID: <alpine.LFD.2.00.1010151228130.2496@localhost6.localdomain6>
References: <1287055805-18233-1-git-send-email-louis.rilling@kerlabs.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-827123453-1287144454=:2496"
Content-ID: <alpine.LFD.2.00.1010151409490.2496@localhost6.localdomain6>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-827123453-1287144454=:2496
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LFD.2.00.1010151409491.2496@localhost6.localdomain6>

On Thu, 14 Oct 2010, Louis Rilling wrote:

> From: Matthieu Fertré <matthieu.fertre@kerlabs.com>
> 
> This patch ensures that we are referring to the right key when dropping
> reference for the futex_wait operation.
> 
> The following scenario explains a typical case where the bug was
> happening:
> 
> Process P calls futex_wait() on futex identified by 'key1'. 2 references
> are taken on this key: one for the struct futex_q itself, and one for the
> futex_wait operation.

It took a while to understand that explanation. You mean we get one
ref in get_key_ref() and one in queue_lock(), right ?

> If now, process P is requeued on a futex identified by 'key2', its
> futex_q->key is updated from 'key1' to 'key2' and a reference is got
> to 'key2' and one is dropped to 'key1'.

Correct.

> Later, another process calls futex_wake(): it gets a reference to
> 'key2', wakes process P, and drops reference to 'key2'.

That's pretty irrelevant as this operation is symetrical.

> Once process P is woken up, it should unqueue, drop reference to 'key2'
> (the one referring to the futex_q, this is done in unqueue_me())
> and to 'key1' (the one referring to futex_wait operation). Without this
> patch it drops reference to 'key2' instead of 'key1'.

I can see the bug, but while the patch fixes it I don't think it is
the proper solution. Aside of that we might have a similar problem in
the futex_wait_requeue_pi() code.

The real underlying problem is, that futex_wait_setup() returns with
two references held in the case of success. That's what needs to be
fixed in the first place.

The futex_wait() case can be fixed with the patch below, still looking
into the futex_wait_requeue_pi() maze.

Darren, this whole key refcounting needs to be simplified _AND_
documented.

Thanks,

	tglx
---
Index: linux-2.6-tip/kernel/futex.c
===================================================================
--- linux-2.6-tip.orig/kernel/futex.c
+++ linux-2.6-tip/kernel/futex.c
@@ -1786,8 +1786,14 @@ retry_private:
 	}
 
 out:
-	if (ret)
-		put_futex_key(fshared, &q->key);
+	/*
+	 * On success we hold here two references acquired in
+	 * get_futex_key() and queue_lock(). Drop one.
+	 *
+	 * On failure we hold one reference acquired in
+	 * get_futex_key(). Drop it.
+	 */
+	put_futex_key(fshared, &q->key);
 	return ret;
 }
 
@@ -1819,7 +1825,7 @@ static int futex_wait(u32 __user *uaddr,
 	}
 
 retry:
-	/* Prepare to wait on uaddr. */
+	/* Prepare to wait on uaddr. Hold hb lock and  q.key ref on success */
 	ret = futex_wait_setup(uaddr, val, fshared, &q, &hb);
 	if (ret)
 		goto out;
@@ -1829,24 +1835,23 @@ retry:
 
 	/* If we were woken (and unqueued), we succeeded, whatever. */
 	ret = 0;
+	/* unqueue_me() drops q.key ref */
 	if (!unqueue_me(&q))
-		goto out_put_key;
+		goto out;
 	ret = -ETIMEDOUT;
 	if (to && !to->task)
-		goto out_put_key;
+		goto out;
 
 	/*
 	 * We expect signal_pending(current), but we might be the
 	 * victim of a spurious wakeup as well.
 	 */
-	if (!signal_pending(current)) {
-		put_futex_key(fshared, &q.key);
+	if (!signal_pending(current))
 		goto retry;
-	}
 
 	ret = -ERESTARTSYS;
 	if (!abs_time)
-		goto out_put_key;
+		goto out;
 
 	restart = &current_thread_info()->restart_block;
 	restart->fn = futex_wait_restart;
@@ -1863,8 +1868,6 @@ retry:
 
 	ret = -ERESTART_RESTARTBLOCK;
 
-out_put_key:
-	put_futex_key(fshared, &q.key);
 out:
 	if (to) {
 		hrtimer_cancel(&to->timer);
---1463795968-827123453-1287144454=:2496--
