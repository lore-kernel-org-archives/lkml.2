Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030Ab0LSJhm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 04:37:42 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:50689 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750950Ab0LSJhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 04:37:40 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sun, 19 Dec 2010 10:36:07 +0100
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Chase Douglas <chase.douglas@canonical.com>,
        Chris Bagwell <chris@cnpbagwell.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 1/4] Input: synaptics - add multitouch packet support
Message-ID: <20101219093607.GA6162@polaris.bitmath.org>
References: <1292683981-6908-1-git-send-email-rydberg@euromail.se>
 <1292683981-6908-2-git-send-email-rydberg@euromail.se>
 <20101219081648.GC10074@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101219081648.GC10074@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PUFgX-0003Tu-9v.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PUFgX-0003Tu-9v 9f0887d698c9ea7d0c669b81abc35138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > @@ -279,6 +279,24 @@ static void synaptics_set_rate(struct psmouse *psmouse, unsigned int rate)
> >  	synaptics_mode_cmd(psmouse, priv->mode);
> >  }
> >  
> > +static int synaptics_set_multitouch_mode(struct psmouse *psmouse)
> > +{
> > +	static unsigned char param = 0xc8;
> > +	struct synaptics_data *priv = psmouse->private;
> > +
> > +	if (!SYN_CAP_MULTITOUCH(priv->ext_cap_0c))
> > +		return 0;
> > +
> > +	if (psmouse_sliced_command(psmouse, SYN_QUE_MODEL))
> > +		return -1;
> > +	if (ps2_command(&psmouse->ps2dev, &param, PSMOUSE_CMD_SETRATE))
> > +		return -1;
> > +
> > +	priv->multitouch = 1;
> 
> That should be bool/true. Also, do we need to have this variable at all
> since we seem to abort initialization if multitouch mode fails?

The logic of the all-patches-applied version does depend on the
advanced gesture flag, but sure, instead of this variable, one could
set the SYN_CAP_MULTIFINGER bit, and use SYN_CAP_MULTITOUCH explicitly
in remaining places. And, of course, another round of testing.

> 
> > +	printk(KERN_INFO "Synaptics: Multitouch mode enabled\n");
> 
> I'd rather only reported if we failed to activate multitouch mode on
> devices that ought support it.

Ok.

> > @@ -53,6 +53,7 @@
> >  #define SYN_CAP_PRODUCT_ID(ec)		(((ec) & 0xff0000) >> 16)
> >  #define SYN_CAP_CLICKPAD(ex0c)		((ex0c) & 0x100100)
> >  #define SYN_CAP_MAX_DIMENSIONS(ex0c)	((ex0c) & 0x020000)
> > +#define SYN_CAP_MULTITOUCH(ex0c)	((ex0c) & 0x080000)
> 
> Synaptics calls this bit "Advanced Gesture", I think we should do the
> same as they might produce full-MT devices in the future.
> 
> Also, how useful is this patch without the 4th one? Why aren't they
> folded together?

This first patch implements multi-finger support in the same fashion
as older hardware, thus enabling for instance hw-finger scroll in
synaptics.

Thanks,
Henrik
