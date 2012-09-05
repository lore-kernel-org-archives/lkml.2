Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab2IEQZg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 12:25:36 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45007 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab2IEQZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 12:25:35 -0400
Date: Wed, 5 Sep 2012 17:30:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ming Lei <ming.lei@canonical.com>
Cc: Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kay Sievers <kay@vrfy.org>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: A workaround for request_firmware() stuck in module_init
Message-ID: <20120905173011.7a1111f0@pyramind.ukuu.org.uk>
In-Reply-To: <CACVXFVO+OgvLoFMcDD0gcQnbzUW=SyR=wiSMyT-FtpjWW5sWdw@mail.gmail.com>
References: <s5hd3222azc.wl%tiwai@suse.de>
	<CACVXFVP-A7M2dG9bOvAnpzR60=iTYSw=WCOEwgo9KeuioxKanQ@mail.gmail.com>
	<s5hd32122hw.wl%tiwai@suse.de>
	<CACVXFVNE1GHAQJTrQy2AYgUBfq5kv42EjJJ7J+2q3jzXG-E=MQ@mail.gmail.com>
	<s5hpq61j9qx.wl%tiwai@suse.de>
	<CACVXFVOu86J5=1DLDrpLCd-pyk1jm2HT7ks1uzCXm9nURCRo2A@mail.gmail.com>
	<20120905140304.5c5c58a4@pyramind.ukuu.org.uk>
	<CACVXFVO+OgvLoFMcDD0gcQnbzUW=SyR=wiSMyT-FtpjWW5sWdw@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, deferring the load may fix the built in case, but which also
> introduces much work on changes of current drivers. In fact,
> there are few guys who complained the built in case.

It fixes the modular case too.

> The current complaint is from that udev may timeout request inside probe()
> when drivers are built as module. As pointed by Linus and Benjamin,
> it is better to fix it in udev, and looks not good to introduce great changes
> (such as Takashi's defer probe patch) in kernel to workaround the problem.

It's not about a workaround but about doing it properly for the long term
and doing it in one place. It's also not a "great change", its a small
change.

> Linus has said that he doesn't like to load firmware in probe(), but in some
> situation the drivers have to load firmware in its probe():

You don't want to load firmware in probe because of the locking problems
- you can trigger a load of another device on the same bus - the defer
  dodges that nicely
 
> In fact, it is better for drivers to load firmware just when user wants to use
> the device, and some drivers have already changed to load firmware in
> the open() callback.

For those devices sure but they are if anything a minority as far as I
can see.

> So looks loading firmware always before probe in driver core is
> against the above idea.

I never said "always"

> > firmware load off and only when the firmware had loaded would it call
> > ->probe with dev->firmware pointing at a refcounted firmware struct.
> 
> IMO, introduce refcount for the firmware doesn't make sense. The lifetime
> of firmware is completely different with lifetime of driver or device:

Exactly. Which is why the moment you have multiple devices you need
refcounts. It's also why the propsoal included a 

dev_discard_firmware()

so you an instance can drop its firmware reference if it doesn't need it
post probe.

>     - firmware needn't be kept in memory in the device/driver's lifetime, and
>       should be loaded just in need, and be released after downloading
>       it into device.

You broke suspend/resume for lots of devices.

>    - sometimes devices may disappear, but it is better to keep the
>      firmware in memory, for example, device may be disconnected
>      during resume but will come back later.

So the moment you have multiple instances of a device with their own
lifetime and you have the need to pin it sometimes you need a refcount

> As said above, ref/deref on probe/remove is not a good idea since
> we needn't to keep the firmware in memory during the whole device/driver
> lifetime.

Often you do. And in the case you don't you still have to deal with
multiple probes doing asynchronous loads of the same firmware so you want
to do matching and refcounting. It's pretty much essential.

The other big value apart from making it harder for driver writers to
screw up is that it takes some of the control and puts it in one place.
That means you can change it later easily not in each driver.

This is enabling for device drivers. With no intention of offending
driver authors the reality is that we should have driver interfaces that

- work the right way by default
- allow driver authors to do things themselves if they need to instead
  (ie opt out)
- are hard to f**k up

because we want it to just work.

Alan
