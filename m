Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757728Ab0CaA2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:28:38 -0400
Received: from kroah.org ([198.145.64.141]:48909 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756254Ab0C3XMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:12:21 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:58:28 2010
Message-Id: <20100330225828.133741053@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:57:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [32/89] USB: EHCI: fix handling of unusual interrupt intervals
In-Reply-To: <20100330230520.GA28779@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 1b9a38bfa6e664ff02511314f5586d711c83cc91 upstream.

This patch (as1320) fixes two problems related to interrupt-URB
scheduling in ehci-hcd.

	URBs with an interval of 2 or 4 microframes aren't handled.
	For the time being, the patch reduces to interval to 1 uframe.

	URBs are constrained to have an interval no larger than 1024
	frames by usb_submit_urb().  But some EHCI controllers allow
	use of a schedule as short as 256 frames; for these
	controllers we may have to decrease the interval to the
	actual schedule length.

The second problem isn't very significant since few devices expose
interrupt endpoints with an interval larger than 256 frames.  But the
first problem is critical; it will prevent the kernel from working
with devices having interrupt intervals of 2 or 4 uframes.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Glynn Farrow <farrowg@sg.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ehci-q.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/usb/host/ehci-q.c
+++ b/drivers/usb/host/ehci-q.c
@@ -802,9 +802,10 @@ qh_make (
 				 * But interval 1 scheduling is simpler, and
 				 * includes high bandwidth.
 				 */
-				dbg ("intr period %d uframes, NYET!",
-						urb->interval);
-				goto done;
+				urb->interval = 1;
+			} else if (qh->period > ehci->periodic_size) {
+				qh->period = ehci->periodic_size;
+				urb->interval = qh->period << 3;
 			}
 		} else {
 			int		think_time;
@@ -827,6 +828,10 @@ qh_make (
 					usb_calc_bus_time (urb->dev->speed,
 					is_input, 0, max_packet (maxp)));
 			qh->period = urb->interval;
+			if (qh->period > ehci->periodic_size) {
+				qh->period = ehci->periodic_size;
+				urb->interval = qh->period;
+			}
 		}
 	}
 


