Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab1AOTnc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 14:43:32 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:40972 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab1AOTnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 14:43:31 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sat, 15 Jan 2011 11:43:30 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@davide-lnx1
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: [patch 1/2] move ready event check into proper inline
Message-ID: <alpine.DEB.2.00.1101151130470.6884@davide-lnx1>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the event readiness check into a proper inline, and use it uniformly 
inside ep_poll() code.
Events in the ->ovflist are no less ready than the ones in ->rdllist.


Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 fs/eventpoll.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

Index: linux-2.6.mod/fs/eventpoll.c
===================================================================
--- linux-2.6.mod.orig/fs/eventpoll.c	2011-01-15 10:10:26.000000000 -0800
+++ linux-2.6.mod/fs/eventpoll.c	2011-01-15 11:28:54.000000000 -0800
@@ -306,6 +306,19 @@
 }
 
 /**
+ * ep_events_available - Checks if ready events might be available.
+ *
+ * @ep: Pointer to the eventpoll context.
+ *
+ * Returns: Returns a value different than zero if ready events are available,
+ *          or zero otherwise.
+ */
+static inline int ep_events_available(struct eventpoll *ep)
+{
+	return !list_empty(&ep->rdllist) || ep->ovflist != EP_UNACTIVE_PTR;
+}
+
+/**
  * ep_call_nested - Perform a bound (possibly) nested call, by checking
  *                  that the recursion limit is not exceeded, and that
  *                  the same nested call (by the meaning of same cookie) is
@@ -1138,7 +1151,7 @@
 	spin_lock_irqsave(&ep->lock, flags);
 
 	res = 0;
-	if (list_empty(&ep->rdllist)) {
+	if (!ep_events_available(ep)) {
 		/*
 		 * We don't have any available event to return to the caller.
 		 * We need to sleep here, and we will be wake up by
@@ -1154,7 +1167,7 @@
 			 * to TASK_INTERRUPTIBLE before doing the checks.
 			 */
 			set_current_state(TASK_INTERRUPTIBLE);
-			if (!list_empty(&ep->rdllist) || timed_out)
+			if (ep_events_available(ep) || timed_out)
 				break;
 			if (signal_pending(current)) {
 				res = -EINTR;
@@ -1172,7 +1185,7 @@
 		set_current_state(TASK_RUNNING);
 	}
 	/* Is it worth to try to dig for events ? */
-	eavail = !list_empty(&ep->rdllist) || ep->ovflist != EP_UNACTIVE_PTR;
+	eavail = ep_events_available(ep);
 
 	spin_unlock_irqrestore(&ep->lock, flags);
 
