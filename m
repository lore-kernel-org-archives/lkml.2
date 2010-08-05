Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933483Ab0HEPsX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 11:48:23 -0400
Received: from mail.lang.hm ([64.81.33.126]:43900 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933418Ab0HEPsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 11:48:20 -0400
Date: Thu, 5 Aug 2010 08:46:54 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
In-Reply-To: <20100805151211.GA10080@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1008050832010.25170@asgard.lang.hm>
References: <AANLkTimRZc2B1=ic-0jrGBX7ahCu=NCoQadCOePGDmh9@mail.gmail.com> <alpine.DEB.2.00.1008041554580.6545@asgard.lang.hm> <AANLkTingom2AKfMu0EbfdfLiMnHo+buy1e4=PBENf3Vi@mail.gmail.com> <alpine.DEB.2.00.1008041620010.6545@asgard.lang.hm>
 <20100804233013.GN24163@linux.vnet.ibm.com> <alpine.DEB.2.00.1008041643490.6545@asgard.lang.hm> <20100805001716.GO24163@linux.vnet.ibm.com> <alpine.DEB.2.00.1008041722060.6545@asgard.lang.hm> <20100805004802.GP24163@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1008042208350.25170@asgard.lang.hm> <20100805151211.GA10080@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Aug 2010, Paul E. McKenney wrote:

> On Wed, Aug 04, 2010 at 10:18:40PM -0700, david@lang.hm wrote:
>> On Wed, 4 Aug 2010, Paul E. McKenney wrote:
>>> On Wed, Aug 04, 2010 at 05:25:53PM -0700, david@lang.hm wrote:
>>>> On Wed, 4 Aug 2010, Paul E. McKenney wrote:
>
> [ . . . ]
>
>>>>> The music player is an interesting example.  It would be idle most
>>>>> of the time, given that audio output doesn't consume very much CPU.
>>>>> So you would not want to suspend the system just because there were
>>>>> no runnable processes.  In contrast, allowing the music player to
>>>>> hold a wake lock lets the system know that it would not be appropriate
>>>>> to suspend.
>>>>>
>>>>> Or am I misunderstanding what you are proposing?
>>>>
>>>> the system would need to be idle for 'long enough' (configurable)
>>>> before deciding to suspend, so as long as 'long enough' is longer
>>>> than the music player is idle this would not be a problem.
>>>
>>> From a user standpoint, having the music player tell the system when
>>> it is OK to suspend (e.g., when the user has paused playback) seems
>>> a lot nicer than having configurable timeouts that need tweaking.
>>
>> every system that I have seen has a configurable "sleep if it's idle
>> for this long" knob. On the iphone (work issue, I didn't want it)
>> that I am currently using it can be configured from 1 min to 5 min.
>>
>> this is the sort of timeout I am talking about.
>>
>> with something in the multi-minute range for the 'do a full suspend'
>> doing a wakeup every few 10s of seconds is perfectly safe.
>
> Ah, I was assuming -much- shorter "do full suspend" timeouts.
>
> My (possibly incorrect) assumption is based on the complaint that led
> to my implementing RCU_FAST_NO_HZ.  A (non-Android) embedded person was
> quite annoyed (to put it mildly) at the earlier version of RCU because
> it prevented the system from entering the power-saving dyntick-idle mode,
> not for minutes, or even for seconds, but for a handful of -milliseconds-.
> This was my first hint that "energy efficiency" means something completely
> different in embedded systems than it does in the servers that I am
> used to.
>
> But I must defer to the Android guys on this -- who knows, perhaps
> multi-minute delays to enter full-suspend mode are OK for them.

if the system was looking at all applications I would agree that the 
timeout should be much shorter.

I have a couple devices that are able to have the display usable, even if 
the CPU is asleep (the OLPC and the Kindle, two different display 
technologies). With these devices I would like to see the suspend happen 
so fast that it can suspend between keystrokes.

however, in the case of Android I think the timeouts have to end up being 
_much_ longer. Otherwise you have the problem of loading an untrusted book 
reader app on the device and the device suspends while you are reading the 
page.

currently Android works around this by having a wakelock held whenever the 
display is on. This seems backwards to me, the display should be on 
because the system is not suspended, not the system is prevented from 
suspending because the display is on.

Rather than having the display be on causing a wavelock to be held (with 
the code that is controls the display having a timeout for how long it 
leaves the display on), I would invert this and have the timeout be based 
on system activity, and when it decides the system is not active, turn off 
the display (along with other things as it suspends)

>>>>>> if the backlight being on holds the wakelock, it would seem that
>>>>>> almost every other use of the wakelock could (and probably should)
>>>>>> be replaced by something that tickles the display to stay on longer.
>>>>>
>>>>> The problem with this approach is that the display consumes quite a
>>>>> bit of power, so you don't want to leave it on unnecessarily.  So if
>>>>> the system is doing something (for example, playing music) that does
>>>>> not require the display, you really want the display to be off.
>>>>
>>>> what percentage (and types) of apps are really useful with the
>>>> display off. I think that there are relativly few apps that you
>>>> really want to keep running if the display is off.
>>>
>>> The length of time those apps are running is the governing factor
>>> for battery life, and not the number of such apps, right?
>>
>> correct, but the number of such apps indicates the scope of the problem.
>
> The number of such apps certainly indicates the amount of effort required
> to modify them, if required.  Is that what you are getting at?

yes.

>>> From another e-mail tonight it sounds like almost everything
>>> already talks
>>
>> to a userspace daemon, so if "(the power management service in the
>> system_server, possibly the media_server and the radio interface
>> glue)" (plus possibly some kernel activity) are the only things
>> looked at when considering if it's safe to sleep or not, all of
>> these can (or already do) do 'something' every few seconds, making
>> this problem sound significantly smaller than it sounded like
>> before.
>>
>> Android could even keep it's user-space API between the system power
>> daemon and the rest of userspace the same if they want to.
>>
>> over time, additional apps could be considered 'trusted' (or flagged
>> that way by the user) and not have to interact with the power daemon
>> to keep things alive.
>
> Hmmm...  Isn't it the "trusted" (AKA PM-driving) apps that interact with
> the power daemon via suspend blockers, rather than the other way around?

