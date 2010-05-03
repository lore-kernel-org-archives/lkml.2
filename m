Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933248Ab0ECQY6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 12:24:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:39020 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933204Ab0ECQY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 12:24:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,320,1270450800"; 
   d="scan'208";a="794985365"
Date: Mon, 3 May 2010 09:24:55 -0700
From: Sarah Sharp <sarah.a.sharp@intel.com>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org, Mauro Carvalho Chehab <mchehab@infradead.org>,
       Hans de Goede <hdegoede@redhat.com>, linux-kernel@vger.kernel.org,
       Andiry Xu <andiry.xu@amd.com>
Subject: [PATCH] gspca: Try a less bandwidth-intensive alt setting.
Message-ID: <20100503162427.GA5132@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Under OHCI, UHCI, and EHCI, if an alternate interface setting took too
much of the bus bandwidth, then submit_urb() would fail.  The xHCI host
controller does bandwidth checking when the alternate interface setting is
installed, so usb_set_interface() can fail.  If it does, try the next
alternate interface setting.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Tested-by:  Andiry Xu <andiry.xu@amd.com>
---
 drivers/media/video/gspca/gspca.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index 222af47..6de3117 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -643,6 +643,7 @@ static struct usb_host_endpoint *get_ep(struct gspca_dev *gspca_dev)
 	xfer = gspca_dev->cam.bulk ? USB_ENDPOINT_XFER_BULK
 				   : USB_ENDPOINT_XFER_ISOC;
 	i = gspca_dev->alt;			/* previous alt setting */
+find_alt:
 	if (gspca_dev->cam.reverse_alts) {
 		while (++i < gspca_dev->nbalt) {
 			ep = alt_xfer(&intf->altsetting[i], xfer);
@@ -666,10 +667,11 @@ static struct usb_host_endpoint *get_ep(struct gspca_dev *gspca_dev)
 	if (gspca_dev->nbalt > 1) {
 		gspca_input_destroy_urb(gspca_dev);
 		ret = usb_set_interface(gspca_dev->dev, gspca_dev->iface, i);
-		if (ret < 0) {
-			err("set alt %d err %d", i, ret);
-			ep = NULL;
-		}
+		/* xHCI hosts will reject set interface requests
+		 * if they take too much bandwidth, so try again.
+		 */
+		if (ret < 0)
+			goto find_alt;
 		gspca_input_create_urb(gspca_dev);
 	}
 	return ep;
-- 
1.6.3.3

