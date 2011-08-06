Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380Ab1HFA07 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:26:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39117 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757157Ab1HFAIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:08:46 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug  5 17:02:52 2011
Message-Id: <20110806000252.679717030@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 05 Aug 2011 17:02:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [38/55] EHCI: fix direction handling for interrupt data toggles
In-Reply-To: <20110806000257.GA25498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit e04f5f7e423018bcec84c11af2058cdce87816f3 upstream.

This patch (as1480) fixes a rather obscure bug in ehci-hcd.  The
qh_update() routine needs to know the number and direction of the
endpoint corresponding to its QH argument.  The number can be taken
directly from the QH data structure, but the direction isn't stored
there.  The direction is taken instead from the first qTD linked to
the QH.

However, it turns out that for interrupt transfers, qh_update() gets
called before the qTDs are linked to the QH.  As a result, qh_update()
computes a bogus direction value, which messes up the endpoint toggle
handling.  Under the right combination of circumstances this causes
usb_reset_endpoint() not to work correctly, which causes packets to be
dropped and communications to fail.

Now, it's silly for the QH structure not to have direct access to all
the descriptor information for the corresponding endpoint.  Ultimately
it may get a pointer to the usb_host_endpoint structure; for now,
adding a copy of the direction flag solves the immediate problem.

This allows the Spyder2 color-calibration system (a low-speed USB
device that sends all its interrupt data packets with the toggle set
to 0 and hance requires constant use of usb_reset_endpoint) to work
when connected through a high-speed hub.  Thanks to Graeme Gill for
supplying the hardware that allowed me to track down this bug.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Graeme Gill <graeme@argyllcms.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ehci-q.c |    3 ++-
 drivers/usb/host/ehci.h   |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/ehci-q.c
+++ b/drivers/usb/host/ehci-q.c
@@ -103,7 +103,7 @@ qh_update (struct ehci_hcd *ehci, struct
 	if (!(hw->hw_info1 & cpu_to_hc32(ehci, 1 << 14))) {
 		unsigned	is_out, epnum;
 
-		is_out = !(qtd->hw_token & cpu_to_hc32(ehci, 1 << 8));
+		is_out = qh->is_out;
 		epnum = (hc32_to_cpup(ehci, &hw->hw_info1) >> 8) & 0x0f;
 		if (unlikely (!usb_gettoggle (qh->dev, epnum, is_out))) {
 			hw->hw_token &= ~cpu_to_hc32(ehci, QTD_TOGGLE);
@@ -923,6 +923,7 @@ done:
 	hw = qh->hw;
 	hw->hw_info1 = cpu_to_hc32(ehci, info1);
 	hw->hw_info2 = cpu_to_hc32(ehci, info2);
+	qh->is_out = !is_input;
 	usb_settoggle (urb->dev, usb_pipeendpoint (urb->pipe), !is_input, 1);
 	qh_refresh (ehci, qh);
 	return qh;
--- a/drivers/usb/host/ehci.h
+++ b/drivers/usb/host/ehci.h
@@ -366,6 +366,7 @@ struct ehci_qh {
 #define NO_FRAME ((unsigned short)~0)			/* pick new start */
 
 	struct usb_device	*dev;		/* access to TT */
+	unsigned		is_out:1;	/* bulk or intr OUT */
 	unsigned		clearing_tt:1;	/* Clear-TT-Buf in progress */
 };
 


