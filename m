Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757Ab2A0S6J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 13:58:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45082 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624Ab2A0S6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 13:58:07 -0500
X-Authority-Analysis: v=2.0 cv=fNy7LOme c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=8QWFeHmMi6UA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=qbGhCgHSAAAA:8 a=meVymXHHAAAA:8 a=Ydygjes7k2629TQovsAA:9 a=gsPgGzzFpHgNvibZ6cAA:7 a=PUjeQqilurYA:10 a=hixJfIHkBgQA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1327690684.22710.127.camel@gandalf.stny.rr.com>
Subject: [PATCH] epoll: Comment the funky #ifdef
From: Steven Rostedt <rostedt@goodmis.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 27 Jan 2012 13:58:04 -0500
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looking for a bug in -rt, I stumbled across this code here from:

commit 2dfa4eeab0fc7e8633974f2770945311b31eedf6
Author: Davide Libenzi <davidel@xmailserver.org>
Date:   Tue Mar 31 15:24:22 2009 -0700

epoll keyed wakeups: teach epoll about hints coming with the wakeup key


Specifically:

+++ b/fs/eventpoll.c
@@ -371,9 +371,28 @@ static int ep_call_nested(struct nested_calls *ncalls, int 
        return error;
 }
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+static inline void ep_wake_up_nested(wait_queue_head_t *wqueue,
+                                    unsigned long events, int subclass)
+{
+       unsigned long flags;
+
+       spin_lock_irqsave_nested(&wqueue->lock, flags, subclass);
+       wake_up_locked_poll(wqueue, events);
+       spin_unlock_irqrestore(&wqueue->lock, flags);
+}
+#else
+static inline void ep_wake_up_nested(wait_queue_head_t *wqueue,
+                                    unsigned long events, int subclass)
+{
+       wake_up_poll(wqueue, events);
+}
+#endif
+

You change the function of ep_wake_up_nested() depending on whether
CONFIG_DEBUG_LOCK_ALLOC is set or not. This looks awfully suspicious,
and there's no comment to explain why. I initially thought that this was
trying to fool lockdep, and hiding a real bug.

Investigating it, I found the creation of wake_up_nested() (which no
longer exists) but was created for the sole purpose of epoll and its
strange wake ups, as explained in:

commit 0ccf831cbee94df9c5006dd46248c0f07847dd7c
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Mon Feb 4 22:27:20 2008 -0800

lockdep: annotate epoll


Although the commit message says "annotate epoll" the change log is much
better at explaining what is happening than what is in the actual code.
Thus a comment is really necessary here. And to save the time of other
developers from having to go trudging through the git logs trying to
figure out why this code exists.

I took parts of the change log and placed it into a comment above the
affected code. This will make the description of what is happening more
visible to new developers that have to look at this code for the first
time.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index aabdfc3..c636fc8 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -422,6 +422,31 @@ out_unlock:
 	return error;
 }
 
+/*
+ * As described in commit 0ccf831cb lockdep: annotate epoll
+ * the use of wait queues used by epoll is done in a very controlled
+ * manner. Wake ups can nest inside each other, but are never done
+ * with the same locking. For example:
+ *
+ *   dfd = socket(...);
+ *   efd1 = epoll_create();
+ *   efd2 = epoll_create();
+ *   epoll_ctl(efd1, EPOLL_CTL_ADD, dfd, ...);
+ *   epoll_ctl(efd2, EPOLL_CTL_ADD, efd1, ...);
+ *
+ * When a packet arrives to the device underneath "dfd", the net code will
+ * issue a wake_up() on its poll wake list. Epoll (efd1) has installed a
+ * callback wakeup entry on that queue, and the wake_up() performed by the
+ * "dfd" net code will end up in ep_poll_callback(). At this point epoll
+ * (efd1) notices that it may have some event ready, so it needs to wake up
+ * the waiters on its poll wait list (efd2). So it calls ep_poll_safewake()
+ * that ends up in another wake_up(), after having checked about the
+ * recursion constraints. That are, no more than EP_MAX_POLLWAKE_NESTS, to
+ * avoid stack blasting.
+ *
+ * When CONFIG_DEBUG_LOCK_ALLOC is enabled, make sure lockdep can handle
+ * this special case of epoll.
+ */
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 static inline void ep_wake_up_nested(wait_queue_head_t *wqueue,
 				     unsigned long events, int subclass)


