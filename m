Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751174Ab0HJE2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 00:28:13 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63692 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab0HJE2G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 00:28:06 -0400
MIME-Version: 1.0
In-Reply-To: <201008100453.11958.rjw@sisk.pl>
References: <AANLkTinQD3ggLFVd2KvX95U2B_j=ZJquZgiBGieukJ+r@mail.gmail.com>
	<201008082117.39082.rjw@sisk.pl>
	<AANLkTimncsuARHeavMCHL4imEOVXMomTJoDQns4-wq5o@mail.gmail.com>
	<201008100453.11958.rjw@sisk.pl>
Date: Mon, 9 Aug 2010 21:28:04 -0700
Message-ID: <AANLkTi=UApkc7_qeeXikP7kAnYW2TOXvVQu91UiBr2LV@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Matthew Garrett <mjg59@srcf.ucam.org>, david@lang.hm,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, swetland@google.com,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/9 Rafael J. Wysocki <rjw@sisk.pl>:
> On Monday, August 09, 2010, Arve Hjønnevåg wrote:
>> 2010/8/8 Rafael J. Wysocki <rjw@sisk.pl>:
>> > On Saturday, August 07, 2010, Arve Hjønnevåg wrote:
>> >> 2010/8/7 Arve Hjønnevåg <arve@android.com>:
>> >> > 2010/8/7 Rafael J. Wysocki <rjw@sisk.pl>:
>> >> >> On Saturday, August 07, 2010, Arve Hjønnevåg wrote:
>> >> >>> 2010/8/6 Alan Stern <stern@rowland.harvard.edu>:
>> >> >>> > On Thu, 5 Aug 2010, Arve Hjønnevåg wrote:
>> >> ...
>> >> >>> >> total_time, total time the wake lock has been active. This one should
>> >> >>> >> be obvious.
>> >> >>> >
>> >> >>> > Also easily added.
>> >> >>> >
>> >> >>> Only with a handle passed to all the calls.
>> >> >>
>> >> >> Well, I'm kind of tired of this "my solution is the only acceptable one"
>> >> >> mindset.  IMHO, it's totally counter productive.
>> >> >>
>> >> >
>> >> > How do you propose to track how long a driver has blocked suspend when
>> >> > you have an unblock call that takes no arguments.
>> >> >
>> >>
>> >> Also, I did not not see a response to my question about why you don't
>> >> want to pass a handle.
>> >
>> > It doesn't really matter what I personally want.  In fact, I'm not totally
>> > opposed to that idea, although there are disadvantages (eg. a "handle"
>> > would really mean a pointer to an object with certain life cycle that needs to
>> > be managed by the caller and it's not that clear to me who should manage the
>> > objects that the PCI wakeup code would pass to pm_wakeup_event(), for one
>>
>> Wouldn't a single global handle work for the way you are handling pci
>> wakeup events?
>
> Not really, because I'd like to know the number of wakeups associated with
> the given device.
>

For debugging purposes right? I'm not sure automatically counting
wakeup events from pm_stay_awake and pm_wakeup_event is the best way
to do this. To avoid race conditions these calls have to be made for
every event that could also be a wakeup event, which means the actual
wakeup event easily gets lost in the noise. This is why I had a
separate wakeup count that only increments on the fist call to
wake_lock after each suspend, but this did not work that well either.

>> It looked like you just reset a global timeout every time a pci wakeup event
>> occurs.
>
> We bump up the per-device counter of wakeup events in addition to that.
>
>> > example).  I sent a pull request for your original patchset to Linus after all. :-)
>> >
>> > I said I didn't think "it would fly", meaning that I was afraid the other kernel
>> > developers wouldn't like that change.
>> >
>> > The reason why I think so is that you'd like to add a whole new infrastructure
>> > whose only purpose would be debugging that would only be useful to systems
>> > using opportunistic suspend.  That, however, is only Android right now and it
>> > cannot use the mainline kernel for other reasons, so basically we would add
>> > infrastructure that's useful to no one.
>> >
>>
>> I'm not sure what you mean by this. The debugging is useful for anyone
>> using the api, not just Android, and a handle is also needed to mix
>> timeouts and pm_relax.
>
> The purpose of the debugging would be to be able to figure out why the system
> is staying in the working state, which is only relevant for systems that use
> opportunistic suspend.
>

Only if the drivers do not have bugs. A driver calling pm_say_awake
without a matching pm_relax call will prevent any race free suspend
from succeeding.

> If opportunistic suspend isn't used, it makes sense to ask which
> device caused suspend (initiated by the user) to be aborted and for this
> purpose it is sufficient to count wakeup events associated with each
> device (you need to preserve the pre-suspend values of these counters, but
> that can be done by a user space power manager just fine).
>
>> The handle can be the device, but some drivers need several handles per
>> device.
>
> That depends on how precise the collected debug information should be and
> that, in turn, depends on what it's going to be used for.
>

It is not just debug information. Drivers that mix wake_lock_timeout
and wake_unlock do not map to the current api.

> Anyway, as I said I'm not opposed to the idea of using a special type of
> objects for collecting debug information on wakeup events, so please free to
> submit patches modifying the current mainline kernel code in that direction.
>

How do you prefer to handle your pci wakeup events? Add a handle to
every device or pci device? Or use a global handle to avoid the race
and report wakeup events for debugging separately?

-- 
Arve Hjønnevåg
