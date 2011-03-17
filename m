Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab1CQX2F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 19:28:05 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62438 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333Ab1CQX2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 19:28:03 -0400
Date: Thu, 17 Mar 2011 17:27:56 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <greg@kroah.com>, devicetree-discuss@lists.ozlabs.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, andy.green@linaro.org,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
Message-ID: <20110317232756.GA3148@angua.secretlab.ca>
References: <20110311165642.GA9996@kroah.com>
 <20110317214042.GQ31411@opensource.wolfsonmicro.com>
 <20110317214736.GA29014@kroah.com>
 <201103172333.01474.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103172333.01474.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 11:33:01PM +0100, Arnd Bergmann wrote:
> On Thursday 17 March 2011 22:47:36 Greg KH wrote:
> > > > Patches to fix this, for this specific PandaBoard controller are gladly
> > > > accepted.  What's odd is this is explicitly a Linux development board,
> > > > so you would think that this could have been caught, and fixed, in the
> > > > hardware a long time ago, right?
> > > 
> > > The way everyone resolves this stuff is by patching their kernel
> > > locally.
> > 
> > Well, that means that the device tree work is going to be useful here,
> > right?  :)
> 
> I like the idea. Let's make this the first use case where a lot of
> people will want to have the device tree on ARM. The patch to the
> driver to check for a mac-address property is trivial, and we
> can probably come up with a decent way of parsing the device
> tree for USB devices, after all there is an existing spec for
> it (http://playground.sun.com/1275/bindings/usb/usb-1_0.ps).
> 

It would be fairly easy to handle.  In the model we've been using for
the flattened tree so far, nodes for detectable are optional and
almost always been omitted (as opposed to OpenFirmware which always
populates the devices, whether they are detectable or not).

However, it's always been an option to populate nodes for devices that
can also be detected if additional data needs to be supplied to make
it work.  For example, providing IRQ swizzle data for PCI host
controllers.

In this case, there needs to be a generic mechanism for attaching
device node pointers to USB devices when the device is attached or
removed from the bus from the perspective of Linux.

The USB binding that you linked uses a single cell containing the hub
or host contoller port to address a usb device.  As long as the device
tree topology mirrors the topology of the USB tree, and providing that
an of_node is associated with the USB host controller device in Linux,
then the USB core code should have sufficient knowledge to set and
clear each USB device's .of_node pointer as devices are attached and
removed.

The patch below also looks right to me.  I believe it also has the
advantage of u-boot already knowing how to update the
local-mac-address property at boot time.

g.

> 	Arnd
> 
> 8<------
> [PATCH] net/smscx5xx: demonstrate use of device tree for mac address
> 
> This takes the MAC address for smsc75xx/smsc95xx USB network devices
> from a the device tree. This is required to get a usable persistent
> address on the popular beagleboard, whose hardware designers
> accidentally forgot that an ethernet device really requires an a
> MAC address to be functional.
> 
> The smsc75xx and smsc95xx drivers are just two copies of the
> same code, so better fix both.
> 
> Not tested!
> 
> Signed-off-by: Arnd Bergmann <arnd.bergmann@linaro.org>
> 
> diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
> index 753ee6e..0420209 100644
> --- a/drivers/net/usb/smsc75xx.c
> +++ b/drivers/net/usb/smsc75xx.c
> @@ -29,6 +29,7 @@
>  #include <linux/crc32.h>
>  #include <linux/usb/usbnet.h>
>  #include <linux/slab.h>
> +#include <linux/of_device.h>
>  #include "smsc75xx.h"
>  
>  #define SMSC_CHIPNAME			"smsc75xx"
> @@ -658,6 +659,8 @@ static int smsc75xx_ioctl(struct net_device *netdev, struct ifreq *rq, int cmd)
>  
>  static void smsc75xx_init_mac_address(struct usbnet *dev)
>  {
> +	void *address;
> +
>  	/* try reading mac address from EEPROM */
>  	if (smsc75xx_read_eeprom(dev, EEPROM_MAC_OFFSET, ETH_ALEN,
>  			dev->net->dev_addr) == 0) {
> @@ -669,6 +672,13 @@ static void smsc75xx_init_mac_address(struct usbnet *dev)
>  		}
>  	}
>  
> +	address = of_get_property(dev->udev->dev.of_node,
> +				  "local-mac-address", NULL);
> +	if (address) {
> +		memcpy(dev->net->dev_addr, address, ETH_ALEN);
> +		return;
> +	}
> +
>  	/* no eeprom, or eeprom values are invalid. generate random MAC */
>  	random_ether_addr(dev->net->dev_addr);
>  	netif_dbg(dev, ifup, dev->net, "MAC address set to random_ether_addr");
> diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
> index bc86f4b..74585fb 100644
> --- a/drivers/net/usb/smsc95xx.c
> +++ b/drivers/net/usb/smsc95xx.c
> @@ -29,6 +29,7 @@
>  #include <linux/crc32.h>
>  #include <linux/usb/usbnet.h>
>  #include <linux/slab.h>
> +#include <linux/of_device.h>
>  #include "smsc95xx.h"
>  
>  #define SMSC_CHIPNAME			"smsc95xx"
> @@ -639,6 +640,8 @@ static int smsc95xx_ioctl(struct net_device *netdev, struct ifreq *rq, int cmd)
>  
>  static void smsc95xx_init_mac_address(struct usbnet *dev)
>  {
> +	void *address;
> +
>  	/* try reading mac address from EEPROM */
>  	if (smsc95xx_read_eeprom(dev, EEPROM_MAC_OFFSET, ETH_ALEN,
>  			dev->net->dev_addr) == 0) {
> @@ -649,6 +652,13 @@ static void smsc95xx_init_mac_address(struct usbnet *dev)
>  		}
>  	}
>  
> +	address = of_get_property(dev->udev->dev.of_node,
> +				  "local-mac-address", NULL);
> +	if (address) {
> +		memcpy(dev->net->dev_addr, address, ETH_ALEN);
> +		return;
> +	}
> +
>  	/* no eeprom, or eeprom values are invalid. generate random MAC */
>  	random_ether_addr(dev->net->dev_addr);
>  	netif_dbg(dev, ifup, dev->net, "MAC address set to random_ether_addr\n");
