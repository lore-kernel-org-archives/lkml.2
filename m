Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab1FDQ6r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 12:58:47 -0400
Received: from imr3.ericy.com ([198.24.6.13]:58782 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760Ab1FDQ6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 12:58:46 -0400
Date: Sat, 4 Jun 2011 09:57:57 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: "Stijn Devriendt (sdevrien)" <sdevrien@cisco.com>
CC: anish singh <anish198519851985@gmail.com>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add support for the Philips SA56004 temperature sensor.
Message-ID: <20110604165757.GA19677@ericsson.com>
References: <1307183831-19627-2-git-send-email-sdevrien@cisco.com>
 <BANLkTimKB8PtFF72rOeDAmkbM_oq=ZMRgg@mail.gmail.com>
 <6E4D2678AC543844917CA081C9D6B33F049B1DE3@XMB-AMS-103.cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6E4D2678AC543844917CA081C9D6B33F049B1DE3@XMB-AMS-103.cisco.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 04, 2011 at 12:32:01PM -0400, Stijn Devriendt (sdevrien) wrote:
> > From: anish singh [mailto:anish198519851985@gmail.com] 
> >
> > I am no expert on HWMON but just want to 
> > add some points.
> > @@ -454,7 +477,7 @@ static struct lm90_data *lm90_update_device(struct device *dev)
> >
> >               if (data->flags & LM90_HAVE_LOCAL_EXT) {
> >                       lm90_read16(client, LM90_REG_R_LOCAL_TEMP,
> > -                                   MAX6657_REG_R_LOCAL_TEMPL,
> > +                                   data->reg_local_ext,
> >                                   &data->temp11[4]);
> > I don't think this variable reg_local_ext should exist as 
> > register address should be "# defined" and should not be
> > part of lm90_data but i do see a case here where we are
> > assuming MAX6657 is only having this LM90_HAVE_LOCAL_EXT
> > flag set.So i think we should have some more branching here
> > to detect the device and pass the corresponding register but as
> > i said i am no expert.
> > 
> 
> Only MAX6657 and SA56004 have the local temperature extension
> register and unfortunately they reside at different offsets.
> Therefore the probing will detect the right chip and, if supported,
> use the correct register.
> 
> >               } else {
> >                       if (lm90_read_reg(client, LM90_REG_R_LOCAL_TEMP,
> > @@ -1372,6 +1400,11 @@ static int lm90_probe(struct i2c_client *new_client,
> >       /* Set maximum conversion rate */
> >       data->max_convrate = lm90_params[data->kind].max_convrate;
> >
> > +       if (data->flags & LM90_HAVE_LOCAL_EXT) {
> > +               data->reg_local_ext = lm90_params[data->kind].reg_local_ext;
> > +               BUG_ON(data->reg_local_ext == 0);
> > +       }
> > +
> > I think this BUG_ON is too harsh in probe.We generally use pr_err
> > to print if something which is supposed to be set is not set.As BUG_ON
> > will call kernel panic,right?
> 
> The reason for adding the BUG_ON rather than the error was that it is
> in fact a coding error when the flag is set without specifying the offset.
> Such a condition should never make it into a running system and should be
> caught during coding or review.
> BUG_ON only does an oops, panic is optional depending on panic_on_oops being
> set.
> 
Maybe use WARN_ON instead ?

Thanks,
Guenter
