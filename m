Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab1GDH4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 03:56:07 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44044 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab1GDH4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 03:56:03 -0400
Date: Mon, 4 Jul 2011 09:55:56 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Bill Gatliff <bgat@billgatliff.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        viresh kumar <viresh.kumar@st.com>, Shawn Guo <shawn.guo@linaro.org>,
        Ryan Mallon <ryan@bluewatersys.com>
Subject: Re: [PATCH 1/3] PWM: add pwm framework support
Message-ID: <20110704075556.GD6069@pengutronix.de>
References: <1309430517-23821-2-git-send-email-s.hauer@pengutronix.de>
 <BANLkTikQGFA7XcuAtEEi7_4m-j6-00sZ6Q@mail.gmail.com>
 <201106301441.24493.arnd@arndb.de>
 <BANLkTin_htv2z3D9Bbf6N8Y7UKFRvPtvOg@mail.gmail.com>
 <20110630170229.GP6069@pengutronix.de>
 <4E0D0595.5070205@gmail.com>
 <20110701073755.GR6069@pengutronix.de>
 <4E0D8540.2020200@gmail.com>
 <20110701085414.GV6069@pengutronix.de>
 <4E0E6916.50406@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E0E6916.50406@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 18:58:33 up 10 days, 22:45, 15 users,  load average: 0.17, 0.23,
 0.17
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 02, 2011 at 10:40:54AM +1000, Ryan Mallon wrote:
> On 01/07/11 18:54, Sascha Hauer wrote:
> >> At _any_ point that you change the pwm api you will need to change all
> >> of the drivers. How do you plan to adapt the api in the future to
> >> support the oddball pwm drivers without having to change all of the
> >> drivers in one go?
> > It is a framework between hardware drivers and user drivers and as such
> > it is able to abstract between the API to the hardware drivers and the
> > API to the user drivers. You can change one of those without touching
> > the other.
> 
> You are missing the point. For example, the current in-kernel api to
> configure a pwm is this:
> 
> int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns);
> 
> Bill's proposed change to the api, which is more flexible, looks like this:
> 
> int pwm_config(struct pwm_channel *p,
>         struct pwm_channel_config *c)
> 
> If you want to change the api in this way at any time, you will need to
> change all of the pwm drivers and all of the users (pwm-bl, pwm-leds,
> etc) at the same time, or introduce some sort of wrapper layer to ease
> the conversion. Either way, if you do it now or do it after your patch
> set it is still the same amount of work.
> 
> We do want a better api for pwm drivers, if only to support oddball
> hardware like the atmel. The process I see is this if we go with Bill's
> patches:
>  - Introduce new api with common framework

I'm repeating myself. At this point you can't convert any of the old
drivers because it breaks the support we already have.

>  - Move drivers to new api

And that's one single step. To be really bisectible have would have to
convert *all* PWM drivers in a single patch, not even a patch series
as it would break bisectibility in between.

> 
> With your patches we get this:
>  - Introduce common framework

And still everything works

>  - Move drivers to common framework

One after another, still everything works

>  - Modify api
>  - Rewrite drivers for new api

There are two of them. One for the hardware drivers and one for the
users. You can change them independently, introduce wrappers where
necessary, you have all the time in the world to do this.

Your aim is to change the API? Then you have to clean up first. People
like Thomas have cleaned up in all areas of the kernel to reach their
goal of merging the RT stuff. They wouldn't have got anywhere with
a here's-a-patch-that-changes-everything approach.

> 
> The problem we have seen with these processes in the past is they get
> left half way with some drivers moving to the new framework and some
> trailing behind and some having their own hand-rolled approach because
> the common api doesn't meet their needs.

With two competing APIs it's even worse because you can't go anywhere
without converting everything in tree.

Just imagine Bill or someone else comes up with a series

PATCH: introduce new pwm framework with completely changed API, sysfs
interface and interrupt support, also convert leds-pwm, pwm_bl, pwm-beeper
to new API and convert all hardware drivers to new API aswell.

What do you think would happen? I can think of two things: Either no
reaction at all from others or a huge thread with no result at all
because we can't agree on details. Then someone comes up with the
recommendation to start small and do it in little steps.


I am tired of discussing this. It seems we can't agree and unless
someone else jumps in here we will probably have to wait for another
year until something moves in the PWM area.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
