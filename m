Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932895Ab2DXWiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:38:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49279 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932868Ab2DXWiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:38:12 -0400
Message-Id: <20120424223255.272515087@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:33:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>
Subject: [ 21/42] EHCI: always clear the STS_FLR status bit
In-Reply-To: <20120424223311.GA8456@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 2fbe2bf1fd37f9d99950bd8d8093623cf22cf08b upstream.

This patch (as1544) fixes a problem affecting some EHCI controllers.
They can generate interrupts whenever the STS_FLR status bit is turned
on, even though that bit is masked out in the Interrupt Enable
register.

Since the driver doesn't use STS_FLR anyway, the patch changes the
interrupt routine to clear that bit whenever it is set, rather than
leaving it alone.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-and-tested-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/ehci-hcd.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -808,8 +808,13 @@ static irqreturn_t ehci_irq (struct usb_
 		goto dead;
 	}
 
+	/*
+	 * We don't use STS_FLR, but some controllers don't like it to
+	 * remain on, so mask it out along with the other status bits.
+	 */
+	masked_status = status & (INTR_MASK | STS_FLR);
+
 	/* Shared IRQ? */
-	masked_status = status & INTR_MASK;
 	if (!masked_status || unlikely(hcd->state == HC_STATE_HALT)) {
 		spin_unlock(&ehci->lock);
 		return IRQ_NONE;


