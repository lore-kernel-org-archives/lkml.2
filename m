Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394Ab2EIFyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:54:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39146 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756628Ab2EIFx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:57 -0400
Message-Id: <20120509055045.705106794@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:52:25 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrey Rahmatullin <wrar@wrar.name>,
        "Oleksij Rempel (fishor)" <bug-track@fisher-privat.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 116/167] [PATCH] USB: EHCI: fix crash during suspend on ASUS computers
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

commit 151b61284776be2d6f02d48c23c3625678960b97 upstream.

This patch (as1545) fixes a problem affecting several ASUS computers:
The machine crashes or corrupts memory when going into suspend if the
ehci-hcd driver is bound to any controllers.  Users have been forced
to unbind or unload ehci-hcd before putting their systems to sleep.

After extensive testing, it was determined that the machines don't
like going into suspend when any EHCI controllers are in the PCI D3
power state.  Presumably this is a firmware bug, but there's nothing
we can do about it except to avoid putting the controllers in D3
during system sleep.

The patch adds a new flag to indicate whether the problem is present,
and avoids changing the controller's power state if the flag is set.
Runtime suspend is unaffected; this matters only for system suspend.
However as a side effect, the controller will not respond to remote
wakeup requests while the system is asleep.  Hence USB wakeup is not
functional -- but of course, this is already true in the current state
of affairs.

This fixes Bugzilla #42728.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Steven Rostedt <rostedt@goodmis.org>
Tested-by: Andrey Rahmatullin <wrar@wrar.name>
Tested-by: Oleksij Rempel (fishor) <bug-track@fisher-privat.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/core/hcd-pci.c  |    9 +++++++++
 drivers/usb/host/ehci-pci.c |    8 ++++++++
 include/linux/usb/hcd.h     |    2 ++
 3 files changed, 19 insertions(+)

--- linux.orig/drivers/usb/core/hcd-pci.c
+++ linux/drivers/usb/core/hcd-pci.c
@@ -495,6 +495,15 @@
 
 	pci_save_state(pci_dev);
 
+	/*
+	 * Some systems crash if an EHCI controller is in D3 during
+	 * a sleep transition.  We have to leave such controllers in D0.
+	 */
+	if (hcd->broken_pci_sleep) {
+		dev_dbg(dev, "Staying in PCI D0\n");
+		return retval;
+	}
+
 	/* If the root hub is dead rather than suspended, disallow remote
 	 * wakeup.  usb_hc_died() should ensure that both hosts are marked as
 	 * dying, so we only need to check the primary roothub.
--- linux.orig/drivers/usb/host/ehci-pci.c
+++ linux/drivers/usb/host/ehci-pci.c
@@ -144,6 +144,14 @@
 			hcd->has_tt = 1;
 			tdi_reset(ehci);
 		}
+		if (pdev->subsystem_vendor == PCI_VENDOR_ID_ASUSTEK) {
+			/* EHCI #1 or #2 on 6 Series/C200 Series chipset */
+			if (pdev->device == 0x1c26 || pdev->device == 0x1c2d) {
+				ehci_info(ehci, "broken D3 during system sleep on ASUS\n");
+				hcd->broken_pci_sleep = 1;
+				device_set_wakeup_capable(&pdev->dev, false);
+			}
+		}
 		break;
 	case PCI_VENDOR_ID_TDI:
 		if (pdev->device == PCI_DEVICE_ID_TDI_EHCI) {
--- linux.orig/include/linux/usb/hcd.h
+++ linux/include/linux/usb/hcd.h
@@ -128,6 +128,8 @@
 	unsigned		wireless:1;	/* Wireless USB HCD */
 	unsigned		authorized_default:1;
 	unsigned		has_tt:1;	/* Integrated TT in root hub */
+	unsigned		broken_pci_sleep:1;	/* Don't put the
+			controller in PCI-D3 for system sleep */
 
 	int			irq;		/* irq allocated */
 	void __iomem		*regs;		/* device memory/io */


