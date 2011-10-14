Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703Ab1JNSZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 14:25:26 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:62383 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab1JNSZY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 14:25:24 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1110141327170.2036-100000@iolanthe.rowland.org>
References: <CACxGe6t2Xu5B0AKZJe-6HEpxK6GfuNm0Y2Kb_bs8ZwaTz5XnRg@mail.gmail.com>
 <Pine.LNX.4.44L0.1110141327170.2036-100000@iolanthe.rowland.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 14 Oct 2011 12:25:03 -0600
X-Google-Sender-Auth: NasQJUJ2kD7UVv35WN0n59lxyXQ
Message-ID: <CACxGe6sc8qOWDvLYSKwUzG8-VEZCXDKQX88qQsFYuP2QtEHvFg@mail.gmail.com>
Subject: Re: [PATCH 2/5] drivercore: Add driver probe deferral mechanism
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ming Lei <tom.leiming@gmail.com>, Andrei Warkentin <awarkentin@vmware.com>,
        Greg KH <greg@kroah.com>, Dilan Lee <dilee@nvidia.com>,
        "G, Manjunath Kondaiah" <manjugk@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>, Manjunath@jasper.es,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Linux PM List <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 11:33 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Fri, 14 Oct 2011, Grant Likely wrote:
>
>> > I don't think the second part needs to be quite so invasive.
>> > Certainly drivers that never defer probes shouldn't require anything to
>> > be moved.
>>
>> Think about that a minute.  Consider a dpm_list of devices:
>>         abcDefGh
>>
>> Now assume that D has an implicit dependency on G.  If D gets probed
>> first, then it will be deferred until G gets probed and then D will
>> get retried and moved to the end of the list resulting in:
>>         abcefGhD
>> Everything is good now for the order that things need to be suspended in.
>>
>> Now lets assume that the drivers get linked into the kernel in a
>> different order (or the modules get loaded in a different order) and G
>> gets probed first, followed by D.  No deferral occurred and so no
>> reordering occurs, resulting in:
>>         abcDefGh (unchanged)
>> But now suspend is broken because D depends on G, but G will be
>> suspended before D.
>
> However D sometimes does defer probes.  Therefore the device always
> needs to be moved, even though this particular probe wasn't deferred.

Yes, that's part of my point.

>>  This looks and smells like a bug to me.  In fact,
>> even without using probe deferral it looks like a bug because the
>> dap_list isn't taking into account the fact that there are very likely
>> to be implicit dependencies between devices that are not represented
>> in the device hierarchy (maybe not common in PCs, but certainly is the
>> case for embedded).  But, it is also easy to solve by ensuring the
>> dap_list is also probe-order sorted.
>>
>> > A deferred probe _should_ move the device to the end of the list.  But
>> > this needs to happen in the probe routine itself (after it has verified
>> > that all the other required devices are present and before it has
>> > registered any children) to prevent races.  It can't be done in a
>> > central location.
>>
>> I'm really concerned about drivers having to implement this and not
>> getting it correct; particularly when moving a device to the end of
>> the list is cheap, and it shouldn't be a problem to do the move
>> unconditionally after a driver has been matches, but before probe() is
>> called.
>
> But that's too early.  What if D gets moved to the end of the list,
> then G gets added to the list and probed, and then D's probe succeeds?

So the argument is that if really_probe() called dpm_move_last()
immediately before the dev->bus->probe()/drv->probe() call then there
is a race condition that G could get both registered and probed before
D's probe() starts using G's resources.  And so, the list would still
have G after D which is in the wrong order.  Do I understand
correctly?

> And after the probe returns is too late, because by then there may well
> be child devices.

Agreed, after probe returns is definitely too late.

>>  We may be able to keep watch to make sure that drivers using
>> probe deferral are also reordering themselves, but that does nothing
>> for the cases described above where the link order of the drivers
>> determines probe order, not the dap_list order.
>
> Devices need to be moved whenever they have any external dependencies,
> regardless of the particular order they get probed in.

I suspect this gets messy in a hurry, but perhaps it is worth trying.
So, any device that makes use of a PHY, GPIO line, codec, etc will
need to call dpm_move_last() before adding child devices, correct?
I'd be much happier to find a way to do this in core code though.  And
there is still a potential race condition here.  For example, if G is
in the middle of it's probe routine, and D gets probed between G
registering GPIOs and calling dpm_move_last(), then we're in the same
boat again.  I think the window for this race can be considered to be
of the same magnitude as the moved to early race described above.  I
need to think about this more...

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
