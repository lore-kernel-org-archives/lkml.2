Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761897Ab2EJW2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 18:28:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62847 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761880Ab2EJW2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 18:28:34 -0400
Date: Thu, 10 May 2012 15:28:30 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Hiroshi DOYU <hdoyu@nvidia.com>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/1] Driver Core: don't oops with unregistered driver in
 driver_find_device()
Message-ID: <20120510222830.GA23084@kroah.com>
References: <1336635302-29260-1-git-send-email-hdoyu@nvidia.com>
 <20120510141130.GA20373@kroah.com>
 <4FABE5D3.9040706@wwwdotorg.org>
 <20120510181611.GA16908@kroah.com>
 <4FAC1E70.8030907@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FAC1E70.8030907@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 02:00:48PM -0600, Stephen Warren wrote:
> On 05/10/2012 12:16 PM, Greg Kroah-Hartman wrote:
> > On Thu, May 10, 2012 at 09:59:15AM -0600, Stephen Warren wrote:
> >> On 05/10/2012 08:11 AM, Greg Kroah-Hartman wrote:
> >>> On Thu, May 10, 2012 at 10:35:02AM +0300, Hiroshi DOYU wrote:
> >>>> driver_find_device() can be called with an unregistered driver.
> >>>
> >>> Who does that?  Where in the kernel?  Why would you try to do that?
> >>>
> >>>> Need to check driver_private to see if it's populated or not,
> >>>> especially under deferrable probe.
> >>>
> >>> Hm, I don't know if this will really catch a driver that was registered
> >>> and then was unregistered, right?  It seems like moving the real problem
> >>> somewhere else, why not fix the original issue instead?
> >>>
> >>>> Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
> >>>> ---
> >>>> In [PATCHv5 2/3] ARM: tegra: Add SMMU enabler in AHB:
> >>>>   http://article.gmane.org/gmane.linux.ports.tegra/4658
> >>>>
> >>>> "tegra_ahb_driver" may not be populated when it's called.
> >>>
> >>> It can?  I don't see that in that patch.
> >>
> >> I think this is what's happening:
> >>
> >> The Tegra SMMU driver is registered using subsys_initcall().
> >>
> >> The Tegra AHB driver is registered using module_platform_driver, so
> >> module_init().
> >>
> >> The device objects for both are registered at basically the same time
> >> during the machine's initialization call, which I think happens before
> >> both or some of the above two calls.
> >>
> >> So, SMMU ends up getting probed before the AHB driver has even been
> >> registered.
> > 
> > What do those two drivers have to do with each other?
> 
> The AHB HW module contains a bit to say "enable the SMMU". This bit
> cannot be turned on until certain initialization has been performed by
> the SMMU driver.
> 
> So, SMMU's probe performs the initialization, then attempts to contact
> the AHB driver to ask it to enable the SMMU.
> 
> >> That's why in patch Hiroshi linked, in tegra_ahb_enable_smmu(), the AHB
> >> driver hasn't (or may not have) been registered, so driver_find_device()
> >> can experience the issue this patch attempts to solve.
> > 
> > It sounds like you have a locking or ordering problem somewhere in this
> > platform, and it needs to be resolved there.  Odds are, this tiny check
> > is the least of your worries, right?
> > 
> > Who is doing the driver_find_device() call in the first place?  The
> > driver core?  Or something else?
> 
> SMMU's probe calls tegra_ahb_enable_smmu().
> 
> tegra_ahb_enable_smmu() needs to find the AHB's struct device so that it
> can find get the driver data associated with it, which contains the
> ioremap'd registers amongst other things.
> 
> In order to find the correct device, tegra_ahb_enable_smmu() is passed
> the device tree node of the appropriate AHB that controls the SMMU.
> 
> The two drivers use deferred probe to ensure that their relative probe
> order doesn't matter. If AHB is probed first, then
> tegra_ahb_enable_smmu()'s driver_find_device() succeeds, and the AHB
> register is programmed to enable the SMMU. If the SMMU is probed first,
> then tegra_ahb_enable_smmu() returns -EPROBE_DEFER to hold off the SMMU
> from completing its probe. I believe this is exactly the kind of thing
> -EPROBE_DEFER was intended for.

Ok, thanks for explaining it better, that would have been nice to have
in the original patch submission :)

This fix, is it needed for 3.4, or just 3.5?

I kind of don't like relying on ->p as a check to see if things are set
up properly, I wonder if we could use the kobject state_initalized field
instead somehow, or maybe state_in_sysfs?  Oh wait, that's in ->p as
well.  Ok, I guess this is as good as it can get.

Can someone resend this to me, with the information above in the
changelog comment, and I'll be glad to apply it?  Again, I need to know
if this is needed for 3.4 or it can wait for 3.5?

thanks,

greg k-h
