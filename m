Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128Ab1JMQ1V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 12:27:21 -0400
Received: from exchange.solarflare.com ([216.237.3.220]:22992 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab1JMQ1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 12:27:20 -0400
Subject: Re: [PATCH 1/3] netdev/phy: Handle IEEE802.3 clause 45 Ethernet
 PHYs
From: Ben Hutchings <bhutchings@solarflare.com>
To: David Daney <david.daney@cavium.com>
Cc: devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, afleming@gmail.com
In-Reply-To: <1318442783-29058-2-git-send-email-david.daney@cavium.com>
References: <1318442783-29058-1-git-send-email-david.daney@cavium.com>
	 <1318442783-29058-2-git-send-email-david.daney@cavium.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Thu, 13 Oct 2011 17:27:16 +0100
Message-ID: <1318523236.2745.29.camel@bwh-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Oct 2011 16:27:19.0770 (UTC) FILETIME=[FA970BA0:01CC89C4]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18446.005
X-TM-AS-Result: No--14.748000-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-12 at 11:06 -0700, David Daney wrote:
> The IEEE802.3 clause 45 MDIO bus protocol allows for directly
> addressing PHY registers using a 21 bit address, and is used by many
> 10G Ethernet PHYS.  Already existing is the ability of MDIO bus
> drivers to use clause 45, with the MII_ADDR_C45 flag.  Here we add
> some support in the PHY and device tree infrastructure to use these
> PHYs.
> 
> Normally the MII_ADDR_C45 flag is ORed with the register address to
> indicate a clause 45 transaction.  Here we also use this flag in the
> *device* address passed to get_phy_id() and get_phy_device() to
> indicate that probing should be done with clause 45 transactions.  If
> a PHY is successfully probed with MII_ADDR_C45, the new struct
> phy_device is_c45 flag is set for the PHY.

That deserves a comment next to the definition of the macro.

> Signed-off-by: David Daney <david.daney@cavium.com>
> ---
>  drivers/net/phy/phy_device.c |   25 ++++++++++++++++++++++---
>  include/linux/phy.h          |    3 +++
>  2 files changed, 25 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 83a5a5a..7e4d61b 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -171,6 +171,8 @@ static struct phy_device* phy_device_create(struct mii_bus *bus,
>  
>  	dev->autoneg = AUTONEG_ENABLE;
>  
> +	dev->is_c45 = (addr & MII_ADDR_C45) != 0;
> +	addr &= ~MII_ADDR_C45;
>  	dev->addr = addr;
>  	dev->phy_id = phy_id;
>  	dev->bus = bus;
> @@ -205,15 +207,24 @@ static struct phy_device* phy_device_create(struct mii_bus *bus,
>   * @phy_id: where to store the ID retrieved.
>   *
>   * Description: Reads the ID registers of the PHY at @addr on the
> - *   @bus, stores it in @phy_id and returns zero on success.
> + *   @bus, stores it in @phy_id and returns zero on success.  If the
> + *   @addr has been ORed with MII_ADDR_C45, mdio clause 45 data
> + *   transfer is used to read ID from the PHY device, otherwise the
> + *   standard protocol (clause 22) is used.
>   */
>  int get_phy_id(struct mii_bus *bus, int addr, u32 *phy_id)
>  {
>  	int phy_reg;
> +	u32 c45_reg_base = 0;
>  
> +	if (addr & MII_ADDR_C45) {
> +		addr &= ~MII_ADDR_C45;
> +		/* Access the PHY's PHY XS registers with C45 mode. */
> +		c45_reg_base = MII_ADDR_C45 | 0x40000;
> +	}
[...]

I'm not sure it's a safe assumption that every PHY has a PHY XS block.
That said, I've not seen any that don't.  mdio45_probe() should work out
which blocks are there, if you can set up an mdio_if_info for it.

It would be nice if someone would try to improve integration between
mdio/mii and phylib rather than duplicating logic and interfaces.  I'm
afraid I'm not going to be spending time on MDIO, though, since we've
putting PHY drivers in firmware rather than on the host now.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

