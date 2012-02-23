Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab2BWPve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 10:51:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339Ab2BWPvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 10:51:33 -0500
Date: Thu, 23 Feb 2012 16:44:38 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Davide Libenzi <davidel@xmailserver.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Greg KH <greg@kroah.com>,
        Jason Baron <jbaron@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>
Cc: Eugene Teo <eugeneteo@kernel.sg>, Maxime Bizon <mbizon@freebox.fr>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] epoll: ep_unregister_pollwait() can use the freed
	pwq->whead
Message-ID: <20120223154438.GA4354@redhat.com>
References: <20120222173326.GA7139@redhat.com> <20120222173505.GD7147@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120222173505.GD7147@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22, Oleg Nesterov wrote:
>
> However this needs more locking. ep_remove_wait_queue() should take
> ep->lock first to avoid the race and pin pwq->whead, then it needs
> pwq->whead->lock for __remove_wait_queue().
>
> This can obviously AB-BA deadlock with wake_up()->ep_poll_callback(),
> so ep_remove_wait_queue() does the nasty lock + trylock-or-retry dance.

Or we can rely on the fact that sighand_cachep is SLAB_DESTROY_BY_RCU,
and assume that ->whead is always rcu-protected if it can go away.

In this case we don't need 3/4 (although it makes sense to add the
fat comment), and 4/4 can be simplified, see below.

ep_pwq_from_wait() is not really needed, it has a single caller.
Just I tried to follow the coding style.

I'd prefer the explicit locking, but I don't really mind.

Oleg.

--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -320,6 +320,11 @@ static inline int ep_is_linked(struct list_head *p)
 	return !list_empty(p);
 }
 
+static inline struct eppoll_entry *ep_pwq_from_wait(wait_queue_t *p)
+{
+	return container_of(p, struct eppoll_entry, wait);
+}
+
 /* Get the "struct epitem" from a wait queue pointer */
 static inline struct epitem *ep_item_from_wait(wait_queue_t *p)
 {
@@ -467,6 +472,17 @@ static void ep_poll_safewake(wait_queue_head_t *wq)
 	put_cpu();
 }
 
+static void ep_remove_wait_queue(struct eppoll_entry *pwq)
+{
+	wait_queue_head_t *whead;
+
+	rcu_read_lock();
+	whead = rcu_dereference(pwq->whead);
+	if (whead)
+		remove_wait_queue(whead, &pwq->wait);
+	rcu_read_unlock();
+}
+
 /*
  * This function unregisters poll callbacks from the associated file
  * descriptor.  Must be called with "mtx" held (or "epmutex" if called from
@@ -481,7 +497,7 @@ static void ep_unregister_pollwait(struct eventpoll *ep, struct epitem *epi)
 		pwq = list_first_entry(lsthead, struct eppoll_entry, llink);
 
 		list_del(&pwq->llink);
-		remove_wait_queue(pwq->whead, &pwq->wait);
+		ep_remove_wait_queue(pwq);
 		kmem_cache_free(pwq_cache, pwq);
 	}
 }
@@ -845,8 +861,11 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
 	spin_lock_irqsave(&ep->lock, flags);
 
 	/* the caller holds eppoll_entry->whead->lock */
-	if ((unsigned long)key & POLLFREE)
+	if ((unsigned long)key & POLLFREE) {
+		/* can't use __remove_wait_queue(), we need list_del_init() */
 		list_del_init(&wait->task_list);
+		ep_pwq_from_wait(wait)->whead = NULL;
+	}
 
 	/*
 	 * If the event mask does not contain any poll(2) event, we consider the

