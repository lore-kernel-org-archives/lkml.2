Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab2GBPWZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 11:22:25 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:58406 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752807Ab2GBPWX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 11:22:23 -0400
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?iso-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>
Date: Mon, 2 Jul 2012 17:22:12 +0200
Subject: RE: [RFC 4/4] remoteproc: Add driver for STE Modem
Thread-Topic: [RFC 4/4] remoteproc: Add driver for STE Modem
Thread-Index: Ac1XfTRYLJAe0RUvRxqkFgQ4vy/e5QADQC4g
Message-ID: <81C3A93C17462B4BBD7E272753C10579232F86BE52@EXDCVYMBSTM005.EQ1STM.local>
References: <1340375470-13097-1-git-send-email-sjur.brandeland@stericsson.com>
 <1340375470-13097-5-git-send-email-sjur.brandeland@stericsson.com>
 <CAK=WgbbG2nHH7+rm6CoR=VhiXVQT3-2VqJYLswmg9EshWu_=EA@mail.gmail.com>
In-Reply-To: <CAK=WgbbG2nHH7+rm6CoR=VhiXVQT3-2VqJYLswmg9EshWu_=EA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

> Cool, thanks for posting this.

Well thank you for your patience reviewing this.

> >  obj-$(CONFIG_STE_MODEM_RPROC)          += ste_modem_remoteproc.o
> > +ste_modem_remoteproc-y                         += ste_modem_rproc.o
> >  ste_modem_remoteproc-y                         +=
> remoteproc_ste_modem_loader.o
> 
> Just wondering - do we need the loader ops to be a separate file ? is
> it only going to be used by this module or do you foresee additional
> users in the future ?

No I don't, squashing this together is a good idea.


> > +/* Maxium number of "channels" */
> > +#define MAX_VQS 14
> 
> Can you explain a bit the background behind this number, and how vqs
> and vqids are generally handled by the ste modem?

The HW Kick mechanism is implemented using a 32-bit register.
These 32 bits are then divided in three groups, status from modem,
modem-to-host and host-to-modem notifications. 
The notifications can be distributed among the remaining 28 bits
at our own choice, but we're simply assuming 14 different notification IDs
in each direction. Hence we can support max 14 Virtio Queues.

> > +/* Setup the kick API for notification subscriptions */
> > +static int ste_rproc_subscribe_to_kicks(struct rproc *rproc)
> > +{
> > +       int i, err;
> > +       u32 txmask = 0, rxmask = 0;
> > +       int (*kick_subscribe)(int notifyid,
> > +                      void (*notify_cb)(int notifyid, void *data),
> void *data);
> > +       int (*notifyid_alloc)(u32 setter_mask, u32 getter_mask);
> > +
> > +       /*
> > +        * We need to declare for the HW what notification IDs
> > +        * we're going to use.
> 
> Can you explain why is this needed ? what happens when we call
> notifyid_alloc(rxmask, txmask) ?

As mentioned above we have 28 bits for modem-to-host and
host-to-modem notifications. How we allocate the bits are
configurable, but we need to tell the HW what bit is used 
in what direction. You may argue that we could just take
14+14, but we would need some way of sanity checking the
mapping to notification-IDs anyhow.

> > +        * notification IDs used for RX and TX by iterating over
> > +        * the notification IDs.
> > +        */
> > +       idr_for_each(&rproc->notifyids, ste_rproc_set_vqid, &rxmask);
> 
> If this really is needed, we might want some help from the remoteproc
> framework to do this, because it already has all the required info.
> 
> It'd be better if we don't fiddle with its internal structures,
> because doing say may make it harder for it to evolve.

Agree, it would be better to have some generic access functions to get
what notification IDs are used for each channel. One option could be
to define a iterator, traversing over all the resource entries.
In that way I could just pick up the notification IDs in the resource
entries. Or we could generalize the Notification-ID iteration.

> > +       notifyid_alloc = symbol_get(stemod_kick_notifyid_alloc);
> 
> This module is using dynamic symbol lookup quite a lot. This really
> stands out because it's quite uncommon.
> 
> Why is it necessary ? Can we use static symbols instead ?
>
> Can you share the code for those symbols as well ?

Unfortunately this driver for the HW-kicks is not yet submitted upstream.
It's not up to me, but I'll check with Linus Walleij about what the plans are...

> > +       if (rproc == NULL)
> > +               return NULL;
> > +       return rproc->priv;
> 
> Might be nicer to just
> 
>     return rproc ? rproc->priv : NULL;

Agree, thanks.


> There's three issues that bother me here:
> 
> 1. It feels like this kind of functionality isn't limited to the STE
> modem, so we better have it implemented in the remoteproc framework.

I'm actually not sure this is a good idea. Usually it is not good to
generalize from only one example. It might be that the STE modem 
has quite different requirements than other remote-proc users.
Not everybody has to unify the approach seen from user-space across
different interface technologies (HSI, HSIC, Shared Memory, and UART).
And not everybody has a 3-stage modem boot protocol to care about...

 
> 2. I'm not convinced that sysfs is an appropriate interface for
> controlling the remote processor:
> - if the remote processor crashes, the user isn't informed about it,
> so it won't refresh its state even if a successful recovery took place

Hm, what do you mean by "user"? A Virtio-Driver or user-space?
A recovery involves a 3-stage boot for STE-modems, there won't be any
recovery without user-space involvement in running the 3-stage boot
process ;-)

