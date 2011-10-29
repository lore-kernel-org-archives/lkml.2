Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab1J2WkR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 18:40:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39437 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755262Ab1J2WkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 18:40:15 -0400
Date: Sun, 30 Oct 2011 00:39:35 +0200
From: Greg KH <gregkh@suse.de>
To: David Herrmann <dh.herrmann@googlemail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] kobject module-ref race-condition or unsafe
 module_put(THIS_MODULE)
Message-ID: <20111029223935.GB3952@suse.de>
References: <CANq1E4SovxjRsuDN3PMqCnjBMMQeHWnvbwreXJWcDj7D7wUxWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANq1E4SovxjRsuDN3PMqCnjBMMQeHWnvbwreXJWcDj7D7wUxWw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 29, 2011 at 07:52:47PM +0200, David Herrmann wrote:
> Hi
> 
> I currently do not understand how kobjects keep a reference to the
> owning module. Lets assume I provide a "release" method via a
> kobj_type for my kobject. I want to go sure my module is still alive
> when this method is called. Otherwise, this "release" method would be
> no longer available and we would jump into invalid memory. Therefore,
> I need to take a reference to my own module. This seems trivial.
> However, how do I release this reference again?
> The most simple solution might be calling module_put(THIS_MODULE) in
> my "release" method. However, if this call drops the module-refcount
> to 0 and immediately removes the module, the module_put() returns to
> my "release" function which now is no longer available.
> 
> It seems quite unlikely that the cleanup of a module is faster than
> two function-returns, however, theoretically there is a race
> condition.
> 
> The following example is based on fs/char_dev.c. Lets assume my module
> provides a  kobject structure. On init I take a ref to myself with
> try_module_get(THIS_MODULE).

No, never do that, why would you?

> I add my own kobj_type with the following release function:
> 
> static void mydev_put(struct mydev *p)
> {
> 	if (p) {
> 		kobject_put(&p->kobj);
> 		module_put(THIS_MODULE);
> 	}
> }

Ick, don't do that.

> How can we go sure that module_put() doesn't free my own module before
> it returns? Isn't a call to module_put(THIS_MODULE) always unsafe
> (unless I own at least two references)?

Yes, that's why you shouldn't be doing this :)

> Maybe I have missed some important fact here, but this seems quite
> unsafe to me. Adding a "owner" field to a kobj_type would fix that
> issue for kobjects/devices.

No, let's determine exactly what you are trying to do first, and why in
the world you are dealing with "raw" kobjects.  You should almost never
never never do that.

What driver are you writing?  Have a pointer to the code somewhere?

greg k-h
