Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457Ab2ETMsP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 08:48:15 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:55212 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297Ab2ETMsO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 08:48:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [-next regression] TCP window full with EPOLLWAKEUP
Date: Sun, 20 May 2012 14:53:11 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        NeilBrown <neilb@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jirislaby@gmail.com>,
        Linux PM list <linux-pm@vger.kernel.org>
References: <4FB81981.3050509@suse.cz> <201205201423.08334.rjw@sisk.pl>
In-Reply-To: <201205201423.08334.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201205201453.11794.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, May 20, 2012, Rafael J. Wysocki wrote:
> On Sunday, May 20, 2012, Jiri Slaby wrote:
> > Hi,
> > 
> > a bisection shows that with the following commit from -next:
> > commit 4d7e30d98939a0340022ccd49325a3d70f7e0238
> > Author: Arve Hjønnevåg <arve@android.com>
> > Date:   Tue May 1 21:33:34 2012 +0200
> > 
> >     epoll: Add a flag, EPOLLWAKEUP, to prevent suspend while epoll
> > events are ready
> > 
> > ====
> > 
> > one of mono programs I use stops receiving data from the network.
> > Wireshark shows that the TCP window of a connection is filled. This
> > means the program does not read the data fast enough after requesting
> > the data.
> > 
> > If I revert that commit on the top of -next (20120518), everything works
> > as expected.
> 
> Hmm.  I suppose that the failing program doesn't set EPOLLWAKEUP by mistake,
> does it?

If it doesn't, we can assume that epi-ws is always NULL and all of the added
overhead comes from the function calls.  So, I wonder if the appended patch
makes any difference?

Rafael


---
 fs/eventpoll.c |   35 ++++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

Index: linux/fs/eventpoll.c
===================================================================
--- linux.orig/fs/eventpoll.c
+++ linux/fs/eventpoll.c
@@ -597,7 +597,8 @@ static int ep_scan_ready_list(struct eve
 		 */
 		if (!ep_is_linked(&epi->rdllink)) {
 			list_add_tail(&epi->rdllink, &ep->rdllist);
-			__pm_stay_awake(epi->ws);
+			if (epi->ws)
+				__pm_stay_awake(epi->ws);
 		}
 	}
 	/*
@@ -611,7 +612,8 @@ static int ep_scan_ready_list(struct eve
 	 * Quickly re-inject items left on "txlist".
 	 */
 	list_splice(&txlist, &ep->rdllist);
-	__pm_relax(ep->ws);
+	if (ep->ws)
+		__pm_relax(ep->ws);
 
 	if (!list_empty(&ep->rdllist)) {
 		/*
@@ -750,7 +752,9 @@ static int ep_read_events_proc(struct ev
 			 * callback, but it's not actually ready, as far as
 			 * caller requested events goes. We can remove it here.
 			 */
-			__pm_relax(epi->ws);
+			if (epi->ws)
+				__pm_relax(epi->ws);
+
 			list_del_init(&epi->rdllink);
 		}
 	}
@@ -956,7 +960,8 @@ static int ep_poll_callback(wait_queue_t
 	/* If this file is already in the ready list we exit soon */
 	if (!ep_is_linked(&epi->rdllink)) {
 		list_add_tail(&epi->rdllink, &ep->rdllist);
-		__pm_stay_awake(epi->ws);
+		if (epi->ws)
+			__pm_stay_awake(epi->ws);
 	}
 
 	/*
@@ -1219,7 +1224,8 @@ static int ep_insert(struct eventpoll *e
 	/* If the file is already "ready" we drop it inside the ready list */
 	if ((revents & event->events) && !ep_is_linked(&epi->rdllink)) {
 		list_add_tail(&epi->rdllink, &ep->rdllist);
-		__pm_stay_awake(epi->ws);
+		if (epi->ws)
+			__pm_stay_awake(epi->ws);
 
 		/* Notify waiting tasks that events are available */
 		if (waitqueue_active(&ep->wq))
@@ -1309,7 +1315,8 @@ static int ep_modify(struct eventpoll *e
 		spin_lock_irq(&ep->lock);
 		if (!ep_is_linked(&epi->rdllink)) {
 			list_add_tail(&epi->rdllink, &ep->rdllist);
-			__pm_stay_awake(epi->ws);
+			if (epi->ws)
+				__pm_stay_awake(epi->ws);
 
 			/* Notify waiting tasks that events are available */
 			if (waitqueue_active(&ep->wq))
@@ -1357,9 +1364,12 @@ static int ep_send_events_proc(struct ev
 		 * instead, but then epi->ws would temporarily be out of sync
 		 * with ep_is_linked().
 		 */
-		if (epi->ws && epi->ws->active)
-			__pm_stay_awake(ep->ws);
-		__pm_relax(epi->ws);
+		if (epi->ws) {
+			if (epi->ws->active)
+				__pm_stay_awake(ep->ws);
+
+			__pm_relax(epi->ws);
+		}
 		list_del_init(&epi->rdllink);
 
 		pt._key = epi->event.events;
@@ -1376,7 +1386,9 @@ static int ep_send_events_proc(struct ev
 			if (__put_user(revents, &uevent->events) ||
 			    __put_user(epi->event.data, &uevent->data)) {
 				list_add(&epi->rdllink, head);
-				__pm_stay_awake(epi->ws);
+				if (epi->ws)
+					__pm_stay_awake(epi->ws);
+
 				return eventcnt ? eventcnt : -EFAULT;
 			}
 			eventcnt++;
@@ -1396,7 +1408,8 @@ static int ep_send_events_proc(struct ev
 				 * poll callback will queue them in ep->ovflist.
 				 */
 				list_add_tail(&epi->rdllink, &ep->rdllist);
-				__pm_stay_awake(epi->ws);
+				if (epi->ws)
+					__pm_stay_awake(epi->ws);
 			}
 		}
 	}
