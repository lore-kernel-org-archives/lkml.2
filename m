Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab2BURjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 12:39:18 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2699 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669Ab2BURjQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 12:39:16 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 21 Feb 2012 09:38:51 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Dong Aisheng <dongas86@gmail.com>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        "B29396@freescale.com" <B29396@freescale.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 21 Feb 2012 09:38:47 -0800
Subject: RE: [PATCH 08/20] pinctrl: Assume map table entries can't have a
 NULL name field
Thread-Topic: [PATCH 08/20] pinctrl: Assume map table entries can't have a
 NULL name field
Thread-Index: AczwmeLBBOFQjBD9ToGifxzgPpltcgAJMYCg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17BD8BC31C@HQMAIL01.nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
	<1329720360-23227-9-git-send-email-swarren@nvidia.com>
 <CAA+hA=THDSqCU-TBjEN=Rc5DkuVxu9kwvtv5w4G7dc3vDrasYg@mail.gmail.com>
In-Reply-To: <CAA+hA=THDSqCU-TBjEN=Rc5DkuVxu9kwvtv5w4G7dc3vDrasYg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dong Aisheng wrote at Tuesday, February 21, 2012 6:08 AM:
> On Mon, Feb 20, 2012 at 2:45 PM, Stephen Warren <swarren@nvidia.com> wrote:
> > pinctrl_register_mappings() already requires that every mapping table
> > entry have a non-NULL name field.
> >
> > Logically, this makes sense too; drivers should always request a specific
> > named state so they know what they're getting. Relying on getting the
>
> Hmm? It makes me a little confused.
> IIRC we allow the driver to request NULL map name in the linaro
> connect discussion.
> For those devices they do not want to support multi states, they
> really don't want to care about the state name.
> The original way is convenient for such a case.

With device tree, every state is always going to have /some/ name; the
binding we discussed didn't include any way to specify "no name" or
"default name" or "default state", so this will keeps things a little
more consistent.

I possibly could be persuaded to allow NULL state names in the mapping
table. However, if so, I think they should work a little differently to
the code currently in pinctrl: Right now, a NULL parameter to pinmux_get()
allows matching against /any/ state name in the table. If we changed this
to only allow matching against mapping table with a NULL name, that might
be OK, since it'd be very explicit what it matched. But, as I mentione
above, migrating such a driver to device tree would require changing this
so I'm not inclined to like that solution without strong requirements.

In other words, what we have right now is something like:

if name:
    match = !strcmp(name, map->name)
else:
    match = true

If we continue to allow NULL names, I think we should change that to:

if name:
    match = map->name && !strcmp(name, map->name)
else:
    match = !map->name

> > diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
> > index b6e3c35..5e30d91 100644
> > --- a/drivers/pinctrl/core.c
> > +++ b/drivers/pinctrl/core.c
> > @@ -488,8 +488,8 @@ static struct pinctrl *pinctrl_get_locked(struct device *dev, const char *name)
> >        int i;
> >        struct pinctrl_map const *map;
> >
> > -       /* We must have dev or ID or both */
> > -       if (!dev && !name)
> > +       /* We must have a state name */
> > +       if (WARN_ON(!name))
> >                return ERR_PTR(-EINVAL);
>
> We're already using the pinctrl device name for hog map.
> So should it be something like:
> 	if (WARN_ON(!dev) || WARN_ON(!name))

That's only true starting with the next patch in this series, which does
modify the code roughly as you described.

-- 
nvpublic

