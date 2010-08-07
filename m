Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab0HGVWN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 17:22:13 -0400
Received: from mail.lang.hm ([64.81.33.126]:57612 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754244Ab0HGVWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 17:22:12 -0400
Date: Sat, 7 Aug 2010 14:20:02 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: "Ted Ts'o" <tytso@mit.edu>, Brian Swetland <swetland@google.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk,
        menage@google.com, david-b@pacbell.net, James.Bottomley@suse.de,
        arjan@infradead.org, swmike@swm.pp.se, galibert@pobox.com,
        dipankar@in.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
In-Reply-To: <20100807153225.GD19600@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1008071403000.30564@asgard.lang.hm>
References: <20100731175841.GA9367@linux.vnet.ibm.com> <20100804195704.GA23681@linux.vnet.ibm.com> <20100806225453.GA3947@linux.vnet.ibm.com> <alpine.DEB.2.00.1008061651530.30564@asgard.lang.hm> <AANLkTikyRhtfX4R3x_NDgHnXssmfVuhjC5PbhRZ0a7su@mail.gmail.com>
 <alpine.DEB.2.00.1008062010510.30564@asgard.lang.hm> <20100807061558.GA28087@thunk.org> <alpine.DEB.2.00.1008070206010.30564@asgard.lang.hm> <20100807153225.GD19600@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Aug 2010, Paul E. McKenney wrote:

> On Sat, Aug 07, 2010 at 02:38:35AM -0700, david@lang.hm wrote:
>> On Sat, 7 Aug 2010, Ted Ts'o wrote:
>>
>>> On Fri, Aug 06, 2010 at 08:14:09PM -0700, david@lang.hm wrote:
>>
>>> So the real key here is to take most applications, which may be
>>> written using techniques that might be considered well written from a
>>> laptop point of view, but not for a cell phone, and not require
>>> modifications.  Even though the application writer might think it's
>>> doing well by waking up every 15 seconds, if the laptop lid is down,
>>> or if the screen is off, for **most** applications, it should be
>>> forcibly put to sleep.
>>>
>>> It's only the rare applications that should really be allowed to run
>>> while screen is off.  And it's only those applications that need
>>> modifications to use suspend blocker.  From your earlier comments, it
>>> seems that this is the key point which you are missing.  (No doubt,
>>> some of these applications that do need to know about suspend blockers
>>> are important ones; ones that make sure the battery isn't about to
>>> blow up, or ones which silently wake up every 10-15 minutes to pull
>>> down fresh mail for you from your mail server.  But those applications
>>> are the exception, not the rule.)
>>
>> the question is what it takes to make an application privilaged like this.
>>
>> what I proposed was to make it possible for the user/admin to select
>> what applications are allowed to keep the system awake.
>
> The Android guys do the same.
>
>> wakelocks require that the application developer decide that they
>> want to keep the system awake as well as the user/admin
>
> Whereas you require that the application developer redesign/rewrite
> applications to decide when to keep the system awake, e.g., by carefully
> determining when to idle themselves.  The difference is that the Android
> developer need only release a suspend blocker.  In contrast, you are
> requiring that the developer rewrite all the code that follows the point
> where the Android developer would release a suspend blocker.
>
> Your way seems to require that the developer do more work for the
> same result.  Why?

portability, and the fact that it will save more power even when the 
system is prevented from suspending.

>> take your example of a mail client waking up every 15 min.
>>
>> with Android it needs to be privilaged to grab the wakelock while
>> fetching the mail, it also needs to use a privilaged API to set the
>> wakeups to wake it up at those times.
>>
>> with what I proposed all you need to do is to tag the application as
>> power privilaged and then if the application sleeps for 15 min
>> between doing thing the system will wake up every 15 min, work for a
>> short time, then go back to sleep.
>>
>>
>> if you want to put everything to sleep when the screen blanks,
>> that's trivial to do.
>>
>> the fun starts when you want to say that there are some things you
>> don't want to put to sleep.
>
> Which is in fact a critical requirement that you appear to have been
> ignoring in your words above.

I admit that the way I wrote this is confusing, but I don't think I am 
ignoring this requirement. the example above was how an application that 
the system is not wanting to put to sleep would run with the two 
mechansims.

>> do you let some processes run while halting others?
>>   in which case how do you prevent deadlocks?
>>     on the other hand, sleeping again is simple, you sleep when
>> there is nothing more to run
>> or do you let wasteful processes run while you are awake?
>>   this avoids deadlocks, but how do you decide when to sleep again?
>>
>>
>> Android approaches this by requiring that any program that a user
>> may want to keep running must be modified to use wakelocks.
>>
>> My suggestion was that the system ignore other processes when
>> deciding if the system is idle enough to put to sleep.
>
> But your suggestion seems to require quite a bit more coding effort for
> little gain.  The Android developer can just release a suspend blocker,
> and in contrast, a developer using your proposal needs to rewrite all
> the code following the point at which the Android developer released the
> suspend blocker.  So why are you saying that your is approach better?  ;-)

no, the coder needs to make his code not do unnessasary things. Even with 
a wakelock this is needed for the system to be able to use lower power 
modes while the system is not going to do a suspend anyway.

I am say that if the coder does that, the coder should not also have to 
code in wakelocks.

I want it to be as easy as possible to port applications between mobile 
platforms. On most platforms wakelocks are not needed because standard 
idle/sleep/suspend mechanisms are good enough. Android allows other 
applications to run that confuse the idle/sleep/suspend mechanisms, so 
something needs to be done to cut through the confusion. Android does this 
by creating a new API to control this, I'm suggesting that there should be 
a way to tell the system to ignore the other applications so that the 
existing mechanisms can make good decisions again.

David Lang
