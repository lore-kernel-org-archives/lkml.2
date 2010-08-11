Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159Ab0HKBb1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 21:31:27 -0400
Received: from mail.lang.hm ([64.81.33.126]:54574 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755894Ab0HKBbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 21:31:25 -0400
Date: Tue, 10 Aug 2010 18:28:39 -0700 (PDT)
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
In-Reply-To: <20100811004223.GH2379@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1008101821280.23481@asgard.lang.hm>
References: <20100807061558.GA28087@thunk.org> <AANLkTi=sMVjya9CH6UoZwJCXJTDRgBhnPXmApU_RHVTi@mail.gmail.com> <20100808155719.GB3635@thunk.org> <AANLkTinM5e2HGOFavODPZNzZx4KshDSjsvKN4pLpGGgr@mail.gmail.com> <20100808213821.GD3635@thunk.org>
 <20100809112453.77210acc@lxorguk.ukuu.org.uk> <20100809181638.GI3026@linux.vnet.ibm.com> <20100809201822.441905f7@lxorguk.ukuu.org.uk> <20100810044541.GA2817@linux.vnet.ibm.com> <20100810093849.138e2318@lxorguk.ukuu.org.uk>
 <20100811004223.GH2379@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Aug 2010, Paul E. McKenney wrote:

> On Tue, Aug 10, 2010 at 09:38:49AM +0100, Alan Cox wrote:
>>> situation you call out can occur with manual suspend-to-RAM already:
>>> the fact is that this is a design choice.  You could indeed make a
>>
>> Losing data is a design choice ? The application set a timer, the OS
>> shouldn't be ignoring it in that situation. It might want to delay it, it
>> might want to warn the user its hogging things it shouldnt (powertop,
>> battery usage monitors in Android etc)
>
> Hmmm...  Let's put the two approaches side by side so that we can compare
> them more easily:
>
> 	Opportunistic Suspend		Idle + Timer Jitter
>
> 	Set timer			Set timer
> 	Suspend				OS delays timer
> 	Resume				OS continues delaying timer
> 	Timer fires			Timer fires
>
> These two cases look quite similar to me.
>
> But as you say, the battery can run out.  So let's add that to the
> comparison:
>
> 	Opportunistic Suspend		Idle + Timer Jitter
>
> 	Set timer			Set timer
> 	Suspend				OS delays timer
> 	Battery runs out		Battery runs out
> 	Data loss			Data loss
>
> The two cases still look quite similar.  You might note, quite correctly,
> that the time between suspend and resume might be quite a bit longer than
> the typical time that the OS delays a timer.  But the power consumption
> on some platforms is quite a bit lower in the suspend case than it is
> in the delayed-timer case.

it has been stated that the android can hit the exact same power state 
either with sleep or suspend, and that the same clock can wake it up 
(it appears as a timer expiring for sleep, or an alarm for suspend, but 
it's the same clock firing the signal)

so in at least some cases the hardware supports doing both with equal 
efficiency.

>>> But that doesn't guarantee that solutions developed for PCs and laptops
>>> will be optimal (or even usable) on cellphones.  Sufficient difference
>>
>> Your cellphone is to all intents a laptop from ten years ago, it even has
>> a similar display resolution and internet availability. The underlying
>> difference between the two is solely form factor - the laptop had a
>> better keyboard.
>
> There are similarities and differences.  You have called out some of
> the similarities.  Differences include the more-aggressive hardware
> power management on cellphones, the greater number and variety of
> hardware accelerators on cellphones, battery capacity, and, as you say,
> physical size.  People currently use cellphones differently than they
> do laptops or desktops.  The usage might converge, but we will see.
> There is as much reason to expect increasing specialization as there
> is to expect increasing convergence.

You are talking about Android as if it was a cell phone only thing, it's 
not. there are shipping tablets (and I believe netbooks, i.e. laptops) 
running andoid.

>>> As to busting all apps, lthough there have been situations where busting
>>> all the apps turned out to be the right thing to do, I agree that these
>>> situations are extremely rare.  Such situations are usually associated
>>> with the emergence of a new high-volume platform.
>>
>> Like Microsoft Windows 16bit co-operative multi-tasking ? It's rarely
>> right. It's merely that in certain cases the value in the market is large
>> enough that it can be used as a big stick to beat people into doing lots
>> of usually wasted work.
>
> Interesting choice of example.  I do well remember the Sequent hardware
> guys' frustration when the old printer driver would monopolize the desktop
> while printing their large documents.  The fact was that Microsoft's
> co-operative multi-tasking required all applications to be well behaved,
> just as does your approach to power efficiency.

and wakelocks require all applications that can take a wakelock be well 
behaved. and applications that do nt take a wakelock directly cannot 
expect to run unless something else takes a wakelock on their behalf

David Lang
