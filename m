Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932850Ab0HLAEq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:04:46 -0400
Received: from kroah.org ([198.145.64.141]:60245 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759538Ab0HLAEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:04:21 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:01:26 2010
Message-Id: <20100812000126.100929823@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:00:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        David Brownell <david-b@pacbell.net>
Subject: [31/54] USB: EHCI: remove PCI assumption
In-Reply-To: <20100812000249.GA30948@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit ae68a83bdc1971cb02fefc7a686ba6d077065e71 upstream.

This patch (as1405) fixes a small bug in ehci-hcd's isochronous
scheduler.  Not all EHCI controllers are PCI, and the code shouldn't
assume that they are.  Instead, introduce a special flag for
controllers which need to delay iso scheduling for full-speed devices
beyond the scheduling threshold.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: David Brownell <david-b@pacbell.net>
Acked-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ehci-pci.c   |    1 +
 drivers/usb/host/ehci-sched.c |   10 ++++------
 drivers/usb/host/ehci.h       |    1 +
 3 files changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/usb/host/ehci-pci.c
+++ b/drivers/usb/host/ehci-pci.c
@@ -111,6 +111,7 @@ static int ehci_pci_setup(struct usb_hcd
 	switch (pdev->vendor) {
 	case PCI_VENDOR_ID_INTEL:
 		ehci->need_io_watchdog = 0;
+		ehci->fs_i_thresh = 1;
 		if (pdev->device == 0x27cc) {
 			ehci->broken_periodic = 1;
 			ehci_info(ehci, "using broken periodic workaround\n");
--- a/drivers/usb/host/ehci-sched.c
+++ b/drivers/usb/host/ehci-sched.c
@@ -1400,7 +1400,6 @@ iso_stream_schedule (
 	int			status;
 	unsigned		mod = ehci->periodic_size << 3;
 	struct ehci_iso_sched	*sched = urb->hcpriv;
-	struct pci_dev		*pdev;
 
 	if (sched->span > (mod - SCHEDULE_SLOP)) {
 		ehci_dbg (ehci, "iso request %p too long\n", urb);
@@ -1427,15 +1426,14 @@ iso_stream_schedule (
 	 * slot in the schedule, implicitly assuming URB_ISO_ASAP.
 	 */
 	if (likely (!list_empty (&stream->td_list))) {
-		pdev = to_pci_dev(ehci_to_hcd(ehci)->self.controller);
 		start = stream->next_uframe;
 
 		/* For high speed devices, allow scheduling within the
-		 * isochronous scheduling threshold.  For full speed devices,
-		 * don't. (Work around for Intel ICH9 bug.)
+		 * isochronous scheduling threshold.  For full speed devices
+		 * and Intel PCI-based controllers, don't (work around for
+		 * Intel ICH9 bug).
 		 */
-		if (!stream->highspeed &&
-				pdev->vendor == PCI_VENDOR_ID_INTEL)
+		if (!stream->highspeed && ehci->fs_i_thresh)
 			next = now + ehci->i_thresh;
 		else
 			next = now;
--- a/drivers/usb/host/ehci.h
+++ b/drivers/usb/host/ehci.h
@@ -130,6 +130,7 @@ struct ehci_hcd {			/* one per controlle
 	unsigned		has_amcc_usb23:1;
 	unsigned		need_io_watchdog:1;
 	unsigned		broken_periodic:1;
+	unsigned		fs_i_thresh:1;	/* Intel iso scheduling */
 
 	/* required for usb32 quirk */
 	#define OHCI_CTRL_HCFS          (3 << 6)


