Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760262Ab1CDWdc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 17:33:32 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47650 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752277Ab1CDWdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 17:33:31 -0500
Date: Fri, 4 Mar 2011 22:33:29 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [REVIEW] NVM Express driver
Message-ID: <20110304223329.18a81f5f@lxorguk.ukuu.org.uk>
In-Reply-To: <20110304221034.GD25574@kroah.com>
References: <20110303204749.GY3663@linux.intel.com>
	<20110303211336.GA32645@kroah.com>
	<20110303214104.GZ3663@linux.intel.com>
	<20110303215155.GA30451@kroah.com>
	<20110303220735.GA3663@linux.intel.com>
	<20110303222226.GA30966@kroah.com>
	<20110304124348.6419c661@lxorguk.ukuu.org.uk>
	<20110304212851.GB28680@kroah.com>
	<20110304215915.18199ce1@lxorguk.ukuu.org.uk>
	<20110304221034.GD25574@kroah.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > How do most other apps do it.
> 
> They write to the sysfs file with the firmware when they feel like it.

Very few seem to do this. Quite a lot also have a much more complex
interaction anyway than 'firmware please', 'zap' , 'ok' to be fair.

> > > So, what could be changed in the current firmware interface to fix this
> > > problem in a manner which would solve these perceived issues?
> > 
> > I'm not sure it can. The basis of the interface is driver requests
> > firmware. That is done by using a pathname which in a namespaced
> > environment isn't global and has races
> 
> Of course, but those races don't show up in real systems, right?

They do. That's why I know they exist. If enough people use your distro
then eventually someone catches it.

> > (Several things break quite spectacularly if you request_firmware while
> > updating a package, but of course nobody considered such details even for
> > automatic stuff in many cases. Really there is some locking needed).
> 
> I've never heard of this race before as you usually do firmware upload
> either at boot time, or when a user specifically asks for it.  Neither
> of those times is when packages are usually getting updated.

Usually is not a good answer for correctness and security with firmware.
It's really really not a good answer when flashing new firmware. "Usually
your expensive hardware is not turned into a valueless brick" lacks a
certain something.

For dynamically requested firmware the request_firmware interface is
excellent stuff, and the right way to fix the races is to lock between
the daemon and package manager. For flashing stuff it's not up to the job.

> 
> > For manual updating of a block of firmware the interface most stuff wants
> > is
> > 
> > 	copy_from_user()
> > 
> > or if you wanted to wrap it up nicely
> > 
> > 	x = vmalloc_from_user(void __user *ptr, ssize_t len);
> > 
> > The app knows which firmware it is talking about and can inspect and
> > compare it while holding an open file handle on the deivce. That protects
> > against hotplug races and getting the wrong device second access, and
> > ensures that the firmware, device and userspace are all talking about
> > exactly the same thing.
> 
> But you do get this type of buffer from the firware interface to your
> driver today, right?

Providing you jump through a small army of hoops, get the right sysfs
nodes, dodge any race conditions, hotplug and the like yes. But it should
be robust and simple. Using request_firmware for this case is neither
robust nor simple, nor is it easy to get the sysfs/driver open/hotplug
race handling right so instead of the kernel code being very occasionally
buggy (which we can spot) the user apps will be horribly buggy and we
don't read those so your push for a complex mis-standard in the kernel
actually makes the problem far worse than it would be without.

> Still, I don't want this to all of a sudden be "open season" for every
> individual driver deciding to want to create an ioctl call for firmware
> updating just because the authors don't like the existing in-kernel
> interface.  Please fix up the in-kernel one instead to meet your needs.

You are not creating an open season. The every driver having its own
ioctl for firmware updating is the norm, and its in some ways a rather
good norm because when it comes to flash updating there isn't much
standardisation and you don't want standardisation as it just asks for
the wrong tool to work in an unfortunate race or user mix-up. Flash
updating is special - it's good that one app doesn't work on another
device !

You could have a standardised helper easily enough I guess. Pick a
standard struct and firmware descriptor and provide a

request_firmware_from_user(struct firmware_something __user *fw)

which hands back stuff in the form the rest of the firmware logic likes
to play and has a standard user side struct format.


Alan
