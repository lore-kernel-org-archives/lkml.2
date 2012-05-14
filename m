Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab2ENGOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 02:14:24 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:44907 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752676Ab2ENGOW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 02:14:22 -0400
MIME-Version: 1.0
In-Reply-To: <201205122133.58164.rjw@sisk.pl>
References: <201205092340.26561.rjw@sisk.pl> <201205112059.25233.rjw@sisk.pl>
 <CAMQu2gzYrzei7Li+m6o0JtiF9LUSDvpQT71KhgMafC_f_KxPJQ@mail.gmail.com> <201205122133.58164.rjw@sisk.pl>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Mon, 14 May 2012 11:44:00 +0530
Message-ID: <CAMQu2gxq3G0Krh2d60iP-mOxLvNPd4M_SaQR=gOZSe2Y+g9o9g@mail.gmail.com>
Subject: Re: [RFC][PATCH 2/2] PM / Domains: Add preliminary cpuidle support
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Colin Cross <ccross@android.com>, Kevin Hilman <khilman@ti.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2012 at 1:03 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Saturday, May 12, 2012, Shilimkar, Santosh wrote:
>> On Sat, May 12, 2012 at 12:29 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > On Friday, May 11, 2012, Santosh Shilimkar wrote:
>> >> On Friday 11 May 2012 12:11 AM, Rafael J. Wysocki wrote:
>> >> > On Thursday, May 10, 2012, Santosh Shilimkar wrote:
> [...]
>> Your case is bit special because CPU is also part of the same power
>> domain as IO's. Since CPU is part of the root power domain along
>> with peripherals, you want CPU to be the device to cut the power in
>> the end(idle) and all the notifiers prepares the IO's for the 'cut
>> power' which CPU can do in the cpuidle.
>
> No, no notifiers, please, they are clearly suboptimal.
>
>> And then on the reverse chain, notifier will help devices to restore
>> the context so that can resume without any issues.
>
> The idea here is to avoid using notifiers.
>
Thanks for clarifying that. Somehow I miss-understood this
part in first place.

>> Well if CPU is added as one more device along with other
>> peripherals, you can still make it work at power domain framework
>> level.
>
> What exactly do you mean by "power domain framework level"?  My patch
> is at the power domain framework level as far as I can say.
>
>> This can be debated further but I think, we need an agreement
>> on CPUIDLE exclusivity.
>
> What do you mean by cpuidle exclusivity?  And what agreement?
>
>> Based on your hardware, say the USB is doing a huge DMA transfer
>> and CPU is not doing anything so it will hit idle thread and can idle.
>
> Sure, it will.
>
>> At least your CPU sub-domain can idle because it is quite independent
>> even if you can't cut the power for whole domain.
>
> That's correct.  The CPU sub-domain is beyond the scope of my patch.
>
>> Even with your patchset its not possible to cut the power because one of the
>> device in the domain is busy. There can be scenario, where say
>> SPI is not used for thousands of CPU idle entry/exit so there
>> is no need to worry about its context save/restore for every
>> idle entry/exit.
>
> The CPU idle state I'm referring to is not the only CPU idle state.
> It is an extra state allowing the CPU to go to even deeper idle that usually
> if all of the devices in its domain happen to be idle.
>
> Quite obviously there are other idle states along this one that will be used
> if this extra state is not enabled.
>
That make sense.

>> The way I am looking at your issue is, every device in a power domain
>> including CPU will decrement the powerdomain usecount.
>
> The CPU will not do that, only devices.
>
>> This can be handled through runtime PM.
>
> But this patchset is a part of runtime PM!  What exactly do you mean?
>
As I said for some reason I thought you were proposing the idle notifiers
which is not the case.

>> When they idle, they can save the context
>> and the context can be restored only when next time they needs to be
>> used. CPU can also decrements the usecount in the idle entry and then check
>> whether the usecound of the common PD is zero.
>
> This is not how it is supposed to work.
>
> It doesn't make sense for cpuidle to even try to use the "domain" state if
> it is known that some I/O devices in the domain aren't idle.  That's why
> that state is disabled in my code whenever one (the first) of the I/O devices
> is resumed.  It is then enabled when the last I/O device in the domain goes
> idle (the states of all devices are saved at this point, to allow cpuidle to
> use the "domain" state without worrying of the devices).
>
Now since the idle notifier confusion ( at least for me) is out, what you
proposed seems to be reasonable considering the power domain is
shared between multiple devices including CPU.

Regards
Santosh
