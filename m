Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab2AYVu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 16:50:57 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:35316 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab2AYVuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 16:50:55 -0500
Date: Wed, 25 Jan 2012 22:50:55 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Keith Packard <keithp@keithp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Lubos Kolouch <lubos.kolouch@gmail.com>
Subject: Re: [Intel-gfx] [PATCH 1/2] drm/i915: Force explicit bpp selection
 for intel_dp_link_required
Message-ID: <20120125215054.GI3896@phenom.ffwll.local>
Mail-Followup-To: Keith Packard <keithp@keithp.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Lubos Kolouch <lubos.kolouch@gmail.com>
References: <1327508186-26704-1-git-send-email-keithp@keithp.com>
 <1327508186-26704-2-git-send-email-keithp@keithp.com>
 <20120125125116.5cea2c4b@jbarnes-desktop>
 <86aa5bcwhs.fsf@sumi.keithp.com>
MIME-Version: 1.0
In-Reply-To: <86aa5bcwhs.fsf@sumi.keithp.com>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 01:17:51PM -0800, Keith Packard wrote:
> On Wed, 25 Jan 2012 12:51:16 -0800, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> 
> > Yeah, looks like I got this wrong when I added the pipe bpp field.
> > Wonder if there's a good way to catch this sort of bug with an assert
> > so we don't get the order mixed up again...
> 
> Ideally, we'd figure out a way to compute this only once. I think the
> only relevant piece of data here is what bpc the pipe should run at, and
> that can be computed at any time during the mode set. We'd then be able
> to compare the pipe bpc with the frame buffer bpp to decide when to
> dither in the crtc mode set code.

I think we could compute this in crtc->mode_fixup (crtc->prepare doesn't
have the mode and adjusted_mode arguments). We could then store the
computed bpc and dithering in one of the private fields. We'd still have
to loop over all encoders, but alas ...

> > The big downside here is that we'll be very pessimistic about the link
> > bw requirements for say 16 or 8bpp modes.
> 
> Right, with this patch, we'll choose link parameters capable of
> supporting 8bpc, even for 16bpp video modes. Note that 8bpp video modes
> need 8bpc links as they have colormaps with 8bpc data in them.

Afaics we'll still correctly fall back to 6bpc (undithered for 16bpp
obviously) and hence things should keep on working.

> > I see you have another patch to address some of this, but I wonder if
> > we have enough info to calculate the bpp at prepare time so it's set
> > early on for use by both the crtc and encoder code?
> 
> fixup gets exactly the same info as mode set, so it should end up with
> exactly the same resulting bpc, which will set the link bandwidth to
> support 6bpc mode if that's all that is needed.
> 
> One problem with the patch is that the pre-PCH mode set path doesn't use
> intel_choose_pipe_bpp_dither, so the condition for 6bpc mode is
> duplicated in i9xx_crtc_mode_set and intel_dp_mode_fixup.
> 
> If crtc->fixup was called before encoder->fixup, we could have computed
> bpp in the crtc->fixup function and then used it in encoder->fixup.
> 
> Alternatively, crtc->fixup could call into the DP code to set the
> link_bw, lane_count and adjusted_mode->clock values after it sets the
> bpp, but that seems to break the abstraction even more.

Yeah, there are a few rough corners with the bpc computation in patch 2.
I'll try to throw around a few ideas that crossed my mind while reading
through it in a reply there.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
