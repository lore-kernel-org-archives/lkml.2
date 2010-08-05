Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934484Ab0HEWKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:10:54 -0400
Received: from mail.lang.hm ([64.81.33.126]:39739 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758881Ab0HEWKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:10:50 -0400
Date: Thu, 5 Aug 2010 15:09:32 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: kevin granade <kevin.granade@gmail.com>
cc: paulmck@linux.vnet.ibm.com,
        =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
In-Reply-To: <AANLkTimaaLSwVusJ=w5-QptoauBnHH0JvCvmWUr0y+KD@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1008051453450.30632@asgard.lang.hm>
References: <alpine.DEB.2.00.1008041620010.6545@asgard.lang.hm> <20100804233013.GN24163@linux.vnet.ibm.com> <alpine.DEB.2.00.1008041643490.6545@asgard.lang.hm> <20100805001716.GO24163@linux.vnet.ibm.com> <alpine.DEB.2.00.1008041722060.6545@asgard.lang.hm>
 <20100805004802.GP24163@linux.vnet.ibm.com> <alpine.DEB.2.00.1008042208350.25170@asgard.lang.hm> <20100805151211.GA10080@linux.vnet.ibm.com> <alpine.DEB.2.00.1008050832010.25170@asgard.lang.hm> <AANLkTi=Yyyc-hOPbkJtsnKCVzncnFq8DPnonmyckekwm@mail.gmail.com>
 <20100805203102.GN2447@linux.vnet.ibm.com> <AANLkTimaaLSwVusJ=w5-QptoauBnHH0JvCvmWUr0y+KD@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="680960-1374493777-1281046173=:30632"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--680960-1374493777-1281046173=:30632
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

On Thu, 5 Aug 2010, kevin granade wrote:

> On Thu, Aug 5, 2010 at 3:31 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
>> On Thu, Aug 05, 2010 at 01:13:31PM -0500, kevin granade wrote:
>>> On Thu, Aug 5, 2010 at 10:46 AM,  <david@lang.hm> wrote:
>>>> On Thu, 5 Aug 2010, Paul E. McKenney wrote:
>>>>
>>>>>
>>>>> [ . . . ]
>>>>>
>>>>>
>>>>> My (possibly incorrect) assumption is based on the complaint that led
>>>>> to my implementing RCU_FAST_NO_HZ.  A (non-Android) embedded person was
>>>>> quite annoyed (to put it mildly) at the earlier version of RCU because
>>>>> it prevented the system from entering the power-saving dyntick-idle mode,
>>>>> not for minutes, or even for seconds, but for a handful of -milliseconds-.
>>>>> This was my first hint that "energy efficiency" means something completely
>>>>> different in embedded systems than it does in the servers that I am
>>>>> used to.
>>>>>
>>>>> But I must defer to the Android guys on this -- who knows, perhaps
>>>>> multi-minute delays to enter full-suspend mode are OK for them.
>>>>
>>>> if the system was looking at all applications I would agree that the timeout
>>>> should be much shorter.
>>>>
>>>> I have a couple devices that are able to have the display usable, even if
>>>> the CPU is asleep (the OLPC and the Kindle, two different display
>>>> technologies). With these devices I would like to see the suspend happen so
>>>> fast that it can suspend between keystrokes.
>>>>
>>>> however, in the case of Android I think the timeouts have to end up being
>>>> _much_ longer. Otherwise you have the problem of loading an untrusted book
>>>> reader app on the device and the device suspends while you are reading the
>>>> page.
>>>>
>>>> currently Android works around this by having a wakelock held whenever the
>>>> display is on. This seems backwards to me, the display should be on because
>>>> the system is not suspended, not the system is prevented from suspending
>>>> because the display is on.
>>>>
>>>> Rather than having the display be on causing a wavelock to be held (with the
>>>> code that is controls the display having a timeout for how long it leaves
>>>> the display on), I would invert this and have the timeout be based on system
>>>> activity, and when it decides the system is not active, turn off the display
>>>> (along with other things as it suspends)
>>>
>>> IIRC, this was a major point of their (Android's) power management
>>> policy.  User input of any kind would reset the "display active"
>>> timeout, which is the primary thing keeping random untrusted
>>> user-facing programs from being suspended while in use.  They seemed
>>> to consider this to be a special case in their policy, but from the
>>> kernel's point of view it is just another suspend blocker being held.
>>>
>>> I'm not sure this is the best use case to look at though, because
>>> since it is user-facing, the timeout durations are on a different
>>> scale than the ones they are really worried about.  I think another
>>> category of use case that they are worried about is:
>>>
>>> (in suspend) -> wakeup due to network -> process network activity -> suspend
>>>
>>> or an example that has been mentioned previously:
>>>
>>> (in suspend) -> wakeup due to alarm for audio processing -> process
>>> batch of audio -> suspend
>>>
>>> In both of these cases, the display may never power on (phone might
>>> beep to indicate txt message or email, audio just keeps playing), so
>>> the magnitude of the "timeout" for suspending again should be very
>>> small.  Specifically, they don't want there to be a timeout at all, so
>>> as little time as possible time is spent out of suspend in addition to
>>> the time required to handle the event that caused wakeup.
>>
>> It would be good to get some sort of range for the "timeout".  In the
>> audio-output case, my understanding that the spacing between bursts of
>> audio-processing activity is measured in some hundreds of milliseconds,
>> in which case one would want the delays until suspend to be on the
>> millisecond scale.  But does Android really suspend between bursts of
>> audio processing while playing music?  Very cool if so!  ;-)
>
> Oops, yea that's actually a really bad example, that's probably
> something that would be handled by low-power states.  I think the
> incoming text message example is a good one though.  There seemed to
> be a focus on user-interaction scale time scales, and I wanted to
> point out that there are also very short duration time scales to
> consider as well.

good point, but I do think the short time scales are less common than 
people think.

I'd love to get good examples of them

on my iphone when a text message arrives the phone displays an alert for 
user-interaction times (it even lights the display to show who the message 
is from, and optionally a preview of the message)

so what would wake a phone up from suspend where the phone should go back 
to sleep in under a second?

David Lang
--680960-1374493777-1281046173=:30632--
