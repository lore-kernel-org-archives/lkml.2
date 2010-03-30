Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468Ab0C3XVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:21:37 -0400
Received: from kroah.org ([198.145.64.141]:46177 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932381Ab0C3XUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:20:19 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:05 2010
Message-Id: <20100330224805.329133576@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:41:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Clemens Ladisch <clemens@ladisch.de>,
       Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [069/156] USB: EHCI: adjust ehci_iso_stream for changes in ehci_qh
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit 1082f57abfa26590b60c43f503afb24102a37016 upstream.

The EHCI driver stores in usb_host_endpoint.hcpriv a pointer to either
an ehci_qh or an ehci_iso_stream structure, and uses the contents of the
hw_info1 field to distinguish the two cases.

After ehci_qh was split into hw and sw parts, ehci_iso_stream must also
be adjusted so that it again looks like an ehci_qh structure.

This fixes a NULL pointer access in ehci_endpoint_disable() when it
tries to access qh->hw->hw_info1.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Reported-by: Colin Fletcher <colin.m.fletcher@googlemail.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ehci-hcd.c   |    2 +-
 drivers/usb/host/ehci-sched.c |    4 ++--
 drivers/usb/host/ehci.h       |    5 ++---
 3 files changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -995,7 +995,7 @@ rescan:
 	/* endpoints can be iso streams.  for now, we don't
 	 * accelerate iso completions ... so spin a while.
 	 */
-	if (qh->hw->hw_info1 == 0) {
+	if (qh->hw == NULL) {
 		ehci_vdbg (ehci, "iso delay\n");
 		goto idle_timeout;
 	}
--- a/drivers/usb/host/ehci-sched.c
+++ b/drivers/usb/host/ehci-sched.c
@@ -1121,8 +1121,8 @@ iso_stream_find (struct ehci_hcd *ehci,
 					urb->interval);
 		}
 
-	/* if dev->ep [epnum] is a QH, info1.maxpacket is nonzero */
-	} else if (unlikely (stream->hw_info1 != 0)) {
+	/* if dev->ep [epnum] is a QH, hw is set */
+	} else if (unlikely (stream->hw != NULL)) {
 		ehci_dbg (ehci, "dev %s ep%d%s, not iso??\n",
 			urb->dev->devpath, epnum,
 			usb_pipein(urb->pipe) ? "in" : "out");
--- a/drivers/usb/host/ehci.h
+++ b/drivers/usb/host/ehci.h
@@ -394,9 +394,8 @@ struct ehci_iso_sched {
  * acts like a qh would, if EHCI had them for ISO.
  */
 struct ehci_iso_stream {
-	/* first two fields match QH, but info1 == 0 */
-	__hc32			hw_next;
-	__hc32			hw_info1;
+	/* first field matches ehci_hq, but is NULL */
+	struct ehci_qh_hw	*hw;
 
 	u32			refcount;
 	u8			bEndpointAddress;


