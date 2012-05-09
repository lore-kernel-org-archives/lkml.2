Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758495Ab2EIG25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:28:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38752 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755658Ab2EIFwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:52:54 -0400
Message-Id: <20120509055034.039563429@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:51:01 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 032/167] [PATCH] EHCI: always clear the STS_FLR status bit
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/ehci-hcd.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index 95ca07a..4a3bc5b 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -858,8 +858,13 @@ static irqreturn_t ehci_irq (struct usb_hcd *hcd)
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
 	if (!masked_status || unlikely(ehci->rh_state == EHCI_RH_HALTED)) {
 		spin_unlock(&ehci->lock);
 		return IRQ_NONE;
-- 
1.7.10



