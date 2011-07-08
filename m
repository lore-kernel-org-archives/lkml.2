Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab1GHFC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:02:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41854 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754081Ab1GHFC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:02:26 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:56 2011
Message-Id: <20110708001656.604066994@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:16:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Andiry Xu <Andiry.Xu@amd.com>
Subject: [040/107] xhci: Always set urb->status to zero for isoc endpoints.
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit b3df3f9c7df9a8d85e03e158d35487618a160901 upstream.

When the xHCI driver encounters a Missed Service Interval event for an
isochronous endpoint ring, it means the host controller skipped over
one or more isochronous TDs.  For TD that is skipped, skip_isoc_td() is
called.  This sets the frame descriptor status to -EXDEV, and also sets
the value stored in the int pointed to by status to -EXDEV.

If the isochronous TD happens to be the last TD in an URB,
handle_tx_event() will use the status variable to give back the URB to
the USB core.  That means drivers will see urb->status as -EXDEV.

It turns out that EHCI, UHCI, and OHCI always set urb->status to zero for
an isochronous urb, regardless of what the frame status is.  See
itd_complete() in ehci-sched.c:

                } else {
                        /* URB was too late */
                        desc->status = -EXDEV;
                }
        }

        /* handle completion now? */
        if (likely ((urb_index + 1) != urb->number_of_packets))
                goto done;

        /* ASSERT: it's really the last itd for this urb
        list_for_each_entry (itd, &stream->td_list, itd_list)
                BUG_ON (itd->urb == urb);
         */

        /* give urb back to the driver; completion often (re)submits */
        dev = urb->dev;
        ehci_urb_done(ehci, urb, 0);

ehci_urb_done() completes the URB with the status of the third argument, which
is always zero in this case.

It turns out that many USB webcam drivers, such as uvcvideo, cannot
handle urb->status set to a non-zero value.  They will not resubmit
their isochronous URBs in that case, and userspace will see a frozen
video.

Change the xHCI driver to be consistent with the EHCI and UHCI driver,
and always set urb->status to 0 for isochronous URBs.

This patch should be backported to kernels as old as 2.6.36

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Andiry Xu <Andiry.Xu@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci-ring.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1768,9 +1768,6 @@ static int process_isoc_td(struct xhci_h
 		}
 	}
 
-	if ((idx == urb_priv->length - 1) && *status == -EINPROGRESS)
-		*status = 0;
-
 	return finish_td(xhci, td, event_trb, event, ep, status, false);
 }
 
@@ -1788,8 +1785,7 @@ static int skip_isoc_td(struct xhci_hcd
 	idx = urb_priv->td_cnt;
 	frame = &td->urb->iso_frame_desc[idx];
 
-	/* The transfer is partly done */
-	*status = -EXDEV;
+	/* The transfer is partly done. */
 	frame->status = -EXDEV;
 
 	/* calc actual length */
@@ -2139,6 +2135,11 @@ cleanup:
 					"status = %d\n",
 					urb, urb->actual_length, status);
 			spin_unlock(&xhci->lock);
+			/* EHCI, UHCI, and OHCI always unconditionally set the
+			 * urb->status of an isochronous endpoint to 0.
+			 */
+			if (usb_pipetype(urb->pipe) == PIPE_ISOCHRONOUS)
+				status = 0;
 			usb_hcd_giveback_urb(bus_to_hcd(urb->dev->bus), urb, status);
 			spin_lock(&xhci->lock);
 		}


