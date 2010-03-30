Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab0C3OmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 10:42:08 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62821 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab0C3OmG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 10:42:06 -0400
MIME-Version: 1.0
In-Reply-To: <1269943112-6975-1-git-send-email-anders.darander@gmail.com>
References: <1269943112-6975-1-git-send-email-anders.darander@gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 30 Mar 2010 08:41:43 -0600
X-Google-Sender-Auth: 0a44fed46fff697b
Message-ID: <fa686aa41003300741x5ef9bdbpf56133304fe4d6e6@mail.gmail.com>
Subject: Re: [PATCH] Allow MACB to connect to a higher addresses PHY.
To: Anders Darander <anders.darander@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
       Ralf Baechle <ralf@linux-mips.org>, Maxime Bizon <mbizon@freebox.fr>,
       Anders Darander <ad@datarespons.se>,
       David Daney <ddaney@caviumnetworks.com>, Sekhar Nori <nsekhar@ti.com>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Andy Fleming <afleming@freescale.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 3:58 AM, Anders Darander
<anders.darander@gmail.com> wrote:
> From: Anders Darander <ad@datarespons.se>
>
> Using the Atmel MACB together with an integrated switch, can make only port 1
> work. This is caused by macb_mii_probe trying to attach the MAC to the first
> PHY, which often is on one of the external ports.
>
> E.g. the Micrel KSZ8873 connects to the MAC on port 3, thus phy_addr should be
> set to 3.
>
> Signed-off-by: Anders Darander <ad@datarespons.se>

Hi Anders,

I understand what you are trying to do, but this is the wrong way to
go about it.  Hard coding it into Kconfig breaks multiplatform
kernels.  Besides, systems may have more than one physical MDIO bus.
This patch would make CONFIG_SWITCHING_PHY_ADDR the only address
accessible on all MDIO busses.

Nak.

The right thing to do is to add a runtime configuration option (ie.
kernel parameter or platform data) to the mac driver to specify
exactly which PHY address it is supposed to use.

g.

> ---
>  drivers/net/phy/Kconfig      |   19 ++++++++++++++++++-
>  drivers/net/phy/phy_device.c |    4 ++++
>  2 files changed, 22 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> index fc5938b..64aa003 100644
> --- a/drivers/net/phy/Kconfig
> +++ b/drivers/net/phy/Kconfig
> @@ -15,11 +15,28 @@ if PHYLIB
>
>  comment "MII PHY device drivers"
>
> +config SWITCHING_PHY
> +       bool "An Ethernet switch is connected to the MAC"
> +       depends on MACB
> +       help
> +         If an Ethernet switch is connected to the MAC, it
> +         is quite common to have the connection on a port
> +         higher than the first port. This option allows to
> +         select the desired port number
> +
> +config SWITCHING_PHY_ADDR
> +       int "PHYA address"
> +       depends on SWITCHING_PHY
> +       default "3"
> +       help
> +         On e.g. the Micrel KSZ8873MLL, port 3 (and thus phy_addr
> +         3) is the one connected to the MAC of the MCU.
> +
>  config MARVELL_PHY
>        tristate "Drivers for Marvell PHYs"
>        ---help---
>          Currently has a driver for the 88E1011S
> -
> +
>  config DAVICOM_PHY
>        tristate "Drivers for Davicom PHYs"
>        ---help---
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index db17945..891bd0d 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -284,7 +284,11 @@ struct phy_device *phy_find_first(struct mii_bus *bus)
>  {
>        int addr;
>
> +#ifdef CONFIG_SWITCHING_PHY
> +       for (addr = CONFIG_SWITCHING_PHY_ADDR; addr < PHY_MAX_ADDR; addr++) {
> +#else
>        for (addr = 0; addr < PHY_MAX_ADDR; addr++) {
> +#endif
>                if (bus->phy_map[addr])
>                        return bus->phy_map[addr];
>        }
> --
> 1.7.0.3
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
