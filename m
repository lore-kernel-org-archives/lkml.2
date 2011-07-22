Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278Ab1GVVWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 17:22:19 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:57989 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932240Ab1GVVWS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 17:22:18 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH] [resend] usbvision: disable scaling for Nogatech MicroCam
Date: Fri, 22 Jul 2011 23:22:02 +0200
User-Agent: KMail/1.9.10
Cc: Joerg Heckenbach <joerg@heckenbach-aw.de>,
        Dwaine Garden <dwainegarden@rogers.com>, linux-media@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
References: <201107222200.55834.linux@rainbow-software.org> <CAGoCfiwqzs70A26WgN2pJJvz2aDzY9siOcTuOCkYm3nDHB=J1Q@mail.gmail.com>
In-Reply-To: <CAGoCfiwqzs70A26WgN2pJJvz2aDzY9siOcTuOCkYm3nDHB=J1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201107222322.07843.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 July 2011 22:06:59 Devin Heitmueller wrote:
> On Fri, Jul 22, 2011 at 4:00 PM, Ondrej Zary <linux@rainbow-software.org> wrote:
> > Scaling causes bad artifacts (horizontal lines) with compression at least
> > with Nogatech MicroCam so disable it (for this HW).
> >
> > This also fixes messed up image with some programs (Cheese with 160x120,
> > Adobe Flash). HW seems to support only image widths that are multiple of 64
> > but the driver does not account that in vidioc_try_fmt_vid_cap(). Cheese
> > calls try_fmt with 160x120, succeeds and then assumes that it really gets
> > data in that resolution - but it gets 128x120 instead. Don't know if this
> > affects other usbvision devices, it would be great if someone could test it.
> >
> > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> >
> > diff -urp linux-2.6.39-rc2-/drivers/media/video/usbvision//usbvision-video.c linux-2.6.39-rc2/drivers/media/video/usbvision/usbvision-video.c
> > --- linux-2.6.39-rc2-/drivers/media/video/usbvision//usbvision-video.c  2011-07-16 16:42:35.000000000 +0200
> > +++ linux-2.6.39-rc2/drivers/media/video/usbvision/usbvision-video.c    2011-07-16 16:36:43.000000000 +0200
> > @@ -924,6 +924,11 @@ static int vidioc_try_fmt_vid_cap(struct
> >        RESTRICT_TO_RANGE(vf->fmt.pix.width, MIN_FRAME_WIDTH, MAX_FRAME_WIDTH);
> >        RESTRICT_TO_RANGE(vf->fmt.pix.height, MIN_FRAME_HEIGHT, MAX_FRAME_HEIGHT);
> >
> > +       if (usbvision_device_data[usbvision->dev_model].codec == CODEC_WEBCAM) {
> > +               vf->fmt.pix.width = MAX_FRAME_WIDTH;
> > +               vf->fmt.pix.height = MAX_FRAME_HEIGHT;
> > +       }
> > +
> >        vf->fmt.pix.bytesperline = vf->fmt.pix.width*
> >                usbvision->palette.bytes_per_pixel;
> >        vf->fmt.pix.sizeimage = vf->fmt.pix.bytesperline*vf->fmt.pix.height;
> > @@ -952,6 +957,11 @@ static int vidioc_s_fmt_vid_cap(struct f
> >
> >        usbvision->cur_frame = NULL;
> >
> > +       if (usbvision_device_data[usbvision->dev_model].codec == CODEC_WEBCAM) {
> > +               vf->fmt.pix.width = MAX_FRAME_WIDTH;
> > +               vf->fmt.pix.height = MAX_FRAME_HEIGHT;
> > +       }
> > +
> >        /* by now we are committed to the new data... */
> >        usbvision_set_output(usbvision, vf->fmt.pix.width, vf->fmt.pix.height);
> >
> >
> > --
> > Ondrej Zary
> 
> Hello Ondrej,
> 
> Drivers are permitted to return a different resolution than what the
> application provided in the S_FMT call.  It is the responsibility of
> the application to look at the struct after the ioctl() call and if
> the values are not what it expects to then accommodate the change.
> 
> In other words, this sounds like a bug in Cheese.

Seems that this bug is widespread - the same problem appears also in guvcview
and adobe flash. I think that the driver is broken too - it should return
corrected resolution in TRY_FMT.

> Devin
> 



-- 
Ondrej Zary
