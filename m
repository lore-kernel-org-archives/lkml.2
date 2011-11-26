Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab1KZWNS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 17:13:18 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:48988 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754198Ab1KZWNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 17:13:15 -0500
Date: Sat, 26 Nov 2011 23:13:04 +0100
From: matthieu castet <castet.matthieu@free.fr>
To: Sander Eikelenboom <linux@eikelenboom.it>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: re : 3.2-rc2 regression due to commit "USB: EHCI: fix HUB TT
 scheduling issue with iso transfer" 811c926c
Message-ID: <20111126231304.0bf12f69@mat-laptop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

could you try the following patch ?

It seems there is a flow in the error condition.


Matthieu


diff --git a/drivers/usb/host/ehci-sched.c b/drivers/usb/host/ehci-sched.c
index 56a3203..464b451 100644
--- a/drivers/usb/host/ehci-sched.c
+++ b/drivers/usb/host/ehci-sched.c
@@ -1475,6 +1475,7 @@ iso_stream_schedule (
 	 * jump until after the queue is primed.
 	 */
 	else {
+		int done = 0;
 		start = SCHEDULE_SLOP + (now & ~0x07);
 
 		/* NOTE:  assumes URB_ISO_ASAP, to limit complexity/bugs */
@@ -1491,19 +1492,23 @@ iso_stream_schedule (
 			/* check schedule: enough space? */
 			if (stream->highspeed) {
 				if (itd_slot_ok(ehci, mod, start,
-						stream->usecs, period))
+						stream->usecs, period)) {
+					done = 1;
 					break;
+				}
 			} else {
 				if ((start % 8) >= 6)
 					continue;
 				if (sitd_slot_ok(ehci, mod, stream,
-						start, sched, period))
+						start, sched, period)) {
+					done = 1;
 					break;
+				}
 			}
 		} while (start > next);
 
 		/* no room in the schedule */
-		if (start == next) {
+		if (!done) {
 			ehci_dbg(ehci, "iso resched full %p (now %d max %d)\n",
 				urb, now, now + mod);
 			status = -ENOSPC;
