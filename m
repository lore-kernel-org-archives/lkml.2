Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829Ab1IQRfA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 13:35:00 -0400
Received: from netrider.rowland.org ([192.131.102.5]:51406 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752215Ab1IQRe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 13:34:59 -0400
Date: Sat, 17 Sep 2011 13:34:55 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Rocko Requin <rockorequin@hotmail.com>
cc: tytso@mit.edu, Kernel development list <linux-kernel@vger.kernel.org>
Subject: RE: [Bug 25832] kernel crashes when a mounted ext3/4 file system is
 physically removed
In-Reply-To: <BAY151-W32DCB4BAFEC97DD4913A12A1090@phx.gbl>
Message-ID: <Pine.LNX.4.44L0.1109171330360.18455-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Sep 2011, Rocko Requin wrote:

> > Why were you using gnome-terminal?  You should be running the tests at
> > a console VT, not under X at all.  Ctrl-Alt-F2 or the equivalent...
> 
> Because with Ted's patch it doesn't crash when run from a console VT, even with an X server running.

That's weird.  Maybe the screen updates change some timing.

> > Here's another patch to address the new problem.  You can apply it on 
> > top of all the other patches.
> 
> Attached is the crash log I get with the latest patch applied.

Okay, more fallout from the same problem.  Here's an updated version of 
the previous patch.

These are really just bandaid-type fixes.  The people who understand
the block layer ought to be involved.  If this keeps up much longer
I'll get in touch with them.

Alan Stern


Index: usb-3.1/block/blk-core.c
===================================================================
--- usb-3.1.orig/block/blk-core.c
+++ usb-3.1/block/blk-core.c
@@ -367,8 +367,10 @@ void blk_cleanup_queue(struct request_qu
 	queue_flag_set_unlocked(QUEUE_FLAG_DEAD, q);
 	mutex_unlock(&q->sysfs_lock);
 
-	if (q->elevator)
+	if (q->elevator) {
 		elevator_exit(q->elevator);
+		q->elevator = NULL;
+	}
 
 	blk_throtl_exit(q);
 
Index: usb-3.1/block/elevator.c
===================================================================
--- usb-3.1.orig/block/elevator.c
+++ usb-3.1/block/elevator.c
@@ -769,7 +769,7 @@ void elv_put_request(struct request_queu
 {
 	struct elevator_queue *e = q->elevator;
 
-	if (e->ops->elevator_put_req_fn)
+	if (e && e->ops->elevator_put_req_fn)
 		e->ops->elevator_put_req_fn(rq);
 }
 
@@ -812,7 +812,7 @@ void elv_completed_request(struct reques
 	 */
 	if (blk_account_rq(rq)) {
 		q->in_flight[rq_is_sync(rq)]--;
-		if ((rq->cmd_flags & REQ_SORTED) &&
+		if ((rq->cmd_flags & REQ_SORTED) && e &&
 		    e->ops->elevator_completed_req_fn)
 			e->ops->elevator_completed_req_fn(q, rq);
 	}

