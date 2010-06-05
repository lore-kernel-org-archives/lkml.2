Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573Ab0FEAjT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 20:39:19 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:65490 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932389Ab0FEAjS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 20:39:18 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1006050148080.2933@localhost.localdomain>
References: <20100603193045.GA7188@elte.hu>
	<20100603232302.GA16184@elte.hu>
	<1275644619.27810.39462.camel@twins>
	<201006050138.30859.rjw@sisk.pl>
	<alpine.LFD.2.00.1006050148080.2933@localhost.localdomain>
Date: Fri, 4 Jun 2010 17:39:17 -0700
Message-ID: <AANLkTikGDSzaENwg_0BAtsYf3ulGd_6sGPR30WsvUxMi@mail.gmail.com>
Subject: Re: suspend blockers & Android integration
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, tytso@mit.edu,
       Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
       Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 4, 2010 at 5:05 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Sat, 5 Jun 2010, Rafael J. Wysocki wrote:
>> I kind of agree here, so I'd like to focus a bit on that.
>>
>> Here's my idea in the very general terms:
>>
>> (1) Use the cgroup freezer to "suspend" the "untrusted" apps (ie. the ones
>>     that don't use suspend blockers aka wakelocks in the Android world) at the
>>     point Android would normally start opportunistic suspend.
>
> There is an additional benefit to this approach:
>
>     In the current android world a background task (e.g. download
>     initiated before the screensaver kicked in) prevents the suspend,
>     but that also means that the crapplications can still suck power
>     completely unconfined.
>

Yes this can happen. It is usually only a big problem when you combine
an (trusted) application that has a bug that blocks suspend forever
with an application that wakes up too often for us to enter low power
idle modes.

>     With the cgroup freezer you can "suspend" them right away and
>     just keep the trusted background task(s) alive which allows us to
>     go into deeper idle states instead of letting the crapplications
>     run unconfined until the download finished and the suspend
>     blocker goes away.
>

Yes this would be better, but I want it in addition to suspend, not
instead of it. It is also unclear if our user-space code could easily
make use of it since our trusted code calls into untrusted code.

>> (2) Allow the cpuidle framework to put CPUs into low-power states after the
>>     "trusted" apps (ie. the ones that use suspend blockers in the Android
>>     world) have gone idle.
>>

As far as I know this is what we already have on hardware that supports it.

>> (3) Teach the cpuidle framework to schedule runtime suspend of I/O devices
>>     before idling the last CPU (*).
>>

I don't think we need this for android phones. We already put I/O
devices in low power modes when they are not in use.

>> (4) Design a mechanism to resume the I/O devices suspended in (3) so that
>>     they are not powered up unnecessarily (that's going to be difficult as far
>>     as I can see).
>>
>> This way, in principle, we should be able to save (at least almost) as much
>> energy as the opportunistic suspend currently used by Android, provided that
>> things will be capable of staying idle for extended periods of time.

The main reason we use suspend is that the system does not stay idle
for extened periods of time. If this gets fixed, and our if user-space
framework can deal with a subset of processes being frozen (this is a
big if) this solution may work, but it does not help us today.

>>
>> (*) That may require per-device PM QoS requirements to be used, in which case
>>     devices may even be suspended earlier if the PM QoS requirements of all
>>     of their users are met.
>>
>> I wonder what people think.  Is this realistic and if so, would it be difficult
>> to implement?
>
> I think it's realistic and not overly complicated to implement.
>

The kernel support can be easily implemented on most arm hardware, I
don't know if it can work on most existing x86 hardware. It does not
give us the same power savings as suspend with existing software, but
it can handle bad apps better (assuming you don't combine
opportunistic suspend and cgroup freezing). The biggest hurdle is how
to handle dependencies between processes that gets frozen and
processes that don't get frozen.

-- 
Arve Hjønnevåg
