Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab0JTPz4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 11:55:56 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52594 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab0JTPzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 11:55:54 -0400
Date: Wed, 20 Oct 2010 09:55:49 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        akpm@linux-foundation.org, Greg KH <greg@kroah.com>,
        Tony Lindgren <tony@atomide.com>, Benoit Cousson <b-cousson@ti.com>,
        Hari Kanigeri <h-kanigeri2@ti.com>, Suman Anna <s-anna@ti.com>,
        Simon Que <sque@ti.com>
Subject: Re: [PATCH 3/3] omap: add hwspinlock device
Message-ID: <20101020155549.GF7285@angua.secretlab.ca>
References: <1287387875-14168-1-git-send-email-ohad@wizery.com>
 <1287387875-14168-4-git-send-email-ohad@wizery.com>
 <87r5fmxghm.fsf@deeprootsystems.com>
 <AANLkTinZ2+ocJCfUpT15Ow3J9XBa-8XWnVC3gDDJ7s-v@mail.gmail.com>
 <87bp6pviwf.fsf@deeprootsystems.com>
 <AANLkTikE1dCXW-7ScVoDgEK3sxai_TyFzstSG+zvNm2F@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikE1dCXW-7ScVoDgEK3sxai_TyFzstSG+zvNm2F@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 04:38:32PM +0200, Ohad Ben-Cohen wrote:
> On Wed, Oct 20, 2010 at 1:53 AM, Kevin Hilman
> <khilman@deeprootsystems.com> wrote:
> >> And to allow early board code to reserve specific hwspinlock numbers
> >> for predefined use-cases, we probably want to be before arch_initcall.
> >
> > There's no reason for board code to have to do this at initcall time.
> 
> If we want to have allow both allocations of predefined hwspinlocks
> with omap_hwspinlock_request_specific(int), and dynamic allocations
> (where we don't care about the specific instance of the hwspinlock we
> will get) with omap_hwspinlock_request(), we must ensure that the
> former _specific() API will never be called after the latter.
> 
> If we will allow drivers to call omap_hwspinlock_request() before all
> callers of omap_hwspinlock_request_specific() completed, then things
> will break (because drivers might start getting hwspinlocks that are
> predefined for dedicated use cases on the system).
> 
> So if we want the _specific API to work, we can only allow early board
> code to use it in order to reserve those predefined hwspinlocks before
> drivers get the chance to call omap_hwspinlock_request().
> 
> The tempting alternative is not to provide the
> omap_hwspinlock_request_specific() API at all (which is something we
> discussed internally).
> 
> Let's take the i2c-omap for example.
> 
> It sounds like it must have a predefined hwspinlock, but what if:
> 
> 1. It will use omap_hwspinlock_request() to dynamically allocate a hwspinlock
> 2. Obviously, the hwspinlock id number must be communicated to the M3
> BIOS, so the i2c-omap will publish that id using a small shared memory
> entry that will be allocated for this sole purpose
> 3. we will make sure that 1+2 completes before the remote processor is
> taken out of reset
> 
> This does not require any smart IPC and it will allow us to get rid of
> the omap_hwspinlock_request_specific() API and its early-callers
> requirement.
> 
> All we will be left to take care of is the order of the ->probe()
> execution (assuming we want both the i2c and the hwspinlock drivers to
> be device_initcall)

Having fought with this kind of thing before, I would strongly
recommend making the interface either all-dynamic, or all-predefined,
but not a mixture of the two.

> 
> >
> > This kind of thing needs to be done by platform_data function pointers,
> > as is done for every other driver that needs platform-specific driver
> > customization.
> 
> Why would we need platform-specific function pointers here ? I'm not
> sure I'm following this one.
> 
> Thanks,
> Ohad.
> 
> 
> >
> > Kevin
> >
