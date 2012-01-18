Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963Ab2ARPvv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 10:51:51 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:53488 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757930Ab2ARPvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 10:51:49 -0500
Date: Wed, 18 Jan 2012 10:51:49 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <gregkh@suse.de>
cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Sergei Trofimovich <slyich@gmail.com>, <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@amd64.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>, <prasad@linux.vnet.ibm.com>,
        Ming Lei <tom.leiming@gmail.com>, Djalal Harouni <tixxdz@opendz.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Andi Kleen <ak@linux.intel.com>,
        <gouders@et.bocholt.fh-gelsenkirchen.de>,
        Marcos Souza <marcos.mage@gmail.com>, <justinmattock@gmail.com>,
        Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: [PATCH] mce: fix warning messages about static struct mce_device
In-Reply-To: <20120118144250.GA16288@suse.de>
Message-ID: <Pine.LNX.4.44L0.1201181047060.1343-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jan 2012, Greg KH wrote:

> > > > Minor nit, i don't think we have any other such [CONFIG_NR_CPUS] 
> > > > pattern in the kernel.
> > > > 
> > > > This should be something like:
> > > > 
> > > >   DECLARE_PER_CPU(struct device *, mce_device);
> > > 
> > > That is what we used to have, but with just a static struct 
> > > device. [...]

Ingo's suggestion is fine.  The difference is that instead of a static
array of struct device's, this is a static pre-cpu pointer to a dynamic 
struct device (effectively, an array of pointers rather than an array 
of structures).

> > Which was fine in itself for a per CPU data structure - wouldnt 
> > the warning be fixed by memset()-ing before registering the 
> > device or such, if device registry absolutely needs a pre-zeroed 
> > buffer?
> 
> It was already fixed that way, but the problem is that you can not have
> statically allocated 'struct device' objects in the system.  That's what
> my add-on patch fixed, also resolving the syslog messages saying there
> was no release function for the device as well.
> 
> > I still think there must be some bug/assumption lurking in the 
> > device layer - do you require all device allocations to be one 
> > via zalloc()? Seems like a weird and unrobust requirement.
> 
> Yes, that's always been the requirement.

There's an additional requirement: Device structures may not be reused.  
Not even if the caller clears all the fields to 0 in between.  That was
the real bug in the original code -- and adding a dummy release routine
wouldn't fix it.

> > Amongst other things we use PER_CPU to have an array of just 2 
> > elements on a dual core system, even if it boots a 
> > CONFIG_NR_CPUS=512 distro kernel. That saves RAM, and with 
> > higher CONFIG_NR_CPUS values it adds up quickly.
> > 
> > > > Or the pointer should be attached to the CPU info structure.
> > > 
> > > Ok, I have no objection to that, do you want me to make a 
> > > patch doing that, now that this is already in Linus's tree?
> > 
> > Would be nice if you could do that or some other equivalent 
> > solution, i'd really not like to see the [CONFIG_NR_CPUS] 
> > pattern to spread in the kernel, we spent a lot of time getting 
> > rid of such uses ;-)
> 
> Ok, I'll work on resolving this.

A static per-cpu pointer to struct device should work perfectly.

Alan Stern

