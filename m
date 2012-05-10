Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760662Ab2EJSQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 14:16:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34279 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756319Ab2EJSQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 14:16:15 -0400
Date: Thu, 10 May 2012 11:16:11 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Hiroshi DOYU <hdoyu@nvidia.com>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/1] Driver Core: don't oops with unregistered driver in
 driver_find_device()
Message-ID: <20120510181611.GA16908@kroah.com>
References: <1336635302-29260-1-git-send-email-hdoyu@nvidia.com>
 <20120510141130.GA20373@kroah.com>
 <4FABE5D3.9040706@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FABE5D3.9040706@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 09:59:15AM -0600, Stephen Warren wrote:
> On 05/10/2012 08:11 AM, Greg Kroah-Hartman wrote:
> > On Thu, May 10, 2012 at 10:35:02AM +0300, Hiroshi DOYU wrote:
> >> driver_find_device() can be called with an unregistered driver.
> > 
> > Who does that?  Where in the kernel?  Why would you try to do that?
> > 
> >> Need to check driver_private to see if it's populated or not,
> >> especially under deferrable probe.
> > 
> > Hm, I don't know if this will really catch a driver that was registered
> > and then was unregistered, right?  It seems like moving the real problem
> > somewhere else, why not fix the original issue instead?
> > 
> >> Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
> >> ---
> >> In [PATCHv5 2/3] ARM: tegra: Add SMMU enabler in AHB:
> >>   http://article.gmane.org/gmane.linux.ports.tegra/4658
> >>
> >> "tegra_ahb_driver" may not be populated when it's called.
> > 
> > It can?  I don't see that in that patch.
> 
> I think this is what's happening:
> 
> The Tegra SMMU driver is registered using subsys_initcall().
> 
> The Tegra AHB driver is registered using module_platform_driver, so
> module_init().
> 
> The device objects for both are registered at basically the same time
> during the machine's initialization call, which I think happens before
> both or some of the above two calls.
> 
> So, SMMU ends up getting probed before the AHB driver has even been
> registered.

What do those two drivers have to do with each other?

> That's why in patch Hiroshi linked, in tegra_ahb_enable_smmu(), the AHB
> driver hasn't (or may not have) been registered, so driver_find_device()
> can experience the issue this patch attempts to solve.

It sounds like you have a locking or ordering problem somewhere in this
platform, and it needs to be resolved there.  Odds are, this tiny check
is the least of your worries, right?

Who is doing the driver_find_device() call in the first place?  The
driver core?  Or something else?

greg k-h
