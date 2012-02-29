Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031200Ab2B2RJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 12:09:41 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:50066 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030302Ab2B2RJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 12:09:40 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: "Dmitry Kravkov" <dmitry@broadcom.com>
Subject: Re: [PATCH 2/8] bnx2x: adopt bnx2x_validate_addr() to .ndo_validate_addr changes
Date: Wed, 29 Feb 2012 18:08:29 +0100
User-Agent: KMail/1.9.10
Cc: "Eilon Greenstein" <eilong@broadcom.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
References: <1330530176-24952-1-git-send-email-danny.kukawka@bisect.de> <1330530176-24952-3-git-send-email-danny.kukawka@bisect.de> <1330532535.25281.2.camel@lb-tlvb-dmitry>
In-Reply-To: <1330532535.25281.2.camel@lb-tlvb-dmitry>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201202291808.30599.danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1330535379;ce06f8fb;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mittwoch, 29. Februar 2012, Dmitry Kravkov wrote:
> On Wed, 2012-02-29 at 16:42 +0100, Danny Kukawka wrote:
> > Adopted bnx2x_validate_addr() to changes in .ndo_validate_addr,
> > handle second parameter to be validated.
> >
> > Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
> > ---
> >  drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c |   13 ++++++++++---
> >  1 files changed, 10 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> > b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c index b4afef6..d25ef1e
> > 100644
> > --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> > +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> > @@ -10532,12 +10532,19 @@ static void poll_bnx2x(struct net_device *dev)
> >  }
> >  #endif
> >
> > -static int bnx2x_validate_addr(struct net_device *dev)
> > +static int bnx2x_validate_addr(struct net_device *dev, void *addr)
> >  {
> >  	struct bnx2x *bp = netdev_priv(dev);
> > +	struct sockaddr *saddr;
> >
> > -	if (!bnx2x_is_valid_ether_addr(bp, dev->dev_addr))
> > -		return -EADDRNOTAVAIL;
> > +	if (addr) {
> > +		saddr = addr;
> > +		if (!bnx2x_is_valid_ether_addr(bp, saddr->sa_data))
> > +			return -EADDRNOTAVAIL;
> > +	} else {
> > +		if (!bnx2x_is_valid_ether_addr(bp, dev->dev_addr))
> > +			return -EADDRNOTAVAIL;
> > +	}
> >  	return 0;
> >  }
>
> Isn't it preferred to calculate the correct address for test and then
> call bnx2x_is_valid_ether_addr() at the end?

Do you mean something like this: 

int eth_validate_addr(struct net_device *dev, void *addr)
{
 u8 *vaddr;

 if (addr)
    vaddr = ((struct sockaddr *) addr)->sa_data;
 else
    vaddr = dev->dev_addr;

 if (!is_valid_ether_addr(vaddr))
    return -EADDRNOTAVAIL;

 return 0;
}


