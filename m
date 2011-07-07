Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab1GGGYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 02:24:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43978 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab1GGGYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 02:24:13 -0400
Date: Wed, 6 Jul 2011 23:24:07 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: djkurtz@chromium.org, rydberg@euromail.se, rubini@cvml.unipv.it,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        derek.foreman@collabora.co.uk, daniel.stone@collabora.co.uk,
        olofj@chromium.org
Subject: Re: [PATCH 05/12] Input: synaptics - process button bits in AGM
 packets
Message-ID: <20110707062407.GD7658@core.coreip.homeip.net>
References: <1309324042-22943-1-git-send-email-djkurtz@chromium.org>
 <1309324042-22943-6-git-send-email-djkurtz@chromium.org>
 <4E134E27.3000108@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E134E27.3000108@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 10:47:19AM -0700, Chase Douglas wrote:
> On 06/28/2011 10:07 PM, djkurtz@chromium.org wrote:
> > From: Daniel Kurtz <djkurtz@chromium.org>
> > 
> > AGM packets contain valid button bits, too.
> > This patch refactors packet processing to parse button bits in AGM packets.
> > However, they aren't actually used or reported.
> > 
> > The point is to more completely process AGM packets,
> > and prepare for future patches that may actually use AGM packet button bits.
> > 
> > Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> 
> I can't see anything wrong with this :).
> 
> Acked-by: Chase Douglas <chase.douglas@canonical.com>
> 

Applied with minor edits.

> > ---
> >  drivers/input/mouse/synaptics.c |   35 ++++++++++++++++++-----------------
> >  1 files changed, 18 insertions(+), 17 deletions(-)
> > 
> > diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
> > index 1ce47b7..74b1222 100644
> > --- a/drivers/input/mouse/synaptics.c
> > +++ b/drivers/input/mouse/synaptics.c
> > @@ -408,27 +408,10 @@ static int synaptics_parse_hw_state(const unsigned char buf[],
> >  	memset(hw, 0, sizeof(struct synaptics_hw_state));
> >  
> >  	if (SYN_MODEL_NEWABS(priv->model_id)) {
> > -		hw->x = (((buf[3] & 0x10) << 8) |
> > -			 ((buf[1] & 0x0f) << 8) |
> > -			 buf[4]);
> > -		hw->y = INVERT_Y((((buf[3] & 0x20) << 7) |
> > -			 ((buf[1] & 0xf0) << 4) |
> > -			 buf[5]));
> > -
> > -		hw->z = buf[2];
> >  		hw->w = (((buf[0] & 0x30) >> 2) |
> >  			 ((buf[0] & 0x04) >> 1) |
> >  			 ((buf[3] & 0x04) >> 2));
> >  
> > -		if (SYN_CAP_ADV_GESTURE(priv->ext_cap_0c) && hw->w == 2) {
> > -			/* Gesture packet: (x, y, z) at half resolution */
> > -			priv->mt.x = (((buf[4] & 0x0f) << 8) | buf[1]) << 1;
> > -			priv->mt.y = INVERT_Y((((buf[4] & 0xf0) << 4)
> > -					      | buf[2]) << 1);
> > -			priv->mt.z = ((buf[3] & 0x30) | (buf[5] & 0x0f)) << 1;
> > -			return 1;
> > -		}
> > -
> >  		hw->left  = (buf[0] & 0x01) ? 1 : 0;
> >  		hw->right = (buf[0] & 0x02) ? 1 : 0;
> >  
> > @@ -451,6 +434,24 @@ static int synaptics_parse_hw_state(const unsigned char buf[],
> >  			hw->down = ((buf[0] ^ buf[3]) & 0x02) ? 1 : 0;
> >  		}
> >  
> > +		if (SYN_CAP_ADV_GESTURE(priv->ext_cap_0c) && hw->w == 2) {
> > +			/* Gesture packet: (x, y, z) at half resolution */
> > +			priv->mt.x = (((buf[4] & 0x0f) << 8) | buf[1]) << 1;
> > +			priv->mt.y = INVERT_Y((((buf[4] & 0xf0) << 4)
> > +					      | buf[2]) << 1);
> > +			priv->mt.z = ((buf[3] & 0x30) | (buf[5] & 0x0f)) << 1;
> > +			return 1;
> > +		} else {
> > +			hw->x = (((buf[3] & 0x10) << 8) |
> > +				 ((buf[1] & 0x0f) << 8) |
> > +				 buf[4]);
> > +			hw->y = INVERT_Y((((buf[3] & 0x20) << 7) |
> > +					 ((buf[1] & 0xf0) << 4) |
> > +					 buf[5]));
> > +
> > +			hw->z = buf[2];
> > +		}
> > +
> >  		if (SYN_CAP_MULTI_BUTTON_NO(priv->ext_cap) &&
> >  		    ((buf[0] ^ buf[3]) & 0x02)) {
> >  			switch (SYN_CAP_MULTI_BUTTON_NO(priv->ext_cap) & ~0x01) {
> 

-- 
Dmitry
