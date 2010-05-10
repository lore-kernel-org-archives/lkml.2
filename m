Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857Ab0EJW5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 18:57:48 -0400
Received: from kroah.org ([198.145.64.141]:51555 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753819Ab0EJW5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:57:19 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:34 2010
Message-Id: <20100510223534.522365646@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:34:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [01/98] USB: EHCI: defer reclamation of siTDs
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 0e5f231bc16ff9910882fa5b9d64d80e7691cfab upstream.

This patch (as1369) fixes a problem in ehci-hcd.  Some controllers
occasionally run into trouble when the driver reclaims siTDs too
quickly.  This can happen while streaming audio; it causes the
controller to crash.

The patch changes siTD reclamation to work the same way as iTD
reclamation: Completed siTDs are stored on a list and not reused until
at least one frame has passed.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Nate Case <ncase@xes-inc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ehci-hcd.c   |    1 +
 drivers/usb/host/ehci-mem.c   |    2 +-
 drivers/usb/host/ehci-sched.c |   38 ++++++++++++++++++++++++++++++--------
 drivers/usb/host/ehci.h       |    5 +++--
 4 files changed, 35 insertions(+), 11 deletions(-)

--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -543,6 +543,7 @@ static int ehci_init(struct usb_hcd *hcd
 	 */
 	ehci->periodic_size = DEFAULT_I_TDPS;
 	INIT_LIST_HEAD(&ehci->cached_itd_list);
+	INIT_LIST_HEAD(&ehci->cached_sitd_list);
 	if ((retval = ehci_mem_init(ehci, GFP_KERNEL)) < 0)
 		return retval;
 
--- a/drivers/usb/host/ehci-mem.c
+++ b/drivers/usb/host/ehci-mem.c
@@ -136,7 +136,7 @@ static inline void qh_put (struct ehci_q
 
 static void ehci_mem_cleanup (struct ehci_hcd *ehci)
 {
-	free_cached_itd_list(ehci);
+	free_cached_lists(ehci);
 	if (ehci->async)
 		qh_put (ehci->async);
 	ehci->async = NULL;
--- a/drivers/usb/host/ehci-sched.c
+++ b/drivers/usb/host/ehci-sched.c
@@ -2127,13 +2127,27 @@ sitd_complete (
 			(stream->bEndpointAddress & USB_DIR_IN) ? "in" : "out");
 	}
 	iso_stream_put (ehci, stream);
-	/* OK to recycle this SITD now that its completion callback ran. */
+
 done:
 	sitd->urb = NULL;
-	sitd->stream = NULL;
-	list_move(&sitd->sitd_list, &stream->free_list);
-	iso_stream_put(ehci, stream);
-
+	if (ehci->clock_frame != sitd->frame) {
+		/* OK to recycle this SITD now. */
+		sitd->stream = NULL;
+		list_move(&sitd->sitd_list, &stream->free_list);
+		iso_stream_put(ehci, stream);
+	} else {
+		/* HW might remember this SITD, so we can't recycle it yet.
+		 * Move it to a safe place until a new frame starts.
+		 */
+		list_move(&sitd->sitd_list, &ehci->cached_sitd_list);
+		if (stream->refcount == 2) {
+			/* If iso_stream_put() were called here, stream
+			 * would be freed.  Instead, just prevent reuse.
+			 */
+			stream->ep->hcpriv = NULL;
+			stream->ep = NULL;
+		}
+	}
 	return retval;
 }
 
@@ -2199,9 +2213,10 @@ done:
 
 /*-------------------------------------------------------------------------*/
 
-static void free_cached_itd_list(struct ehci_hcd *ehci)
+static void free_cached_lists(struct ehci_hcd *ehci)
 {
 	struct ehci_itd *itd, *n;
+	struct ehci_sitd *sitd, *sn;
 
 	list_for_each_entry_safe(itd, n, &ehci->cached_itd_list, itd_list) {
 		struct ehci_iso_stream	*stream = itd->stream;
@@ -2209,6 +2224,13 @@ static void free_cached_itd_list(struct
 		list_move(&itd->itd_list, &stream->free_list);
 		iso_stream_put(ehci, stream);
 	}
+
+	list_for_each_entry_safe(sitd, sn, &ehci->cached_sitd_list, sitd_list) {
+		struct ehci_iso_stream	*stream = sitd->stream;
+		sitd->stream = NULL;
+		list_move(&sitd->sitd_list, &stream->free_list);
+		iso_stream_put(ehci, stream);
+	}
 }
 
 /*-------------------------------------------------------------------------*/
@@ -2235,7 +2257,7 @@ scan_periodic (struct ehci_hcd *ehci)
 		clock_frame = -1;
 	}
 	if (ehci->clock_frame != clock_frame) {
-		free_cached_itd_list(ehci);
+		free_cached_lists(ehci);
 		ehci->clock_frame = clock_frame;
 	}
 	clock %= mod;
@@ -2398,7 +2420,7 @@ restart:
 			clock = now;
 			clock_frame = clock >> 3;
 			if (ehci->clock_frame != clock_frame) {
-				free_cached_itd_list(ehci);
+				free_cached_lists(ehci);
 				ehci->clock_frame = clock_frame;
 			}
 		} else {
--- a/drivers/usb/host/ehci.h
+++ b/drivers/usb/host/ehci.h
@@ -87,8 +87,9 @@ struct ehci_hcd {			/* one per controlle
 	int			next_uframe;	/* scan periodic, start here */
 	unsigned		periodic_sched;	/* periodic activity count */
 
-	/* list of itds completed while clock_frame was still active */
+	/* list of itds & sitds completed while clock_frame was still active */
 	struct list_head	cached_itd_list;
+	struct list_head	cached_sitd_list;
 	unsigned		clock_frame;
 
 	/* per root hub port */
@@ -195,7 +196,7 @@ timer_action_done (struct ehci_hcd *ehci
 	clear_bit (action, &ehci->actions);
 }
 
-static void free_cached_itd_list(struct ehci_hcd *ehci);
+static void free_cached_lists(struct ehci_hcd *ehci);
 
 /*-------------------------------------------------------------------------*/
 


