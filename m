Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab2HFEwF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 00:52:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48843 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab2HFEwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 00:52:00 -0400
Date: Sun, 5 Aug 2012 23:51:50 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Dave Airlie <airlied@gmail.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        linux-kernel@vger.kernel.org, Andreas Heider <andreas@meetr.de>
Subject: Re: [RFC PATCH 3/5] drm/i915: register LVDS connector even if we
 can't get a panel mode
Message-ID: <20120806045150.GA23652@thinkpad-t410>
Mail-Followup-To: Alex Deucher <alexdeucher@gmail.com>,
	Dave Airlie <airlied@gmail.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
	linux-kernel@vger.kernel.org, Andreas Heider <andreas@meetr.de>
References: <1344009741-14248-4-git-send-email-seth.forshee@canonical.com>
 <20120803161416.GA22563@srcf.ucam.org>
 <20120803162451.GF8165@thinkpad-t410>
 <20120803162702.GA22896@srcf.ucam.org>
 <20120804165727.GA4980@thinkpad-t410>
 <20120805211412.GG12232@phenom.ffwll.local>
 <20120805211838.GA27188@srcf.ucam.org>
 <20120805214016.GH12232@phenom.ffwll.local>
 <CAPM=9twHbwzPxFbpeXOP2eANVQssVaOHuztG9FDM4CgcQs-9tA@mail.gmail.com>
 <CADnq5_ORRL++gB_Xh9a3vTMf8PeQ92npAcA0P5QdxAhpVM8Wig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADnq5_ORRL++gB_Xh9a3vTMf8PeQ92npAcA0P5QdxAhpVM8Wig@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 05, 2012 at 07:20:31PM -0400, Alex Deucher wrote:
> On Sun, Aug 5, 2012 at 5:44 PM, Dave Airlie <airlied@gmail.com> wrote:
> > On Mon, Aug 6, 2012 at 7:40 AM, Daniel Vetter <daniel@ffwll.ch> wrote:
> >> On Sun, Aug 05, 2012 at 10:18:38PM +0100, Matthew Garrett wrote:
> >>> On Sun, Aug 05, 2012 at 11:14:12PM +0200, Daniel Vetter wrote:
> >>>
> >>> > I like this approach more - the only other solution I see is to ask the
> >>> > currently active driver (i.e. radeon) at bootime for the right mode. Which
> >>> > sounds much more hellish and fragile ...
> >>>
> >>> The "correct" approach is clearly to just have the drm core change the
> >>> i2c mux before requesting edid, but that's made difficult because of the
> >>> absence of ordering guarantees in initialisation. I don't like quirking
> >>> this, since we're then back to the situation of potentially having to
> >>> add every new piece of related hardware to the quirk list.
> >>
> >> The "correct" approach of switching the mux before we fetch the edid is
> >> actualy the one I fear will result in fragile code: Only run on few
> >> machines, and as you say with tons of funky interactions with the init
> >> sequence ordering. And I guess people will bitch&moan about the flickering
> >> this will cause ;-)
> >>
> >> As long as it's only apple shipping multi-gpu machines with
> >> broken/non-existing vbt, I'll happily stomach the quirk list entries.
> >> They're bad, but imo the lesser evil.
> >
> > Well in theory you can switch the ddc lines without switching the other lines,
> > so we could do a mutex protected mux switch around edid retrival,
> >
> 
> Depends on the system.  On non-Macs, some systems have a single mux,
> others have a separate mux for i2c and display as specified in the
> ATPX ACPI methods.  Not sure how the Macs do it.  I've started
> cleaning up the PX radeon code along with a bunch of other radeon
> ralated ACPI fixes:
> http://cgit.freedesktop.org/~agd5f/linux/log/?h=acpi_patches

The Macs mux the i2c and display separately. However they don't support
the vendor ACPI interfaces for the mux. The driver that provides the
vga_switcheroo handler is separate from the graphics drivers, and the
same whether the discrete graphics are Radeon or nVidia.

Really to support this in any generic sort of way vga_switcheroo needs
to support muxing the DDC separately from the display, but as Matthew
pointed out the ordering of initialization could be a problem. Even if
we protect the DDC with a mutex how can we guarantee that the switcheroo
handler is registered to switch the DDC before i915 is ready to check
for an EDID?

