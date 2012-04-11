Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760890Ab2DKScF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 14:32:05 -0400
Received: from mail.solarflare.com ([216.237.3.220]:27900 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753695Ab2DKScD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 14:32:03 -0400
Message-ID: <1334169119.2552.17.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [RFC PATCH 2/2] net: ethtool: Add capability to retrieve
 plug-in module EEPROM
From: Ben Hutchings <bhutchings@solarflare.com>
To: Stuart Hodgson <smhodgson@solarflare.com>
CC: <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>
Date: Wed, 11 Apr 2012 19:31:59 +0100
In-Reply-To: <4F85C22C.30707@solarflare.com>
References: <4F71FE15.7060708@solarflare.com>
	 <1333390698.2623.47.camel@bwh-desktop.uk.solarflarecom.com>
	 <4F85C22C.30707@solarflare.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-6.800.1017-18830.005
X-TM-AS-Result: No--22.605900-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-11 at 18:41 +0100, Stuart Hodgson wrote:
> On 02/04/12 19:18, Ben Hutchings wrote:
> > On Tue, 2012-03-27 at 18:51 +0100, Stuart Hodgson wrote:
[...]
> >> --- a/drivers/net/ethernet/sfc/ethtool.c
> >> +++ b/drivers/net/ethernet/sfc/ethtool.c
[...]
> >> +        payload_len = MCDI_DWORD(outbuf,
> >> +                     GET_PHY_MEDIA_INFO_OUT_DATALEN);
> >> +
> >> +        to_copy = (space_remaining<  payload_len) ?
> >> +                space_remaining : payload_len;
> >> +
> >> +        to_copy -= page_off;
> >
> > page_off is the number of bytes we need to discard from payload_len, but
> > we don't want do discard that from space_remaining.  I think the last
> > two statements should be changed to:
> >
> > 	payload_len -= page_off;
> > 	to_copy = (space_remaining<  payload_len) ?
> > 		space_remaining : payload_len;
> >
> 
> I am pretty sure that these two pieces of code are the same

Suppose we start with ee->offset = 64, ee->len = 32.  After the MCDI
request returns and we assign payload_len from that, I believe we will
have page_off = 64, payload_len = 128, space_remaining = 32.

Work through the calculations from there and you'll see the problem.

[...]
> >> +    phy_cfg = efx->phy_data;
> >> +    modinfo->eeprom_len = mcdi_to_module_eeprom_len(phy_cfg->media);
> >> +    modinfo->type = SFF_8079;
> > [...]
> >
> > I don't think this makes sense.  If we're fixing the type as SFF_8079
> > then why are we calling a function to get the length?
> >
> > Ben.
> >
> 
> What about adding an mcdi_to_module_eeprom_type in the same manner
> as mcdi_to_module_eeprom_len and the other mapping functions?

Could do, but I don't see the point of breaking this out into separate
functions that are only used once.  It's actually going to increase code
duplication because you'll have to put the same PHY type checks in both
of them.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

