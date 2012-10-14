Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525Ab2JNOpU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:45:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46834 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932485Ab2JNOo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:44:26 -0400
Message-Id: <20121014143536.911004545@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:35:56 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Elric Fu <elricfu1@gmail.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Miroslav Sabljic <miroslav.sabljic@avl.com>
Subject: [ 023/147] xHCI: add cmd_ring_state
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Elric Fu <elricfu1@gmail.com>

commit c181bc5b5d5c79b71203cd10cef97f802fb6f9c1 upstream.

Adding cmd_ring_state for command ring. It helps to verify
the current command ring state for controlling the command
ring operations.

This patch should be backported to kernels as old as 3.0.  The commit
7ed603ecf8b68ab81f4c83097d3063d43ec73bb8 "xhci: Add an assertion to
check for virt_dev=0 bug." papers over the NULL pointer dereference that
I now believe is related to a timed out Set Address command.  This (and
the four patches that follow it) contain the real fix that also allows
VIA USB 3.0 hubs to consistently re-enumerate during the plug/unplug
stress tests.

Signed-off-by: Elric Fu <elricfu1@gmail.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Tested-by: Miroslav Sabljic <miroslav.sabljic@avl.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci-ring.c |    3 +++
 drivers/usb/host/xhci.c      |    6 ++++--
 drivers/usb/host/xhci.h      |    4 ++++
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 643c2f3..75c857e 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -280,6 +280,9 @@ static inline int room_on_ring(struct xhci_hcd *xhci, struct xhci_ring *ring,
 /* Ring the host controller doorbell after placing a command on the ring */
 void xhci_ring_cmd_db(struct xhci_hcd *xhci)
 {
+	if (!(xhci->cmd_ring_state & CMD_RING_STATE_RUNNING))
+		return;
+
 	xhci_dbg(xhci, "// Ding dong!\n");
 	xhci_writel(xhci, DB_VALUE_HOST, &xhci->dba->doorbell[0]);
 	/* Flush PCI posted writes */
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index c59d5b5..f425356 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -104,9 +104,10 @@ int xhci_halt(struct xhci_hcd *xhci)
 
 	ret = handshake(xhci, &xhci->op_regs->status,
 			STS_HALT, STS_HALT, XHCI_MAX_HALT_USEC);
-	if (!ret)
+	if (!ret) {
 		xhci->xhc_state |= XHCI_STATE_HALTED;
-	else
+		xhci->cmd_ring_state = CMD_RING_STATE_STOPPED;
+	} else
 		xhci_warn(xhci, "Host not halted after %u microseconds.\n",
 				XHCI_MAX_HALT_USEC);
 	return ret;
@@ -485,6 +486,7 @@ static int xhci_run_finished(struct xhci_hcd *xhci)
 		return -ENODEV;
 	}
 	xhci->shared_hcd->state = HC_STATE_RUNNING;
+	xhci->cmd_ring_state = CMD_RING_STATE_RUNNING;
 
 	if (xhci->quirks & XHCI_NEC_HOST)
 		xhci_ring_cmd_db(xhci);
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index c713256..33f24e9 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1421,6 +1421,10 @@ struct xhci_hcd {
 	/* data structures */
 	struct xhci_device_context_array *dcbaa;
 	struct xhci_ring	*cmd_ring;
+	unsigned int            cmd_ring_state;
+#define CMD_RING_STATE_RUNNING         (1 << 0)
+#define CMD_RING_STATE_ABORTED         (1 << 1)
+#define CMD_RING_STATE_STOPPED         (1 << 2)
 	unsigned int		cmd_ring_reserved_trbs;
 	struct xhci_ring	*event_ring;
 	struct xhci_erst	erst;