> - if the user space crashes, we don't get informed about it, and the
> remote processor can erroneously stay powered on indefinitely

This is not a problem for the STE modem. The user space process controlling
the modem is running as a daemon. If this daemon crashes it is automatically
restarted and forces a modem reboot in order to bring user-space daemon and
modem into sync.

> It seems to me that a char device will solve these issues: we can use
> ioctl to control the power, if the user crashes we'll know about it
> via the release handler, and if the remote processor crashes we can
> let the user know by sending it a notification for it to read via the
> fd.

Currently, I don't see the need for this for the STE modem. (anyway my
impression was that IOCTLs was going out of fashion, but I guess
you could argue the same about new sysfs entries ;-) 

> 3. I'm not sure we want to let the user space directly control the
> power of the remote processor: what if it decides to power off the
> rproc while other kernel users utilize it?
>
> We might want to change the semantics of the interface to just allow
> the user to increase/decrease a power reference count instead of
> directly booting/shutting it down.

In this case we need a way to make the virtio-drivers release the
virtio-queues in order to decrement the refcount, right? 

The Virtio-Console seems a bit difficult here. If I read the code
right in the Virtio-Console driver, the only way to make it release
it's virtio queues is to trigger the Virtio-Consonle remove function
(i.e. unregister the Virtio Device).

So it seems that we need to force an unregistration of the virtio devices,
in order to make it release it's queues.

Currently it looks like this only can be done with rproc_unregister.
This is probably not what we want, so from my point of view we need
a some new functionality to trigger unregistration of the virtio
devices from ste-remoteproc.

But I might off here and or missed something in my code-reading...

> This assumes a certain order of allocations which takes place inside
> the remoteproc framework, and may break if things change (e.g.
> https://lkml.org/lkml/2012/5/20/35)
> 
> Instead, we might want the remoteproc framework to help here. The best
> suggestion I have is to "teach" remoteproc about different
> purpose-specific memory regions, and ask it to allocate memory only
> from the relevant region (if one exists). This will prevent different
> order of allocations from using memory we must reserve for certain
> purposes.
> 
> Ludovic is working on such patch, you might want to take its latest
> version from him.

Ok, looking forward seeing some patches on this then Ludovic :-).

Perhaps another option is to use dma_mark_declared_memory_occupied(),
it seems to be able to force allocation at a certain device address.

Finally - thank you for spending time on code reading and helping
me forward with the STE rproc driver.

Thanks,
Sjur
