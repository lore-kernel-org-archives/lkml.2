Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299Ab0HKDDU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 23:03:20 -0400
Received: from mail.lang.hm ([64.81.33.126]:54806 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757937Ab0HKDDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 23:03:18 -0400
Date: Tue, 10 Aug 2010 20:00:53 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Ted Ts'o" <tytso@mit.edu>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Brian Swetland <swetland@google.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, menage@google.com,
        david-b@pacbell.net, James.Bottomley@suse.de, arjan@infradead.org,
        swmike@swm.pp.se, galibert@pobox.com, dipankar@in.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
In-Reply-To: <20100811022131.GA2587@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1008101947550.23481@asgard.lang.hm>
References: <20100808155719.GB3635@thunk.org> <AANLkTinM5e2HGOFavODPZNzZx4KshDSjsvKN4pLpGGgr@mail.gmail.com> <20100808213821.GD3635@thunk.org> <20100809112453.77210acc@lxorguk.ukuu.org.uk> <20100809181638.GI3026@linux.vnet.ibm.com> <20100809201822.441905f7@lxorguk.ukuu.org.uk>
 <20100810044541.GA2817@linux.vnet.ibm.com> <20100810093849.138e2318@lxorguk.ukuu.org.uk> <20100811004223.GH2379@linux.vnet.ibm.com> <alpine.DEB.2.00.1008101821280.23481@asgard.lang.hm> <20100811022131.GA2587@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Aug 2010, Paul E. McKenney wrote:

> Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
> 
> On Tue, Aug 10, 2010 at 06:28:39PM -0700, david@lang.hm wrote:
>> On Tue, 10 Aug 2010, Paul E. McKenney wrote:
>>
>>> On Tue, Aug 10, 2010 at 09:38:49AM +0100, Alan Cox wrote:
>>>>> situation you call out can occur with manual suspend-to-RAM already:
>>>>> the fact is that this is a design choice.  You could indeed make a
>>>>
>>>> Losing data is a design choice ? The application set a timer, the OS
>>>> shouldn't be ignoring it in that situation. It might want to delay it, it
>>>> might want to warn the user its hogging things it shouldnt (powertop,
>>>> battery usage monitors in Android etc)
>>>
>>> Hmmm...  Let's put the two approaches side by side so that we can compare
>>> them more easily:
>>>
>>> 	Opportunistic Suspend		Idle + Timer Jitter
>>>
>>> 	Set timer			Set timer
>>> 	Suspend				OS delays timer
>>> 	Resume				OS continues delaying timer
>>> 	Timer fires			Timer fires
>>>
>>> These two cases look quite similar to me.
>>>
>>> But as you say, the battery can run out.  So let's add that to the
>>> comparison:
>>>
>>> 	Opportunistic Suspend		Idle + Timer Jitter
>>>
>>> 	Set timer			Set timer
>>> 	Suspend				OS delays timer
>>> 	Battery runs out		Battery runs out
>>> 	Data loss			Data loss
>>>
>>> The two cases still look quite similar.  You might note, quite correctly,
>>> that the time between suspend and resume might be quite a bit longer than
>>> the typical time that the OS delays a timer.  But the power consumption
>>> on some platforms is quite a bit lower in the suspend case than it is
>>> in the delayed-timer case.
>>
>> it has been stated that the android can hit the exact same power
>> state either with sleep or suspend, and that the same clock can wake
>> it up (it appears as a timer expiring for sleep, or an alarm for
>> suspend, but it's the same clock firing the signal)
>>
>> so in at least some cases the hardware supports doing both with
>> equal efficiency.
>
> It indeed has been so stated.  But in this section we were discussing
> data loss, not hardware power-state capabilities.

you specifically stated that suspend would use less power. I am pointing 
out that ther is info posed in this thread to say that's not always the 
case.

in either case it is possible for the system to wake up again later to let 
the timer fire and the application save it's work. It's arguably easier 
in the idle case as it doesn't require application modification

for example

Idle + Timer Jitter
set timer
OS sets timer jitter to 1 hour
system sleeps for 1 hour with no wakeups
timer fires, applications wake and process data
system sleeps (for 1 hour or more with no wakeups)
  (repeat as needed until battery runs out)

much less chance for data loss as there is _far_ more of a chance that the 
timer

waking up once per hour for a short time is not going to make a noticable 
difference in your total battery life of a cell phone due to the 
significant idle power draw needed for the cell circuitry. On something 
like a e-reader with no radio link and a month-long idle time it could 
make a difference.

note that this is with a badly written app running that is trying to 
wakeup repeatedly. If the app is well behaved and only schedule a timer 
when they will have work to do, they may not schedule a timer at all after 
the data is saved, and so would have the data safe and just as long a 
standby time.

>>>>> But that doesn't guarantee that solutions developed for PCs and laptops
>>>>> will be optimal (or even usable) on cellphones.  Sufficient difference
>>>>
>>>> Your cellphone is to all intents a laptop from ten years ago, it even has
>>>> a similar display resolution and internet availability. The underlying
>>>> difference between the two is solely form factor - the laptop had a
>>>> better keyboard.
>>>
>>> There are similarities and differences.  You have called out some of
>>> the similarities.  Differences include the more-aggressive hardware
>>> power management on cellphones, the greater number and variety of
>>> hardware accelerators on cellphones, battery capacity, and, as you say,
>>> physical size.  People currently use cellphones differently than they
>>> do laptops or desktops.  The usage might converge, but we will see.
>>> There is as much reason to expect increasing specialization as there
>>> is to expect increasing convergence.
>>
>> You are talking about Android as if it was a cell phone only thing,
>> it's not. there are shipping tablets (and I believe netbooks, i.e.
>> laptops) running andoid.
>
> I was talking about cellphones.  But yes, Android (and thus suspend
> blockers) are used for tablets as well as cellphones, thank you for
> reminding me!

the fact that it's used there means that you can't argue that it's 
difference because cell phones are so different (unless you are saying 
that Android is really not appropriate for those uses)

On the other hand, lots of things are used in places where it is 
inappropriate, Windows CE is used on phones, tablets, etc but I think most 
people would say that the use of windows there isn't appropriate.

David Lang
