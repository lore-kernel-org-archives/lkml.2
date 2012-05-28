Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab2E1Dv1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:51:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51946 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753617Ab2E1D3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:17 -0400
Message-Id: <20120528031208.821753278@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:12:45 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Hans de Goede <hdegoede@redhat.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 043/117] usb-xhci: Handle COMP_TX_ERR for isoc tds
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 9c745995ae5c4ff787f34a359de908facc11ee00 upstream.

While testing unplugging an UVC HD webcam with usb-redirection (so through
usbdevfs), my userspace usb-redir code was getting a value of -1 in
iso_frame_desc[n].status, which according to Documentation/usb/error-codes.txt
is not a valid value.

The source of this -1 is the default case in xhci-ring.c:process_isoc_td()
adding a kprintf there showed the value of trb_comp_code to be COMP_TX_ERR
in this case, so this patch adds handling for that completion code to
process_isoc_td().

This was observed and tested with the following xhci controller:
1033:0194 NEC Corporation uPD720200 USB 3.0 Host Controller (rev 04)

Note: I also wonder if setting frame->status to -1 (-EPERM) is the best we can
do, but since I cannot come up with anything better I've left that as is.

This patch should be backported to kernels as old as 2.6.36, which contain the
commit 04e51901dd44f40a5a385ced897f6bca87d5f40a "USB: xHCI: Isochronous
transfer implementation".

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci-ring.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index cb1de11..d40194c 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1804,6 +1804,7 @@ static int process_isoc_td(struct xhci_hcd *xhci, struct xhci_td *td,
 		break;
 	case COMP_DEV_ERR:
 	case COMP_STALL:
+	case COMP_TX_ERR:
 		frame->status = -EPROTO;
 		skip_td = true;
 		break;


