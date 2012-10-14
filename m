Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932552Ab2JNOqN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:46:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46799 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932412Ab2JNOoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:44:20 -0400
Message-Id: <20121014143536.779061089@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:35:55 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 022/147] xhci: Warn when hosts dont halt.
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 5af98bb06dee79d28c805f9fd0805ce791121784 upstream.

Eric Fu reports a problem with his VIA host controller fetching a zeroed
event ring pointer on resume from suspend.  The host should have been
halted, but we can't be sure because that code ignores the return value
from xhci_halt().  Print a warning when the host controller refuses to
halt within XHCI_MAX_HALT_USEC (currently 16 seconds).

(Update: it turns out that the VIA host controller is reporting a halted
state when it fetches the zeroed event ring pointer.  However, we still
need this warning for other host controllers.)

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index e1963d4..f68bc15 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -106,6 +106,9 @@ int xhci_halt(struct xhci_hcd *xhci)
 			STS_HALT, STS_HALT, XHCI_MAX_HALT_USEC);
 	if (!ret)
 		xhci->xhc_state |= XHCI_STATE_HALTED;
+	else
+		xhci_warn(xhci, "Host not halted after %u microseconds.\n",
+				XHCI_MAX_HALT_USEC);
 	return ret;
 }
 


