Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759338Ab2EINSg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 09:18:36 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:63359 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757968Ab2EINSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 09:18:35 -0400
Message-ID: <1336569510.8274.360.camel@deadeye>
Subject: RE: [PATCH] pch_gbe: Adding read memory barriers
From: Ben Hutchings <bhutchings@solarflare.com>
To: David Laight <David.Laight@ACULAB.COM>
CC: Erwan Velu <erwanaliasr1@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <tshimizu818@gmail.com>
Date: Wed, 9 May 2012 14:18:30 +0100
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F602CD83CB@saturn3.aculab.com>
References: <4FA822C4.60809@gmail.com>
	 <AE90C24D6B3A694183C094C60CF0A2F602CD83CB@saturn3.aculab.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [88.96.1.126]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-6.800.1017-18894.005
X-TM-AS-Result: No--20.192200-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 11:47 +0100, David Laight wrote:
> > Under a strong incoming packet stream and/or high cpu usage,
> > the pch_gbe driver reports "Receive CRC Error" and discards packet.
> > 
> > It occurred on an Intel ATOM E620T while running a 
> > 300mbit/sec multicast
> > network stream leading to a ~100% cpu usage.
> > 
> > Adding rmb() calls before considering the network card's status solve
> > this issue.
> > 
> > Getting it into stable would be perfect as it solves 
> > reliability issues.
> > 
> > Signed-off-by: Erwan Velu <erwan.velu@zodiacaerospace.com>
> > ---
> >   .../net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c   |    3 +++
> >   1 files changed, 3 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c 
> > b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
> > index 8035e5f..ace3654 100644
> > --- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
> > +++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
> > @@ -1413,6 +1413,7 @@ static irqreturn_t pch_gbe_intr(int 
> > irq, void *data)
> >   			pch_gbe_mac_set_pause_packet(hw);
> >   		}
> >   	}
> > +	smp_rmb(); /* prevent any other reads before*/
> 
> Under the assumption that your memory references are uncached,
> you only need to stop gcc reordering the object code,
> Rather than actually adding one of the 'fence' instructions.

Also, the usual MMIO functions already include compiler barriers.

> So you should only need: asm volatile(:::"memory")
> NFI which define generates that, the defines in the copy of
> sysdep.h I just looked at always include one of the fences.

This is barrier().  But I think this must be intended to control
ordering of fields that are written elsewhere.

Really, this needs a much more specific comment to explain the intent.
Then reviewers can work out whether it actually achieves the intent!

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

