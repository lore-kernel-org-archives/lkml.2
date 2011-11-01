Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322Ab1KASFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 14:05:35 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33633 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259Ab1KASFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 14:05:34 -0400
Date: Tue, 1 Nov 2011 11:05:19 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: David Herrmann <dh.herrmann@googlemail.com>
Cc: Greg KH <gregkh@suse.de>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] Input: Remove unsafe device module references
Message-ID: <20111101180519.GB15216@core.coreip.homeip.net>
References: <1320162100-13494-1-git-send-email-dh.herrmann@googlemail.com>
 <20111101170156.GA8925@suse.de>
 <CANq1E4S07S2kNTmAxQRa4mEVKrGnS7cTHKqPoHEzLOyu3Mfqzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANq1E4S07S2kNTmAxQRa4mEVKrGnS7cTHKqPoHEzLOyu3Mfqzw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 01, 2011 at 06:52:11PM +0100, David Herrmann wrote:
> Hi Greg
> 
> On Tue, Nov 1, 2011 at 6:01 PM, Greg KH <gregkh@suse.de> wrote:
> > On Tue, Nov 01, 2011 at 04:41:40PM +0100, David Herrmann wrote:
> >> Hi Dmitry and Greg
> >>
> >> It doesn't make sense to take a reference to our own module. When we call
> >> module_put(THIS_MODULE) we cannot make sure that our module is still alive when
> >> this function returns. Therefore, module_put() will return to invalid memory and
> >> our input_dev_release() function is no longer available.
> >>
> >> It would be interesting if Greg could elaborate what else we could do to replace
> >> this module-refcount as it is definitely needed here. However, "struct device"
> >> doesn't provide an owner field so there is no way for us to let the device core
> >> keep a reference to our module.
> >
> > For a bus module, yes, this is needed, so don't remove these calls, it's
> > wrong to do so.
> >
> >> I have no clue what to do here but the current implementation is definitely
> >> unsafe so this is marked as RFC. Currently, the device_attributes probably
> >> already keep a reference to our module so applying this patch would probably not
> >> break anything, however, this does not look like something we can trust on.
> >
> > Yes it is, why do you think it isn't?
> >
> >> My bug-thread kind of died (https://lkml.org/lkml/2011/10/29/75) so I now try to
> >> show this with an example here.
> >
> > It died due to me traveling, sorry, I'll respond to them now.
> 
> No problem. This is why I've resent this with an example.
> 
> > I fail to see what the real problem you are trying to solve here is.  Is
> > there something with the way the kernel works today that you are having
> > problems with?  What is driving this?
> 
> I am working on converting the hci stack to properly use sysfs APIs +
> struct device. And my problem simply is the following:
> 
> @@ -1417,8 +1417,6 @@ static void input_dev_release(struct device *device)
>        input_mt_destroy_slots(dev);
>        kfree(dev->absinfo);
>        kfree(dev);
> -
> -       module_put(THIS_MODULE);
>  }
> 
> If this module_put(THIS_MODULE) is needed as you said, then I can be
> sure that this call does not release the last module-reference, can I?
> Otherwise, this call may return to invalid memory.
> 
> But, if I can be sure that this doesn't release the last reference,
> why take this reference at all?
> 
> The only reason I can think of is, that some other code calls
> __get_module() after I called it, and it calls put_module() after I
> call it. In all other cases, taking/releasing this reference is
> needless as we can trust that our caller protects us.
> 
> In other words, which code does this module_get/put() protect? It
> cannot protect input_dev_release() because module_put(THIS_MODULE) is
> called *inside* input_dev_release(). I need some way to protect the
> input_dev_release() callback-code outside of this callback.
> Or can I go sure that the caller of the input_dev_callback() takes a
> reference to my module before calling this and releases it after? (But
> then I wonder how does it know what module I am?)
> 
> If this is the recommended way to protect the device_release
> callbacks, I will just copy it into hci_dev, but currently I really
> don't get why these are needed.
> If you can tell me an example why the input-core breaks if this patch
> is applied, I can probably better explain to you, why I think it still
> breaks without this patch applied.
> 
> 
> 
> For instance see my example:
> 
> 1)
> input-core-module is loaded
> 2)
> input-core-module creates a new input device and increases
> module-refcnt inside input_allocate_device()
> 4)
> another subsystem grabs the "struct device" and increases its refcnt
> (for any reason...)
> 5)
> input-core-module destroys the input-device but it still stays alive
> until the other subsystem releases its refcnt of the "struct device".
> 6)
> input-core-module is unloaded
> This doesn't succeed as the still living input-device has a module-refcnt
> 7)
> the other subsystem releases its refcnt of the input-device
> 8)
> The input-device is destroyed and its _release_ function is called
> The release function destroys the input-device *and* frees the last
> module-refcnt. Then *boom*, the release function cannot return as it
> is no longer available as described above.

The analysis is right except that this condition is very unlikely to
trigger. By removing __module_get/module_put you are making this problem
much much easier to hit.

> 
> My solution: Some parent subsystem of us must take and release this
> module-refcnt instead of us, so this bug doesn't occur.
> Or: We simply wait for all these input_devices to be released before
> exiting input_exit().

How would you know that all input devices are released in the sense
that all threads left (as in exited) all code in input.c completely?

-- 
Dmitry
