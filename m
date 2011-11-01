Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab1KARF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 13:05:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55969 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755721Ab1KARF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 13:05:27 -0400
Date: Tue, 1 Nov 2011 10:05:16 -0700
From: Greg KH <gregkh@suse.de>
To: David Herrmann <dh.herrmann@googlemail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] kobject module-ref race-condition or unsafe
 module_put(THIS_MODULE)
Message-ID: <20111101170516.GB8925@suse.de>
References: <CANq1E4SovxjRsuDN3PMqCnjBMMQeHWnvbwreXJWcDj7D7wUxWw@mail.gmail.com>
 <20111029223935.GB3952@suse.de>
 <CANq1E4QwjDOb0x_HcarwY4cM=P5NXoL6351=ivy-NLP9ZnVoJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANq1E4QwjDOb0x_HcarwY4cM=P5NXoL6351=ivy-NLP9ZnVoJA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 30, 2011 at 01:36:08AM +0200, David Herrmann wrote:
> On Sun, Oct 30, 2011 at 12:39 AM, Greg KH <gregkh@suse.de> wrote:
> > On Sat, Oct 29, 2011 at 07:52:47PM +0200, David Herrmann wrote:
> >> Hi
> >>
> >> I currently do not understand how kobjects keep a reference to the
> >> owning module. Lets assume I provide a "release" method via a
> >> kobj_type for my kobject. I want to go sure my module is still alive
> >> when this method is called. Otherwise, this "release" method would be
> >> no longer available and we would jump into invalid memory. Therefore,
> >> I need to take a reference to my own module. This seems trivial.
> >> However, how do I release this reference again?
> >> The most simple solution might be calling module_put(THIS_MODULE) in
> >> my "release" method. However, if this call drops the module-refcount
> >> to 0 and immediately removes the module, the module_put() returns to
> >> my "release" function which now is no longer available.
> >>
> >> It seems quite unlikely that the cleanup of a module is faster than
> >> two function-returns, however, theoretically there is a race
> >> condition.
> >>
> >> The following example is based on fs/char_dev.c. Lets assume my module
> >> provides a  kobject structure. On init I take a ref to myself with
> >> try_module_get(THIS_MODULE).
> >
> > No, never do that, why would you?
> >
> >> I add my own kobj_type with the following release function:
> >>
> >> static void mydev_put(struct mydev *p)
> >> {
> >>       if (p) {
> >>               kobject_put(&p->kobj);
> >>               module_put(THIS_MODULE);
> >>       }
> >> }
> >
> > Ick, don't do that.
> >
> >> How can we go sure that module_put() doesn't free my own module before
> >> it returns? Isn't a call to module_put(THIS_MODULE) always unsafe
> >> (unless I own at least two references)?
> >
> > Yes, that's why you shouldn't be doing this :)
> >
> >> Maybe I have missed some important fact here, but this seems quite
> >> unsafe to me. Adding a "owner" field to a kobj_type would fix that
> >> issue for kobjects/devices.
> >
> > No, let's determine exactly what you are trying to do first, and why in
> > the world you are dealing with "raw" kobjects.  You should almost never
> > never never do that.
> >
> > What driver are you writing?  Have a pointer to the code somewhere?
> 
> Initially, I was looking at hci_dev at net/bluetooth/hci_core.c and
> hci_sysfs.c. It registers a "struct device" with a device_type
> structure and a static release function. I was wondering how I can be
> sure that the "release" function is still available when it is called.

Ah, so you are a bus, that's good, that is the only thing that should be
caring about this.

> I couldn't find any module reference in "struct device" nor can I be
> sure that the module is still loaded when the device is freed.

That's because a struct device doesn't care about a module, it's the
larger structure that wraps it that should, if it really needs to.

Look at how USB and PCI handle this, that's the way to properly do this
if you really feel you need to do so.

> There are several bugfixes in padovan's tree and pending on the ML so
> I can't point you to the source. Reading net/bluetooth/hci* really
> doesn't help here. However, what should I do in the following case:
> 
> I provide hci_alloc_dev() which creates a hci_dev with an embedded
> "struct device" and hci_dev_get/put which map to get/put_device(). The
> device is registered with a "device_type" including a "release"
> callback which simply calls kfree() on the hci_dev.

Good.

> Now how can I be sure the "release" callback pointing to my function
> is still available when a device is freed? When unloading the
> bluetooth module I cannot wait for all hci_dev structures to be
> freed().

Why not?  That sounds like the correct thing to do, right?  It's what
the network stack does.

> This would make ref-counts useless. What is the recommended
> way to do that?

No, please don't confuse module counts with reference counts of devices,
they are two totally different things.

Device reference counts count the users of the memory for the device.

Module reference counts count the users of the memory for the code for
the module.

Usually the two are never linked, as they are different.

hope this helps,

greg k-h
