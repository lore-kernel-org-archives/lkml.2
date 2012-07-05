Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab2GEMNz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:13:55 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:47707 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab2GEMNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:13:53 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.10.162]
In-Reply-To: <81C3A93C17462B4BBD7E272753C10579232F86BE52@EXDCVYMBSTM005.EQ1STM.local>
References: <1340375470-13097-1-git-send-email-sjur.brandeland@stericsson.com>
 <1340375470-13097-5-git-send-email-sjur.brandeland@stericsson.com>
 <CAK=WgbbG2nHH7+rm6CoR=VhiXVQT3-2VqJYLswmg9EshWu_=EA@mail.gmail.com> <81C3A93C17462B4BBD7E272753C10579232F86BE52@EXDCVYMBSTM005.EQ1STM.local>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 5 Jul 2012 15:13:29 +0300
Message-ID: <CAK=Wgbb_pAx9Kfwbh23k=62vQUx5vnVpwe3q50BY=KwAkLC=ng@mail.gmail.com>
Subject: Re: [RFC 4/4] remoteproc: Add driver for STE Modem
To: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Mon, Jul 2, 2012 at 6:22 PM, Sjur BRENDELAND
<sjur.brandeland@stericsson.com> wrote:
> Well thank you for your patience reviewing this.

Sure np !

>> > +       /*
>> > +        * We need to declare for the HW what notification IDs
>> > +        * we're going to use.
>>
>> Can you explain why is this needed ? what happens when we call
>> notifyid_alloc(rxmask, txmask) ?
>
> As mentioned above we have 28 bits for modem-to-host and
> host-to-modem notifications. How we allocate the bits are
> configurable, but we need to tell the HW what bit is used
> in what direction.

Can you please explain a bit the hardware (in the context of those
bits) ? E.g. what happens when we flip one of those bits ? Does it
generate an interrupt or is it just a logical bit which maintains the
state of the channel ?

>> > +        * notification IDs used for RX and TX by iterating over
>> > +        * the notification IDs.
>> > +        */
>> > +       idr_for_each(&rproc->notifyids, ste_rproc_set_vqid, &rxmask);
>>
>> If this really is needed, we might want some help from the remoteproc
>> framework to do this, because it already has all the required info.
>>
>> It'd be better if we don't fiddle with its internal structures,
>> because doing say may make it harder for it to evolve.
>
> Agree, it would be better to have some generic access functions to get
> what notification IDs are used for each channel. One option could be
> to define a iterator, traversing over all the resource entries.
> In that way I could just pick up the notification IDs in the resource
> entries. Or we could generalize the Notification-ID iteration.

What if we make remoteproc export the largest notification id (to the
low level driver) ? since those notification-id numbers are continuous
and starting from zero, I suspect that knowing the largest used id
number may just be enough info for you to configure those hw bits.

>> > +       notifyid_alloc = symbol_get(stemod_kick_notifyid_alloc);
>>
>> This module is using dynamic symbol lookup quite a lot. This really
>> stands out because it's quite uncommon.
>>
>> Why is it necessary ? Can we use static symbols instead ?
>>
>> Can you share the code for those symbols as well ?
>
> Unfortunately this driver for the HW-kicks is not yet submitted upstream.
> It's not up to me, but I'll check with Linus Walleij about what the plans are...

Sure, that's fine, but the extensive symbol_get() usage in this driver
is still quite surprising.

Why is it necessary ? Can we just use static symbols instead (i.e.
just invoke the functions directly and let the linker do its job) ?

>> There's three issues that bother me here:
>>
>> 1. It feels like this kind of functionality isn't limited to the STE
>> modem, so we better have it implemented in the remoteproc framework.
>
> I'm actually not sure this is a good idea. Usually it is not good to
> generalize from only one example. It might be that the STE modem
> has quite different requirements than other remote-proc users.
> Not everybody has to unify the approach seen from user-space across
> different interface technologies (HSI, HSIC, Shared Memory, and UART).
> And not everybody has a 3-stage modem boot protocol to care about...

Sure, 3-stage modem boot protocol sounds very specific to your use case.

But the generalization of your requirement isn't very
platform-specific: in essence, it boils down to "we need to let user
space clients be able to power up the remote processor", and the
solution for that might be useful for others too.

