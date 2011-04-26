Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983Ab1DZUk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 16:40:57 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:39275 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754071Ab1DZUk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 16:40:56 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Subject: Re: [PATCH] usbvision: remove (broken) image format conversion
Date: Tue, 26 Apr 2011 22:40:35 +0200
User-Agent: KMail/1.9.10
Cc: "Hans de Goede" <hdegoede@redhat.com>,
        "Joerg Heckenbach" <joerg@heckenbach-aw.de>,
        "Dwaine Garden" <dwainegarden@rogers.com>, linux-media@vger.kernel.org,
        "Kernel development list" <linux-kernel@vger.kernel.org>
References: <201104252323.20420.linux@rainbow-software.org> <4DB6B28D.5090607@redhat.com> <f2291b622da20d240c4ebe0ae72beb8c.squirrel@webmail.xs4all.nl>
In-Reply-To: <f2291b622da20d240c4ebe0ae72beb8c.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201104262240.40497.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 April 2011 14:33:20 Hans Verkuil wrote:
> > Hi,
> >
> > On 04/26/2011 10:30 AM, Ondrej Zary wrote:
> >> On Tuesday 26 April 2011, you wrote:
> >>> On Monday, April 25, 2011 23:23:17 Ondrej Zary wrote:
> >>>> The YVU420 and YUV422P formats are broken and cause kernel panic on
> >>>> use.
> >>>> (YVU420 does not work and sometimes causes "unable to handle paging
> >>>> request" panic, YUV422P always causes "NULL pointer dereference").
> >>>>
> >>>> As V4L2 spec says that drivers shouldn't do any in-kernel image format
> >>>> conversion, remove it completely (except YUYV).
> >>>
> >>> What really should happen is that the conversion is moved to
> >>> libv4lconvert.
> >>> I've never had the time to tackle that, but it would improve this
> >>> driver a
> >>> lot.
> >>
> >> Depending on isoc_mode module parameter, the device uses different image
> >> formats: YUV 4:2:2 interleaved, YUV 4:2:0 planar or compressed format.
> >>
> >> Maybe the parameter should go away and these three formats exposed to
> >> userspace?
> >
> > That sounds right,
> >
> >> Hopefully the non-compressed formats could be used directly
> >> without any conversion. But the compressed format (with new
> >> V4L2_PIX_FMT_
> >> assigned?) should be preferred (as it provides much higher frame rates).
> >> The
> >> code moved into libv4lconvert would decompress the format and convert
> >> into
> >> something standard (YUV420?).
> >
> > Correct.
> >
> >>> Would you perhaps be interested in doing that work?
> >>
> >> I can try it. But the hardware isn't mine so my time is limited.
> >
> > If you could give it a shot that would be great. I've some hardware to
> > test this with (although I've never actually tested that hardware), so
> > I can hopefully pick things up if you cannot finish things before you
> > need to return the hardware.
>
> I can also test this.

After digging in the code for hours, I'm giving this up. It's not worth it.

The ISOC_MODE_YUV422 mode works as V4L2_PIX_FMT_YVYU with VLC and 
mplayer+libv4lconvert, reducing the loop (and dropping strech_*) in 
usbvision_parse_lines_422() to:
 scratch_get(usbvision, frame->data + (frame->v4l2_linesize * frame->curline),
 2 * frame->frmwidth);

The ISOC_MODE_YUV420 is some weird custom format with 64-byte lines of YYUV. 
usbvision_parse_lines_420() is real mess with that scratch_* crap everywhere.

ISOC_MODE_COMPRESS: There are callbacks to usbvision_request_intra() and also 
usbvision_adjust_compression(). This is not going to work outside the kernel.


So I can redo the conversion removal patch to keep the RGB formats and also 
provide another one to remove the testpattern (it oopses too). But I'm not 
going to do any major changes in the driver.

-- 
Ondrej Zary
