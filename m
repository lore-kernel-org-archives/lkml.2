Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933890Ab1LGQYK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:24:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34398 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933873Ab1LGQYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:24:06 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:21 2011
Message-Id: <20111207161221.048388834@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:12:18 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>,
        Matthieu Castet <matthieu.castet@parrot.com>,
        Thomas Poussevin <thomas.poussevin@parrot.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [076/104] USB: EHCI: fix HUB TT scheduling issue with iso transfer
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Poussevin <thomas.poussevin@parrot.com>

commit 811c926c538f7e8d3c08b630dd5844efd7e000f6 upstream.

The current TT scheduling doesn't allow to play and then record on a
full-speed device connected to a high speed hub.

The IN iso stream can only start on the first uframe (0-2 for a 165 us)
because of CSPLIT transactions.
For the OUT iso stream there no such restriction. uframe 0-5 are possible.

The idea of this patch is that the first uframe are precious (for IN TT iso
stream) and we should allocate the last uframes first if possible.

For that we reverse the order of uframe allocation (last uframe first).

Here an example :

hid interrupt stream
----------------------------------------------------------------------
uframe                |  0  |  1  |  2  |  3  |  4  |  5  |  6  |  7  |
----------------------------------------------------------------------
max_tt_usecs          | 125 | 125 | 125 | 125 | 125 | 125 | 30  |  0  |
----------------------------------------------------------------------
used usecs on a frame | 13  |  0  |  0  |  0  |  0  |  0  |  0  |  0  |
----------------------------------------------------------------------

iso OUT stream
----------------------------------------------------------------------
uframe                |  0  |  1  |  2  |  3  |  4  |  5  |  6  |  7  |
----------------------------------------------------------------------
max_tt_usecs          | 125 | 125 | 125 | 125 | 125 | 125 | 30  |  0  |
----------------------------------------------------------------------
used usecs on a frame | 13  | 125 |  39 |  0  |  0  |  0  |  0  |  0  |
----------------------------------------------------------------------

There no place for iso IN stream  (uframe 0-2 are used) and we got "cannot
submit datapipe for urb 0, error -28: not enough bandwidth" error.

With the patch this become.

iso OUT stream
----------------------------------------------------------------------
uframe                |  0  |  1  |  2  |  3  |  4  |  5  |  6  |  7  |
----------------------------------------------------------------------
max_tt_usecs          | 125 | 125 | 125 | 125 | 125 | 125 | 30  |  0  |
----------------------------------------------------------------------
used usecs on a frame |  13 |  0  |  0  |  0  | 125 |  39 |  0  |  0  |
----------------------------------------------------------------------

iso IN stream
----------------------------------------------------------------------
uframe                |  0  |  1  |  2  |  3  |  4  |  5  |  6  |  7  |
----------------------------------------------------------------------
max_tt_usecs          | 125 | 125 | 125 | 125 | 125 | 125 | 30  |  0  |
----------------------------------------------------------------------
used usecs on a frame |  13 |  0  | 125 | 40  | 125 |  39 |  0  |  0  |
----------------------------------------------------------------------

Signed-off-by: Matthieu Castet <matthieu.castet@parrot.com>
Signed-off-by: Thomas Poussevin <thomas.poussevin@parrot.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ehci-sched.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/usb/host/ehci-sched.c
+++ b/drivers/usb/host/ehci-sched.c
@@ -1480,10 +1480,15 @@ iso_stream_schedule (
 
 		/* NOTE:  assumes URB_ISO_ASAP, to limit complexity/bugs */
 
-		/* find a uframe slot with enough bandwidth */
-		next = start + period;
-		for (; start < next; start++) {
-
+		/* find a uframe slot with enough bandwidth.
+		 * Early uframes are more precious because full-speed
+		 * iso IN transfers can't use late uframes,
+		 * and therefore they should be allocated last.
+		 */
+		next = start;
+		start += period;
+		do {
+			start--;
 			/* check schedule: enough space? */
 			if (stream->highspeed) {
 				if (itd_slot_ok(ehci, mod, start,
@@ -1496,7 +1501,7 @@ iso_stream_schedule (
 						start, sched, period))
 					break;
 			}
-		}
+		} while (start > next);
 
 		/* no room in the schedule */
 		if (start == next) {


