Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751093Ab2IHFH7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 01:07:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52433 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab2IHFH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 01:07:58 -0400
Date: Sat, 8 Sep 2012 00:07:52 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Dave Airlie <airlied@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        David Airlie <airlied@linux.ie>, Matthew Garrett <mjg@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Andreas Heider <andreas@meetr.de>
Subject: Re: [PATCH 0/7] Fixes for hybrid graphics Apple machines
Message-ID: <20120908050752.GA12477@ubuntu-mba51>
Mail-Followup-To: Dave Airlie <airlied@gmail.com>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	David Airlie <airlied@linux.ie>, Matthew Garrett <mjg@redhat.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Andreas Heider <andreas@meetr.de>
References: <1347031330-19657-1-git-send-email-seth.forshee@canonical.com>
 <CAPM=9tyHodSp0BCdU4Bz=95JXhiiswYRTAre6LyQjiV023UXCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM=9tyHodSp0BCdU4Bz=95JXhiiswYRTAre6LyQjiV023UXCw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 10:35:04PM +0100, Dave Airlie wrote:
> On Fri, Sep 7, 2012 at 4:22 PM, Seth Forshee <seth.forshee@canonical.com> wrote:
> > Many hybrid graphics Apple laptops fail to set up LVDS on the secondary
> > GPU due to missing or incorrect mode information for the panel at init
> > time. The only way to get the LVDS mode on these machines is via the
> > DDC, but this is muxed to the active GPU at boot. However, the graphics
> > mux on these machines supports muxing the i2c idependently of the
> > display, making it possible for the secondary graphics driver to read
> > the EDID without a full display switch.
> >
> > In order to support this, these patches modify vga_switcheroo to allow
> > muxing of the DDC idependently of the display. apple-gmux is updated to
> > support this new functionality, and drm_get_edid() is modified to switch
> > the DDC mux as needed.
> >
> > For this to work we also need to ensure that sufficient switcheroo
> > suport is available before initializing the secondary GPU. This is done
> > by adding any non-active GPUs that try to initialize before switcheroo
> > is ready to a list and initializing these devices once switcheroo
> > becomes ready. This behavior is restricted to Apple laptops to prevent
> > causing problems on other machines.
> 
> I hate this idea, no delaying stuff. We either need to have some sort
> of enforced ordering or make some stuff only work built-in.
> 
> But sticking things on a delayed list just in case seems wrong to me.

I really don't like it either. My preferred solution would be to have
i915 register the LVDS connector whenever we can reasonably expect that
an LVDS panel might be present, then treat the panel as disconnected
until we can get the mode information. I was headed down this path with
the first patches I sent, but both Daniel and Matthew responded
unfavorably to this approach.

Otherwise I'm open to suggestions on how enforcing the ordering of the
device initializations. Forcing apple-gmux to be built-in or making i915
depend on it might solve the problem, but I don't find either of these
to be very desirable either.

Thanks,
Seth

