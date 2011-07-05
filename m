Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423Ab1GEWuz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 18:50:55 -0400
Received: from smtp-out.google.com ([74.125.121.67]:25685 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab1GEWuy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 18:50:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:from:
	date:x-google-sender-auth:message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=fEf4onh8CPGqO63yu4cCJvYhv+vbwuwEziIFHLyK/GPcLicrjmbNrrQiQR4qPIImC
	bJujqgVOmymz5oI2NljMQ==
MIME-Version: 1.0
In-Reply-To: <4E134D0C.7060500@canonical.com>
References: <1309324042-22943-1-git-send-email-djkurtz@chromium.org>
 <1309324042-22943-3-git-send-email-djkurtz@chromium.org> <4E134D0C.7060500@canonical.com>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Wed, 6 Jul 2011 06:50:30 +0800
X-Google-Sender-Auth: 2t7sFTD-E4T8TJ5yK_zgEAZYZJk
Message-ID: <CAGS+omA0=wperMBA+kXVtJW1HJg=1CuW+HnS5kN_cDCBSphT=A@mail.gmail.com>
Subject: Re: [PATCH 02/12] Input: synaptics - do not invert y if 0
To: Chase Douglas <chase.douglas@canonical.com>
Cc: dmitry.torokhov@gmail.com, rydberg@euromail.se, rubini@cvml.unipv.it,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        derek.foreman@collabora.co.uk, daniel.stone@collabora.co.uk,
        olofj@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 6, 2011 at 1:42 AM, Chase Douglas
<chase.douglas@canonical.com> wrote:
>
> On 06/28/2011 10:07 PM, djkurtz@chromium.org wrote:
> > From: Daniel Kurtz <djkurtz@chromium.org>
> >
> > Synaptics touchpads report increasing y from bottom to top.
> > This is inverted from normal userspace "top of screen is 0" coordinates.
> > Thus, the kernel driver reports inverted y coordinates to userspace.
> >
> > In some cases, however, y = 0 is sent by the touchpad.
> > In these cases, the kernel driver should not invert, and just report 0.
>
> Under what cases is y sent as 0, and why do we want to report it as 0 to
> userspace?

I know of two such cases for the image sensor:
  (1) When all fingers, save the first finger are removed, an AGM
packet with (x=0, y=0, z=0) is sent.
  (2) When all fingers are removed, an SGM packet with (x=0, y=0, z=0) is sent.

After uploading this patch set, I played with the profile sensor
again, and I also saw it sometimes sends y=1 packets.  I don't know
what those are.

This is mostly useful for debugging the kernel driver.
When observing the raw position values, the special 0 (and 1?) cases
are more obvious when not inverted.
I think I am misleading in my commit message.  I don't believe these
are actually ever passed through to userspace.

>
> >
> > This patch also refactors the inversion into a macro, and moves it
> > into packet processing instead of during position reporting.
>
> It's getting really hard to read the bit transformations with a macro.
> I'd prefer an approach that splits the computation. Maybe:
>
> hw->y = bit_manipulations;
> hw->y = INVERT_Y(hw->y);
>
> (could use a temporary variable too)
>
> Or maybe define a static inline function that takes the hw state as an arg:
>
> hw->y = bit_manipulations;
> fix_y(hw);
>
> I'd prefer this implementation if every scenario involved manipulating
> the y value of the hw state struct.

Ok.  This option sounds good to me.  Both the sgm & agm cases
manipulate the same struct.

>
> Also, it would be great if you could add your explanation of why Y is
> inverted as a comment above INVERT_Y (or whatever function/macro it
> eventually becomes).

Ok.  I agree a comment would help.

Thanks for the review!

-Dan

>
> Thanks!
>
> -- Chase
>
> > Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> > ---
> >  drivers/input/mouse/synaptics.c |   16 +++++++++-------
> >  1 files changed, 9 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
> > index e06e045..f6d0c04 100644
> > --- a/drivers/input/mouse/synaptics.c
> > +++ b/drivers/input/mouse/synaptics.c
> > @@ -44,6 +44,8 @@
> >  #define YMIN_NOMINAL 1408
> >  #define YMAX_NOMINAL 4448
> >
> > +#define INVERT_Y(y) (((y) != 0) ? (YMAX_NOMINAL + YMIN_NOMINAL - (y)) : 0)
> > +
> >
> >  /*****************************************************************************
> >   *   Stuff we need even when we do not want native Synaptics support
> > @@ -409,9 +411,9 @@ static int synaptics_parse_hw_state(const unsigned char buf[],
> >               hw->x = (((buf[3] & 0x10) << 8) |
> >                        ((buf[1] & 0x0f) << 8) |
> >                        buf[4]);
> > -             hw->y = (((buf[3] & 0x20) << 7) |
> > +             hw->y = INVERT_Y((((buf[3] & 0x20) << 7) |
> >                        ((buf[1] & 0xf0) << 4) |
> > -                      buf[5]);
> > +                      buf[5]));
> >
> >               hw->z = buf[2];
> >               hw->w = (((buf[0] & 0x30) >> 2) |
> > @@ -421,7 +423,8 @@ static int synaptics_parse_hw_state(const unsigned char buf[],
> >               if (SYN_CAP_ADV_GESTURE(priv->ext_cap_0c) && hw->w == 2) {
> >                       /* Gesture packet: (x, y, z) at half resolution */
> >                       priv->mt.x = (((buf[4] & 0x0f) << 8) | buf[1]) << 1;
> > -                     priv->mt.y = (((buf[4] & 0xf0) << 4) | buf[2]) << 1;
> > +                     priv->mt.y = INVERT_Y((((buf[4] & 0xf0) << 4)
> > +                                           | buf[2]) << 1);
> >                       priv->mt.z = ((buf[3] & 0x30) | (buf[5] & 0x0f)) << 1;
> >                       return 1;
> >               }
> > @@ -473,7 +476,7 @@ static int synaptics_parse_hw_state(const unsigned char buf[],
> >               }
> >       } else {
> >               hw->x = (((buf[1] & 0x1f) << 8) | buf[2]);
> > -             hw->y = (((buf[4] & 0x1f) << 8) | buf[5]);
> > +             hw->y = INVERT_Y(((buf[4] & 0x1f) << 8) | buf[5]);
> >
> >               hw->z = (((buf[0] & 0x30) << 2) | (buf[3] & 0x3F));
> >               hw->w = (((buf[1] & 0x80) >> 4) | ((buf[0] & 0x04) >> 1));
> > @@ -491,8 +494,7 @@ static void set_slot(struct input_dev *dev, int slot, bool active, int x, int y)
> >       input_mt_report_slot_state(dev, MT_TOOL_FINGER, active);
> >       if (active) {
> >               input_report_abs(dev, ABS_MT_POSITION_X, x);
> > -             input_report_abs(dev, ABS_MT_POSITION_Y,
> > -                              YMAX_NOMINAL + YMIN_NOMINAL - y);
> > +             input_report_abs(dev, ABS_MT_POSITION_Y, y);
> >       }
> >  }
> >
> > @@ -584,7 +586,7 @@ static void synaptics_process_packet(struct psmouse *psmouse)
> >
> >       if (num_fingers > 0) {
> >               input_report_abs(dev, ABS_X, hw.x);
> > -             input_report_abs(dev, ABS_Y, YMAX_NOMINAL + YMIN_NOMINAL - hw.y);
> > +             input_report_abs(dev, ABS_Y, hw.y);
> >       }
> >       input_report_abs(dev, ABS_PRESSURE, hw.z);
> >
>
