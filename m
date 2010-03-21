Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab0CUQMP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 12:12:15 -0400
Received: from legolas.restena.lu ([158.64.1.34]:57045 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab0CUQMN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 12:12:13 -0400
Date: Sun, 21 Mar 2010 17:11:28 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-fbdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>, Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH v2 2/6] hid: add framebuffer support to PicoLCD device
Message-ID: <20100321171128.324a606f@neptune.home>
In-Reply-To: <45a44e481003210024l2c66938fp9436d34f6473f811@mail.gmail.com>
References: <20100320170014.440959a8@neptune.home>
 <20100320170415.6ee219c8@neptune.home>
 <45a44e481003210024l2c66938fp9436d34f6473f811@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 March 2010 Jaya Kumar <jayakumar.lkml@gmail.com> wrote:
> > Add framebuffer support to PicoLCD device with use of deferred-io.
> >
> > Only changed areas of framebuffer get sent to device in order to
> > save USB bandwidth and especially resources on PicoLCD device or
> > allow higher refresh rate for a small area.
> 
> Interesting work. One minor comment, defio doesn't currently guarantee
> that it is "changed areas". Just that it is "written" pages which
> typically equates to "changed" but does not guarantee this.

When copying from framebuffer to shadow buffer I check if any given tile
has changed and only send that tile to the device if it has effectively
changed. So this check is done independently of defio.
(though I have to force-fully transfer the whole framebuffer at probe
or after reset - which is missing)

> > Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
> > ---
> >  drivers/hid/Kconfig       |    7 +-
> >  drivers/hid/hid-picolcd.c |  454 +++++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 460 insertions(+), 1 deletions(-)
> 
> It is customary for framebuffer drivers to live in drivers/video. This
> is the first one I've reviewed that is outside of it. Is there a good
> reason for this one to be outside of it? If so, could you put it in
> the comments.

I've kept all the pieces of PicoLCD driver together under hid,
as it's a HID based device. Framebuffer is just one of its features and
keeping pieces together makes it easier to handle.

> > diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> > index 7097f0a..a474bcd 100644
> > --- a/drivers/hid/Kconfig
> > +++ b/drivers/hid/Kconfig
> > @@ -230,6 +230,11 @@ config HID_PETALYNX
> >  config HID_PICOLCD
> >        tristate "PicoLCD (graphic version)"
> >        depends on USB_HID
> > +       select FB_DEFERRED_IO if FB
> > +       select FB_SYS_FILLRECT if FB
> > +       select FB_SYS_COPYAREA if FB
> > +       select FB_SYS_IMAGEBLIT if FB
> > +       select FB_SYS_FOPS if FB
> 
> I think all of that "if FB" stuff looks odd, it would disappear if it
> were in the right Kconfig.

In the initial patch I did select FB as well though for v2 I decided
to make all the dependencies of non-input features optional. For the FB
case the various helper entries are needed, for the rest it's sufficient
to have #ifdef's for their device class.

Another option would be to distribute the Kconfig entries over the
various device class's Kconfig files though I don't think that would
make things easier to understand...

> > +/* Framebuffer visual structures */
> > +static const struct fb_fix_screeninfo picolcdfb_fix = {
> > +       .id          = PICOLCDFB_NAME,
> > +       .type        = FB_TYPE_PACKED_PIXELS,
> > +       .visual      = FB_VISUAL_MONO01,
> 
> Interesting choice. Out of curiosity, which fb client application are
> you testing/using this with?

For now I've just been testing with manual read/write to /dev/fb. I've
not yet played with fb applications.


I've had a look at fb applications, seems that none wants to play with
individual bits, they all bail out requesting 8 or more bpp (some
fail politely, others just exit/segfault and don't undo changes they did)

So I guess I will have to add support for translating 8bpp to device's
1bpp to be able to use any existing fb application and switching between
1bpp and 8bpp framebuffer...

> > +       /*
> > +        * Translate the XBM format screen_base into the format needed by the
> > +        * PicoLCD. See display layout above.
> > +        * Do this one tile after the other and push those tiles that changed.
> > +        */
> 
> I think screen_base is in standard fb format, which you've specified
> as MONO01 above. When you say, XBM format, in the above comment is it
> exactly the same?

It should be the same (from what I read MONO01 versus MONO10 is just
whether 0 or 1 is "black" or "white") and in combination with
PACKED_PIXELS it makes 8 pixels per bytes.

Thanks for the review,
Bruno
