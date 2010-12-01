Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab0LAJyv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 04:54:51 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55597 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab0LAJyu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 04:54:50 -0500
MIME-Version: 1.0
In-Reply-To: <20101201010011.GB31571@kroah.com>
References: <1290594227.4446.12.camel@concordia> <20101124120818.7951bcb4@udp111988uds.am.freescale.net>
 <20101124182353.GA10589@suse.de> <1290638647.14502.10.camel@concordia>
 <20101129214439.GA9830@kroah.com> <4CF42053.8060801@freescale.com>
 <20101129223030.GA14663@kroah.com> <4CF42B02.1030009@freescale.com>
 <20101130032915.GA13386@kroah.com> <4CF551A0.7030200@freescale.com> <20101201010011.GB31571@kroah.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 1 Dec 2010 10:54:34 +0100
Message-ID: <AANLkTi=foTZsnNBgYYAZySPWuwueEraeXGTQz+1aefKm@mail.gmail.com>
Subject: Re: How do I choose an arbitrary minor number for my tty device?
To: Greg KH <greg@kroah.com>
Cc: Timur Tabi <timur@freescale.com>,
        Michael Ellerman <michael@ellerman.id.au>, Greg KH <gregkh@suse.de>,
        Scott Wood <scottwood@freescale.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stuart Yoder <stuart.yoder@freescale.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 1, 2010 at 02:00, Greg KH <greg@kroah.com> wrote:
> On Tue, Nov 30, 2010 at 01:33:52PM -0600, Timur Tabi wrote:
>> Greg KH wrote:
>> >>> > > When this function is called, userspace had better know exactly what is
>> >>> > > going on as it can get confused due to the lack of uevents happening.
>> >> >
>> >> > Thanks for the explanation, but I'm just concerned that you'll add a comment
>> >> > that says, "don't call this function".  A quick grep will show that there are
>> >> > users of this function, and we'll have this exact conversation all over again.
>> > Care to turn the above into a patch?  I'll be glad to apply that as well
>>
>> One question: why are uevents not happening?
>
> What uevent would describe this?  Userspace asked for the rename to
> happen, so it better be aware that it did.
>
> We don't want to do a "remove" and then "add" sequence of events, that
> would confuse everyone.

A bit more details:

First: never rename anything! :)

It's racy at many levels, symlinks and other stuff are not replaced
atomically, you get a "move" uevent", but it's not easy to connect the
event to the old and new device. Device nodes are not renamed at all,
there isn't even support for that in the kernel now.

In the meantime during renaming, your target name might be taken by
another driver, creating conflicts. Or the old name is taken directly
after you renamed it -- then you get events for the same DEVPATH,
before you even seet the "move" event. It's just a mess, and nothing
new should ever rely on kernel device renaming. Besides that it's not
even implemented now for other things than (driver-core wise very
simple) network devices.

We are currently about to change network renaming in udev to
completely disallow renaming of devices in the same namespace as the
kernel uses, because we can't solve the problems properly, that arise
with swapping names of multiple interfaces without races. Means,
renaming of eth[0-9]* will only be allowed to some other name than
eth[0-9]*, for the mentioned reasons.

Make up a "real" name in the driver before you register anything, or
add some other attributes for userspace to find the device, or use
udev to add symlinks -- but never rename kernel devices later, it's a
complete mess. We don't even want to get into that and try to
implement the missing pieces in the core. We really have other pieces
to fix in the driver core mess. :)

Kay
