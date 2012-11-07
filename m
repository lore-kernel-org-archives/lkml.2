Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab2KGRRF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 12:17:05 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:59571 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751346Ab2KGRRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 12:17:03 -0500
Date: Wed, 7 Nov 2012 12:17:02 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Huang Ying <ying.huang@intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: [BUGFIX] PM: Fix active child counting when disabled and forbidden
In-Reply-To: <2385996.Tx2Do9TUNJ@vostro.rjw.lan>
Message-ID: <Pine.LNX.4.44L0.1211071214190.1175-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Nov 2012, Rafael J. Wysocki wrote:

> > The PCI subsystem assumes that 
> > driverless devices are not in use, so they are disabled for runtime PM 
> > and marked as suspended.  This is not appropriate for VGA devices, 
> > which can indeed be used without a driver.
> > 
> > I'm not sure what the best solution is.  Maybe we should Ying's 
> > proposal a step farther:
> > 
> > 	Make pm_runtime_set_suspended() fail if runtime PM is 
> > 	forbidden.
> >
> > 	Make pm_runtime_forbid() call pm_runtime_set_active()
> > 	(and do a runtime resume of the parent) if disable_depth > 0.
> 
> I'd prefer this one.

That wasn't meant to be a choice.  The first item is close to what the 
original patch did; I was suggesting that we should adopt all three 
items.

If you adopt the second item but not the first then things won't work 
when a driver is removed after power/control is set to "on".

>  The callers of pm_runtime_forbid() may actually
> reasonably expect something like this to happen.
> 
> > 	Make the PCI runtime-idle routine call 
> > 	pm_runtime_set_suspended() if disable_depth > 0.  Or maybe
> > 	do this for all devices, in the runtime PM core.
> 
> That would mean calling it on every call to pm_runtime_put() and friends
> which seems to be a bit wasteful.

Not on every call; only when disable_depth > 0.  We don't expect to see 
idle calls very often under those circumstances.

Alan Stern

