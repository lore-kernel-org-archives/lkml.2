Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933110Ab0HLARf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:17:35 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47176 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933102Ab0HLARb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:17:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NaKWrgJuMA6U66Q/qZUzKpROr1+2hoT8vDUrK5+Ifkw+Bx+kFdEndrIeatQZCHYxHr
         Wg1N9P33uNm64NYkqalq+54Yd04Dg3l5s5u9jk1gqsmt/njx/g46FAhtNauR2aW0V4Sf
         AqQ4vSraGmLNQAzbZ27n3KbZB1k7Z4g42Dz0Q=
MIME-Version: 1.0
In-Reply-To: <20100811221258.GI2516@linux.vnet.ibm.com>
References: <20100808155719.GB3635@thunk.org>
	<AANLkTinM5e2HGOFavODPZNzZx4KshDSjsvKN4pLpGGgr@mail.gmail.com>
	<20100808213821.GD3635@thunk.org>
	<20100809112453.77210acc@lxorguk.ukuu.org.uk>
	<20100809181638.GI3026@linux.vnet.ibm.com>
	<20100809201822.441905f7@lxorguk.ukuu.org.uk>
	<20100810044541.GA2817@linux.vnet.ibm.com>
	<20100810093849.138e2318@lxorguk.ukuu.org.uk>
	<20100811004223.GH2379@linux.vnet.ibm.com>
	<AANLkTik7Po9OuKC-QBZ=E83J70sU_ewNi+nNWgcjjLXd@mail.gmail.com>
	<20100811221258.GI2516@linux.vnet.ibm.com>
Date: Thu, 12 Aug 2010 03:17:29 +0300
Message-ID: <AANLkTi=fJjM=uWeV+L66ajM9rhrL0t1OO-C7ThNRdbae@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
From: Felipe Contreras <felipe.contreras@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Ted Ts'o" <tytso@mit.edu>,
        david@lang.hm, Brian Swetland <swetland@google.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, menage@google.com,
        david-b@pacbell.net, James.Bottomley@suse.de, arjan@infradead.org,
        swmike@swm.pp.se, galibert@pobox.com, dipankar@in.ibm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 1:12 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Wed, Aug 11, 2010 at 11:00:42PM +0300, Felipe Contreras wrote:
>> On Wed, Aug 11, 2010 at 3:42 AM, Paul E. McKenney
>> <paulmck@linux.vnet.ibm.com> wrote:
>> > On Tue, Aug 10, 2010 at 09:38:49AM +0100, Alan Cox wrote:
>> >> You may also wish to review the earlier parts of the discussion where it
>> >> was explicitly stated by several developers that they were using
>> >> "suspend" type modes as power states already and not using suspend
>> >> blockers. So it's being done, today on ARM and your statement is directly
>> >> contradicting the code. Modern ARM processors and x86 MID devices can
>> >> suspend and resume extremely fast (fast enough that the fact Linux x86
>> >> rewriting all the SMP alternatives on suspend/resume is a measurable
>> >> problem). If this same property doesn't end up on big PC boxes in time
>> >> then I'd be very surprised. At that point the openoffice with suspend
>> >> blockers or oracle with suspend blockers question becomes rather relevant.
>> >
>> > Here is the list of properties distinguishing idle from suspend:
>> >
>> > 1.      Idle states are entered by a given CPU only there are no runnable
>> >        tasks for that CPU.  In contrast, opportunistic suspend can
>> >        halt the entire system even when there are tasks that are ready,
>> >        willing, and able to run.  (But please note that this might not
>> >        apply to real-time tasks.)
>>
>> But if there are no runnable tasks (which is the target), they behave the same.
>
> And if there are runnable tasks, then then don't behave the same.

Unless they have blocked suspend.

Anyway, Alan was picturing a hypothetical point in time when x86 can
suspend/resume as fast as ARM, and thus the question of whether or not
to enable suspend-blockers in a system that runs openoffice becomes
relevant. If applications have been fixed by that time to not wake the
system unnecessarily, as many of them have already been tanks to tools
like powertop, then suspend-blockers would not make that much of a
difference, therefore the effort required to implement
suspend-blockers properly on all applications in the system, including
openoffice might not be worth the gain.

> Apparently different people in this debate have different targets.

I remember clearly Android people explaining that dynamic PM is
orthogonal to suspend-blockers; if a suspend is blocked, you still
want dynamic PM to reach the lower power state. Therefore the target
of not having unneeded runnable tasks is shared by Android folks.

>> > 2.      There can be a set of input events that do not bring the system
>> >        out of suspend, but which would bring the system out of idle.
>> >        Exactly which events are in this set depends both on hardware
>> >        capabilities and on the platform/application policy.  For example,
>> >        on one of the Android-based smartphones, touchscreen input is
>> >        ignored when the system is suspended, but is handled when idle.
>>
>> And in N900 touching the screen doesn't bring the device out of idle,
>> I guess because it's off.
>
> As long as touching the N900 screen doesn't bring the device out of
> suspend, its behavior is not a counterexample to #2 above.

You said "there can be a set of input events that do not bring the
system out of suspend, but which would bring the system out of idle".
There's no suspend (in the Android sense) in N900, only idle, and the
events that bring N900 out of idle can be mapped to the set of events
that bring Android out of suspend.

IOW. Alan wasn't talking about idle vs suspend on the same device, he
was talking about opportunistic suspend vs dynamic PM.

>> > 3.      The system comes out of idle when a timer expires.  In contrast,
>> >        timers might or might not bring the system out of suspend,
>> >        depending on both hardware capabilities and platform/application
>> >        policy.
>>
>> Isn't this solved by range timers?
>
> Ahem.  This is a list of differences between idle and suspend, not
> a list of problems to be solved.  But to answer your question, if a
> timer does not bring a given device out of suspend, then a range timer
> is not likely to, either.  Don't get me wrong, I do believe that range
> timers have an important part to play in the energy-efficiency arena,
> but I have not been convinced that they are any kind of silver bullet.

Certainly, but the context is the set of differences that would aid in
the decision of whether or not to go for suspend-blockers in a general
purpose system where openoffice would run.

>> > 4.      Suspend generally forces devices to go into their low-power
>> >        states immediately.  In contrast, idle generally leaves unused
>> >        devices at full power, relying on timers to shut down these
>> >        devices.  Idle thus has shorter average wakeup latencies, but
>> >        worse energy efficiency.
>>
>> Only if you make these assumptions
>>  1) All the applications use suspend-blockers only when they absolutely must
>>  2) The user has given the right applications the right access
>
> You believe that these assumptions are unreasonable?  Compared to the
> assumption that all applications are carefully written to conserve power?
> If so, on what grounds?

No, I think both (for opportunistic suspend and dynamic PM) are
completely reasonable. But think again; if you have the assumptions
met on both, then both work fine, if you don't meet them, then both
don't work correctly.

My point is that suspend-blockers don't magically reduce power usage,
just like dynamic PM, it depends on what user-space actually does. You
made it look as it *always* reached better energy efficiency.

> It seems to me that the same social-engineering approaches work in
> both cases.

Yes, but if dynamic PM works as advertised, you don't need
opportunistic suspend.

>> If not, you'll see much worst energy efficiency. So in theory maybe,
>> but in practice you can't say that.
>
> Really?  What makes you say that?

For starters an application might be holding the wakelock more than it
should, also, an application might miss a timer due to not having PM
permissions to hold the lock, and thus might need an expensive
initialization when it runs again.

-- 
Felipe Contreras
