Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab2GFJTF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 05:19:05 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:48332 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932072Ab2GFJS5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 05:18:57 -0400
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?iso-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>
Date: Fri, 6 Jul 2012 11:18:38 +0200
Subject: RE: [RFC 4/4] remoteproc: Add driver for STE Modem
Thread-Topic: [RFC 4/4] remoteproc: Add driver for STE Modem
Thread-Index: Ac1ap6tN5oXVNupeRxWWaMy5FJggwgAsBkpA
Message-ID: <81C3A93C17462B4BBD7E272753C10579232F92EFE2@EXDCVYMBSTM005.EQ1STM.local>
References: <1340375470-13097-1-git-send-email-sjur.brandeland@stericsson.com>
 <1340375470-13097-5-git-send-email-sjur.brandeland@stericsson.com>
 <CAK=WgbbG2nHH7+rm6CoR=VhiXVQT3-2VqJYLswmg9EshWu_=EA@mail.gmail.com>
 <81C3A93C17462B4BBD7E272753C10579232F86BE52@EXDCVYMBSTM005.EQ1STM.local>
 <CAK=Wgbb_pAx9Kfwbh23k=62vQUx5vnVpwe3q50BY=KwAkLC=ng@mail.gmail.com>
In-Reply-To: <CAK=Wgbb_pAx9Kfwbh23k=62vQUx5vnVpwe3q50BY=KwAkLC=ng@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

> Can you please explain a bit the hardware (in the context of those
> bits) ? E.g. what happens when we flip one of those bits ? Does it
> generate an interrupt or is it just a logical bit which maintains the
> state of the channel ?

The simple story is that when Host writes a bit indicated with TX-mask
it generates an interrupt on the modem-side. And likewise when the
modem writes a bit indicated with RX mask the Host will receive an
interrupt.

>> Agree, it would be better to have some generic access functions to get
>> what notification IDs are used for each channel. One option could be
>> to define a iterator, traversing over all the resource entries.
>> In that way I could just pick up the notification IDs in the resource
>> entries. Or we could generalize the Notification-ID iteration.
> 
> What if we make remoteproc export the largest notification id (to the
> low level driver) ? since those notification-id numbers are continuous
> and starting from zero, I suspect that knowing the largest used id
> number may just be enough info for you to configure those hw bits.

Yes, if you can guarantee this, I could make a very simple solution.

> >> This module is using dynamic symbol lookup quite a lot. This really
> >> stands out because it's quite uncommon.
...
> Why is it necessary ? Can we just use static symbols instead (i.e.
> just invoke the functions directly and let the linker do its job) ?

Ok, I guess a more standard way to solve this is use #ifdef's and
dummy inline functions in the header file instead. I'll do that 
next time around then.

...
> Sure. The bigger picture, though, is a random user space context which
> needs the remote processor powered up. And when we expose such an
> interface to user space, we can't trust it to do the right thing, and
> must be able to cope with it crashing horribly.
> 
>>> It seems to me that a char device will solve these issues: we can use
>>> ioctl to control the power, if the user crashes we'll know about it
>>> via the release handler, and if the remote processor crashes we can
>>> let the user know by sending it a notification for it to read via the fd.
>>
>> Currently, I don't see the need for this for the STE modem. (anyway my
>> impression was that IOCTLs was going out of fashion, but I guess
>> you could argue the same about new sysfs entries ;-)
> 
> I suspect that a char device is the only sane way to expose this
> interface without relying on the user space doing the right thing...
> we just can't tell who's going to use this interface once we expose
> it, and how good their programming skills are :)

OK, we can do it this way as well. It feels a bit over-the-top in my case,
but I understand where you're coming from any why.

>> The Virtio-Console seems a bit difficult here. If I read the code
>> right in the Virtio-Console driver, the only way to make it release
>> it's virtio queues is to trigger the Virtio-Consonle remove function
>> (i.e. unregister the Virtio Device).
>>
>> So it seems that we need to force an unregistration of the virtio devices,
>> in order to make it release it's queues.
>>
>> Currently it looks like this only can be done with rproc_unregister.
>> This is probably not what we want, so from my point of view we need
>> a some new functionality to trigger unregistration of the virtio
>> devices from ste-remoteproc.
> 
> Yeah, no code is needed; something like this should do the trick:
> 
> root@omap4430-panda:/sys/bus/virtio/drivers/virtio_console# echo
> virtio1 > unbind
> 
> (replace "virtio1" with the name of the virtio device, in your system,
> that's bound to virtio_console)

Sweet, that's nice and simple.


Regards,
Sjur