Moreover, adding a user space interface in a low level driver might
really do raise a few eyebrows, especially in this new era of
convergence. It's better to add it once, in a generic framework, so
others could use it, rather than have people duplicate it (possibly in
slightly different ways) in their drivers.

>> 2. I'm not convinced that sysfs is an appropriate interface for
>> controlling the remote processor:
>> - if the remote processor crashes, the user isn't informed about it,
>> so it won't refresh its state even if a successful recovery took place
>
> Hm, what do you mean by "user"? A Virtio-Driver or user-space?
> A recovery involves a 3-stage boot for STE-modems, there won't be any
> recovery without user-space involvement in running the 3-stage boot
> process ;-)

I meant user space here. But I'm not only thinking about your specific
use case, but also generally about what people can do with this new
user space interface.

You may have the recovery use case in mind now, but the generalization
of this user space interface is "let user space be able to power up
the remote processor".

This might actually be useful for others who have other user space use
cases, but we must make sure the interface is, or can be made, capable
of dealing with crashes.

>> - if the user space crashes, we don't get informed about it, and the
>> remote processor can erroneously stay powered on indefinitely
>
> This is not a problem for the STE modem. The user space process controlling
> the modem is running as a daemon. If this daemon crashes it is automatically
> restarted and forces a modem reboot in order to bring user-space daemon and
> modem into sync.

Sure. The bigger picture, though, is a random user space context which
needs the remote processor powered up. And when we expose such an
interface to user space, we can't trust it to do the right thing, and
must be able to cope with it crashing horribly.

>> It seems to me that a char device will solve these issues: we can use
>> ioctl to control the power, if the user crashes we'll know about it
>> via the release handler, and if the remote processor crashes we can
>> let the user know by sending it a notification for it to read via the
>> fd.
>
> Currently, I don't see the need for this for the STE modem. (anyway my
> impression was that IOCTLs was going out of fashion, but I guess
> you could argue the same about new sysfs entries ;-)

I suspect that a char device is the only sane way to expose this
interface without relying on the user space doing the right thing...
we just can't tell who's going to use this interface once we expose
it, and how good their programming skills are :)

>> 3. I'm not sure we want to let the user space directly control the
>> power of the remote processor: what if it decides to power off the
>> rproc while other kernel users utilize it?
>>
>> We might want to change the semantics of the interface to just allow
>> the user to increase/decrease a power reference count instead of
>> directly booting/shutting it down.
>
> In this case we need a way to make the virtio-drivers release the
> virtio-queues in order to decrement the refcount, right?
>
> The Virtio-Console seems a bit difficult here. If I read the code
> right in the Virtio-Console driver, the only way to make it release
> it's virtio queues is to trigger the Virtio-Consonle remove function
> (i.e. unregister the Virtio Device).
>
> So it seems that we need to force an unregistration of the virtio devices,
> in order to make it release it's queues.
>
> Currently it looks like this only can be done with rproc_unregister.
> This is probably not what we want, so from my point of view we need
> a some new functionality to trigger unregistration of the virtio
> devices from ste-remoteproc.

Yeah, no code is needed; something like this should do the trick:

root@omap4430-panda:/sys/bus/virtio/drivers/virtio_console# echo
virtio1 > unbind

(replace "virtio1" with the name of the virtio device, in your system,
that's bound to virtio_console)

>> This assumes a certain order of allocations which takes place inside
>> the remoteproc framework, and may break if things change (e.g.
>> https://lkml.org/lkml/2012/5/20/35)
>>
>> Instead, we might want the remoteproc framework to help here. The best
>> suggestion I have is to "teach" remoteproc about different
>> purpose-specific memory regions, and ask it to allocate memory only
>> from the relevant region (if one exists). This will prevent different
>> order of allocations from using memory we must reserve for certain
>> purposes.
>>
>> Ludovic is working on such patch, you might want to take its latest
>> version from him.
>
> Ok, looking forward seeing some patches on this then Ludovic :-).
>
> Perhaps another option is to use dma_mark_declared_memory_occupied(),
> it seems to be able to force allocation at a certain device address.
>
> Finally - thank you for spending time on code reading and helping
> me forward with the STE rproc driver.

Sure, thanks for helping make the kernel better :)

Ohad.
