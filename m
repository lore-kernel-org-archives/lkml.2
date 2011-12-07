Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809Ab1LGN0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 08:26:41 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:63702 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459Ab1LGN0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 08:26:40 -0500
Message-ID: <20191.27018.478290.890636@ipc1.ka-ro>
Date: Wed, 7 Dec 2011 14:26:34 +0100
From: =?utf-8?Q?Lothar_Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: <netdev@vger.kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][NET] several cleanups and bugfixes for fec.c: fix the
 .remove code
In-Reply-To: <20111207132828.GQ5550@S2100-06.ap.freescale.net>
References: <cover.1323163127.git.LW@KARO-electronics.de>
	<04c11563fee748562d7b53d5e5b3c5cf37fef200.1323163127.git.LW@KARO-electronics.de>
	<20111207132828.GQ5550@S2100-06.ap.freescale.net>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Shawn Guo writes:
> On Tue, Dec 06, 2011 at 11:27:15AM +0100, Lothar Waßmann wrote:
> > The .remove code is broken in several ways.
> >  - mdiobus_unregister() is called twice for the same object in case of dual FEC
> >  - phy_disconnect() is being called when the PHY is already disconnected
> >  - the requested IRQ(s) are not freed
> >  - fec_stop() is being called with the inteface already stopped
> > 
> >  All of those lead to kernel crashes if the remove function is actually used.
> > 
> > Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
> > ---
> >  drivers/net/ethernet/freescale/fec.c |   30 +++++++++++++++++++++---------
> >  1 files changed, 21 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/freescale/fec.c b/drivers/net/ethernet/freescale/fec.c
> > index ab0afb5..70ec7ec 100644
> > --- a/drivers/net/ethernet/freescale/fec.c
> > +++ b/drivers/net/ethernet/freescale/fec.c
> > @@ -235,6 +235,7 @@ struct fec_enet_private {
> >  
> >  	/* Phylib and MDIO interface */
> >  	struct	mii_bus *mii_bus;
> > +	int	mii_cnt;
> >  	struct	phy_device *phy_dev;
> >  	int	mii_timeout;
> >  	uint	phy_speed;
> > @@ -1040,8 +1041,12 @@ static int fec_enet_mii_init(struct platform_device *pdev)
> >  	 */
> >  	if ((id_entry->driver_data & FEC_QUIRK_ENET_MAC) && pdev->id > 0) {
> >  		/* fec1 uses fec0 mii_bus */
> > -		fep->mii_bus = fec0_mii_bus;
> > -		return 0;
> > +		if (fep->mii_cnt && fec0_mii_bus) {
> 
> This seems broken.  The second fec has its own fep and fep->mii_cnt is
> always 0 here.
> 
I already noticed that myself.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
