Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030832Ab2ERCxr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 22:53:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40586 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030756Ab2ERCwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:52:54 -0400
Message-Id: <20120518023257.912012223@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 03:33:20 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Markus Kolb <linux-201011@tower-net.de>,
        =?ISO-8859-15?q?Iker=20Salm=C3=B3n=20San=20Mill=C3=A1n?= 
	<shaola@esdebian.org>,
        Jonathan Nieder <jrnieder@gmail.com>,
        Oliver Neukum <oliver@neukum.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 26/53] cdc_ether: Ignore bogus union descriptor for RNDIS devices
In-Reply-To: <20120518023254.339945758@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit 6eddcb4c82883451aec3be1240f17793370fa62f upstream.

Some RNDIS devices include a bogus CDC Union descriptor pointing
to non-existing interfaces.  The RNDIS code is already prepared
to handle devices without a CDC Union descriptor by hardwiring
the driver to use interfaces 0 and 1, which is correct for the
devices with the bogus descriptor as well. So we can reuse the
existing workaround.

Cc: Markus Kolb <linux-201011@tower-net.de>
Cc: Iker Salmón San Millán <shaola@esdebian.org>
Cc: Jonathan Nieder <jrnieder@gmail.com>
Cc: Oliver Neukum <oliver@neukum.org>
Cc: 655387@bugs.debian.org
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/usb/cdc_ether.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
index 90a3002..00880ed 100644
--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -83,6 +83,7 @@ int usbnet_generic_cdc_bind(struct usbnet *dev, struct usb_interface *intf)
 	struct cdc_state		*info = (void *) &dev->data;
 	int				status;
 	int				rndis;
+	bool				android_rndis_quirk = false;
 	struct usb_driver		*driver = driver_of(intf);
 	struct usb_cdc_mdlm_desc	*desc = NULL;
 	struct usb_cdc_mdlm_detail_desc *detail = NULL;
@@ -195,6 +196,11 @@ int usbnet_generic_cdc_bind(struct usbnet *dev, struct usb_interface *intf)
 					info->control,
 					info->u->bSlaveInterface0,
 					info->data);
+				/* fall back to hard-wiring for RNDIS */
+				if (rndis) {
+					android_rndis_quirk = true;
+					goto next_desc;
+				}
 				goto bad_desc;
 			}
 			if (info->control != intf) {
@@ -271,11 +277,15 @@ next_desc:
 	/* Microsoft ActiveSync based and some regular RNDIS devices lack the
 	 * CDC descriptors, so we'll hard-wire the interfaces and not check
 	 * for descriptors.
+	 *
+	 * Some Android RNDIS devices have a CDC Union descriptor pointing
+	 * to non-existing interfaces.  Ignore that and attempt the same
+	 * hard-wired 0 and 1 interfaces.
 	 */
-	if (rndis && !info->u) {
+	if (rndis && (!info->u || android_rndis_quirk)) {
 		info->control = usb_ifnum_to_if(dev->udev, 0);
 		info->data = usb_ifnum_to_if(dev->udev, 1);
-		if (!info->control || !info->data) {
+		if (!info->control || !info->data || info->control != intf) {
 			dev_dbg(&intf->dev,
 				"rndis: master #0/%p slave #1/%p\n",
 				info->control,
-- 
1.7.10



