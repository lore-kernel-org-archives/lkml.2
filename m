Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375Ab1GAQ7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 12:59:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50622 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755297Ab1GAQ7P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 12:59:15 -0400
Date: Fri, 1 Jul 2011 18:00:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Chris Wolfe <cwolfe@chromium.org>
Cc: Alan Cox <alan@linux.intel.com>, Nathan Royer <nroyer@invensense.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jonathan Cameron <jic23@cam.ac.uk>, Jiri Kosina <jkosina@suse.cz>,
        Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 11/11] misc: Add slave driver for bma085 pressure sensor
Message-ID: <20110701180046.20efb83e@lxorguk.ukuu.org.uk>
In-Reply-To: <CAN_12A9jvid+7u5mOHbFBqE+Xtb6kbo_endwRk98JLrGK2E2TA@mail.gmail.com>
References: <1309486707-1658-1-git-send-email-nroyer@invensense.com>
	<1309486707-1658-11-git-send-email-nroyer@invensense.com>
	<20110701085604.0aabd6f1@bob.linux.org.uk>
	<CAN_12A8Za7r92=r3JHx3R=AwAA7xk6=NVVMiSp68HPatb1G3hg@mail.gmail.com>
	<20110701154150.0ac303a3@lxorguk.ukuu.org.uk>
	<CAN_12A9jvid+7u5mOHbFBqE+Xtb6kbo_endwRk98JLrGK2E2TA@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > It's a hot pluggable bus - no different to an i2c bus on a hot pluggable
> > device.
> 
> Can such a hot pluggable device maintain state while "unplugged"?

The hardware or the driver ?

As far as the OS is concerned it would have gone away.

> e.g. if the system is going to suspend, we need to pause the MPU,
> switch it back to pass-through mode, then send commands to suspend the
> slave on that bus. I took that to mean we wanted the secondary bus to
> have a normal device on it, which is still considered plugged in, but
> temporarily inaccessible from the CPU.

Thats a bit messier but we'd still want them to be normal i²c drivers
when on the slave bus and being driven by Linux. Possibly you end up with
a little helper to send i²c commands directly to the bus  in the "smart"
mode.

> A) special-purpose code in the mpu3050 driver for each possible slave;
> or B) normal drivers and platform data which cope with B1) the kernel
> relaying their data to the MPU and B2) being disconnected from the CPU
> while the MPU reads from the device directly.

If it's operating as a normal i²c device then it'll behave like any
normal kernel device, and really ought to be using runtime pm anyway.

In "smart" mode its really up to the driver how it does it but two
versions of every device is not a good answer !

> 
> >> The other note that may not have been made explicit yet is that the
> >> 3050 will happily provide unprocessed gyro and slave data without
> >> firmware loaded. The firmware sets up some additional processing
> >> capabilities of the chip, which are used by InvenSense's user-space
> >> products.
> >
> > Yes - and the current mpu3050 driver provides just these interfaces.
> 
> Ah, great. Sorry for missing them. In scanning the ioctls, it looked
> like dev-i2c was still a similar level of abstraction :)

Sorry may not have been clear "just those" as in "just those which can be
used without loading firmware and running non-free stuff"

And really until that area is sorted it may be premature to worry about
the rest - if its going to need proprietary bits to use the smart mode,
then the kernel just needs an i2c slave bus implementation, a few drivers
(we have most listed already it seems), and we are done.

Alan
