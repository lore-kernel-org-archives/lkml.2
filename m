Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145Ab2JAG5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 02:57:23 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:53329 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751932Ab2JAG5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 02:57:22 -0400
From: Arun MURTHY <arun.murthy@stericsson.com>
To: anish singh <anish198519851985@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Date: Mon, 1 Oct 2012 08:57:04 +0200
Subject: RE: [PATCHv4 1/4] modem_shm: Add Modem Access Framework
Thread-Topic: [PATCHv4 1/4] modem_shm: Add Modem Access Framework
Thread-Index: Ac2fnrMKICLwI5B4RbygjzGXgN0EtwAATvmw
Message-ID: <F45880696056844FA6A73F415B568C695B6962C1CD@EXDCVYMBSTM006.EQ1STM.local>
References: <1348819504-1303-1-git-send-email-arun.murthy@stericsson.com>
	<1348819504-1303-2-git-send-email-arun.murthy@stericsson.com>
	<20120928160045.GD2625@kroah.com>
	<F45880696056844FA6A73F415B568C695B6962C153@EXDCVYMBSTM006.EQ1STM.local>
 <CAK7N6vpXfhb0KhMfqxbcSQqT=qPcMS06OdaG9kNsWMqiiepLTQ@mail.gmail.com>
In-Reply-To: <CAK7N6vpXfhb0KhMfqxbcSQqT=qPcMS06OdaG9kNsWMqiiepLTQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q916vSma023109

> On Mon, Oct 1, 2012 at 11:00 AM, Arun MURTHY
> <arun.murthy@stericsson.com> wrote:
> >> On Fri, Sep 28, 2012 at 01:35:01PM +0530, Arun Murthy wrote:
> >> > +#include <linux/module.h>
> >> > +#include <linux/slab.h>
> >> > +#include <linux/err.h>
> >> > +#include <linux/printk.h>
> >> > +#include <linux/modem_shm/modem.h>
> >> > +
> >> > +static struct class *modem_class;
> >>
> >> What's wrong with a bus_type instead?
> >
> > Can I know the advantage of using bus_type over class?
> >
> >>
> >> > +static int __modem_is_requested(struct device *dev, void *data) {
> >> > +   struct modem_desc *mdesc = (struct modem_desc *)data;
> >> > +
> >> > +   if (!mdesc->mclients) {
> >> > +           printk(KERN_ERR "modem_access: modem description is
> >> NULL\n");
> >> > +           return 0;
> >> > +   }
> >> > +   return atomic_read(&mdesc->mclients->cnt);
> >> > +}
> >> > +
> >> > +int modem_is_requested(struct modem_desc *mdesc) {
> >> > +   return class_for_each_device(modem_class, NULL, (void *)mdesc,
> >> > +__modem_is_requested); }
> >>
> >> Where is the documentation for your public api functions like this?
> >
> > Sure will include this in the next patchset.
> >
> >>
> >> > +
> >> > +int modem_release(struct modem_desc *mdesc) {
> >> > +   if (!mdesc->release)
> >> > +           return -EFAULT;
> >> > +
> >> > +   if (modem_is_requested(mdesc)) {
> >> > +           atomic_dec(&mdesc->mclients->cnt);
> >> > +           if (atomic_read(&mdesc->use_cnt) == 1) {
> >> > +                   mdesc->release(mdesc);
> >> > +                   atomic_dec(&mdesc->use_cnt);
> >> > +           }
> >>
> >> Eeek, why aren't you using the built-in reference counting that the
> >> struct device provided to you, and instead are rolling your own?
> >> This happens in many places, why?
> >
> > My usage of counters over here is for each modem there are many clients.
> > Each of the clients will have a ref to modem_desc. Each of them use
> > this for requesting and releasing the modem. One counter for tracking
> > the request and release for each client which is done by variable 'cnt' in
> struct clients.
> > The counter use_cnt is used for tracking the modem request/release
> > irrespective of the clients and counter cli_cnt is used for
> > restricting the modem_get to the no of clients defined in no_clients.
> >
> > So totally 3 counter one for restricting the usage of modem_get by
> > clients, second for restricting modem request/release at top level,
> > and 3rd for restricting modem release/request for per client per modem
> basis.
> >
> > Can you let me know if the same can be achieved by using built-in ref
> > counting?
> Is this your model:
> You have a modem device which can be requested by many clients.This
> clients can register for a particular service which this modem provides and
> then after that if it client doesn't need this service then it will call un-register.

Let me correct a bit over here:
There are many clients, yes correct but the operations performed are only two,
i.e modem request and modem release. This is something like waking up the
modem and let modem to sleep.
The traffic of this request and release is too high.

So irrespective of the requests/releases made to the MAF framework, the MAF
should perform the operation request/release only once.

So each and every time handling list consumes time. 
Let me brief the context, this is a single chip modem and ape, basically used in
mobile, tablets etc. So the traffic in ape-modem communication is too high and
also time critical. If it bound to exceed the time, or delay might end up in buffer
full. Thatâ€™s the reason I have made it as simple as possible.

Thanks and Regards,
Arun R Murthy
------------------
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