I was looking at it from a kernel point of view, "trusted" (AKA 
PM-driving) apps are ones that have permission to grab the wakelock. Any 
app/daemon that is so trusted can communicate with anything else in 
userspace as part of making it's decision on whento take the wakelock, but 
those other applications would not qualify as "trusted" in my eyes.

>> as for intramentation, the key tool to use to see why a system isn't
>> going to sleep would be powertop, just like on other linux systems.
>
> Powertop is indeed an extremely valuable tool, but I am not certain
> that it really provides the information that the Android guys need.
> If I understand Arve's and Brian's posts, here is the scenario that they
> are trying to detect:
>
> o	Some PM-driving application has a bug in which it fails to
> 	release a wakelock, thus blocking suspend indefinitely.
>
> o	This PM-driving application, otherwise being a good citizen,
> 	blocks.
>
> o	There are numerous power-oblivious apps running, consuming
> 	significant CPU.
>
> What the Android developers need to know is that the trusted application
> is wrongly holding a wakelock.  Won't powertop instead tell them about
> all the power-oblivious apps?

in my proposal (without a wakelock), powertop would tell you what 
applications are running and setting timers. If we can modify the 
kernel/suspend decision code to only look at processes in one cgroup when 
deciding if the system should go to sleep, a similar modification to 
poewrtop should let you only show stats on the "trusted" applications.

If you have a userspace power management daemon that accepts requests from 
untrusted programs and does something to keep the system from sleeping 
(either taking a wakelock or setting a 'short' timer), it needs to keep 
the records of this itself because otherwise all the kernel will see (with 
either powertop or wakelock reporting) is that the power management daemon 
is what kept the system from sleeping.

David Lang
