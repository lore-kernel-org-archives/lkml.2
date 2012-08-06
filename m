Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab2HFUQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 16:16:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52658 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161Ab2HFUQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 16:16:56 -0400
Date: Mon, 6 Aug 2012 15:16:48 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        linux-kernel@vger.kernel.org, Andreas Heider <andreas@meetr.de>
Subject: Re: [RFC PATCH 3/5] drm/i915: register LVDS connector even if we
 can't get a panel mode
Message-ID: <20120806201648.GD28213@thinkpad-t410>
Mail-Followup-To: Matthew Garrett <mjg59@srcf.ucam.org>,
	dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
	linux-kernel@vger.kernel.org, Andreas Heider <andreas@meetr.de>
References: <1344009741-14248-1-git-send-email-seth.forshee@canonical.com>
 <1344009741-14248-4-git-send-email-seth.forshee@canonical.com>
 <20120803161416.GA22563@srcf.ucam.org>
 <20120803162451.GF8165@thinkpad-t410>
 <20120803162702.GA22896@srcf.ucam.org>
 <20120804165727.GA4980@thinkpad-t410>
 <20120805211412.GG12232@phenom.ffwll.local>
 <20120805211838.GA27188@srcf.ucam.org>
 <20120805214016.GH12232@phenom.ffwll.local>
 <20120806122317.GA11339@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120806122317.GA11339@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 01:23:17PM +0100, Matthew Garrett wrote:
> On Sun, Aug 05, 2012 at 11:40:16PM +0200, Daniel Vetter wrote:
> 
> > As long as it's only apple shipping multi-gpu machines with
> > broken/non-existing vbt, I'll happily stomach the quirk list entries.
> > They're bad, but imo the lesser evil.
> 
> Doing this via quirks means that we'll always be broken on the hardware 
> at the point where it ships. Implementing the functionality means we 
> stand some chance of working out of the box.

I've been thinking some today about how this functionality might be
implemented.

It looks like the simplest way to let the inactive GPU have the i2c bus
temporarily is to have drm_get_edid() control the mux and serialize it
with a mutex. It should be pretty easy to make vga_switcheroo support
muxing the DDC separately from the display.

There is the problem of vga_switcheroo not really being operational
until it has two clients and a handler, and the graphics drivers not
registering clients until they've initialized LVDS. This probably won't
be too dificult to solve.

The bigger problem is still making sure the switcheroo handler is
registered, when it's needed, before trying to read the EDID. We could
potentially delay initializing non-active graphics devices until after a
switcheroo handler has been registered, but that's a problem if the
handler is implemented by the driver for the secondary GPU (is this ever
the case?). Otherwise we seem to be stuck with making i915 able to cope
with getting modes for LVDS after initialization, which kind of puts us
back where we started.

Any other ideas?

