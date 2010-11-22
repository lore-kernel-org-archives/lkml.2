Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab0KVKUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 05:20:54 -0500
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:65019 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911Ab0KVKUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 05:20:53 -0500
Subject: Re: [PATCH 1/5] Backlight: Add backlight type
From: Richard Purdie <rpurdie@linux.intel.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        nouveau@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-acpi@vger.kernel.org,
        lenb@kernel.org
In-Reply-To: <20101119202558.GA10898@srcf.ucam.org>
References: <1290182036-30484-1-git-send-email-mjg@redhat.com>
	 <20101119120523.15bc341c.akpm@linux-foundation.org>
	 <20101119202558.GA10898@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Nov 2010 10:17:00 +0000
Message-ID: <1290421020.1272.16707.camel@rex>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 20:25 +0000, Matthew Garrett wrote:
> On Fri, Nov 19, 2010 at 12:05:23PM -0800, Andrew Morton wrote:
> > On Fri, 19 Nov 2010 10:53:52 -0500
> > Matthew Garrett <mjg@redhat.com> wrote:
> > 
> > > There may be multiple ways of controlling the backlight on a given machine.
> > > Allow drivers to expose the type of interface they are providing, making
> > > it possible for userspace to make appropriate policy decisions.
> > > 
> > > ...
> > >
> > >  60 files changed, 102 insertions(+), 0 deletions(-)
> > 
> > This patch has a pretty short half-life.
> 
> Well, ideally it would have landed in the backlight tree when I sent it 
> months ago. Then we'd have the opportunity to ensure that everything was 
> fixed up before it went in in the merge window.
> 
> > > @@ -62,6 +68,8 @@ struct backlight_properties {
> > >  	/* FB Blanking active? (values as for power) */
> > >  	/* Due to be removed, please use (state & BL_CORE_FBBLANK) */
> > >  	int fb_blank;
> > > +	/* Backlight type */
> > > +	enum backlight_type type;
> > >  	/* Flags used to signal drivers of state changes */
> > >  	/* Upper 4 bits are reserved for driver internal use */
> > >  	unsigned int state;
> > 
> > And if/when the half-life expires, we'll have drivers in-tree which
> > forget to set backlight_properties.type.  I haven't checked, but if
> > we're lucky they will default to "0".
> 
> Depends entirely on whether they kzalloc the structure or not before
> calling backlight_device_register(). 
> 
> > What will be the runtime effects upon such unconverted drivers? 
> > Ideally we'd like them to continue to work OK, and to emit a runtime
> > warning.  In which case you'll need BACKLIGHT_RAW=1 so the unconverted
> > driver can be detected, warned about and fixed up by the core code.
> 
> The worst case I can think of is that we walk off the array - I guess 
> there's an argument for sanity checking that in backlight_show_type().

I think adding a BACKLIGHT_TYPEUNKNOWN as the first item in the enum,
sanity checking the array bounds and printing a warning if type is not
one of the defined values would be good.

I also want to make sure you think this patch is going to scale with
multiple GPU output machines? Thats the main reason I've held off any
patch like this as it doesn't help solve that problem as far as I can
tell. Yes, we have the device parent information and I see later in the
patch series you ensure the backlight is registered against the
connector which is good. If you have an ACPI "firmware" control that you
say should always be preferred, how do we know which connector device
that corresponds to in the multiple output case? From that point of view
this model falls apart?

What I really want to avoid is a new interface which just papers over
cracks, only to have everything crumble anyway.

Cheers,

Richard



