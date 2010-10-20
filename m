Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab0JTPv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 11:51:28 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53403 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744Ab0JTPv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 11:51:26 -0400
Date: Wed, 20 Oct 2010 09:51:17 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
        Ryan Mallon <ryan@bluewatersys.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        akpm@linux-foundation.org, Greg KH <greg@kroah.com>,
        Tony Lindgren <tony@atomide.com>, Benoit Cousson <b-cousson@ti.com>,
        Hari Kanigeri <h-kanigeri2@ti.com>, Suman Anna <s-anna@ti.com>
Subject: Re: [PATCH 3/3] omap: add hwspinlock device
Message-ID: <20101020155117.GE7285@angua.secretlab.ca>
References: <1287387875-14168-1-git-send-email-ohad@wizery.com>
 <1287387875-14168-4-git-send-email-ohad@wizery.com>
 <87r5fmxghm.fsf@deeprootsystems.com>
 <AANLkTinZ2+ocJCfUpT15Ow3J9XBa-8XWnVC3gDDJ7s-v@mail.gmail.com>
 <AANLkTimTDCbLP+EeUeo35re0FrMvqV3ozU+v7DZXr_p3@mail.gmail.com>
 <AANLkTikE_WtBJQOJDNFGcW_4fW+FPvTBCHfrKsaUgZZY@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikE_WtBJQOJDNFGcW_4fW+FPvTBCHfrKsaUgZZY@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 04:09:22PM +0200, Ohad Ben-Cohen wrote:
> On Wed, Oct 20, 2010 at 1:12 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> > On Tue, Oct 19, 2010 at 3:02 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> ...
> >> i2c-omap, which is subsys_initcall (the I2C bus is shared between the
> >> A9 and the M3 on some OMAP4 boards).
> ...
> > Man. this is getting ugly.  I think we need to discuss how to solve
> > this at the Plumbers micro-conference. It kind of fits in with the
> > whole embedded (ab)use of the device model topic anyway. Actually,
> > this particular case isn't bad, but the moving of i2c and spi busses
> > to an earlier initcall is just band-aiding the real problem of driver
> > probe order dependencies.
> 
> +1

:-)

> 
> On Wed, Oct 20, 2010 at 1:53 AM, Kevin Hilman
> <khilman@deeprootsystems.com> wrote:
> > Rather than moving towards having more drivers have to be built in (and
> > depend on their probe order) we need to be moving towards building all
> > these drivers as modules, including omap-i2c.
> 
> +1

-1. Like Ryan points out below, the problem isn't modules vs.
built-in, it is drivers depending on implicit init order which sort of
works, but is fragile and will break in subtle ways. It needs to work
in both cases, and the only solution to fix the dependency issue.

I completely agree that more drivers need to support modules, but
that is an orthogonal issue.

I suspect that in most cases the driver model already provides the
needed functionality via the parent->child relationships, and a lot of
the problems can be removed by getting the driver of the parent device
to register the children.

It gets more complex (like in this case) when a single device needs
multiple devices to be initialized before it is probed. I can think of
a couple of ways to solve this. One option is for such drivers to
explicitly look for its dependant devices and defer .probe() work
until they appear. I hacked up some code for this a while back, but I
never pursued it through to completion[1].

Another option is to defer even registering the dependent devices
until the prerequisites are all probed.  This could potentially be
done in board support code by using a bus notifier to look for the
critical device.

[1]http://forum.soft32.com/linux/RFC-drivers-base-Add-bus_register_notifier_alldev-variant-ftopict478522.html

> 
> This whole thing is a mess, and today it's being solved in the wrong,
> non-scalable and error-prone way.
> 
> The question is whether we want to gate hwspinlock until this issue is solved ?

No, don't gate hwspinlock.  I don't see any reason to defer it for
this issue.

> On Wed, Oct 20, 2010 at 3:20 AM, Ryan Mallon <ryan@bluewatersys.com> wrote:
> > The issue of probe order still needs to be resolved for those of us who
> > do want all the drivers built into the kernel.

+1

> 
> What about doing something similar to the way suspend/resume and the
> device hierarchy interact ?
> 
> device_resume waits for its parent to be resumed before waking up the
> device - this sounds similar to what ->probe() should do: wait for its
> device dependency to probe first (so in this case, i2c-omap should
> wait for hwspinlock).
> 
> Conversely, device_suspend waits for all its children to be suspended
> before continuing, which sounds just like what ->remove() should do
> (so again, in this case, the hwspinlock device should wait for all its
> users to be removed before bailing).

This works for the simple hierarchy case, but it doesn't help the
multi-dependency case.

g.
