Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab1LGKtO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 05:49:14 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:56352 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab1LGKtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 05:49:12 -0500
Message-ID: <20191.17573.87285.411253@ipc1.ka-ro>
Date: Wed, 7 Dec 2011 11:49:09 +0100
From: =?utf-8?Q?Lothar_Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: <netdev@vger.kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][NET] several cleanups and bugfixes for fec.c: preserve
 MII/RMII setting in fec_stop()
In-Reply-To: <20111207105816.GH5550@S2100-06.ap.freescale.net>
References: <cover.1323163127.git.LW@KARO-electronics.de>
	<d6f4de9e4cfb393754b42815a2ef1a59c96eab83.1323163127.git.LW@KARO-electronics.de>
	<20111207094146.GG5550@S2100-06.ap.freescale.net>
	<20191.17172.493079.722098@ipc1.ka-ro>
	<20111207105816.GH5550@S2100-06.ap.freescale.net>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Shawn Guo writes:
> On Wed, Dec 07, 2011 at 11:42:28AM +0100, Lothar Waßmann wrote:
> > Hi,
> > 
> > Shawn Guo writes:
> > > On Tue, Dec 06, 2011 at 11:27:14AM +0100, Lothar Waßmann wrote:
> > > > Additionally to setting the ETHER_EN bit in FEC_ECNTRL the MII/RMII
> > > > setting in FEC_R_CNTRL needs to be preserved to keep the MII interface
> > > 
> > > s/MII/RMII?  From what I see from imx28 and imx6q RM, the reset state
> > > for this setting is MII mode.
> > > 
> > > > functional.
> > > > 
> > > > Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
> > > > ---
> > > >  drivers/net/ethernet/freescale/fec.c |    5 ++++-
> > > >  1 files changed, 4 insertions(+), 1 deletions(-)
> > > 
> > > I assume this is fixing a problem you are seeing on imx28 only.
> > > Do you see the problem on imx53/51?
> > > 
> > No. i.MX53 uses the RMII gasket which is not affected by resetting the
> > controller. And imMX51 does not support RMII at all.
> > 
> > > > 
> > > > diff --git a/drivers/net/ethernet/freescale/fec.c b/drivers/net/ethernet/freescale/fec.c
> > > > index 11534b9..ab0afb5 100644
> > > > --- a/drivers/net/ethernet/freescale/fec.c
> > > > +++ b/drivers/net/ethernet/freescale/fec.c
> > > > @@ -515,6 +515,7 @@ fec_stop(struct net_device *ndev)
> > > >  	struct fec_enet_private *fep = netdev_priv(ndev);
> > > >  	const struct platform_device_id *id_entry =
> > > >  				platform_get_device_id(fep->pdev);
> > > > +	u32 rmii_mode = readl(fep->hwp + FEC_R_CNTRL) & (1 << 8);
> > > 
> > > This bit is only available on ENET (imx28 and imx6q).  Do we want to
> > > do the same thing for FEC (imx25/27/35/51/53)?
> > > 
> > No. AFAICT that's not necessary there.
> > 
> So you need to check it's actually running on ENET before accessing
> the bit.
> 
That's done in the place where the register is being written:
|	if (id_entry->driver_data & FEC_QUIRK_ENET_MAC) {
|		writel(2, fep->hwp + FEC_ECNTRL);
|		writel(rmii_mode, fep->hwp + FEC_R_CNTRL);
|	}

We could save one register read by doing the check also for the read,
but that would further complicate the code.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
