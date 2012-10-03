Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124Ab2JCEcL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 00:32:11 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:39983 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750940Ab2JCEcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 00:32:06 -0400
From: Arun MURTHY <arun.murthy@stericsson.com>
To: anish singh <anish198519851985@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Date: Wed, 3 Oct 2012 06:31:44 +0200
Subject: RE: [PATCHv4 1/4] modem_shm: Add Modem Access Framework
Thread-Topic: [PATCHv4 1/4] modem_shm: Add Modem Access Framework
Thread-Index: Ac2hHhBgaFBIcraQQuelf/W19/jKZAAAUvqw
Message-ID: <F45880696056844FA6A73F415B568C695B6962CC98@EXDCVYMBSTM006.EQ1STM.local>
References: <1348819504-1303-1-git-send-email-arun.murthy@stericsson.com>
	<1348819504-1303-2-git-send-email-arun.murthy@stericsson.com>
	<20120928160045.GD2625@kroah.com>
	<F45880696056844FA6A73F415B568C695B6962C153@EXDCVYMBSTM006.EQ1STM.local>
	<20121001155940.GA1957@kroah.com>
	<F45880696056844FA6A73F415B568C695B6962CC8C@EXDCVYMBSTM006.EQ1STM.local>
 <CAK7N6vqpHvi0R4eY0NPJ90Yu1_sVXOri-qOU5FPhp_5XcY3z0w@mail.gmail.com>
In-Reply-To: <CAK7N6vqpHvi0R4eY0NPJ90Yu1_sVXOri-qOU5FPhp_5XcY3z0w@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q934WIZX003176

> On Wed, Oct 3, 2012 at 9:24 AM, Arun MURTHY
> <arun.murthy@stericsson.com> wrote:
> >> On Mon, Oct 01, 2012 at 07:30:38AM +0200, Arun MURTHY wrote:
> >> > > On Fri, Sep 28, 2012 at 01:35:01PM +0530, Arun Murthy wrote:
> >> > > > +#include <linux/module.h>
> >> > > > +#include <linux/slab.h>
> >> > > > +#include <linux/err.h>
> >> > > > +#include <linux/printk.h>
> >> > > > +#include <linux/modem_shm/modem.h>
> >> > > > +
> >> > > > +static struct class *modem_class;
> >> > >
> >> > > What's wrong with a bus_type instead?
> >> >
> >> > Can I know the advantage of using bus_type over class?
> >>
> >> You have devices living on a bus, and it's much more descriptive than
> >> a class (which we are going to eventually get rid of one of these days...).
> >>
> >> Might I ask why you choose a class over a bus_type?
> >
> > Basically my requirement is to create a central entity for accessing
> > and releasing modem from APE. Since this is done by different clients
> > the central entity should be able to handle the request and play
> > safely, since this has more affect in system suspend and deep sleep.
> > Using class helps me in achieving this and also create an entry to
> > user space which can be used in the later parts. Moreover
> You can have that same mechanism work for bus_type as well.
> > this not something like a bus or so, so I didn't use bus instead went
> > with a simple class approach.
> >
> >>
> >> > > > +int modem_release(struct modem_desc *mdesc) {
> >> > > > +       if (!mdesc->release)
> >> > > > +               return -EFAULT;
> >> > > > +
> >> > > > +       if (modem_is_requested(mdesc)) {
> >> > > > +               atomic_dec(&mdesc->mclients->cnt);
> >> > > > +               if (atomic_read(&mdesc->use_cnt) == 1) {
> >> > > > +                       mdesc->release(mdesc);
> >> > > > +                       atomic_dec(&mdesc->use_cnt);
> >> > > > +               }
> >> > >
> >> > > Eeek, why aren't you using the built-in reference counting that
> >> > > the struct device provided to you, and instead are rolling your own?
> >> > > This happens in many places, why?
> >> >
> >> > My usage of counters over here is for each modem there are many
> clients.
> >> > Each of the clients will have a ref to modem_desc. Each of them use
> >> > this for requesting and releasing the modem. One counter for
> >> > tracking the request and release for each client which is done by
> >> > variable 'cnt' in
> >> struct clients.
> >> > The counter use_cnt is used for tracking the modem request/release
> >> > irrespective of the clients and counter cli_cnt is used for
> >> > restricting the modem_get to the no of clients defined in no_clients.
> >> >
> >> > So totally 3 counter one for restricting the usage of modem_get by
> >> > clients, second for restricting modem request/release at top level,
> >> > and 3rd for restricting modem release/request for per client per
> >> > modem
> >> basis.
> >> >
> >> > Can you let me know if the same can be achieved by using built-in
> >> > ref counting?
> >>
> >> Yes, because you don't need all of those different levels, just stick
> >> with one and you should be fine. :)
> >>
> >
> > No, checks at all these levels are required, I have briefed out the need also.
> > This will have effect on system power management, i.e suspend and deep
> > sleep.
> > We restrict that the drivers should request modem only once and
> > release only once, but we cannot rely on the clients hence a check for
> > the same has to be done in the MAF. Also the no of clients should be
> > defined and hence a check for the same is done in MAF. Apart from all
> > these the requests coming from all the clients is to be accumulated
> > and based on that modem release or access should be performed, hence
> so.
> I think best way to deal with this is:
> Define a new bus type and have your clients call the bus exposed
> functionality when ever they need a service.So in your case it would be
> request and release only AND when all of your clients have released the bus
> then you can do the cleanup i.e. switch off the modem and on added
> advantage of making it a bus_type would be that you can do the reference
> counting in your bus driver.
> 
> Designing is not my forte but I feel this way you can solve the problem at
> hand.
> Please feel free to correct me.I would really appreciate it.

At the very first look itself this MAF is not a bus by its technical meaning, so
why to use bus_type is the point that I have.

Thanks and Regards,
Arun R Murthy
------------------
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
