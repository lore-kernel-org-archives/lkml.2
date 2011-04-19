Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab1DSURw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:17:52 -0400
Received: from kroah.org ([198.145.64.141]:35764 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755110Ab1DSURt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:17:49 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:50 2011
Message-Id: <20110419201050.358510687@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:09:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Matthew Wilcox <willy@linux.intel.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [67/70] USB: Fix unplug of device with active streams
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Matthew Wilcox <willy@linux.intel.com>

commit b214f191d95ba4b5a35aebd69cd129cf7e3b1884 upstream.

If I unplug a device while the UAS driver is loaded, I get an oops
in usb_free_streams().  This is because usb_unbind_interface() calls
usb_disable_interface() which calls usb_disable_endpoint() which sets
ep_out and ep_in to NULL.  Then the UAS driver calls usb_pipe_endpoint()
which returns a NULL pointer and passes an array of NULL pointers to
usb_free_streams().

I think the correct fix for this is to check for the NULL pointer
in usb_free_streams() rather than making the driver check for this
situation.  My original patch for this checked for dev->state ==
USB_STATE_NOTATTACHED, but the call to usb_disable_interface() is
conditional, so not all drivers would want this check.

Note from Sarah Sharp: This patch does avoid a potential dereference,
but the real fix (which will be implemented later) is to set the
.soft_unbind flag in the usb_driver structure for the UAS driver, and
all drivers that allocate streams.  The driver should free any streams
when it is unbound from the interface.  This avoids leaking stream rings
in the xHCI driver when usb_disable_interface() is called.

This should be queued for stable trees back to 2.6.35.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/hcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1885,7 +1885,7 @@ void usb_free_streams(struct usb_interfa
 
 	/* Streams only apply to bulk endpoints. */
 	for (i = 0; i < num_eps; i++)
-		if (!usb_endpoint_xfer_bulk(&eps[i]->desc))
+		if (!eps[i] || !usb_endpoint_xfer_bulk(&eps[i]->desc))
 			return;
 
 	hcd->driver->free_streams(hcd, dev, eps, num_eps, mem_flags);


