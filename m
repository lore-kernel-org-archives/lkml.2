Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965387Ab2EOChL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:37:11 -0400
Received: from mail.windriver.com ([147.11.1.11]:49810 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965381Ab2EOCRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:52 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 138/179] EHCI: fix direction handling for interrupt data toggles
Date: Mon, 14 May 2012 22:13:54 -0400
Message-ID: <1337048075-6132-139-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/host/ehci-q.c |    3 ++-
 drivers/usb/host/ehci.h   |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/ehci-q.c b/drivers/usb/host/ehci-q.c
index 781c573..9b46a1e 100644
--- a/drivers/usb/host/ehci-q.c
+++ b/drivers/usb/host/ehci-q.c
@@ -103,7 +103,7 @@ qh_update (struct ehci_hcd *ehci, struct ehci_qh *qh, struct ehci_qtd *qtd)
 	if (!(hw->hw_info1 & cpu_to_hc32(ehci, 1 << 14))) {
 		unsigned	is_out, epnum;
 
-		is_out = !(qtd->hw_token & cpu_to_hc32(ehci, 1 << 8));
+		is_out = qh->is_out;
 		epnum = (hc32_to_cpup(ehci, &hw->hw_info1) >> 8) & 0x0f;
 		if (unlikely (!usb_gettoggle (qh->dev, epnum, is_out))) {
 			hw->hw_token &= ~cpu_to_hc32(ehci, QTD_TOGGLE);
@@ -945,6 +945,7 @@ done:
 	hw = qh->hw;
 	hw->hw_info1 = cpu_to_hc32(ehci, info1);
 	hw->hw_info2 = cpu_to_hc32(ehci, info2);
+	qh->is_out = !is_input;
 	usb_settoggle (urb->dev, usb_pipeendpoint (urb->pipe), !is_input, 1);
 	qh_refresh (ehci, qh);
 	return qh;
diff --git a/drivers/usb/host/ehci.h b/drivers/usb/host/ehci.h
index 20b5e16..1bb7a7f 100644
--- a/drivers/usb/host/ehci.h
+++ b/drivers/usb/host/ehci.h
@@ -367,6 +367,7 @@ struct ehci_qh {
 #define NO_FRAME ((unsigned short)~0)			/* pick new start */
 
 	struct usb_device	*dev;		/* access to TT */
+	unsigned		is_out:1;	/* bulk or intr OUT */
 	unsigned		clearing_tt:1;	/* Clear-TT-Buf in progress */
 };
 
-- 
1.7.9.6

