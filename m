Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab1AHNTa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 08:19:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451Ab1AHNT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 08:19:29 -0500
Date: Sat, 8 Jan 2011 08:19:19 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Greg KH <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: Re: kobject_put vs module unload
In-Reply-To: <20110108055621.GB10391@suse.de>
Message-ID: <Pine.LNX.4.64.1101080811400.29089@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1101072234040.382@hs20-bc2-1.build.redhat.com>
 <20110108055621.GB10391@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Jan 2011, Greg KH wrote:

> On Fri, Jan 07, 2011 at 10:42:22PM -0500, Mikulas Patocka wrote:
> > Hi
> > 
> > I'm looking at some kobject problem in device mapper and I came across 
> > this problem:
> > 
> > According to kobject interface specification, If we embed a kobject into 
> > the device structure, we shouldn't free the device structure when the 
> > device is unloaded, but we should register a "release" callback in 
> > kobj_type that will actually free the device structure.
> 
> That is correct.
> 
> What does "device is unloaded" mean?  That really doesn't mean anything
> in reference to the driver model/kobject code.
> 
> > What happens in this scenario?:
> > 
> > 1) someone references a device kobject
> > 2) the device is unloaded (but the device structure is still in memory 
> > because of that reference)
> 
> What do you mean here?  How can a device be "unloaded"?  Is it just
> unregistered?

Device mapper devices can be unloaded by the user with "dmsetup remove" 
command. Other drivers (like md), offer other commands to unload devices, 
but the principle is the same.

> > 3) the driver module is unloaded
> 
> Oops, you just lost.

If you unload all device mappers's devices, the module reference count 
drops to zero and you can unload the device mapper module.

> > 4) the reference obtained at point 1) is dropped, kobject reference count 
> > reaches zero and the release callback is called. But that callback points 
> > to an unloaded module and causes a crash.
> > 
> > How is it solved? Am I missing something?
> 
> You have the code that creates and frees the object, to not be in the
> module that could have been unloaded.  It's really just that simple.

If the whole device mapper subsystem can be a module, where can I put the 
code?

I think a similar bug exists in md, it can also be unloaded as a module 
and it has "release" method in its module code.

> Hope this helps,
> 
> greg k-h

Mikulas
