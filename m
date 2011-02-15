Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab1BOTsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 14:48:32 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33158 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908Ab1BOTs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 14:48:29 -0500
Date: Tue, 15 Feb 2011 12:48:24 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Kevin Hilman <khilman@ti.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [RFC][PATCH 2/2] PM: Make system-wide PM and runtime PM handle
 subsystems consistently
Message-ID: <20110215194824.GC7649@angua.secretlab.ca>
References: <201101300107.19389.rjw@sisk.pl>
 <201102011939.49793.rjw@sisk.pl>
 <201102122312.26545.rjw@sisk.pl>
 <201102122314.41407.rjw@sisk.pl>
 <87pqqtrwxt.fsf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pqqtrwxt.fsf@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 10:10:06AM -0800, Kevin Hilman wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> >
> > The code handling system-wide power transitions (eg. suspend-to-RAM)
> > can in theory execute callbacks provided by the device's bus type,
> > device type and class in each phase of the power transition.  In
> > turn, the runtime PM core code only calls one of those callbacks at
> > a time, preferring bus type callbacks to device type or class
> > callbacks and device type callbacks to class callbacks.
> >
> > It seems reasonable to make them both behave in the same way in that
> > respect.  Moreover, even though a device may belong to two subsystems
> > (eg. bus type and device class) simultaneously, in practice power
> > management callbacks for system-wide power transitions are always
> > provided by only one of them (ie. if the bus type callbacks are
> > defined, the device class ones are not and vice versa).  Thus it is
> > possible to modify the code handling system-wide power transitions
> > so that it follows the core runtime PM code (ie. treats the
> > subsystem callbacks as mutually exclusive).
> >
> > On the other hand, the core runtime PM code will choose to execute,
> > for example, a runtime suspend callback provided by the device type
> > even if the bus type's struct dev_pm_ops object exists, but the
> > runtime_suspend pointer in it happens to be NULL.  This is confusing,
> > because it may lead to the execution of callbacks from different
> > subsystems during different operations (eg. the bus type suspend
> > callback may be executed during runtime suspend, while the device
> > type callback will be executed during runtime resume).
> >
> > Make all of the power management code treat subsystem callbacks in
> > a consistent way, such that:
> > (1) If the device's bus type is defined (eg. dev->bus is not NULL)
> >     and its pm pointer is not NULL, the callbacks from dev->bus->pm
> >     will be used.
> > (2) If dev->bus is NULL or dev->bus->pm is NULL, but the device's
> >     device type is defined (eg. dev->type is not NULL) and its pm
> >     pointer is not NULL, the callbacks from dev->type->pm will be
> >     used.
> > (3) If dev->bus is NULL or dev->bus->pm is NULL and dev->type is
> >     NULL or dev->type->pm is NULL, the callbacks from dev->class->pm
> >     will be used provided that both dev->class and dev->class->pm
> >     are not NULL.
> >
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> This looks good,  consistency between system and runtime PM is a great
> help to readability.
> 
> Acked-by: Kevin Hilman <khilman@ti.com>

Reasoning-sounds-sane-to: Grant Likely <grant.likely@secretlab.ca>

