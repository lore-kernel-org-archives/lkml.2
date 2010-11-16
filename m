Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152Ab0KPTrP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 14:47:15 -0500
Received: from ist.d-labs.de ([213.239.218.44]:48190 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758538Ab0KPTrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 14:47:14 -0500
Date: Tue, 16 Nov 2010 20:46:45 +0100
From: Florian Mickler <florian@mickler.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Dave Airlie <airlied@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Keith Packard <keithp@keithp.com>
Subject: Re: "do_IRQ: 0.89 No irq handler for vector (irq -1)"
Message-ID: <20101116204645.2c105e9b@schatten.dmk.lab>
In-Reply-To: <20101012124938.47170457@jbarnes-desktop>
References: <AANLkTikZj21CtFwC2ttvc0wJPx2qyedn7b1xXaxH659E@mail.gmail.com>
	<20101011154826.440b4990@jbarnes-desktop>
	<20101011164014.5a11ee48@jbarnes-desktop>
	<201010122101.17812.rjw@sisk.pl>
	<20101012124938.47170457@jbarnes-desktop>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Oct 2010 12:49:38 -0700
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Tue, 12 Oct 2010 21:01:17 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Tuesday, October 12, 2010, Jesse Barnes wrote:
> > > On Mon, 11 Oct 2010 15:48:26 -0700
> > > Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > > 
> > > > On Fri, 8 Oct 2010 21:46:50 +1000
> > > > Dave Airlie <airlied@gmail.com> wrote:
> > > > > Not sure how best to fix, I can workaround by calling
> > > > > pci_set_power_state(PCI_D0) in the drm drivers, but I sorta thing the
> > > > > PCI layer should take care of this.
> > > > 
> > > > So I think we *should* be able to call pci_disable_device at remove
> > > > time.  But as you say, some platforms may not correctly re-route VGA
> > > > space to an existing device or disable it properly when we do that.
> > > > AFAICT x86 will be ok here though (seems to work ok locally too).
> > > 
> > > Just tested this some more, and I think it's the right thing to do in
> > > the KMS case at least.  When we load a KMS driver it takes over the gfx
> > > device and nothing can assume anything about VGA state unless using the
> > > VGA arbiter.  So calling pci_disable_device() in the shutdown path of a
> > > KMS driver shouldn't make things any worse, and will work around this
> > > issue.
> > > 
> > > Doing so in the non-KMS case violates some PC assumptions though, in
> > > that things like vgacon and the BIOS will assume VGA memory is still
> > > around, which on some platforms pci_disable_device() may affect (I only
> > > checked the x86 implementation).
> > > 
> > > > That said, it seems like we should update the current device state at
> > > > load time as well, once we've matched the driver it seems like there
> > > > should be no harm.
> > > > 
> > > > Rafael, what do you think?  Would having the correct power state at
> > > > load time cause any trouble with other PM code?  I know we've had
> > > > issues with setting it explicitly in the past...
> > > 
> > > So we should probably make pci_enable_device pick up the current state
> > > as well, instead of assuming it's unknown just because the enable count
> > > was non-zero (which as Dave points out, can be affected by sysfs writes
> > > too).
> > > 
> > > The only downside I can think of there is that if the device is already
> > > enabled, we generally have to assume another driver owns it, and who
> > > knows if the device is actually alive enough to read the current state
> > > from.  But I think we handle those errors ok too, so pulling it out
> > > should be safe.
> > 
> > I remember trying to do something like this and it didn't play well with the
> > initialization.  Still, I didn't do that in pci_enable_device(), so I can't say
> > for sure at the moment.  I _think_ it will be fine, though.
> 
> Seems to work ok for the buggy i915 reload case.  But looking at it
> again, I really don't like two things:
>   1) doing just the set_power_state seems wrong, what about the rest of
>   enable?
>   2) allowing nested enables at all
> 
> I know sysfs currently allows us to bump the enable count to arbitrary
> levels, but that's easy to fix; we can just check pci_is_enabled()
> before calling enable_device in the sysfs store routine.
> 
> If we did that, we could warn when pci_enable_device is called in a
> nested way, which is generally a bug (two drivers trying to take over a
> device?).
> 
> I don't think I buy that VGA is special anyway, at least not for KMS
> enabled kernels, where vgacon and the BIOS can't assume anything about
> graphics state anymore.  More generally, I don't think BIOSes have been
> able to assume anything about the current graphics state since Windows
> 3.1, when most platforms stopped using BIOS calls and/or VGA regs for
> mode setting.
> 
> Thoughts?
> 

does this need to go to 2.6.36.y? (is it already on it's way?)

commit 97c145f7c87453cec90e91238fba5fe2c1561b32
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Fri Nov 5 15:16:36 2010 -0400

    PCI: read current power state at enable time

