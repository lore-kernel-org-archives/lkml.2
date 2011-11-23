Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759419Ab1KWAt6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:49:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42900 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759323Ab1KWAlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:41:22 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:24:07 2011
Message-Id: <20111123002407.327064626@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:23:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Don Zickus <dzickus@redhat.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [29/53] usb, xhci: Clear warm reset change event during init
In-Reply-To: <20111123002419.GA8531@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Don Zickus <dzickus@redhat.com>

commit 79c3dd8150fd5236d95766a9e662e3e932b462c9 upstream.

I noticed on my Panther Point system that I wasn't getting hotplug events
for my usb3.0 disk on a usb3 port.  I tracked it down to the fact that the
system had the warm reset change bit still set.  This seemed to block future
events from being received, including a hotplug event.

Clearing this bit during initialization allowed the hotplug event to be
received and the disk to be recognized correctly.

This patch should be backported to kernels as old as 2.6.39.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/hub.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -813,6 +813,12 @@ static void hub_activate(struct usb_hub
 					USB_PORT_FEAT_C_PORT_LINK_STATE);
 		}
 
+		if ((portchange & USB_PORT_STAT_C_BH_RESET) &&
+				hub_is_superspeed(hub->hdev)) {
+			need_debounce_delay = true;
+			clear_port_feature(hub->hdev, port1,
+					USB_PORT_FEAT_C_BH_PORT_RESET);
+		}
 		/* We can forget about a "removed" device when there's a
 		 * physical disconnect or the connect status changes.
 		 */


