Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604Ab1LGQUH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:20:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33569 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757230Ab1LGQUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:20:04 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:08:27 2011
Message-Id: <20111207160827.197810325@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:07:16 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Matthieu CASTET <castet.matthieu@free.fr>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [56/80] EHCI : Fix a regression in the ISO scheduler
In-Reply-To: <20111207161256.GA7736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu CASTET <castet.matthieu@free.fr>

commit e3420901eba65b1c46bed86d360e3a8685d20734 upstream.

Fix a regression that was introduced by commit
811c926c538f7e8d3c08b630dd5844efd7e000f6 (USB: EHCI: fix HUB TT scheduling
issue with iso transfer).

We detect an error if next == start, but this means uframe 0 can't be allocated
anymore for iso transfer...

Reported-by: Sander Eikelenboom <linux@eikelenboom.it>
Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ehci-sched.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/usb/host/ehci-sched.c
+++ b/drivers/usb/host/ehci-sched.c
@@ -1479,6 +1479,7 @@ iso_stream_schedule (
 	 * jump until after the queue is primed.
 	 */
 	else {
+		int done = 0;
 		start = SCHEDULE_SLOP + (now & ~0x07);
 
 		/* NOTE:  assumes URB_ISO_ASAP, to limit complexity/bugs */
@@ -1496,18 +1497,18 @@ iso_stream_schedule (
 			if (stream->highspeed) {
 				if (itd_slot_ok(ehci, mod, start,
 						stream->usecs, period))
-					break;
+					done = 1;
 			} else {
 				if ((start % 8) >= 6)
 					continue;
 				if (sitd_slot_ok(ehci, mod, stream,
 						start, sched, period))
-					break;
+					done = 1;
 			}
-		} while (start > next);
+		} while (start > next && !done);
 
 		/* no room in the schedule */
-		if (start == next) {
+		if (!done) {
 			ehci_dbg(ehci, "iso resched full %p (now %d max %d)\n",
 				urb, now, now + mod);
 			status = -ENOSPC;


