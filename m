Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762602Ab0HGKCh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 06:02:37 -0400
Received: from mail.lang.hm ([64.81.33.126]:33064 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762543Ab0HGKCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 06:02:35 -0400
Date: Sat, 7 Aug 2010 03:00:48 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Brian Swetland <swetland@google.com>,
        kevin granade <kevin.granade@gmail.com>,
        Arve Hj?nnev?g <arve@android.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
In-Reply-To: <201008071101.25384.rjw@sisk.pl>
Message-ID: <alpine.DEB.2.00.1008070247590.30564@asgard.lang.hm>
References: <20100805230304.GQ2447@linux.vnet.ibm.com> <20100807001431.GA3252@opensource.wolfsonmicro.com> <alpine.DEB.2.00.1008061741460.30564@asgard.lang.hm> <201008071101.25384.rjw@sisk.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Aug 2010, Rafael J. Wysocki wrote:

> On Saturday, August 07, 2010, david@lang.hm wrote:
>> On Sat, 7 Aug 2010, Mark Brown wrote:
>>
>>> On Fri, Aug 06, 2010 at 04:35:59PM -0700, david@lang.hm wrote:
>>>> On Fri, 6 Aug 2010, Paul E. McKenney wrote:
> ...
>> What we want to have happen in an ideal world is
>>
>> when the storage isn't needed (between reads) the storage should shutdown
>> to as low a power state as possible.
>>
>> when the CPU isn't needed (between decoding bursts) the CPU and as much of
>> the system as possible (potentially including some banks of RAM) should
>> shutdown to as low a power state as possible.
>
> Unfortunately, the criteria for "not being needed" are not really
> straightforward and one of the wakelocks' roles is to work around this issue.

if you can ignore the activity caused by the other "unimportant" processes 
in the system, why is this much different then just the one process 
running, in which case standard power management sleeps work pretty well.

>> today there are two ways of this happening, via the idle approach (on
>> everything except Android), or via suspend (on Android)
>>
>> Given that many platforms cannot go to into suspend while still playing
>> audio, the idle approach is not going to be able to be eliminated (and in
>> fact will be the most common approach to be used/deugged in terms of the
>> types of platforms), it seems to me that there may be a significant amount
>> of value in seeing if there is a way to change Android to use this
>> approach as well instead of having two different systems competing to do
>> the same job.
>
> There is a fundamental obstacle to that, though.  Namely, the Android
> developers say that the idle-based approach doesn't lead to sufficient energy
> savings due to periodic timers and "polling applications".

polling applications can be solved by deciding that they aren't going to 
be allowed to affect the power management decision (don't consider their 
CPU useage when deciding to go to sleep, don't consider their timers when 
deciding when to wake back up)

> Technically that
> boils down to the interrupt sources that remain active in the idle-based case
> and that are shut down during suspend.  If you found a way to deactivate all of
> them from the idle context in a non-racy fashion, that would probably satisfy
> the Android's needs too.

well, we already have similar capibility for other peripherals (I keep 
pointing to drive spin down as an example), the key to avoiding the 
races seems to be in the drivers supporting this.

the fact that Android is making it possible for suspend to selectivly 
avoid disabling them makes me think that a lot of the work needed to make 
this happen has probably been done. look at what would happen in a suspend 
if it decided to leave everything else on and just disable the one thing, 
that should e the same thing that happens if you are just disabling that 
one thing for idle sleep.

David Lang
