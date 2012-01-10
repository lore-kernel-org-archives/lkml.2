Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934400Ab2AJXFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 18:05:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52959 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934313Ab2AJXEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 18:04:25 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan 10 13:56:05 2012
Message-Id: <20120110215605.293110884@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 10 Jan 2012 13:55:46 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Hans de Goede <hdegoede@redhat.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [43/49] xhci: Properly handle COMP_2ND_BW_ERR
In-Reply-To: <20120110215609.GA22505@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 71d85724bdd947a3b42a88d08af79f290a1a767b upstream.

I encountered a result of COMP_2ND_BW_ERR while improving how the pwc
webcam driver handles not having the full usb1 bandwidth available to
itself.

I created the following test setup, a NEC xhci controller with a
single TT USB 2 hub plugged into it, with a usb keyboard and a pwc webcam
plugged into the usb2 hub. This caused the following to show up in dmesg
when trying to stream from the pwc camera at its highest alt setting:

xhci_hcd 0000:01:00.0: ERROR: unexpected command completion code 0x23.
usb 6-2.1: Not enough bandwidth for altsetting 9

And usb_set_interface returned -EINVAL, which caused my pwc code to not
do the right thing as it expected -ENOSPC.

This patch makes the xhci driver properly handle COMP_2ND_BW_ERR and makes
usb_set_interface return -ENOSPC as expected.

This should be backported to stable kernels as old as 2.6.32.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci.c |    1 +
 drivers/usb/host/xhci.h |    1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1620,6 +1620,7 @@ static int xhci_configure_endpoint_resul
 		/* FIXME: can we allocate more resources for the HC? */
 		break;
 	case COMP_BW_ERR:
+	case COMP_2ND_BW_ERR:
 		dev_warn(&udev->dev, "Not enough bandwidth "
 				"for new device state.\n");
 		ret = -ENOSPC;
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1033,7 +1033,6 @@ struct xhci_transfer_event {
 /* Invalid Stream ID Error */
 #define COMP_STRID_ERR	34
 /* Secondary Bandwidth Error - may be returned by a Configure Endpoint cmd */
-/* FIXME - check for this */
 #define COMP_2ND_BW_ERR	35
 /* Split Transaction Error */
 #define	COMP_SPLIT_ERR	36


