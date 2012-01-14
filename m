Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab2ANQaH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 11:30:07 -0500
Received: from netrider.rowland.org ([192.131.102.5]:55041 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755164Ab2ANQaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 11:30:04 -0500
Date: Sat, 14 Jan 2012 11:30:03 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Greg KH <gregkh@suse.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Ming Lei <tom.leiming@gmail.com>, Djalal Harouni <tixxdz@opendz.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Tony Luck <tony.luck@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>,
        <linux-kernel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
        <gouders@et.bocholt.fh-gelsenkirchen.de>,
        Marcos Souza <marcos.mage@gmail.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "tglx@linutronix.de" <tglx@linutronix.de>, <prasad@linux.vnet.ibm.com>,
        <justinmattock@gmail.com>, Jeff Chua <jeff.chua.linux@gmail.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: x86/mce: machine check warning during poweroff
In-Reply-To: <20120114144938.GA32033@suse.de>
Message-ID: <Pine.LNX.4.44L0.1201141121300.7598-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Jan 2012, Greg KH wrote:

> On Fri, Jan 13, 2012 at 06:53:04PM -0800, Linus Torvalds wrote:
> > On Fri, Jan 13, 2012 at 6:41 PM, Srivatsa S. Bhat
> > <srivatsa.bhat@linux.vnet.ibm.com> wrote:
> > >
> > > YES!! Finally I have a fix for this whole MCE thing! :-)
> > 
> > Goodie.
> > 
> > > The patch below works perfectly for me - I tested multiple CPU hotplug
> > > operations as well as multiple pm_test runs at core level. Please let me
> > > know if this solves the suspend issue as well..
> > 
> > Ok, I'll try, and I bet it does.
> > 
> > HOWEVER.
> > 
> > I'd be a whole lot happier knowing exactly which field in "struct
> > device" that needed to be NULL before it gets registered.
> > 
> > I don't like how
> > 
> >   device_register() + device_create_file(dev)..
> > 
> > is not sufficiently undone by
> > 
> >  .. device_remove_file(dev) +  device_unregister()
> > 
> > so that it can't be repeated. Exactly *what* state is stale and
> > re-used incorrectly if you do that device_register() a second time.
> > 
> > It smells like a misfeature of the device core handling.
> 
> It has to do with the fact that this is a "static" device that is being
> reused.  Normally it would be cleaned up properly in the release
> function, but as there isn't one, some fields are being left in a bad
> state.

That's exactly right.  In general, device structures should never be
reused.  Apart from the reinitialization issues, in the general case
you have the problem that the references to the previous incarnation
may not all have been dropped.  Now, perhaps in the MCE case you _do_
know that they're all gone (I can't tell), but relying on it is
dangerous.

The driver core isn't designed to handle device structures that get
unregistered and then spring back to life; callers are supposed to
allocate a fresh new structure instead.  (We had to solve this very
same problem in the USB subsystem a number of years ago; figuring it
all out was tricky even back then.)  And this is true regardless of
whether the original structure was allocated dynamically or not.

Alan Stern

