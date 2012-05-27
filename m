Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934183Ab2E0BTT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:19:19 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36809 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945932Ab2E0BTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:19:04 -0400
Message-Id: <20120527002520.011771470@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:26:06 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 60/91] xhci: Reset reserved command ring TRBs on cleanup.
In-Reply-To: <20120527010903.GA18244@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 33b2831ac870d50cc8e01c317b07fb1e69c13fe1 upstream.

When the xHCI driver needs to clean up memory (perhaps due to a failed
register restore on resume from S3 or resume from S4), it needs to reset
the number of reserved TRBs on the command ring to zero.  Otherwise,
several resume cycles (about 30) with a UAS device attached will
continually increment the number of reserved TRBs, until all command
submissions fail because there isn't enough room on the command ring.

This patch should be backported to kernels as old as 2.6.32,
that contain the commit 913a8a344ffcaf0b4a586d6662a2c66a7106557d
"USB: xhci: Change how xHCI commands are handled."

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-mem.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1807,6 +1807,7 @@ void xhci_mem_cleanup(struct xhci_hcd *x
 	xhci->event_ring = NULL;
 	xhci_dbg(xhci, "Freed event ring\n");
 
+	xhci->cmd_ring_reserved_trbs = 0;
 	if (xhci->cmd_ring)
 		xhci_ring_free(xhci, xhci->cmd_ring);
 	xhci->cmd_ring = NULL;


