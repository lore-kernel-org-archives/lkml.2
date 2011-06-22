Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064Ab1FVOUb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 10:20:31 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42399 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755582Ab1FVOU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 10:20:29 -0400
Date: Wed, 22 Jun 2011 10:20:28 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] PCI / PM: Block races between runtime PM and system
 sleep
In-Reply-To: <201106220149.17380.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1106221011240.1977-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jun 2011, Rafael J. Wysocki wrote:

> > It's probably okay to prevent pm_runtime_suspend() from working during
> > .suspend() or .resume(), but it's not a good idea to prevent
> > pm_runtime_resume() from working then.
> 
> OK, but taking a reference by means of pm_runtime_get_noresume() won't
> block pm_runtime_resume().

Exactly my point -- we don't need to (and don't want to) block 
pm_runtime_resume during the .suspend() and .resume() callbacks.

> > During the .suspend and .resume callbacks, races with
> > .runtime_suspend() can be prevented by calling
> > pm_runtime_get_noresume() just before .suspend() and then calling
> > pm_runtime_put_sync() just after .resume().
> 
> So, you seem to suggest to call pm_runtime_get_noresume() in
> __device_suspend() and pm_runtime_put_sync() in device_resume().

Yes.  Also perhaps call pm_runtime_barrier() immediately after 
get_noresume.

> That would be fine by me, perhaps up to the "sync" part of the "put".

The main feature of this design is that it allows runtime PM to work 
between .resume() and .complete().  If you do a put_noidle instead of 
put_sync then you may prevent runtime PM from working properly.

> > >  (a _put_sync() at this point will likely invoke
> > > .runtime_idle() from the subsystem before executing .complete(), which may
> > > not be desirable)?
> > 
> > It should be allowed.  The purpose of .complete() is not to re-enable
> > runtime power management of the device; it is to release resources
> > (like memory) allocated during .prepare() and perhaps also to allow new
> > children to be registered under the device.
> 
> Right.  But does "allowed" mean the core _should_ do it at this point?
> We may as well call pm_runtime_idle() directly from rpm_complete(), but
> perhaps it's better to call it from device_resume(), so that it runs in
> parallel for async devices.

Calling pm_runtime_put_noidle() followed by pm_runtime_idle() is 
essentially the same as calling pm_runtime_put_sync() anyway.

If a subsystem really does want to block runtime PM between the 
.resume() and .complete() callbacks, it can do its own get_noresume and 
put_sync -- just as you have done with PCI.

Alan Stern

