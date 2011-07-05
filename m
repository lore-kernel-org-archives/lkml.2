Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab1GEQGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 12:06:21 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:34648 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755437Ab1GEQGU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 12:06:20 -0400
MIME-Version: 1.0
In-Reply-To: <20110705142149.GA3498@suse.de>
References: <20110704170949.11059.92774.stgit@ponder> <20110704174126.GA26533@suse.de>
 <20110704180159.GA11278@ponder.secretlab.ca> <20110705142149.GA3498@suse.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 5 Jul 2011 10:05:59 -0600
X-Google-Sender-Auth: 24nMyCNOSbMLUqAL7s7mRZcdS9k
Message-ID: <CACxGe6urJUgs=qTkLEHCUfddurN_qQ==KKQM3Av+hSfCRtc0qA@mail.gmail.com>
Subject: Re: [PATCH] drivercore: Add driver probe deferral mechanism
To: Greg KH <gregkh@suse.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 5, 2011 at 8:21 AM, Greg KH <gregkh@suse.de> wrote:
> On Mon, Jul 04, 2011 at 12:01:59PM -0600, Grant Likely wrote:
>> On Mon, Jul 04, 2011 at 10:41:26AM -0700, Greg KH wrote:
>> > On Mon, Jul 04, 2011 at 11:11:59AM -0600, Grant Likely wrote:
>> > > Allow drivers to report at probe time that they cannot get all the resources
>> > > required by the device, and should be retried at a later time.
>> >
>> > When is "later"?
>>
>> In this case, after at least one other device has successfully probed.
>> The 'later' is handled in a workqueue that walks the list
>> asynchronously from normal initialization.
>>
>> > And why would a driver not be able to get all of the proper resources?
>>
>> Discussed below...
>>
>> > Why can't a bus, at a later time, just try to reprobe everything when it
>> > determines that it is a "later" time now, without having to do this
>> > added change to the core?
>>
>> It can't be done by a specific bus type because it has zero
>> relationship with the bus type.  For example, it is typical for an
>> SDHCI driver to require a GPIO line for the card detect switch, and
>> the device cannot be initialized until it has it.  However, the
>> bus_type that the SDHCI driver is attached to could be anything;
>> platform_bus_type, pci, amba, etc.  It isn't a bus_type deficiency,
>> but rather that the driver core has no way to gracefully handle
>> devices that get probed in an undetermined order.
>>
>> It has to be done at the core level because any device in the system,
>> regardless of bus_type, may require another device to be probed first.
>> Originally I tried modifying the drivers to successfully probe
>> anyway and then 'go to sleep' to try again later, but it turned out to
>> push a lot of complexity into the device drivers when it can be solved
>> far more simply if the driver core has the ability to retry drivers
>> that request it.
>
> So the driver core is just going to sit and spin and continue to try to
> probe drivers for as long as it gets that error value returned?  What is
> going to ever cause that loop to terminate?  It seems a bit hacky to
> just keep looping over and over and hoping that sometime everything will
> all settle down so that we can go to sleep again.

No, that would be insane.  The list of deferred devices is only walked
when triggered, and it stops at the end of the list unless retriggered
again.  Also, for the drivers using this, reattempting probe is cheap
since the driver is expected to test resources first before
initializing hardware.  If it can't get what it needs, it returns
-EAGAIN immediately.  We /could/ implement dependency checking in the
core code instead of calling each driver's probe, but that would mean
teaching the driver core about every possible resource a driver might
want which would be absolutely horrible to code, would probably be
more expensive, and definitely more complex.

in this version of the patch there is no way for a driver to be
dropped from the deferred list and the list walk is quite inefficient.
 The next version will solve both problems by removing each device
from the list when the list is walked.  If a driver requests deferral
again, then the device gets re-added to the end.

Another problem with this version is that every successful probe will
trigger walking the list because that was the obvious way to implement
it.  So, it is theoretically possible that the list will get walked
once every single time a driver is bound (but probably not in practice
because the list walk is handled in a workqueue that is naturally
serialized).  I'm looking at changing how the workqueue is scheduled
so that it only gets kicked at the end of a block of driver probing
(like at the end of syscalls), but that is more of an optimization
than anything.

g.


>
> It just doesn't feel right, there has to be some other way to handle
> stuff like this in a way that is known to terminate properly other than
> just guessing.
>
> greg k-h
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
