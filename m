Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727Ab1CQWdI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 18:33:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52778 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755674Ab1CQWdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 18:33:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <greg@kroah.com>, Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: RFC: Platform data for onboard USB assets
Date: Thu, 17 Mar 2011 23:33:01 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8+; KDE/4.5.1; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, andy.green@linaro.org,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
References: <20110311165642.GA9996@kroah.com> <20110317214042.GQ31411@opensource.wolfsonmicro.com> <20110317214736.GA29014@kroah.com>
In-Reply-To: <20110317214736.GA29014@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103172333.01474.arnd@arndb.de>
X-Provags-ID: V02:K0:APud49uyq9dsAe4NphnTJMYaC65GlliKCP7/w9DnwZr
 YCFi4AWXthioLTu5ggnMK8YkwMM1PhmFBdo7iHDezeuczCAX9/
 FilSna3kL1CiqkLSrNAYfxQwl9Bk6/Z6FdrnPlhpRKlQZRBVz2
 asg5tEkmLuCcMz4/DkbCffVa3fimMqxuH5eye5pfDs9ZLXHWiD
 9museaH/6qZTeThTHDzzw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 March 2011 22:47:36 Greg KH wrote:
> > > Patches to fix this, for this specific PandaBoard controller are gladly
> > > accepted.  What's odd is this is explicitly a Linux development board,
> > > so you would think that this could have been caught, and fixed, in the
> > > hardware a long time ago, right?
> > 
> > The way everyone resolves this stuff is by patching their kernel
> > locally.
> 
> Well, that means that the device tree work is going to be useful here,
> right?  :)

I like the idea. Let's make this the first use case where a lot of
people will want to have the device tree on ARM. The patch to the
driver to check for a mac-address property is trivial, and we
can probably come up with a decent way of parsing the device
tree for USB devices, after all there is an existing spec for
it (http://playground.sun.com/1275/bindings/usb/usb-1_0.ps).

	Arnd

8<------
[PATCH] net/smscx5xx: demonstrate use of device tree for mac address

This takes the MAC address for smsc75xx/smsc95xx USB network devices
from a the device tree. This is required to get a usable persistent
address on the popular beagleboard, whose hardware designers
accidentally forgot that an ethernet device really requires an a
MAC address to be functional.

The smsc75xx and smsc95xx drivers are just two copies of the
same code, so better fix both.

Not tested!

Signed-off-by: Arnd Bergmann <arnd.bergmann@linaro.org>

diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
index 753ee6e..0420209 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -29,6 +29,7 @@
 #include <linux/crc32.h>
 #include <linux/usb/usbnet.h>
 #include <linux/slab.h>
+#include <linux/of_device.h>
 #include "smsc75xx.h"
 
 #define SMSC_CHIPNAME			"smsc75xx"
@@ -658,6 +659,8 @@ static int smsc75xx_ioctl(struct net_device *netdev, struct ifreq *rq, int cmd)
 
 static void smsc75xx_init_mac_address(struct usbnet *dev)
 {
+	void *address;
+
 	/* try reading mac address from EEPROM */
 	if (smsc75xx_read_eeprom(dev, EEPROM_MAC_OFFSET, ETH_ALEN,
 			dev->net->dev_addr) == 0) {
@@ -669,6 +672,13 @@ static void smsc75xx_init_mac_address(struct usbnet *dev)
 		}
 	}
 
+	address = of_get_property(dev->udev->dev.of_node,
+				  "local-mac-address", NULL);
+	if (address) {
+		memcpy(dev->net->dev_addr, address, ETH_ALEN);
+		return;
+	}
+
 	/* no eeprom, or eeprom values are invalid. generate random MAC */
 	random_ether_addr(dev->net->dev_addr);
 	netif_dbg(dev, ifup, dev->net, "MAC address set to random_ether_addr");
diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index bc86f4b..74585fb 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -29,6 +29,7 @@
 #include <linux/crc32.h>
 #include <linux/usb/usbnet.h>
 #include <linux/slab.h>
+#include <linux/of_device.h>
 #include "smsc95xx.h"
 
 #define SMSC_CHIPNAME			"smsc95xx"
@@ -639,6 +640,8 @@ static int smsc95xx_ioctl(struct net_device *netdev, struct ifreq *rq, int cmd)
 
 static void smsc95xx_init_mac_address(struct usbnet *dev)
 {
+	void *address;
+
 	/* try reading mac address from EEPROM */
 	if (smsc95xx_read_eeprom(dev, EEPROM_MAC_OFFSET, ETH_ALEN,
 			dev->net->dev_addr) == 0) {
@@ -649,6 +652,13 @@ static void smsc95xx_init_mac_address(struct usbnet *dev)
 		}
 	}
 
+	address = of_get_property(dev->udev->dev.of_node,
+				  "local-mac-address", NULL);
+	if (address) {
+		memcpy(dev->net->dev_addr, address, ETH_ALEN);
+		return;
+	}
+
 	/* no eeprom, or eeprom values are invalid. generate random MAC */
 	random_ether_addr(dev->net->dev_addr);
 	netif_dbg(dev, ifup, dev->net, "MAC address set to random_ether_addr\n");
