Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932675Ab1CDWLM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 17:11:12 -0500
Received: from kroah.org ([198.145.64.141]:39311 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932498Ab1CDWLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 17:11:10 -0500
Date: Fri, 4 Mar 2011 14:10:34 -0800
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [REVIEW] NVM Express driver
Message-ID: <20110304221034.GD25574@kroah.com>
References: <20110303204749.GY3663@linux.intel.com>
 <20110303211336.GA32645@kroah.com>
 <20110303214104.GZ3663@linux.intel.com>
 <20110303215155.GA30451@kroah.com>
 <20110303220735.GA3663@linux.intel.com>
 <20110303222226.GA30966@kroah.com>
 <20110304124348.6419c661@lxorguk.ukuu.org.uk>
 <20110304212851.GB28680@kroah.com>
 <20110304215915.18199ce1@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110304215915.18199ce1@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 09:59:15PM +0000, Alan Cox wrote:
> > And non-automated loading of firmware as well.  Dell uses this for
> > updating their BIOSes just fine, with a userspace tool that initiates
> > the loading of the firmware.
> 
> Try using the Dell tool with namespaces.

Heck, try using _any_ tool that talks to sysfs with namespaces, don't
try to claim that this driver using its own custom firmware loader is a
solution to the namespace/sysfs issue please.  That's very disingenuous.

> > How does Dell do it?
> 
> How do most other apps do it.

They write to the sysfs file with the firmware when they feel like it.

> > So, what could be changed in the current firmware interface to fix this
> > problem in a manner which would solve these perceived issues?
> 
> I'm not sure it can. The basis of the interface is driver requests
> firmware. That is done by using a pathname which in a namespaced
> environment isn't global and has races

Of course, but those races don't show up in real systems, right?

> (Several things break quite spectacularly if you request_firmware while
> updating a package, but of course nobody considered such details even for
> automatic stuff in many cases. Really there is some locking needed).

I've never heard of this race before as you usually do firmware upload
either at boot time, or when a user specifically asks for it.  Neither
of those times is when packages are usually getting updated.

> For manual updating of a block of firmware the interface most stuff wants
> is
> 
> 	copy_from_user()
> 
> or if you wanted to wrap it up nicely
> 
> 	x = vmalloc_from_user(void __user *ptr, ssize_t len);
> 
> The app knows which firmware it is talking about and can inspect and
> compare it while holding an open file handle on the deivce. That protects
> against hotplug races and getting the wrong device second access, and
> ensures that the firmware, device and userspace are all talking about
> exactly the same thing.

But you do get this type of buffer from the firware interface to your
driver today, right?

> It would nice to say "its an obscure corner case that will just error",
> but far too much hardware still gets semi permanently (or permanently)
> converted into junk if you goof a permanent flash firmware update.

One would hope that the hardware was a bit more resiliant than that, but
I know how hardware is designed :(

Still, I don't want this to all of a sudden be "open season" for every
individual driver deciding to want to create an ioctl call for firmware
updating just because the authors don't like the existing in-kernel
interface.  Please fix up the in-kernel one instead to meet your needs.

thanks,

greg k-h
